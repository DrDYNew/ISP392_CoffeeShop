/**
 * Login Page JavaScript
 * Handles form validation and user interactions
 */

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    initializeLoginForm();
    showMessages();
});

/**
 * Initialize login form functionality
 */
function initializeLoginForm() {
    const loginForm = document.getElementById('loginForm');
    const emailInput = document.getElementById('email');
    const passwordInput = document.getElementById('password');
    const submitButton = document.querySelector('.btn-login');
    
    if (!loginForm) return;
    
    // Real-time validation
    emailInput.addEventListener('blur', function() {
        validateEmail(this);
    });
    
    passwordInput.addEventListener('blur', function() {
        validatePassword(this);
    });
    
    // Clear error states on input
    emailInput.addEventListener('input', function() {
        clearFieldError(this);
    });
    
    passwordInput.addEventListener('input', function() {
        clearFieldError(this);
    });
    
    // Form submission
    loginForm.addEventListener('submit', function(e) {
        e.preventDefault();
        
        if (validateLoginForm()) {
            submitLoginForm();
        }
    });
    
    // Enter key handling
    document.addEventListener('keypress', function(e) {
        if (e.key === 'Enter' && !submitButton.disabled) {
            loginForm.dispatchEvent(new Event('submit'));
        }
    });
}

/**
 * Validate email field
 * @param {HTMLElement} emailField 
 * @returns {boolean}
 */
function validateEmail(emailField) {
    const email = emailField.value.trim();
    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    
    if (!email) {
        showFieldError(emailField, 'Email không được để trống');
        return false;
    }
    
    if (!emailRegex.test(email)) {
        showFieldError(emailField, 'Email không đúng định dạng');
        return false;
    }
    
    clearFieldError(emailField);
    return true;
}

/**
 * Validate password field
 * @param {HTMLElement} passwordField 
 * @returns {boolean}
 */
function validatePassword(passwordField) {
    const password = passwordField.value;
    
    if (!password) {
        showFieldError(passwordField, 'Mật khẩu không được để trống');
        return false;
    }
    
    if (password.length < 3) {
        showFieldError(passwordField, 'Mật khẩu phải có ít nhất 3 ký tự');
        return false;
    }
    
    clearFieldError(passwordField);
    return true;
}

/**
 * Validate entire login form
 * @returns {boolean}
 */
function validateLoginForm() {
    const emailField = document.getElementById('email');
    const passwordField = document.getElementById('password');
    
    const isEmailValid = validateEmail(emailField);
    const isPasswordValid = validatePassword(passwordField);
    
    return isEmailValid && isPasswordValid;
}

/**
 * Show field error
 * @param {HTMLElement} field 
 * @param {string} message 
 */
function showFieldError(field, message) {
    clearFieldError(field);
    
    field.classList.add('error');
    
    const errorDiv = document.createElement('div');
    errorDiv.className = 'field-error';
    errorDiv.style.color = '#e53e3e';
    errorDiv.style.fontSize = '0.8rem';
    errorDiv.style.marginTop = '5px';
    errorDiv.textContent = message;
    
    field.parentNode.appendChild(errorDiv);
}

/**
 * Clear field error
 * @param {HTMLElement} field 
 */
function clearFieldError(field) {
    field.classList.remove('error');
    
    const errorDiv = field.parentNode.querySelector('.field-error');
    if (errorDiv) {
        errorDiv.remove();
    }
}

/**
 * Submit login form
 */
function submitLoginForm() {
    const submitButton = document.querySelector('.btn-login');
    const originalText = submitButton.textContent;
    
    // Show loading state
    submitButton.classList.add('loading');
    submitButton.disabled = true;
    submitButton.textContent = 'Đang đăng nhập...';
    
    // Simulate network delay and submit
    setTimeout(() => {
        document.getElementById('loginForm').submit();
    }, 500);
}

/**
 * Show messages from URL parameters or server
 */
function showMessages() {
    const urlParams = new URLSearchParams(window.location.search);
    const message = urlParams.get('message');
    
    if (message) {
        showAlert(message, 'info');
        
        // Remove message from URL
        const url = new URL(window.location);
        url.searchParams.delete('message');
        window.history.replaceState({}, document.title, url);
    }
}

/**
 * Show alert message
 * @param {string} message 
 * @param {string} type - 'error', 'success', 'info'
 */
function showAlert(message, type = 'info') {
    // Remove existing alerts
    const existingAlerts = document.querySelectorAll('.alert');
    existingAlerts.forEach(alert => alert.remove());
    
    const alertDiv = document.createElement('div');
    alertDiv.className = `alert alert-${type}`;
    alertDiv.textContent = message;
    
    const container = document.querySelector('.login-container');
    const form = document.getElementById('loginForm');
    container.insertBefore(alertDiv, form);
    
    // Auto hide after 5 seconds
    setTimeout(() => {
        if (alertDiv.parentNode) {
            alertDiv.remove();
        }
    }, 5000);
}

/**
 * Toggle password visibility
 */
function togglePasswordVisibility() {
    const passwordField = document.getElementById('password');
    const toggleButton = document.querySelector('.password-toggle');
    
    if (passwordField.type === 'password') {
        passwordField.type = 'text';
        toggleButton.textContent = '🙈';
    } else {
        passwordField.type = 'password';
        toggleButton.textContent = '👁️';
    }
}

/**
 * Handle remember me functionality
 */
function handleRememberMe() {
    const rememberCheckbox = document.getElementById('rememberMe');
    const emailField = document.getElementById('email');
    
    if (rememberCheckbox && emailField) {
        // Load saved email if remember me was checked
        const savedEmail = localStorage.getItem('rememberedEmail');
        if (savedEmail) {
            emailField.value = savedEmail;
            rememberCheckbox.checked = true;
        }
        
        // Save/remove email based on checkbox state
        rememberCheckbox.addEventListener('change', function() {
            if (this.checked) {
                localStorage.setItem('rememberedEmail', emailField.value);
            } else {
                localStorage.removeItem('rememberedEmail');
            }
        });
        
        // Update saved email when email changes
        emailField.addEventListener('input', function() {
            if (rememberCheckbox.checked) {
                localStorage.setItem('rememberedEmail', this.value);
            }
        });
    }
}

// Initialize remember me functionality
document.addEventListener('DOMContentLoaded', handleRememberMe);