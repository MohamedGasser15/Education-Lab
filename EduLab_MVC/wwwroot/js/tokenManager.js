/**
 * Manages JWT token operations including automatic refresh and validity checks.
 */
class TokenManager {
    constructor() {
        this.isRefreshing = false;
        this.refreshInterval = 60000; // 1 minute
        this.expiryBufferTime = 30000; // 30 seconds
        this.init();
    }

    /**
     * Initializes the token manager and sets up periodic checks.
     */
    init() {
        console.log('TokenManager initialized');
        // Check token validity every minute
        setInterval(() => this.checkTokenValidity(), this.refreshInterval);

        // Also check immediately on initialization
        this.checkTokenValidity();
    }

    /**
     * Checks if the access token is about to expire and refreshes it if needed.
     */
    async checkTokenValidity() {
        if (this.isRefreshing) {
            console.log('Refresh already in progress, skipping check');
            return;
        }

        const accessToken = this.getCookie('AuthToken');
        if (!accessToken) {
            console.log('No access token found in cookies');
            return;
        }

        try {
            const tokenData = this.parseJwt(accessToken);
            if (tokenData && tokenData.exp) {
                const expiryTime = tokenData.exp * 1000;
                const currentTime = Date.now();

                if (expiryTime - currentTime < this.expiryBufferTime) {
                    console.log('Token about to expire, refreshing...');
                    await this.refreshToken();
                } else {
                    console.log('Token is still valid');
                }
            }
        } catch (error) {
            console.error('Error checking token validity:', error);
        }
    }

    /**
     * Refreshes the access token using the refresh token.
     */
    async refreshToken() {
        if (this.isRefreshing) {
            console.log('Refresh already in progress');
            return;
        }

        this.isRefreshing = true;
        console.log('Starting token refresh process');

        try {
            const accessToken = this.getCookie('AuthToken');
            const refreshToken = this.getCookie('RefreshToken');

            if (!accessToken || !refreshToken) {
                throw new Error('No tokens available for refresh');
            }

            // Get anti-forgery token
            const verificationToken = document.querySelector('input[name="__RequestVerificationToken"]')?.value;
            if (!verificationToken) {
                throw new Error('Anti-forgery token not found');
            }

            const response = await fetch('/Learner/Auth/RefreshToken', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'RequestVerificationToken': verificationToken,
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: JSON.stringify({
                    accessToken: accessToken,
                    refreshToken: refreshToken
                })
            });

            if (response.ok) {
                const result = await response.json();
                if (result.success) {
                    console.log('Token refreshed successfully');
                    // The server middleware will handle updating cookies
                } else {
                    throw new Error(result.error || 'Failed to refresh token');
                }
            } else if (response.status === 401) {
                throw new Error('Unauthorized - redirecting to login');
            } else {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
        } catch (error) {
            console.error('Token refresh failed:', error);

            // Only redirect if it's an authentication error
            if (error.message.includes('Unauthorized') || error.message.includes('No tokens')) {
                this.handleLogout();
            }
        } finally {
            this.isRefreshing = false;
            console.log('Token refresh process completed');
        }
    }

    /**
     * Handles user logout by redirecting to login page.
     */
    handleLogout() {
        console.log('Handling logout due to token refresh failure');

        // Clear any existing tokens from cookies
        this.clearCookies();

        // Redirect to login page
        window.location.href = '/Learner/Auth/Login';
    }

    /**
     * Clears authentication cookies.
     */
    clearCookies() {
        const cookies = ['AuthToken', 'RefreshToken', 'RefreshTokenExpiry', 'UserFullName', 'UserRole', 'ProfileImageUrl'];
        cookies.forEach(cookie => {
            document.cookie = `${cookie}=; expires=Thu, 01 Jan 1970 00:00:00 GMT; path=/`;
        });
    }

    /**
     * Gets a cookie value by name.
     * @param {string} name - The cookie name.
     * @returns {string|null} The cookie value or null if not found.
     */
    getCookie(name) {
        const value = `; ${document.cookie}`;
        const parts = value.split(`; ${name}=`);
        if (parts.length === 2) {
            return parts.pop().split(';').shift();
        }
        return null;
    }

    /**
     * Parses a JWT token and returns its payload.
     * @param {string} token - The JWT token.
     * @returns {object|null} The token payload or null if invalid.
     */
    parseJwt(token) {
        try {
            // Handle base64url encoding
            const base64Url = token.split('.')[1];
            const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
            const jsonPayload = decodeURIComponent(atob(base64).split('').map(function (c) {
                return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
            }).join(''));

            return JSON.parse(jsonPayload);
        } catch (error) {
            console.error('Error parsing JWT:', error);
            return null;
        }
    }

    /**
     * Manually triggers a token refresh (for testing or specific cases).
     */
    async manualRefresh() {
        console.log('Manual token refresh triggered');
        await this.refreshToken();
    }
}

// Initialize token manager when DOM is loaded
document.addEventListener('DOMContentLoaded', function () {
    // Only initialize if we're on a page that requires authentication
    if (document.querySelector('input[name="__RequestVerificationToken"]')) {
        window.tokenManager = new TokenManager();
        console.log('TokenManager initialized successfully');
    }
});

// Export for module usage if needed
if (typeof module !== 'undefined' && module.exports) {
    module.exports = TokenManager;
}