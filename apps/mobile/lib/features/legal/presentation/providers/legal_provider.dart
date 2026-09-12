import 'package:flutter/foundation.dart';
import 'package:mobile/core/di/service_locator.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/legal/data/models/legal_content_model.dart';
import 'package:mobile/features/legal/data/services/legal_api_service.dart';

class LegalProvider with ChangeNotifier {
  final LegalApiService _service;

  bool _isLoading = false;
  LegalContentModel? _aboutDoc;
  LegalContentModel? _privacyDoc;
  LegalContentModel? _termsDoc;
  String? _loadedLanguage;

  LegalProvider({LegalApiService? service})
    : _service = service ?? resolveOr(() => LegalApiService());

  bool get isLoading => _isLoading;
  LegalContentModel? get aboutDoc => _aboutDoc;
  LegalContentModel? get privacyDoc => _privacyDoc;
  LegalContentModel? get termsDoc => _termsDoc;

  Future<void> fetchLegalDocs({
    required String language,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _loadedLanguage == language && _aboutDoc != null) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _service.getAllLegalInfo(language: language);
      if (result is Success<Map<String, LegalContentModel>>) {
        final map = result.data;
        _aboutDoc =
            map['about'] ??
            LegalApiService.getDefaultDoc('about', language: language);
        _privacyDoc =
            map['privacy'] ??
            LegalApiService.getDefaultDoc('privacy', language: language);
        _termsDoc =
            map['terms'] ??
            LegalApiService.getDefaultDoc('terms', language: language);
        _loadedLanguage = language;
      } else {
        _aboutDoc = LegalApiService.getDefaultDoc('about', language: language);
        _privacyDoc = LegalApiService.getDefaultDoc(
          'privacy',
          language: language,
        );
        _termsDoc = LegalApiService.getDefaultDoc('terms', language: language);
        _loadedLanguage = language;
      }
    } catch (_) {
      _aboutDoc = LegalApiService.getDefaultDoc('about', language: language);
      _privacyDoc = LegalApiService.getDefaultDoc(
        'privacy',
        language: language,
      );
      _termsDoc = LegalApiService.getDefaultDoc('terms', language: language);
      _loadedLanguage = language;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
