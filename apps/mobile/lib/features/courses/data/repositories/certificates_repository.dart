import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/courses/data/models/certificate_model.dart';
import 'package:mobile/features/courses/data/services/certificates_api_service.dart';

class CertificatesRepository {
  final CertificatesApiService _apiService;

  CertificatesRepository({CertificatesApiService? apiService})
      : _apiService = apiService ?? CertificatesApiService();

  Future<Result<List<CertificateModel>>> getMyCertificates() {
    return _apiService.getMyCertificates();
  }

  Future<Result<Map<String, dynamic>>> verifyCertificate(String code) {
    return _apiService.verifyCertificate(code);
  }
}
