import 'dart:convert';

enum DownloadType {
  video,
  certificate,
  resource;

  String toJson() => name;

  static DownloadType fromJson(String? val) {
    if (val == null) return DownloadType.video;
    return DownloadType.values.firstWhere(
      (e) => e.name.toLowerCase() == val.toLowerCase(),
      orElse: () => DownloadType.video,
    );
  }
}

enum DownloadStatus {
  idle,
  downloading,
  completed,
  failed;

  String toJson() => name;

  static DownloadStatus fromJson(String? val) {
    if (val == null) return DownloadStatus.idle;
    return DownloadStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == val.toLowerCase(),
      orElse: () => DownloadStatus.idle,
    );
  }
}

class DownloadItemModel {
  final String id;
  final int itemId;
  final DownloadType type;
  final String title;
  final int courseId;
  final String courseTitle;
  final String sourceUrl;
  final String localPath;
  final String fileName;
  final int fileSizeBytes;
  final int downloadedBytes;
  final double progress; // 0.0 to 1.0
  final DownloadStatus status;
  final DateTime createdAt;
  final String? error;
  final Map<String, dynamic> metadata;

  const DownloadItemModel({
    required this.id,
    required this.itemId,
    required this.type,
    required this.title,
    required this.courseId,
    required this.courseTitle,
    required this.sourceUrl,
    required this.localPath,
    this.fileName = '',
    this.fileSizeBytes = 0,
    this.downloadedBytes = 0,
    this.progress = 0.0,
    this.status = DownloadStatus.idle,
    required this.createdAt,
    this.error,
    this.metadata = const {},
  });

  bool get isCompleted => status == DownloadStatus.completed;
  bool get isDownloading => status == DownloadStatus.downloading;
  bool get isFailed => status == DownloadStatus.failed;

  String get effectiveFileName {
    if (fileName.isNotEmpty) return fileName;
    if (localPath.isNotEmpty) return localPath.split('/').last;
    return '${type.name}_$itemId.mp4';
  }

  String get formattedSize {
    final bytes = fileSizeBytes > 0 ? fileSizeBytes : downloadedBytes;
    if (bytes <= 0) return '0 MB';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  DownloadItemModel copyWith({
    String? id,
    int? itemId,
    DownloadType? type,
    String? title,
    int? courseId,
    String? courseTitle,
    String? sourceUrl,
    String? localPath,
    String? fileName,
    int? fileSizeBytes,
    int? downloadedBytes,
    double? progress,
    DownloadStatus? status,
    DateTime? createdAt,
    String? error,
    Map<String, dynamic>? metadata,
  }) {
    return DownloadItemModel(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      type: type ?? this.type,
      title: title ?? this.title,
      courseId: courseId ?? this.courseId,
      courseTitle: courseTitle ?? this.courseTitle,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      localPath: localPath ?? this.localPath,
      fileName: fileName ?? this.fileName,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      downloadedBytes: downloadedBytes ?? this.downloadedBytes,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      error: error ?? this.error,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itemId': itemId,
      'type': type.toJson(),
      'title': title,
      'courseId': courseId,
      'courseTitle': courseTitle,
      'sourceUrl': sourceUrl,
      'localPath': localPath,
      'fileName': effectiveFileName,
      'fileSizeBytes': fileSizeBytes,
      'downloadedBytes': downloadedBytes,
      'progress': progress,
      'status': status.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'error': error,
      'metadata': metadata,
    };
  }

  factory DownloadItemModel.fromMap(Map<String, dynamic> map) {
    final rawLocalPath = map['localPath']?.toString() ?? '';
    final rawFileName = map['fileName']?.toString() ??
        (rawLocalPath.isNotEmpty ? rawLocalPath.split('/').last : '');

    return DownloadItemModel(
      id: map['id']?.toString() ?? '',
      itemId: int.tryParse(map['itemId']?.toString() ?? '0') ?? 0,
      type: DownloadType.fromJson(map['type']?.toString()),
      title: map['title']?.toString() ?? '',
      courseId: int.tryParse(map['courseId']?.toString() ?? '0') ?? 0,
      courseTitle: map['courseTitle']?.toString() ?? '',
      sourceUrl: map['sourceUrl']?.toString() ?? '',
      localPath: rawLocalPath,
      fileName: rawFileName,
      fileSizeBytes: int.tryParse(map['fileSizeBytes']?.toString() ?? '0') ?? 0,
      downloadedBytes: int.tryParse(map['downloadedBytes']?.toString() ?? '0') ?? 0,
      progress: (map['progress'] as num?)?.toDouble() ?? 0.0,
      status: DownloadStatus.fromJson(map['status']?.toString()),
      createdAt: DateTime.tryParse(map['createdAt']?.toString() ?? '') ?? DateTime.now(),
      error: map['error']?.toString(),
      metadata: map['metadata'] is Map ? Map<String, dynamic>.from(map['metadata']) : const {},
    );
  }

  String toJson() => jsonEncode(toMap());

  factory DownloadItemModel.fromJson(String source) =>
      DownloadItemModel.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
