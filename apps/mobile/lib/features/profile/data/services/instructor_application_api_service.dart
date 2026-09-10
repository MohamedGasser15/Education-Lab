import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/profile/data/models/instructor_application_models.dart';

class InstructorApplicationApiService {
  final ApiClient _apiClient;

  InstructorApplicationApiService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// POST /api/InstructorApplication/apply (multipart/form-data)
  Future<Result<String>> submitApplication(InstructorApplicationDTO dto) async {
    try {
      final formData = dio.FormData();

      formData.fields.add(MapEntry('FullName', dto.fullName.trim()));
      if (dto.email != null && dto.email!.trim().isNotEmpty) {
        formData.fields.add(MapEntry('Email', dto.email!.trim()));
      }
      formData.fields.add(MapEntry('Phone', dto.phone.trim()));
      formData.fields.add(MapEntry('Bio', dto.bio.trim()));
      formData.fields.add(MapEntry('Specialization', dto.specialization.trim()));
      formData.fields.add(MapEntry('Experience', dto.experience.trim()));

      for (final skill in dto.skills) {
        if (skill.trim().isNotEmpty) {
          formData.fields.add(MapEntry('Skills', skill.trim()));
        }
      }

      if (dto.profileImage != null) {
        final img = dto.profileImage!;
        formData.files.add(MapEntry(
          'ProfileImage',
          await dio.MultipartFile.fromFile(
            img.path,
            filename: img.name.isNotEmpty ? img.name : 'profile_avatar.jpg',
          ),
        ));
      }

      if (dto.cvFile != null) {
        final cv = dto.cvFile!;
        formData.files.add(MapEntry(
          'CvFile',
          await dio.MultipartFile.fromFile(
            cv.path,
            filename: cv.name.isNotEmpty ? cv.name : 'resume_document.pdf',
          ),
        ));
      }

      final result = await _apiClient.postFormDataSafe(
        ApiConstants.instructorApplicationApply,
        formData: formData,
      );

      if (result is Success) {
        dynamic data = result.data;
        if (data is String && data.isNotEmpty) {
          try {
            data = json.decode(data);
          } catch (_) {}
        }

        String msg = 'تم تقديم الطلب بنجاح وجاري مراجعته من قبل الإدارة.';
        if (data is Map<String, dynamic> && data['message'] != null) {
          msg = data['message'].toString();
        }
        return Success(msg);
      } else if (result is Failure) {
        return Failure(_extractErrorMessage(result), error: result.error);
      }
      return const Failure('تعذر إرسال طلب الانضمام');
    } catch (e) {
      debugPrint('InstructorApplicationApiService.submitApplication error: $e');
      return Failure('حدث خطأ غير متوقع أثناء تقديم الطلب: $e', error: e);
    }
  }

  /// GET /api/InstructorApplication/my-applications
  Future<Result<List<InstructorApplicationResponseDto>>> getMyApplications() async {
    try {
      final result = await _apiClient.getSafe(ApiConstants.instructorApplicationMyApplications);

      if (result is Success) {
        dynamic data = result.data;
        if (data is String && data.isNotEmpty) {
          try {
            data = json.decode(data);
          } catch (_) {}
        }

        if (data is List) {
          final apps = data
              .whereType<Map<String, dynamic>>()
              .map((json) => InstructorApplicationResponseDto.fromJson(json))
              .toList();
          return Success(apps);
        } else if (data is Map<String, dynamic>) {
          final payload = data['data'] ?? data['result'] ?? data['items'];
          if (payload is List) {
            final apps = payload
                .whereType<Map<String, dynamic>>()
                .map((json) => InstructorApplicationResponseDto.fromJson(json))
                .toList();
            return Success(apps);
          }
        }
        return const Success([]);
      } else if (result is Failure) {
        return Failure(_extractErrorMessage(result), error: result.error);
      }
      return const Failure('تعذر جلب طلبات الانضمام');
    } catch (e) {
      debugPrint('InstructorApplicationApiService.getMyApplications error: $e');
      return Failure('حدث خطأ أثناء جلب الطلبات: $e', error: e);
    }
  }

  /// GET /api/InstructorApplication/application-details/{id}
  Future<Result<InstructorApplicationResponseDto>> getApplicationDetails(String id) async {
    try {
      final result = await _apiClient.getSafe('${ApiConstants.instructorApplicationDetails}/$id');

      if (result is Success) {
        dynamic data = result.data;
        if (data is String && data.isNotEmpty) {
          try {
            data = json.decode(data);
          } catch (_) {}
        }

        if (data is Map<String, dynamic>) {
          final payload = data['data'] ?? data['result'] ?? data;
          if (payload is Map<String, dynamic>) {
            return Success(InstructorApplicationResponseDto.fromJson(payload));
          }
        }
        return const Failure('صيغة البيانات غير صحيحة');
      } else if (result is Failure) {
        return Failure(_extractErrorMessage(result), error: result.error);
      }
      return const Failure('تعذر جلب تفاصيل الطلب');
    } catch (e) {
      debugPrint('InstructorApplicationApiService.getApplicationDetails error: $e');
      return Failure('حدث خطأ أثناء جلب تفاصيل الطلب: $e', error: e);
    }
  }

  String _extractErrorMessage(Failure failure) {
    String msg = failure.message;
    try {
      // 1. Try extracting JSON message from failure.error if it is ApiException
      if (failure.error is ApiException) {
        final rawBody = (failure.error as ApiException).responseBody;
        final decoded = json.decode(rawBody);
        if (decoded is Map<String, dynamic>) {
          if (decoded['message'] != null) return decoded['message'].toString();
          if (decoded['errors'] is Map<String, dynamic>) {
            final errors = decoded['errors'] as Map<String, dynamic>;
            final firstVal = errors.values.first;
            if (firstVal is List && firstVal.isNotEmpty) return firstVal.first.toString();
            return firstVal.toString();
          }
          if (decoded['title'] != null) return decoded['title'].toString();
        }
      }

      // 2. Try parsing message if it contains embedded JSON
      final colonIndex = msg.indexOf('{');
      if (colonIndex != -1) {
        final jsonSub = msg.substring(colonIndex);
        final decoded = json.decode(jsonSub);
        if (decoded is Map<String, dynamic>) {
          if (decoded['message'] != null) return decoded['message'].toString();
          if (decoded['errors'] is Map<String, dynamic>) {
            final errors = decoded['errors'] as Map<String, dynamic>;
            final firstVal = errors.values.first;
            if (firstVal is List && firstVal.isNotEmpty) return firstVal.first.toString();
            return firstVal.toString();
          }
          if (decoded['title'] != null) return decoded['title'].toString();
        }
      }
    } catch (_) {}

    if (msg.contains('Upload failed with status 400')) {
      return 'لديك طلب سابق قيد المراجعة أو تم قبوله بالفعل، أو البيانات المدخلة غير صحيحة.';
    }
    if (msg.contains('Upload failed with status 403')) {
      return 'تقديم الطلب متاح فقط للمتعلمين والطلاب.';
    }

    return msg;
  }
}
