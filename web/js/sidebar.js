// Sidebar Navigation Functions
function toggleInventoryMenu(element) {
    var menu = element.nextElementSibling;
    var icon = element.querySelector('.fa-angle-left');
    
    if (menu.style.display === 'none' || menu.style.display === '') {
        menu.style.display = 'block';
        icon.classList.add('fa-angle-down');
        icon.classList.remove('fa-angle-left');
        element.parentElement.classList.add('active');
    } else {
        menu.style.display = 'none';
        icon.classList.add('fa-angle-left');
        icon.classList.remove('fa-angle-down');
        element.parentElement.classList.remove('active');
    }
}

function togglePurchaseMenu(element) {
    var menu = element.nextElementSibling;
    var icon = element.querySelector('.fa-angle-left');
    
    if (menu.style.display === 'none' || menu.style.display === '') {
        menu.style.display = 'block';
        icon.classList.add('fa-angle-down');
        icon.classList.remove('fa-angle-left');
        element.parentElement.classList.add('active');
    } else {
        menu.style.display = 'none';
        icon.classList.add('fa-angle-left');
        icon.classList.remove('fa-angle-down');
        element.parentElement.classList.remove('active');
    }
}

// Set active menu based on current URL
document.addEventListener('DOMContentLoaded', function() {
    var currentPath = window.location.pathname;
    var menuItems = document.querySelectorAll('.sidebar-menu a');
    
    menuItems.forEach(function(item) {
        var href = item.getAttribute('href');
        if (href && currentPath.includes(href.split('?')[0])) {
            item.parentElement.classList.add('active');
            
            // If it's a submenu item, expand the parent menu
            var parentTreeview = item.closest('.treeview');
            if (parentTreeview) {
                var parentMenu = parentTreeview.querySelector('.treeview-menu');
                var parentIcon = parentTreeview.querySelector('.fa-angle-left');
                
                if (parentMenu) {
                    parentMenu.style.display = 'block';
                    if (parentIcon) {
                        parentIcon.classList.add('fa-angle-down');
                        parentIcon.classList.remove('fa-angle-left');
                    }
                    parentTreeview.classList.add('active');
                }
            }
        }
    });
});