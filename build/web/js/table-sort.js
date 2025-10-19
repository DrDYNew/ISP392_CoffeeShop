/**
 * Table Sort Utility
 * Provides click-to-sort functionality for table columns
 */

let currentSortOrder = 'asc'; // Track current sort order

/**
 * Sort table rows by STT column (index column)
 * Click once: Sort descending (high to low)
 * Click again: Sort ascending (low to high)
 * @param {string} tableBodyId - The ID of the table body element
 */
function sortBySTT(tableBodyId) {
    const tbody = document.getElementById(tableBodyId);
    if (!tbody) {
        console.error('Table body not found with ID:', tableBodyId);
        return;
    }

    const rows = Array.from(tbody.getElementsByTagName('tr'));
    
    // Toggle sort order
    currentSortOrder = (currentSortOrder === 'asc') ? 'desc' : 'asc';
    
    // Sort rows
    rows.sort((a, b) => {
        // Get the first cell (STT column) text content
        const aValue = parseInt(a.cells[0].textContent.trim()) || 0;
        const bValue = parseInt(b.cells[0].textContent.trim()) || 0;
        
        if (currentSortOrder === 'asc') {
            return aValue - bValue; // Ascending: low to high
        } else {
            return bValue - aValue; // Descending: high to low
        }
    });
    
    // Re-append sorted rows to tbody
    rows.forEach(row => tbody.appendChild(row));
    
    // Update STT column header with sort indicator
    updateSortIndicator(currentSortOrder);
}

/**
 * Update the sort indicator icon in the STT column header
 * @param {string} order - Current sort order ('asc' or 'desc')
 */
function updateSortIndicator(order) {
    const sttHeaders = document.querySelectorAll('th.sortable-stt');
    sttHeaders.forEach(header => {
        // Remove existing sort icons
        const existingIcon = header.querySelector('.sort-icon');
        if (existingIcon) {
            existingIcon.remove();
        }
        
        // Add new sort icon
        const icon = document.createElement('i');
        icon.className = 'fa sort-icon';
        
        if (order === 'asc') {
            icon.classList.add('fa-sort-amount-asc');
            icon.style.marginLeft = '5px';
        } else {
            icon.classList.add('fa-sort-amount-desc');
            icon.style.marginLeft = '5px';
        }
        
        header.appendChild(icon);
    });
}

/**
 * Initialize sortable STT columns
 * Call this function when the page loads
 */
function initSortableSTT() {
    const sttHeaders = document.querySelectorAll('th.sortable-stt');
    sttHeaders.forEach(header => {
        header.style.cursor = 'pointer';
        header.style.userSelect = 'none';
        
        // Add initial sort icon (default: ascending)
        const icon = document.createElement('i');
        icon.className = 'fa fa-sort sort-icon';
        icon.style.marginLeft = '5px';
        icon.style.opacity = '0.5';
        header.appendChild(icon);
    });
}

// Auto-initialize when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    initSortableSTT();
});
