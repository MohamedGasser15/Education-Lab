import 'package:flutter/foundation.dart';
import 'package:mobile/core/di/service_locator.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/courses/data/models/certificate_model.dart';
import 'package:mobile/features/courses/data/repositories/certificates_repository.dart';

class CertificatesProvider with ChangeNotifier {
  final CertificatesRepository _repository;

  bool _isLoading = false;
  String? _errorMessage;
  List<CertificateModel> _certificates = [];

  CertificatesProvider({CertificatesRepository? repository})
    : _repository = repository ?? resolveOr(() => CertificatesRepository());

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<CertificateModel> get certificates => _certificates;
  int get count => _certificates.length;

  Future<void> fetchMyCertificates({bool forceRefresh = false}) async {
    if (_certificates.isNotEmpty && !forceRefresh) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.getMyCertificates();
      if (result is Success<List<CertificateModel>>) {
        _certificates = result.data;
        _errorMessage = null;
      } else if (result is Failure<List<CertificateModel>>) {
        _errorMessage = result.message;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _certificates = [];
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}
