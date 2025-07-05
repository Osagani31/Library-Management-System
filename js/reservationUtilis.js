/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

// Function to notify other tabs that a reservation has been made
function notifyReservationMade() {
    // Set a flag in localStorage that a reservation was made
    localStorage.setItem('bookReserved', 'true');
    localStorage.setItem('bookReservationTime', Date.now().toString());
    localStorage.setItem('bookAvailabilityChanged', 'true');
    localStorage.setItem('availabilityChangeTime', Date.now().toString());
    
    // Dispatch a storage event to notify other tabs
    window.dispatchEvent(new StorageEvent('storage', {
        key: 'bookReserved',
        newValue: 'true'
    }));
}

// Function to notify other tabs that a reservation has been cancelled
function notifyReservationCancelled() {
    // Set a flag in localStorage that a reservation was cancelled
    localStorage.setItem('bookReservationCancelled', 'true');
    localStorage.setItem('bookCancellationTime', Date.now().toString());
    localStorage.setItem('bookAvailabilityChanged', 'true');
    localStorage.setItem('availabilityChangeTime', Date.now().toString());
    
    // Dispatch a storage event to notify other tabs
    window.dispatchEvent(new StorageEvent('storage', {
        key: 'bookReservationCancelled',
        newValue: 'true'
    }));
}

// Function to listen for reservation changes from other tabs
function listenForReservationChanges() {
    window.addEventListener('storage', function(event) {
        if ((event.key === 'bookReserved' && event.newValue === 'true') || 
            (event.key === 'bookReservationCancelled' && event.newValue === 'true') ||
            (event.key === 'bookAvailabilityChanged' && event.newValue === 'true')) {
            
            const changeTime = localStorage.getItem('availabilityChangeTime');
            // Only respond to recent events (within the last 5 seconds)
            if (changeTime && (Date.now() - parseInt(changeTime)) < 5000) {
                console.log('Book availability changed in another tab');
                
                // If we're on the book list page, refresh it
                if (window.location.href.includes('action=list')) {
                    window.location.reload();
                }
                
                // If we're on the dashboard, update it
                if (window.location.href.includes('dashboard.jsp')) {
                    // Update the dashboard counts without full page refresh
                    updateDashboardCounts();
                }
            }
        }
    });
}

// Function to update dashboard counts without page refresh
function updateDashboardCounts() {
    fetch('dashboardCount')
        .then(response => response.json())
        .then(data => {
            if (!data.error) {
                // Update the dashboard cards with the new counts
                const cards = document.querySelectorAll('.dashboard-cards .card-value');
                if (cards.length >= 3) {
                    cards[0].textContent = data.totalBooks;
                    cards[1].textContent = data.availableBooks;
                    cards[2].textContent = data.reservations;
                    
                    // Highlight the available books card
                    const availableCard = document.querySelector('a[href="book?action=list&available=true"]');
                    if (availableCard) {
                        availableCard.classList.add('highlight-update');
                        setTimeout(() => {
                            availableCard.classList.remove('highlight-update');
                        }, 2000);
                    }
                }
            }
        })
        .catch(err => console.error('Error updating dashboard:', err));
}

// Initialize reservation utilities
document.addEventListener('DOMContentLoaded', function() {
    listenForReservationChanges();
    
    // Check if we need to update the page based on recent changes
    const availabilityChanged = localStorage.getItem('bookAvailabilityChanged') === 'true';
    const changeTime = localStorage.getItem('availabilityChangeTime');
    
    if (availabilityChanged && changeTime && (Date.now() - parseInt(changeTime)) < 5000) {
        // Clear the flag
        localStorage.setItem('bookAvailabilityChanged', 'false');
        
        // Update the appropriate page
        if (window.location.href.includes('dashboard.jsp')) {
            updateDashboardCounts();
        }
    }
});



