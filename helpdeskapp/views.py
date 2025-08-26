from django.shortcuts import render, redirect,get_object_or_404
from django.contrib.auth import get_user_model, update_session_auth_hash
from django.contrib import messages
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required,user_passes_test
from .models import Ticket, CustomUser, CABRequest, TicketAssignment,EscalationNote
from .forms import CustomUserRegistrationForm, CustomLoginForm, TicketForm,CustomUserSettingsForm,CABRequestForm
from django.contrib.auth import get_user_model, update_session_auth_hash
import openai
import os
from django.conf import settings
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from dotenv import load_dotenv
import json
import uuid
from .utils import get_least_busy_l1_technician
from .utils import get_least_busy_l2_technician
from django.contrib.auth.decorators import permission_required
from django.core.exceptions import PermissionDenied
from django.utils.html import escape
from urllib.parse import quote
from django.utils import timezone
from django.views.decorators.http import require_POST
from django.core.mail import send_mail
from django.db.models import Count
from django.http import JsonResponse

#Forget password 
from django.utils.http import urlsafe_base64_encode
from django.utils.http import urlsafe_base64_decode
from django.utils.encoding import force_bytes
from django.urls import reverse
from django.contrib.auth.tokens import default_token_generator
from django.contrib.auth.forms import SetPasswordForm
from django.db.models import Q

from .forms import CustomPasswordResetForm



User = CustomUser

def home(request):
    form = CustomLoginForm()
    return render(request, "login.html", {"form": form})


def register(request):
    if request.method == "POST":
        form = CustomUserRegistrationForm(request.POST)
        if form.is_valid():
            user = form.save()  
            messages.success(request, "Registration successful! You can now log in.")
            return redirect("login")  
    else: 
        form = CustomUserRegistrationForm()

    return render(request, "register.html", {"form": form})

def user_login(request):
    if request.method == "POST":
        form = CustomLoginForm(request.POST)
        if form.is_valid():
            email = form.cleaned_data["email"]
            password = form.cleaned_data["password"]
            
            user = authenticate(request, username=email, password=password)
            
            if user is not None:
                login(request, user)
                
                # Redirect based on the role
                if user.role == "End-User":
                    return redirect("dashboard")  # End-users go to their dashboard
                elif user.role == "L1_Technician" :
                    return redirect("technician_dashboard")  # Redirect L1 Technicians to their dashboard
                elif user.role == "CAB" :
                    return redirect("cab")
                elif user.role == user.role == "L2_Technician":
                    return redirect("l2_technician_dashboard")  # Redirect L2 Technicians to their dashboard
                else:
                    return redirect("admin_dashboard")  # Admin users go to the admin dashboard

            else: 
                messages.error(request, "Invalid email or password!")
    
    else:  
        form = CustomLoginForm()
            
    return render(request, "login.html", {"form": form})


@login_required
def dashboard(request):
    tickets = Ticket.objects.filter(user=request.user)
     # Sort tickets by order
    order = request.GET.get('order')
    if order == 'oldest':
        tickets = tickets.order_by('date_created_on')
    else:
        tickets = tickets.order_by('-date_created_on')

    if request.method == 'POST':
        if 'ticket_title' in request.POST:
            # Ticket form submitted
            form = TicketForm(request.POST, request.FILES)
            if form.is_valid():
                ticket = form.save(commit=False)
                ticket.user = request.user
                ticket.save()
                return redirect('dashboard')
            settings_form = CustomUserSettingsForm(instance=request.user)  # Keep existing settings form
               
        else:
            # Settings form submitted
            settings_form = CustomUserSettingsForm(request.POST, instance=request.user)
            if settings_form.is_valid():
                settings_form.save()
                return redirect('dashboard')
            form = TicketForm()  # Keep existing ticket form
    else:
        form = TicketForm()
        settings_form = CustomUserSettingsForm(instance=request.user)

    return render(request, 'dashboard.html', {
        'tickets': tickets,
        'form': form,
        'settings_form': settings_form,
    })


@login_required
def add_ticket_view(request):
    if request.method == 'POST':
        form = TicketForm(request.POST, request.FILES)
        if form.is_valid():
            ticket = form.save(commit=False)
            ticket.user = request.user
            ticket.save()
            return redirect('dashboard')  # or your ticket list view
    else:
        form = TicketForm()

    return render(request, 'add_tickets.html', {'form': form})


@login_required
def add_ticket(request):
    if request.method == "POST":
        print("Starting add_ticket POST")
        form = TicketForm(request.POST, request.FILES)
        if form.is_valid():
            print("Form is valid")
            ticket = form.save(commit=False)
            ticket.user = request.user
            ticket.ticket_number = str(uuid.uuid4()).replace('-', '')[:8].upper()

            technician = get_least_busy_l1_technician()
            if technician:
                ticket.assigned_technician = technician
                ticket.status = 'Pending'
                print(f" Assigned to: {technician.email}")
                print("Sending ticket assignment email...")
                send_ticket_assignment_email(technician, ticket)
                ticket.assigned_at = timezone.now()
            else:
                ticket.status = 'Unassigned'
                print(" No technician available")

            ticket.save()
            # messages.success(request, "Ticket successfully created!")
            return redirect('dashboard')
        else:
            print(" Form is invalid")
            print(form.errors)
            # messages.error(request, "Form submission failed. Please correct the errors.")
    else:
        print(" GET request to add_ticket")

    form = TicketForm()
    return render(request, "add_tickets.html", {"form": form})
    
@login_required
def my_tickets(request):
    tickets = Ticket.objects.filter(user=request.user)  # Get tickets of logged-in user
    return render(request, 'admin.html', {'tickets': tickets})


@login_required
def settings_page(request):
    user = request.user
    if request.method == "POST":
        form = CustomUserSettingsForm(request.POST, instance=user)

        if form.is_valid():
            full_name = form.cleaned_data['full_name']
            new_password = form.cleaned_data.get('new_password')

            # Update full name
            first_name, last_name = full_name.split(' ', 1) if ' ' in full_name else (full_name, '')
            user.first_name = first_name
            user.last_name = last_name

            # Update password if provided
            if new_password:
                user.set_password(new_password)
                update_session_auth_hash(request, user)  # Keep the user logged in after password change

            user.save()
            messages.success(request, "Settings updated successfully!")
            return redirect('settings.html')
        else:
            messages.error(request, "Error updating settings. Please check your inputs.")
    else:
        form = CustomUserSettingsForm(instance=user)

    return render(request, "settings.html", {"form": form})


def user_logout(request):
    logout(request)  # Properly log out the user
    messages.success(request, "You have been logged out.")
    return redirect('login')

@login_required
def admin_dashboard(request):
    priority_data = get_priority_data()
    return render(request, "admin.html", {"priorityData": priority_data})


def get_priority_data():
    # Aggregate counts by priority
    counts = Ticket.objects.values('priority_level').annotate(count=Count('id'))

    # Ensure all levels are present, even if zero
    priority_map = {"Low": 0, "Medium": 0, "High": 0}
    for item in counts:
        priority_map[item["priority_level"]] = item["count"]

    return priority_map

@login_required
def metrics_view(request):
    if request.headers.get("x-requested-with") == "XMLHttpRequest":
        return JsonResponse({"priority_data": get_priority_data()})
    return JsonResponse({"error": "Invalid request"}, status=400)

@login_required
def view_tickets(request):
    if request.user.is_authenticated:
        if request.user.role == "L1_Technician":
            if not request.user.has_perm("helpdeskapp.view_pending_tickets"):
                return render(request, "base.html", {"error_message": "You do not have permission to view pending tickets."})

            tickets = Ticket.objects.filter(status="Pending", assigned_technician=request.user)
            return render(request, "technician_dashboard.html", {"tickets": tickets})

        elif request.user.role == "L2_Technician":
            if not request.user.has_perm("helpdeskapp.view_escalated_tickets"):
                return render(request, "base.html", {"error_message": "You do not have permission to view escalated tickets."})

            tickets = Ticket.objects.filter(status="Escalated", assigned_technician=request.user)
            return render(request, "technician_dashboard.html", {"tickets": tickets})
        elif request.user.role == "L2_Technician":

            tickets = Ticket.objects.filter(status="Resolved")
            return render(request, "technician_dashboard.html", {"tickets": tickets})

        else:
            if not request.user.is_staff:
                return render(request, "base.html", {"error_message": "Access denied!"})

            tickets = Ticket.objects.all()  # Admins can see all tickets
            return render(request, "admin.html", {"tickets": tickets})

    return redirect("login")

@login_required 
def l1_technicians_tickets(request):
    if request.user.role == "L1_Technician" : 
        if not request.user.has_perm("helpdeskapp.view_pending_tickets"):
            #raise PermissionDenied  # Block unauthorized access
            return render(request, "base.html", {"error_message": "You do not have permission to view this page."})


        tickets = Ticket.objects.filter(assigned_technician=request.user)

        # Filter by priority
        priority = request.GET.get('priority')
        if priority:
            tickets = tickets.filter(priority_level=priority)

        # Sort by date
        order = request.GET.get('order')
        if order == 'oldest':
            tickets = tickets.order_by('date_created_on')
        else:  # default to newest
            tickets = tickets.order_by('-date_created_on')

        department = request.GET.get('department')
        if department:
            tickets = tickets.filter(department=department)



        return render(request, "l1_technicians_tickets.html", {"tickets": tickets})

    #messages.error(request, "Unauthorized access!")
    #return redirect("dashboard") 
    return render(request, "base.html", {"error_message": "Unauthorized access!"})

@login_required 
def technician_dashboard(request):
    if request.user.role == "L1_Technician":
        if not request.user.has_perm("helpdeskapp.view_pending_tickets"):
            return render(request, "base.html", {"error_message": "You do not have permission to view this page."})

        my_tickets_count = Ticket.objects.filter(assigned_technician=request.user).count()
        pending_tickets_count = Ticket.objects.filter(
            assigned_technician=request.user, status='Pending'
        ).count()

        return render(request, "technician_dashboard.html", {
            "my_tickets_count": my_tickets_count,
            "pending_tickets_count": pending_tickets_count
        })

    return render(request, "base.html", {"error_message": "Unauthorized access!"})

@login_required 
def notes(request):
    if request.user.role == "L1_Technician" : 
        if not request.user.has_perm("helpdeskapp.view_pending_tickets"):
            #raise PermissionDenied  # Block unauthorized access
            return render(request, "base.html", {"error_message": "You do not have permission to view this page."})
        return render(request, "notes.html")

    #messages.error(request, "Unauthorized access!")
    #return redirect("dashboard") 
    return render(request, "base.html", {"error_message": "Unauthorized access!"})

@login_required
def accept_ticket(request, id):
    ticket = get_object_or_404(Ticket, id=id)
    ticket.status = "In Progress"
    ticket.assigned_at = timezone.now()       # New: time ticket was accepted

    ticket.save()
    return redirect("l1_technicians_tickets")


@login_required
def escalate_ticket(request, id):
    ticket = get_object_or_404(Ticket, id=id)

    if request.method == 'POST':
        note_text = request.POST.get('note', '').strip()
        if note_text:
            EscalationNote.objects.create(
                ticket=ticket,
                note=note_text,
                created_by=request.user
            )

    ticket.status = "Escalated"
    ticket.escalated_at = timezone.now()

    # Assign the least busy L2 Technician
    l2_technician = get_least_busy_l2_technician()
    if l2_technician:
        ticket.assigned_technician = l2_technician
    ticket.save()
    ticket.assigned_at = timezone.now()
    # Send Email to User who created the ticket
    send_mail(
        subject="Your ticket has been escalated",
        message=f"Hello {ticket.user.username},\n\nYour ticket '{ticket.ticket_title}' has been escalated to '{l2_technician.email}' ." ,
        from_email=settings.DEFAULT_FROM_EMAIL,
        recipient_list=[ticket.user.email],
        fail_silently=False
    )

    # Send Email to Assigned L2 Technician
    if l2_technician:
        send_mail(
            subject="New Escalated Ticket Assigned to You",
            message=f"Hello {l2_technician.username},\n\nYou have been assigned an escalated ticket: '{ticket.ticket_title}', Login to access the ticket.",
            from_email=settings.DEFAULT_FROM_EMAIL,
            recipient_list=[l2_technician.email],
            fail_silently=False
        )

    return redirect("l1_technicians_tickets")

@login_required
def complete_ticket(request, id):
    ticket = get_object_or_404(Ticket, id=id)
    ticket.status = "Resolved"
    ticket.completed_at = timezone.now()  # End time for L1 completion

    # Assign the least busy L2 Technician for closure
    l2_technician = get_least_busy_l2_technician()
    if l2_technician:
         ticket.assigned_technician = l2_technician
    ticket.save()
    ticket.assigned_at = timezone.now()
    return redirect("l1_technicians_tickets")


@login_required
def l2_technician_dashboard(request):
    tickets = Ticket.objects.filter(assigned_technician=request.user)

    priority = request.GET.get('priority')
    if priority:
        tickets = tickets.filter(priority_level=priority)

    department = request.GET.get('department')
    if department:
        tickets = tickets.filter(department=department)

    order = request.GET.get('order')
    if order == 'oldest':
        tickets = tickets.order_by('date_created_on')
    else:
        tickets = tickets.order_by('-date_created_on')

    completed_tickets = tickets.filter(status='Resolved')

    # Add count of escalated
    escalated_count = Ticket.objects.filter(
        status='Escalated',
        assigned_technician=request.user
    ).count()

    total_l2_tickets = completed_tickets.count() + escalated_count

    return render(request, 'l2_technician_dashboard.html', {
        'completed_tickets': completed_tickets,
        'tickets': tickets,
        'total_l2_tickets': total_l2_tickets,
        'request': request,
    })


    
@login_required
def escalated_tickets(request):
    tickets = Ticket.objects.filter(status="Escalated", assigned_technician=request.user)

    priority = request.GET.get('priority')
    if priority:
        tickets = tickets.filter(priority_level=priority)

    order = request.GET.get('order')
    if order == 'oldest':
        tickets = tickets.order_by('date_created_on')
    else:
        tickets = tickets.order_by('-date_created_on')

    department = request.GET.get('department')
    if department:
        tickets = tickets.filter(department=department)

    # Also get resolved count
    resolved_count = Ticket.objects.filter(
        status='Resolved',
        assigned_technician=request.user
    ).count()

    total_l2_tickets = resolved_count + tickets.count()

    return render(request, 'escalated_tickets.html', {
        'escalated_tickets': tickets,
        'total_l2_tickets': total_l2_tickets
    })


@login_required
def completed_tickets(request):
    tickets = Ticket.objects.filter(status="Resolved", assigned_technician=request.user)  # Adjust filter as needed
     # Filter by priority
    priority = request.GET.get('priority')
    if priority:
            tickets = tickets.filter(priority_level=priority)

        # Sort by date
    order = request.GET.get('order')
    if order == 'oldest':
            tickets = tickets.order_by('date_created_on')
    else:  # default to newest
            tickets = tickets.order_by('-date_created_on')

    department = request.GET.get('department')
    if department:
            tickets = tickets.filter(department=department)

    return render(request, 'l2_technician_dashboard.html', {'completed_tickets': tickets 
 })


#L2 technicians closing Escalated tickets by L1 technicians 
@login_required
def close_ticket_ecalated(request, id):
    ticket = get_object_or_404(Ticket, id=id)
    ticket.status = "Closed"
    ticket.closed_at = timezone.now()  # End time for L2 closure

    ticket.save()
    return redirect("escalated_tickets")

#L2 technicians closing resolved tickets by L1 technicians 
@login_required
def close_ticket_completed(request, id):
    ticket = get_object_or_404(Ticket, id=id)
    ticket.status = "Closed"
    ticket.closed_at = timezone.now()  # End time for L2 closure

    ticket.save()
    return redirect("completed_tickets")

@login_required
def accept_ticket_l2_escalated(request, id):
    ticket = get_object_or_404(Ticket, id=id)
    if not ticket.accepted_by_l2:
        ticket.accepted_by_l2 = True
        ticket.start_time = timezone.now()
        ticket.save()

    return redirect('escalated_tickets')  

@require_POST
@login_required
def accept_ticket_l2_completed(request, id):
    ticket = get_object_or_404(Ticket, id=id)
    if not ticket.accepted_by_l2:
        ticket.accepted_by_l2 = True
        ticket.start_time = timezone.now()
        ticket.save()
    return redirect('completed_tickets')

#Chatbot
@csrf_exempt
def chat_with_bot(request):
    if request.method == "POST":
        data = json.loads(request.body)
        user_message = data.get("message", "").lower()

        # Basic keyword-response logic
        if "hello" in user_message or "hi" in user_message:
            reply = "Hello! How can I help you today?"
        elif "help" in user_message:
            reply = "Sure, I'm here to help. Please tell me more about your issue."
        elif "ticket" in user_message:
            reply = "You can create a ticket from your dashboard."
        elif "thank" in user_message:
            reply = "You're welcome! 😊"

        elif "how do I reset my password?" in user_message:
            reply = "Click on 'Settings', enter a new password and confirm your password"    
        else:
            reply = "I'm not sure how to respond to that. Could you please rephrase?"

        return JsonResponse({"reply": reply})
    return JsonResponse({"error": "Invalid request method"}, status=400)



@login_required
def technician_requests(request):
    if request.method == "POST":
        form = CABRequestForm(request.POST, request.FILES)
        if form.is_valid():
            cab_request = form.save(commit=False)
            cab_request.requester = request.user
            cab_request.requester_name = request.user.full_name
            cab_request.save()
            return redirect("technician_requestslist")  # named route for list
    else:
        form = CABRequestForm()

    # Calculate total tickets assigned to the user (escalated + resolved)
    escalated_count = Ticket.objects.filter(status='Escalated', assigned_technician=request.user).count()
    resolved_count = Ticket.objects.filter(status='Resolved', assigned_technician=request.user).count()
    total_l2_tickets = escalated_count + resolved_count

    return render(request, "technician_requests.html", {
        "form": form,
        "total_l2_tickets": total_l2_tickets,
    })


@login_required
def technician_requestslist(request):
    submitted_requests = CABRequest.objects.filter(requester=request.user).order_by('-created_at')

    # Calculate total tickets assigned to the user (escalated + resolved)
    escalated_count = Ticket.objects.filter(status='Escalated', assigned_technician=request.user).count()
    resolved_count = Ticket.objects.filter(status='Resolved', assigned_technician=request.user).count()
    total_l2_tickets = escalated_count + resolved_count

    return render(request, "technician_requestslist.html", {
        "submitted_requests": submitted_requests,
        "total_l2_tickets": total_l2_tickets,
    })



def reports_view(request):
    # Group tickets by priority
    ticket_counts = Ticket.objects.values('priority_level').annotate(count=Count('id'))

    # Initialize default values
    priority_data = {
        'Low': 0,
        'Medium': 0,
        'High': 0
    }

    for entry in ticket_counts:
        priority = entry['priority_level']
        if priority in priority_data:
            priority_data[priority] = entry['count']

    # Optional: Debug
    print("DEBUG priority_data:", priority_data)

    return render(request, 'reports.html', {
        'priority_data_json': json.dumps(priority_data)
    })
@login_required
def roles_management_view(request):
    users = get_user_model().objects.all()  # Fetch all users
    role_choices = dict(CustomUser.ROLE_CHOICES)  # Assuming this is how roles are stored

    if request.method == "POST":
        user_id = request.POST.get("user_id")
        role_name = request.POST.get("role")

        # Fetch the user object
        user = get_object_or_404(get_user_model(), id=user_id)

        # Validate the role choice
        if role_name not in role_choices:
            messages.error(request, f"The role '{role_name}' does not exist.")
            return redirect("roles_management")

        # Assign the role
        user.role = role_name
        user.save()

        messages.success(request, f"Role '{role_name}' assigned to {user.full_name}")
        return redirect("roles_management")

    return render(request, "roles_management.html", {"users": users, "role_choices": role_choices})

@login_required
def user_roles_list_view(request):
    users = get_user_model().objects.all()
    return render(request, "user_role_list.html", {"users": users})


def is_admin(user):
    return user.role == "Administrator"


def cab_requests_view(request):
    if request.method == "POST":
        form = CABRequestForm(request.POST)
        if form.is_valid():
            cab_request = form.save(commit=False)
            cab_request.requester = request.user
            cab_request.status = "in_progress"
            cab_request.rejection_reason = None
            cab_request.save()
            messages.success(request, "CAB request submitted successfully!")
            return redirect("cab_requests")
    else:
        form = CABRequestForm()

    cab_requests = CABRequest.objects.all().order_by('-created_at')

    return render(request, "cab_requests.html", {
        "form": form,
        "requests": cab_requests,
    })

def manage_tickets(request):
    if request.method == 'POST':
        action = request.POST.get('action')
        ticket_id = request.POST.get('ticket_id')
        ticket = get_object_or_404(Ticket, id=ticket_id)

        if action == 'assign':
            technician_id = request.POST.get('technician_id')
            technician = get_object_or_404(
                User, id=technician_id, role__in=['L1_Technician', 'L2_Technician']
            )

            TicketAssignment.objects.create(
                ticket=ticket,
                technician=technician,
                assigned_by=request.user
            )

            return JsonResponse({
                'success': True,
                'message': f"Ticket {ticket.id} assigned to {technician.username} successfully!"
            })

        elif action == 'close':
            ticket.status = 'Closed'
            ticket.save()
            return JsonResponse({
                'success': True,
                'message': f"Ticket {ticket.id} closed successfully!"
            })

        return JsonResponse({'success': False, 'message': 'Invalid action'})

    # For GET requests, render normal page
    tickets = Ticket.objects.exclude(status='Closed')
    technicians = User.objects.filter(role__in=['L1_Technician', 'L2_Technician'])
    departments = Ticket.DEPARTMENT_CHOICES
    priorities = Ticket.PRIORITY_CHOICES

    return render(request, 'manage_tickets.html', {
        'tickets': tickets,
        'technicians': technicians,
        'departments': departments,
        'priorities': priorities,
    })

    
def is_CAB(user):
    return user.is_authenticated and user.role == "CAB"  

@login_required
@user_passes_test(is_CAB)
def cab_requests_list(request):
    requests = CABRequest.objects.all().order_by("-created_at")
    status_filter = request.GET.get("status")
    type_filter = request.GET.get("change_type")

    if status_filter:
        requests = requests.filter(status=status_filter)
    if type_filter:
        requests = requests.filter(change_type=type_filter)

    return render(request, "cab_requests_list.html", {
        "requests": requests,
        "status_filter": status_filter,
        "type_filter": type_filter,
    })

def cab_request_detail(request, pk):
    cab_request = get_object_or_404(CABRequest, pk=pk)

    if request.method == "POST":
        action = request.POST.get("action")

        if action == "approve":
            cab_request.status = "approved"
            cab_request.rejection_reason = None  

        elif action == "reject":
            reason = request.POST.get("rejection_reason")
            if reason:
                cab_request.status = "rejected"
                cab_request.rejection_reason = reason
            else:
                messages.error(request, "Rejection reason is required.")
                return redirect("cab_request_detail", pk=pk)

        cab_request.save()
        return redirect("cab_request_detail", pk=pk)


    return render(request, "cab_request_detail.html", {"request_obj": cab_request})



@login_required
def cab_dashboard(request):
    status = request.GET.get('status', '')
    change_type = request.GET.get('change_type', '')

    requests = CABRequest.objects.all()

    if status:
        requests = requests.filter(status=status)
    if change_type:
        requests = requests.filter(change_type=change_type)

    context = {
        "requests": requests,
        "status_filter": status,
        "type_filter": change_type,
    }

    return render(request, 'cab.html', context)

@login_required
def cab_stats_view(request):
    analytics = {
        "insufficient_info": CABRequest.objects.filter(rejection_reason="insufficient_info").count(),
        "high_risk": CABRequest.objects.filter(rejection_reason="high_risk").count(),
        "no_business_justification": CABRequest.objects.filter(rejection_reason="no_business_justification").count(),
        "incomplete_rollback_plan": CABRequest.objects.filter(rejection_reason="incomplete_rollback_plan").count(),
        "resource_constraints": CABRequest.objects.filter(rejection_reason="resource_constraints").count(),
    }

    return render(request, "cab_stats.html", {"analytics": analytics})


def cab_stats(request):
    rejection_data = (
        CABRequest.objects
        .filter(status='rejected')
        .values('rejection_reason')
        .annotate(total=Count('id'))
        .order_by('-total')
    )

    labels = []
    counts = []
    reason_map = dict(CABRequest.REJECTION_REASONS)

    for item in rejection_data:
        reason_key = item['rejection_reason']
        labels.append(reason_map.get(reason_key, "Unknown"))
        counts.append(item['total'])

    analytics = {
        "labels": labels,
        "counts": counts,
    }

    return render(request, "cab_stats.html", {"analytics": analytics})

@login_required
def cab_requests_table_view(request):
    cab_requests = CABRequest.objects.all().order_by('-created_at')
    return render(request, "cab_requests_table.html", {
        "requests": cab_requests
    })


#Function for sending an email to the technician
def send_ticket_assignment_email(technician, ticket):
    print("Inside send_ticket_assignment_email")

    subject = f"New Ticket Assigned: {ticket.ticket_title}"
    message = f"""
Hello {technician.get_full_name()},

You have been assigned a new support ticket.

Ticket Number: {ticket.ticket_number}
Title: {ticket.ticket_title}
Priority: {ticket.priority_level}

Please log in to the Helpdesk system to view and manage the ticket.

- Helpdesk System
"""

    try:
        send_mail(
            subject=subject,
            message=message,
            from_email=settings.DEFAULT_FROM_EMAIL,
            recipient_list=[technician.email],
            fail_silently=False,
        )
        print(f"Email sent to {technician.email}")
    except Exception as e:
        print(f"Failed to send email to {technician.email}: {e}")

#Reset password 
def custom_password_reset(request):
    if request.method == 'POST':
        form = CustomPasswordResetForm(request.POST)
        if form.is_valid():
            email = form.cleaned_data['email']
            user = User.objects.get(email=email)
            token = default_token_generator.make_token(user)
            uid = urlsafe_base64_encode(force_bytes(user.pk))
            reset_link = request.build_absolute_uri(
                reverse('custom_password_reset_confirm', kwargs={'uidb64': uid, 'token': token})
            )
            
            # send email
            send_mail(
                'Password Reset',
                f'Click the link to reset your password: {reset_link}',
                'Services@dbi-itgroup.co.za',
                [user.email],
                fail_silently=False,
            )
            # messages.success(request, "Password reset link has been sent to your email.")
            return redirect('login')
    else:
        form = CustomPasswordResetForm()
    return render(request, 'password_reset_form.html', {'form': form})

#Password reset confirm 
def custom_password_reset_confirm(request, uidb64, token):
    try:
        uid = urlsafe_base64_decode(uidb64).decode()
        user = User.objects.get(pk=uid)
    except (TypeError, ValueError, OverflowError, User.DoesNotExist):
        user = None

    if user is not None and default_token_generator.check_token(user, token):
        if request.method == 'POST':
            form = SetPasswordForm(user, request.POST)
            if form.is_valid():
                form.save()
                # messages.success(request, "Your password has been reset successfully.")
                return redirect('login')
        else:
            form = SetPasswordForm(user)
        return render(request, 'password_reset_confirm.html', {'form': form})
    else:
        # messages.error(request, "The reset link is invalid or expired.")
        return redirect('login')
    
