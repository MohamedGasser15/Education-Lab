class TokenManager {
    constructor() {
        this.isRefreshing = false;
        this.init();
    }

    init() {
        // التحقق من صلاحية التوكن كل دقيقة
        setInterval(() => this.checkTokenValidity(), 60000);
    }

    async checkTokenValidity() {
        if (this.isRefreshing) return;

        const accessToken = this.getCookie('AuthToken');
        if (!accessToken) return;

        // التحقق من انتهاء الصلاحية (قبل 30 ثانية من الانتهاء الفعلي)
        const tokenData = this.parseJwt(accessToken);
        if (tokenData && tokenData.exp) {
            const expiryTime = tokenData.exp * 1000;
            const currentTime = Date.now();
            const bufferTime = 30000; // 30 ثانية

            if (expiryTime - currentTime < bufferTime) {
                await this.refreshToken();
            }
        }
    }

    async refreshToken() {
        this.isRefreshing = true;

        try {
            const accessToken = this.getCookie('AuthToken');
            const refreshToken = this.getCookie('RefreshToken');

            if (!accessToken || !refreshToken) {
                throw new Error('No tokens available');
            }

            const response = await fetch('/Learner/Auth/RefreshToken', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'RequestVerificationToken': document.querySelector('input[name="__RequestVerificationToken"]').value
                },
                body: JSON.stringify({
                    accessToken: accessToken,
                    refreshToken: refreshToken
                })
            });

            if (response.ok) {
                const result = await response.json();
                console.log('Token refreshed successfully');
            } else {
                throw new Error('Failed to refresh token');
            }
        } catch (error) {
            console.error('Token refresh failed:', error);
            window.location.href = '/Learner/Auth/Login';
        } finally {
            this.isRefreshing = false;
        }
    }

    getCookie(name) {
        const value = `; ${document.cookie}`;
        const parts = value.split(`; ${name}=`);
        if (parts.length === 2) return parts.pop().split(';').shift();
    }

    parseJwt(token) {
        try {
            return JSON.parse(atob(token.split('.')[1]));
        } catch (e) {
            return null;
        }
    }
}

// Initialize token manager
document.addEventListener('DOMContentLoaded', function () {
    window.tokenManager = new TokenManager();
});