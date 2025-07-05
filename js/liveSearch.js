/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


document.addEventListener('DOMContentLoaded', function() {
    initializeLiveSearch();
});

/**
 * Initialize the live search functionality
 */
function initializeLiveSearch() {
    const searchInput = document.getElementById('searchInput');
    if (!searchInput) return;
    
    // Debounce function to prevent too many requests
    let debounceTimer;
    
    // Add event listener for input changes
    searchInput.addEventListener('input', function() {
        const query = this.value.trim();
        
        // Clear any existing timer
        clearTimeout(debounceTimer);
        
        // Set a delay before making the request
        debounceTimer = setTimeout(() => {
            if (query.length >= 2) {
                // Only search if at least 2 characters
                performLiveSearch(query);
            } else {
                // Clear results if query is too short
                clearSearchResults();
            }
        }, 300); // 300ms delay
    });
    
    // Handle search type selection if available
    const searchTypeSelect = document.getElementById('searchType');
    if (searchTypeSelect) {
        searchTypeSelect.addEventListener('change', function() {
            if (searchInput.value.trim().length >= 2) {
                performLiveSearch(searchInput.value.trim());
            }
        });
    }
}

/**
 * Perform live search using AJAX
 * @param {string} query - The search query
 */
function performLiveSearch(query) {
    // Get search type if available
    const searchType = document.getElementById('searchType')?.value || 'both';
    
    // Show loading indicator
    showLoadingIndicator();
    
    // Create URL with parameters
    const url = `liveSearch?query=${encodeURIComponent(query)}&type=${encodeURIComponent(searchType)}`;
    
    // Create and send AJAX request
    fetch(url)
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            displaySearchResults(data);
        })
        .catch(error => {
            console.error('Error during search:', error);
            displayErrorMessage('An error occurred during search. Please try again.');
        })
        .finally(() => {
            // Hide loading indicator
            hideLoadingIndicator();
        });
}

/**
 * Display the search results in the results container
 * @param {Array} books - The array of book objects
 */
function displaySearchResults(books) {
    const resultsContainer = document.getElementById('searchResults');
    if (!resultsContainer) return;
    
    // Clear previous results
    resultsContainer.innerHTML = '';
    
    if (books.length === 0) {
        // No results found
        resultsContainer.innerHTML = '<div class="no-results">No books found matching your criteria.</div>';
        return;
    }
    
    // Create table if results exist
    const table = document.createElement('table');
    table.className = 'table table-striped search-results-table';
    
    // Create table header
    const thead = document.createElement('thead');
    thead.innerHTML = `
        <tr>
            <th>Title</th>
            <th>Author</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
    `;
    table.appendChild(thead);
    
    // Create table body
    const tbody = document.createElement('tbody');
    
    // Add each book to the table
    books.forEach(book => {
        const tr = document.createElement('tr');
        
        // Status label
        const statusLabel = book.available ? 
            '<span class="badge bg-success">Available</span>' : 
            '<span class="badge bg-danger">Not Available</span>';
        
        tr.innerHTML = `
            <td>${book.title}</td>
            <td>${book.author}</td>
            <td>${statusLabel}</td>
            <td>
                <a href="book?action=details&id=${book.id}" class="btn btn-sm btn-info">
                    <i class="fas fa-info-circle"></i> Details
                </a>
                ${book.available ? 
                    `<a href="reservation?action=new&bookId=${book.id}" class="btn btn-sm btn-primary ms-1">
                        <i class="fas fa-bookmark"></i> Reserve
                    </a>` : ''}
            </td>
        `;
        
        tbody.appendChild(tr);
    });
    
    table.appendChild(tbody);
    resultsContainer.appendChild(table);
}

/**
 * Clear the search results
 */
function clearSearchResults() {
    const resultsContainer = document.getElementById('searchResults');
    if (resultsContainer) {
        resultsContainer.innerHTML = '';
    }
}

/**
 * Display an error message
 * @param {string} message - The error message to display
 */
function displayErrorMessage(message) {
    const resultsContainer = document.getElementById('searchResults');
    if (resultsContainer) {
        resultsContainer.innerHTML = `<div class="alert alert-danger">${message}</div>`;
    }
}

/**
 * Show loading indicator
 */
function showLoadingIndicator() {
    const resultsContainer = document.getElementById('searchResults');
    if (resultsContainer) {
        resultsContainer.innerHTML = `
            <div class="text-center mt-4">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Loading...</span>
                </div>
                <p class="mt-2">Searching...</p>
            </div>
        `;
    }
}

/**
 * Hide loading indicator
 */
function hideLoadingIndicator() {
    // The loading indicator will be replaced when results are displayed
}

/**
 * Live Search functionality for books
 */

let searchTimeout;
const searchDelay = 400; // milliseconds delay after typing

function performLiveSearch() {
    const searchTerm = document.getElementById('liveSearchInput').value.trim();
    const resultsContainer = document.getElementById('liveSearchResults');
    
    // Clear previous timeout to prevent multiple requests
    clearTimeout(searchTimeout);
    
    // Clear results if search is empty
    if (searchTerm === '') {
        resultsContainer.innerHTML = '';
        resultsContainer.style.display = 'none';
        return;
    }
    
    // Set a timeout for the search to reduce number of requests while typing
    searchTimeout = setTimeout(() => {
        // Show loading indicator
        resultsContainer.innerHTML = '<div class="text-center p-3"><div class="spinner-border spinner-border-sm text-primary" role="status"></div> Searching...</div>';
        resultsContainer.style.display = 'block';
        
        // Create the AJAX request
        const xhr = new XMLHttpRequest();
        xhr.open('GET', `book?action=livesearch&term=${encodeURIComponent(searchTerm)}`, true);
        
        xhr.onload = function() {
            if (this.status === 200) {
                try {
                    const books = JSON.parse(this.responseText);
                    displayLiveSearchResults(books, resultsContainer);
                } catch (e) {
                    resultsContainer.innerHTML = '<div class="p-3 text-danger">Error processing results</div>';
                }
            } else {
                resultsContainer.innerHTML = '<div class="p-3 text-danger">Error loading results</div>';
            }
        };
        
        xhr.onerror = function() {
            resultsContainer.innerHTML = '<div class="p-3 text-danger">Network error occurred</div>';
        };
        
        xhr.send();
    }, searchDelay);
}

function displayLiveSearchResults(books, container) {
    // If no books found
    if (!books || books.length === 0) {
        container.innerHTML = '<div class="p-3 text-muted">No books found matching your search</div>';
        return;
    }
    
    // Build results HTML
    let html = '<div class="list-group">';
    
    books.forEach(book => {
        const availability = book.available ? 
            '<span class="badge bg-success">Available</span>' : 
            '<span class="badge bg-danger">Reserved</span>';
            
        html += `
            <a href="book?action=details&bookId=${book.bookId}" class="list-group-item list-group-item-action">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="mb-1">${book.title}</h6>
                        <small class="text-muted">by ${book.author}</small>
                    </div>
                    <div>
                        ${availability}
                    </div>
                </div>
            </a>
        `;
    });
    
    html += '</div>';
    container.innerHTML = html;
    container.style.display = 'block';
}

// Event listener to close results when clicking outside
document.addEventListener('click', function(event) {
    const resultsContainer = document.getElementById('liveSearchResults');
    const searchInput = document.getElementById('liveSearchInput');
    
    if (resultsContainer && searchInput) {
        if (!resultsContainer.contains(event.target) && event.target !== searchInput) {
            resultsContainer.style.display = 'none';
        }
    }
});


