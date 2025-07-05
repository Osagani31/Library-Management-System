/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
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

