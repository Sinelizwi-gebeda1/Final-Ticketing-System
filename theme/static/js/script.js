document.addEventListener('DOMContentLoaded', () => {
    const tickets = document.querySelectorAll('.ticket-card');
    const searchInput = document.getElementById('ticket-search');
    const filterButtons = document.querySelectorAll('.filter-btn');

    let activeFilters = { priority: [], department: [] };

    // Function to apply filters + search
    function applyFiltersAndSearch() {
        const query = searchInput.value.toLowerCase();

        tickets.forEach(ticket => {
            const tTitle = ticket.dataset.title.toLowerCase();
            const tNumber = ticket.dataset.number.toLowerCase();
            const tPriority = ticket.dataset.priority;
            const tDept = ticket.dataset.department;

            let visible = true;

            // Apply active filters
            if (activeFilters.priority.length && !activeFilters.priority.includes(tPriority)) visible = false;
            if (activeFilters.department.length && !activeFilters.department.includes(tDept)) visible = false;

            // Apply search
            if (query && !(tTitle.includes(query) || tNumber.includes(query))) visible = false;

            // Preserve grid layout
            ticket.style.display = visible ? '' : 'none';
        });
    }

    // Live search input
    if (searchInput) {
        searchInput.addEventListener('input', applyFiltersAndSearch);
    }

    // Filter button clicks
    filterButtons.forEach(btn => {
        btn.addEventListener('click', () => {
            const filter = btn.dataset.filter;
            const value = btn.dataset.value;

            // Toggle button active state
            btn.classList.toggle('bg-blue-600');
            btn.classList.toggle('text-white');

            // Update activeFilters
            if (activeFilters[filter].includes(value)) {
                activeFilters[filter] = activeFilters[filter].filter(v => v !== value);
            } else {
                activeFilters[filter].push(value);
            }

            applyFiltersAndSearch();
        });
    });

    // Modal open/close
    window.openModal = id => {
        const modal = document.getElementById(id);
        if (modal) {
            modal.classList.remove('hidden');
            modal.classList.add('flex');
        }
    };

    window.closeModal = id => {
        const modal = document.getElementById(id);
        if (modal) {
            modal.classList.remove('flex');
            modal.classList.add('hidden');
        }
    };


//Escalate Modal
// Open ticket details modal
function openModal(id) {
    document.getElementById(id).classList.remove('hidden');
    document.getElementById(id).classList.add('flex');
}

function closeModal(id) {
    document.getElementById(id).classList.remove('flex');
    document.getElementById(id).classList.add('hidden');
}

// Open Escalate Modal with ticket ID
document.querySelectorAll('.escalate-btn').forEach(button => {
    button.addEventListener('click', function() {
        const ticketId = this.getAttribute('data-ticket-id');
        document.getElementById('modalTicketId').value = ticketId;
        const escalateModal = new bootstrap.Modal(document.getElementById('escalateModal'));
        escalateModal.show();
    });
});


// Modal helpers
function openModal(id) {
    document.getElementById(id).classList.remove('hidden');
    document.getElementById(id).classList.add('flex');
}

function closeModal(id) {
    document.getElementById(id).classList.remove('flex');
    document.getElementById(id).classList.add('hidden');
}


    // Optional chatbot
    const botBtn = document.getElementById('support-bot');
    const chatBox = document.getElementById('chat-popup');
    const chatClose = document.getElementById('chat-close');
    const chatBody = document.getElementById('chat-body');
    const inputField = document.getElementById('user-input');
    const sendBtn = document.getElementById('send-btn');

    function appendMessage(text, sender) {
        if (!chatBody) return;
        const timestamp = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
        const msgDiv = document.createElement('div');
        msgDiv.classList.add('flex', 'items-end', 'space-x-2', 'mb-2');
        if (sender === 'user') {
            msgDiv.classList.add('justify-end');
            msgDiv.innerHTML = `<span class="text-xs text-gray-400">${timestamp}</span>
                <div class="bg-blue-600 text-white px-3 py-2 rounded-r-lg rounded-tl-lg max-w-[70%] shadow">${text}</div>`;
        } else {
            msgDiv.classList.add('justify-start');
            msgDiv.innerHTML = `<div class="bg-gray-200 text-gray-800 px-3 py-2 rounded-l-lg rounded-tr-lg max-w-[70%] shadow-sm">${text}</div>
                <span class="text-xs text-gray-400">${timestamp}</span>`;
        }
        chatBody.appendChild(msgDiv);
        chatBody.scrollTop = chatBody.scrollHeight;
    }

    if (botBtn) botBtn.addEventListener('click', () => chatBox?.classList.toggle('hidden'));
    if (chatClose) chatClose.addEventListener('click', () => chatBox?.classList.add('hidden'));

    if (sendBtn) {
        sendBtn.addEventListener('click', async () => {
            const message = inputField.value.trim();
            if (!message) return;
            appendMessage(message, 'user');
            inputField.value = '';

            try {
                const response = await fetch('/chat-bot/', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRFToken': document.querySelector('[name=csrfmiddlewaretoken]').value
                    },
                    body: JSON.stringify({ message })
                });
                const data = await response.json();
                appendMessage(data.reply, 'bot');
            } catch (err) {
                console.error(err);
                appendMessage('Sorry, something went wrong.', 'bot');
            }
        });

        inputField?.addEventListener('keypress', e => {
            if (e.key === 'Enter') {
                sendBtn.click();
                e.preventDefault();
            }
        });
    }
});
function markAsRead(notificationId) {
    fetch(`/notifications/read/${notificationId}/`, {
        method: 'POST',
        headers: {
            'X-CSRFToken': getCSRFToken(),
            'Content-Type': 'application/json',
        },
    })
    .then(response => response.json())
    .then(data => {
        if(data.success){
            // Remove notification from DOM
            const elem = document.querySelector(`.notification-item[data-id='${notificationId}']`);
            if(elem) elem.remove();

            // Optionally update badge count
            const badge = document.getElementById('notification-badge');
            if(badge) {
                let count = parseInt(badge.innerText);
                badge.innerText = Math.max(count - 1, 0);
            }
        }
    });
}

// Helper to get CSRF token from cookies
function getCSRFToken() {
    let cookieValue = null;
    if (document.cookie && document.cookie !== '') {
        const cookies = document.cookie.split(';');
        for (let cookie of cookies) {
            cookie = cookie.trim();
            if (cookie.startsWith('csrftoken=')) {
                cookieValue = decodeURIComponent(cookie.substring('csrftoken='.length));
                break;
            }
        }
    }
    return cookieValue;
}
