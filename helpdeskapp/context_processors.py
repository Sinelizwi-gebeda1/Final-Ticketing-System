from django.utils import timezone
from datetime import timedelta
from helpdeskapp.models import Ticket, Notification

def l2_assigned_tickets_count(request):
    if request.user.is_authenticated and request.user.role == "L2_Technician":
        escalated_count = Ticket.objects.filter(status='Escalated', assigned_technician=request.user).count()
        resolved_count = Ticket.objects.filter(status='Resolved', assigned_technician=request.user).count()
        count = escalated_count + resolved_count
    else:
        count = 0
    return {
        "l2_assigned_ticket_count": count
    }

def notification_context(request):
    notifications = []
    notifications_unread_count = 0

    if request.user.is_authenticated:
        now = timezone.now()
        two_minutes_ago = now - timedelta(minutes=2)

        # L1 Technician
        if request.user.role == "L1_Technician":
            pending_tickets = Ticket.objects.filter(
                assigned_technician=request.user,
                status='Pending',
                accepted_by_l1=False,
                assigned_at__lte=two_minutes_ago
            )

        # L2 Technician
        elif request.user.role == "L2_Technician":
            pending_tickets = Ticket.objects.filter(
                assigned_technician=request.user,
                status__in=['Escalated', 'Resolved'],
                accepted_by_l2=False,
                assigned_at__lte=two_minutes_ago
            )
        else:
            pending_tickets = Ticket.objects.none()

        # Count pending tickets for badge
        notifications_unread_count = pending_tickets.count()

        # Optional: Create a notification entry for each ticket
        for ticket in pending_tickets:
            message = f"Ticket {ticket.ticket_number} has not been accepted yet."
            if not Notification.objects.filter(user=request.user, message=message).exists():
                Notification.objects.create(user=request.user, message=message)

        notifications = Notification.objects.filter(user=request.user).order_by('-created_at')

    return {
        'notifications': notifications,
        'notifications_unread_count': notifications_unread_count
    }