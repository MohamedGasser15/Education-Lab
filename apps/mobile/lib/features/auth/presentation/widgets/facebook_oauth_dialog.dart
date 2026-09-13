import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// In-app Facebook OAuth Dialog for platforms (like iOS) where the native SDK
/// enforces Limited Login (JWT OIDC Token) instead of standard Graph API Access Tokens.
class FacebookOAuthDialog extends StatefulWidget {
  final String appId;

  const FacebookOAuthDialog({
    super.key,
    this.appId = '2046814272412391',
  });

  static Future<String?> show(BuildContext context, {String appId = '2046814272412391'}) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FacebookOAuthDialog(appId: appId),
    );
  }

  @override
  State<FacebookOAuthDialog> createState() => _FacebookOAuthDialogState();
}

class _FacebookOAuthDialogState extends State<FacebookOAuthDialog> {
  late final WebViewController _controller;
  bool _isLoading = true;

  static const String _redirectUri = 'https://www.facebook.com/connect/login_success.html';

  @override
  void initState() {
    super.initState();
    final authUrl = Uri.https('www.facebook.com', '/v19.0/dialog/oauth', {
      'client_id': widget.appId,
      'redirect_uri': _redirectUri,
      'response_type': 'token,granted_scopes',
      'scope': 'email,public_profile',
      'display': 'touch',
    });

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            _checkRedirect(url);
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _isLoading = false);
          },
          onNavigationRequest: (request) {
            if (_checkRedirect(request.url)) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(authUrl);
  }

  bool _checkRedirect(String url) {
    if (url.startsWith(_redirectUri)) {
      final sanitizedUrl = url.replaceFirst('#', '?');
      final uri = Uri.tryParse(sanitizedUrl);
      if (uri != null) {
        final accessToken = uri.queryParameters['access_token'];
        if (accessToken != null && accessToken.isNotEmpty) {
          Navigator.of(context).pop(accessToken);
          return true;
        }

        final error = uri.queryParameters['error'];
        if (error != null) {
          Navigator.of(context).pop(null);
          return true;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.facebook, color: Color(0xFF1877F2), size: 28),
                const SizedBox(width: 8),
                Text(
                  'Facebook Login',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(null),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          if (_isLoading)
            const LinearProgressIndicator(
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1877F2)),
            ),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
              child: WebViewWidget(controller: _controller),
            ),
          ),
        ],
      ),
    );
  }
}
