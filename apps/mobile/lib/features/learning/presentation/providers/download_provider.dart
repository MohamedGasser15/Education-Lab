import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/models/download_item_model.dart';
import 'package:mobile/core/services/download_service.dart';
import 'package:mobile/features/courses/data/models/certificate_model.dart';
import 'package:mobile/features/courses/data/models/course_details_model.dart';

class DownloadProvider extends ChangeNotifier {
  final DownloadService _service = DownloadService();
  StreamSubscription<DownloadItemModel>? _progressSub;
  bool _initialized = false;

  DownloadProvider() {
    _init();
  }

  bool get isInitialized => _initialized;

  Future<void> _init() async {
    await _service.init();
    _progressSub = _service.onProgress.listen((_) {
      notifyListeners();
    });
    _initialized = true;
    notifyListeners();
  }

  static String lectureId(int id) => 'lecture_$id';
  static String certId(dynamic id) => 'cert_$id';
  static String resourceId(int id) => 'resource_$id';

  // --- Quick Status Queries ---
  bool isLectureDownloaded(int id) => _service.isDownloaded(lectureId(id));
  bool isLectureDownloading(int id) => _service.isDownloading(lectureId(id));
  double getLectureProgress(int id) => _service.getProgress(lectureId(id));
  String? getLectureLocalPath(int id) => _service.getLocalFilePath(lectureId(id));

  bool isCertDownloaded(dynamic id) => _service.isDownloaded(certId(id));
  bool isCertDownloading(dynamic id) => _service.isDownloading(certId(id));
  String? getCertLocalPath(dynamic id) => _service.getLocalFilePath(certId(id));

  // --- Collection Queries ---
  List<DownloadItemModel> get allCompletedDownloads =>
      _service.allItems.where((i) => i.isCompleted).toList();

  List<DownloadItemModel> get downloadedLectures =>
      allCompletedDownloads.where((i) => i.type == DownloadType.video).toList();

  List<DownloadItemModel> get downloadedCertificates =>
      allCompletedDownloads.where((i) => i.type == DownloadType.certificate).toList();

  Set<int> get downloadedCourseIds =>
      downloadedLectures.map((i) => i.courseId).where((id) => id > 0).toSet();

  bool hasDownloadedLecturesForCourse(int courseId) =>
      downloadedCourseIds.contains(courseId);

  List<DownloadItemModel> getDownloadedLecturesForCourse(int courseId) =>
      downloadedLectures.where((i) => i.courseId == courseId).toList();

  String get totalStorageFormatted => _service.getFormattedTotalSize();
  int get totalStorageBytes => _service.getTotalDownloadedBytes();

  // --- Download Actions ---
  Future<bool> downloadLecture({
    required CourseLectureModel lecture,
    required int courseId,
    required String courseTitle,
  }) async {
    final rawUrl = lecture.videoUrl?.trim() ?? '';
    if (rawUrl.isEmpty) return false;

    final item = await _service.startDownload(
      id: lectureId(lecture.id),
      itemId: lecture.id,
      type: DownloadType.video,
      title: lecture.title,
      courseId: courseId,
      courseTitle: courseTitle,
      sourceUrl: rawUrl,
      metadata: {
        'duration': lecture.duration,
        'sectionId': lecture.sectionId,
        'isArticle': lecture.isArticle,
      },
    );

    notifyListeners();
    return item != null && item.isCompleted;
  }

  void cancelLectureDownload(int id) {
    _service.cancelDownload(lectureId(id));
    notifyListeners();
  }

  Future<void> deleteLectureDownload(int id) async {
    await _service.deleteDownload(lectureId(id));
    notifyListeners();
  }

  Future<bool> downloadCertificate({
    required CertificateModel certificate,
    bool isPdf = true,
    Uint8List? renderedBytes,
  }) async {
    final rawUrl = isPdf ? certificate.fullPdfUrl : certificate.fullImageUrl;

    // 1. If high-res client-rendered bytes are provided (100% reliable, zero 404s)
    if (renderedBytes != null && renderedBytes.isNotEmpty) {
      final ext = isPdf ? '.png' : '.png';
      final item = await _service.saveBytesAsDownload(
        id: certId(certificate.id),
        itemId: certificate.id,
        type: DownloadType.certificate,
        title: certificate.courseTitle,
        courseId: certificate.courseId,
        courseTitle: certificate.courseTitle,
        sourceUrl: rawUrl.isNotEmpty
            ? rawUrl
            : 'local://certificate/${certificate.certificateCode}',
        bytes: renderedBytes,
        extension: ext,
        metadata: {
          'code': certificate.certificateCode,
          'studentName': certificate.studentName,
          'isPdf': isPdf,
        },
      );
      notifyListeners();
      return item != null && item.isCompleted;
    }

    // 2. Fallback to remote server download if no rendered bytes provided
    if (rawUrl.isNotEmpty) {
      final item = await _service.startDownload(
        id: certId(certificate.id),
        itemId: certificate.id,
        type: DownloadType.certificate,
        title: certificate.courseTitle,
        courseId: certificate.courseId,
        courseTitle: certificate.courseTitle,
        sourceUrl: rawUrl,
        metadata: {
          'code': certificate.certificateCode,
          'studentName': certificate.studentName,
          'isPdf': isPdf,
        },
      );

      notifyListeners();
      return item != null && item.isCompleted;
    }

    return false;
  }

  Future<void> deleteCertificateDownload(dynamic id) async {
    await _service.deleteDownload(certId(id));
    notifyListeners();
  }

  Future<void> deleteItem(String id) async {
    await _service.deleteDownload(id);
    notifyListeners();
  }

  Future<void> clearAll() async {
    await _service.clearAllDownloads();
    notifyListeners();
  }

  @override
  void dispose() {
    _progressSub?.cancel();
    super.dispose();
  }
}
