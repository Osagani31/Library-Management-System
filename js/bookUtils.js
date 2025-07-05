/**
 * Book Utilities for the Library Management System
 * 
 * This script handles book-related functionality and cross-tab communication
 * when books are added or updated in the system.
 */

// Function to notify other tabs that a book has been added
function notifyBookAdded() {
    // Set a flag in localStorage that a book was added
    localStorage.setItem('bookAdded', 'true');
    localStorage.setItem('bookAddedTime', Date.now().toString());
    
    // Dispatch a storage event to notify other tabs
    window.dispatchEvent(new StorageEvent('storage', {
        key: 'bookAdded',
        newValue: 'true'
    }));
}

// Function to listen for book additions from other tabs
function listenForBookChanges() {
    window.addEventListener('storage', function(event) {
        if (event.key === 'bookAdded' && event.newValue === 'true') {
            const addedTime = localStorage.getItem('bookAddedTime');
            // Only respond to recent events (within the last 5 seconds)
            if (addedTime && (Date.now() - parseInt(addedTime)) < 5000) {
                console.log('Book added in another tab, refreshing data');
                // Clear the flag
                localStorage.setItem('bookAdded', 'false');
                
                // If we're on the book list page, refresh it
                if (window.location.href.includes('action=list')) {
                    window.location.reload();
                }
                
                // Or update the count via AJAX if we're on another page
                if (window.location.href.includes('dashboard')) {
                    // The dashboard page already has code to handle this
                    return;
                }
                
                // Update counts via fetch API
                fetch('dashboardCount')
                    .then(response => response.json())
                    .then(data => {
                        console.log('Updated dashboard counts:', data);
                    })
                    .catch(err => console.error('Error updating counts:', err));
            }
        }
    });
}

// Function to set a form submission flag
function markBookFormSubmitted() {
    localStorage.setItem('bookFormSubmitted', 'true');
}

// Initialize book utilities
document.addEventListener('DOMContentLoaded', function() {
    listenForBookChanges();
    
    // If we're on the book form page, prepare form handling
    const addBookForm = document.getElementById('addBookForm');
    if (addBookForm) {
        addBookForm.addEventListener('submit', function() {
            markBookFormSubmitted();
        });
    }
});

