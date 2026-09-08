import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/courses/data/models/certificate_model.dart';

class CertificatesApiService {
  final ApiClient _apiClient;

  CertificatesApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// GET /api/Certificates/my
  Future<Result<List<CertificateModel>>> getMyCertificates() async {
    try {
      final result = await _apiClient.getSafe(ApiConstants.myCertificates);

      if (result is Success) {
        dynamic data = result.data;
        if (data is String && data.isNotEmpty) {
          try {
            data = json.decode(data);
          } catch (_) {}
        }

        List<dynamic> list = [];
        if (data is List) {
          list = data;
        } else if (data is Map<String, dynamic>) {
          if (data['data'] is List) {
            list = data['data'] as List;
          } else if (data['result'] is List) {
            list = data['result'] as List;
          }
        }

        final certificates = list
            .map((item) => CertificateModel.fromJson(item as Map<String, dynamic>))
            .toList();

        return Success(certificates);
      } else if (result is Failure) {
        return Failure(_extractErrorMessage(result), error: result.error);
      }
      return const Failure('تعذر جلب قائمة الشهادات');
    } catch (e) {
      debugPrint('CertificatesApiService.getMyCertificates error: $e');
      return Failure('حدث خطأ أثناء جلب الشهادات: $e', error: e);
    }
  }

  /// GET /api/Certificates/verify/{code}
  Future<Result<Map<String, dynamic>>> verifyCertificate(String code) async {
    try {
      final result = await _apiClient.getSafe(ApiConstants.verifyCertificatePath(code));

      if (result is Success) {
        dynamic data = result.data;
        if (data is String && data.isNotEmpty) {
          try {
            data = json.decode(data);
          } catch (_) {}
        }
        if (data is Map<String, dynamic>) {
          return Success(data);
        }
        return const Success({'valid': true});
      } else if (result is Failure) {
        return Failure(_extractErrorMessage(result), error: result.error);
      }
      return const Failure('الشهادة غير صالحة أو غير موجودة');
    } catch (e) {
      debugPrint('CertificatesApiService.verifyCertificate error: $e');
      return Failure('حدث خطأ أثناء التحقق من الشهادة: $e', error: e);
    }
  }

  String _extractErrorMessage(Failure failure) {
    String msg = failure.message;
    try {
      if (failure.error is ApiException) {
        final rawBody = (failure.error as ApiException).responseBody;
        final decoded = json.decode(rawBody);
        if (decoded is Map<String, dynamic>) {
          if (decoded['message'] != null) return decoded['message'].toString();
          if (decoded['Message'] != null) return decoded['Message'].toString();
        }
      }
    } catch (_) {}
    return msg;
  }
}
