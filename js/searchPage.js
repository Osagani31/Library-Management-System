/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */
let searchTimeout;
const searchDelay = 400; // milliseconds delay after typing

document.addEventListener('DOMContentLoaded', function() {
    // Set up event listeners
    const searchInput = document.getElementById('liveSearchInput');
    if (searchInput) {
        searchInput.addEventListener('input', performLiveSearch);
    }
    
    const searchTypeSelect = document.getElementById('searchType');
    if (searchTypeSelect) {
        searchTypeSelect.addEventListener('change', function() {
            if (searchInput.value.trim().length > 0) {
                performLiveSearch();
            }
        });
    }
    
    // Event listener to close results when clicking outside
    document.addEventListener('click', function(event) {
        const resultsContainer = document.getElementById('liveSearchResults');
        
        if (resultsContainer && searchInput) {
            if (!resultsContainer.contains(event.target) && event.target !== searchInput) {
                resultsContainer.style.display = 'none';
            }
        }
    });
});

/**
 * Perform live search as user types
 */
function performLiveSearch() {
    const searchTerm = document.getElementById('liveSearchInput').value.trim();
    const searchType = document.getElementById('searchType')?.value || 'both';
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
        let endpoint = `book?action=livesearch&term=${encodeURIComponent(searchTerm)}&type=${encodeURIComponent(searchType)}`;
        xhr.open('GET', endpoint, true);
        
        xhr.onload = function() {
            if (this.status === 200) {
                try {
                    const books = JSON.parse(this.responseText);
                    displayLiveSearchResults(books, resultsContainer);
                    updateMainSearchResults(books);
                } catch (e) {
                    resultsContainer.innerHTML = '<div class="p-3 text-danger">Error processing results</div>';
                }
            } else {
                resultsContainer.innerHTML = '<div class="p-3 text-danger">Error loading results</div>';
            }
        };
        
        xhr.onerror = function() {
            resultsContainer.innerHTML = '<div class="p-3 text-danger">Network error occurred</div>';
            console.error('Live search AJAX error:', xhr);
            alert('Live search failed: Network error.');
        };
        
        xhr.send();
    }, searchDelay);
}

/**
 * Display live search results in dropdown
 */
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
            `<a href=\"reserveForm.jsp?bookId=${book.bookId}\" class=\"badge bg-success text-decoration-none\">Available</a>` : 
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

/**
 * Update the main search results section
 */
function updateMainSearchResults(books) {
    const mainResultsContainer = document.getElementById('searchResults');
    if (!mainResultsContainer) return;
    
    if (!books || books.length === 0) {
        mainResultsContainer.innerHTML = `
            <div class="text-center py-4">
                <i class="fas fa-search fa-2x mb-3 text-muted"></i>
                <p class="text-muted">No books found matching your search criteria</p>
            </div>
        `;
        return;
    }
    
    // Build results as a table
    let html = `
        <div class="table-responsive">
            <table class="table table-hover">
                <thead class="table-light">
                    <tr>
                        <th>Title</th>
                        <th>Author</th>
                        <th>ISBN</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
    `;
    
    books.forEach(book => {
        const availability = book.available ? 
            '<span class="badge bg-success">Available</span>' : 
            '<span class="badge bg-danger">Reserved</span>';
        
        const reserveBtn = book.available ? 
            `<a href="reserveForm.jsp?bookId=${book.bookId}" class="btn btn-sm btn-success">
                <i class="fas fa-bookmark"></i> Reserve
            </a>` : 
            `<button class="btn btn-sm btn-secondary" disabled>
                <i class="fas fa-bookmark"></i> Reserved
            </button>`;
            
        html += `
            <tr>
                <td>${book.title}</td>
                <td>${book.author}</td>
                <td>${book.isbn || 'N/A'}</td>
                <td>${availability}</td>
                <td>
                    <div class="btn-group">
                        <a href="book?action=details&bookId=${book.bookId}" class="btn btn-sm btn-info">
                            <i class="fas fa-info-circle"></i> Details
                        </a>
                        ${reserveBtn}
                    </div>
                </td>
            </tr>
        `;
    });
    
    html += `
                </tbody>
            </table>
        </div>
    `;
    
    mainResultsContainer.innerHTML = html;
}

// Add global error handler for JS errors
window.addEventListener('error', function(event) {
    alert('JavaScript error: ' + event.message + '\n' + event.filename + ':' + event.lineno);
    console.error('JavaScript error:', event);
});


