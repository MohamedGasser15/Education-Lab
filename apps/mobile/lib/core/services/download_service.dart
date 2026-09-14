import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/core/models/download_item_model.dart';

class DownloadService {
  static final DownloadService _instance = DownloadService._internal();
  factory DownloadService() => _instance;
  DownloadService._internal();

  static const String _registryPrefKey = 'edulab_offline_downloads_registry_v1';
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(minutes: 10),
      followRedirects: true,
      validateStatus: (status) => status != null && status >= 200 && status < 400,
    ),
  );

  final Map<String, CancelToken> _cancelTokens = {};
  final Map<String, DownloadItemModel> _items = {};
  final StreamController<DownloadItemModel> _progressController =
      StreamController<DownloadItemModel>.broadcast();

  bool _initialized = false;
  Directory? _downloadsDirectory;

  Stream<DownloadItemModel> get onProgress => _progressController.stream;
  List<DownloadItemModel> get allItems => _items.values.toList();
  String? get downloadsDirectoryPath => _downloadsDirectory?.path;

  Future<void> init() async {
    if (_initialized) return;

    try {
      final docsDir = await getApplicationDocumentsDirectory();
      _downloadsDirectory = Directory('${docsDir.path}/edulab_downloads');
      if (!await _downloadsDirectory!.exists()) {
        await _downloadsDirectory!.create(recursive: true);
      }

      final prefs = await SharedPreferences.getInstance();
      final rawList = prefs.getStringList(_registryPrefKey) ?? [];

      bool needsSave = false;
      for (final raw in rawList) {
        try {
          var item = DownloadItemModel.fromJson(raw);
          if (item.isCompleted) {
            // Check fresh container path first (iOS sandbox migration support)
            final freshPath = '${_downloadsDirectory!.path}/${item.effectiveFileName}';
            final freshFile = File(freshPath);
            final oldFile = File(item.localPath);

            if (await freshFile.exists()) {
              if (item.localPath != freshPath) {
                item = item.copyWith(
                  localPath: freshPath,
                  fileName: item.effectiveFileName,
                );
                needsSave = true;
              }
              _items[item.id] = item;
            } else if (await oldFile.exists()) {
              _items[item.id] = item;
            } else {
              // File might be indexing or temporary sync delay; retain item in memory
              _items[item.id] = item.copyWith(
                localPath: freshPath,
                fileName: item.effectiveFileName,
              );
            }
          }
        } catch (e) {
          debugPrint('[DownloadService] Error parsing item: $e');
        }
      }

      if (needsSave) {
        await _persistRegistry();
      }

      _initialized = true;
    } catch (e) {
      debugPrint('[DownloadService] Initialization failed: $e');
    }
  }

  Future<void> _persistRegistry() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final completed = _items.values.where((i) => i.isCompleted).map((i) => i.toJson()).toList();
      await prefs.setStringList(_registryPrefKey, completed);
    } catch (e) {
      debugPrint('[DownloadService] Failed to persist registry: $e');
    }
  }

  DownloadItemModel? getItem(String id) => _items[id];

  bool isDownloaded(String id) {
    final item = _items[id];
    if (item == null || !item.isCompleted) return false;

    if (_downloadsDirectory != null) {
      final freshFile = File('${_downloadsDirectory!.path}/${item.effectiveFileName}');
      if (freshFile.existsSync()) return true;
    }
    return File(item.localPath).existsSync();
  }

  bool isDownloading(String id) {
    final item = _items[id];
    return item != null && item.isDownloading;
  }

  double getProgress(String id) {
    final item = _items[id];
    return item?.progress ?? 0.0;
  }

  String? getLocalFilePath(String id) {
    final item = _items[id];
    if (item != null && item.isCompleted) {
      if (_downloadsDirectory != null) {
        final freshFile = File('${_downloadsDirectory!.path}/${item.effectiveFileName}');
        if (freshFile.existsSync()) return freshFile.path;
      }
      final file = File(item.localPath);
      if (file.existsSync()) return file.path;
    }
    return null;
  }

  String _sanitizeFileName(String raw) {
    return raw.replaceAll(RegExp(r'[^\w\.\-]'), '_');
  }

  String _deriveExtension(String url, DownloadType type) {
    final cleanUrl = url.split('?').first.toLowerCase();
    if (cleanUrl.endsWith('.mp4')) return '.mp4';
    if (cleanUrl.endsWith('.mkv')) return '.mkv';
    if (cleanUrl.endsWith('.webm')) return '.webm';
    if (cleanUrl.endsWith('.pdf')) return '.pdf';
    if (cleanUrl.endsWith('.png')) return '.png';
    if (cleanUrl.endsWith('.jpg') || cleanUrl.endsWith('.jpeg')) return '.jpg';
    if (cleanUrl.endsWith('.zip')) return '.zip';

    switch (type) {
      case DownloadType.video:
        return '.mp4';
      case DownloadType.certificate:
        return '.pdf';
      case DownloadType.resource:
        return '.pdf';
    }
  }

  Future<DownloadItemModel?> startDownload({
    required String id,
    required int itemId,
    required DownloadType type,
    required String title,
    required int courseId,
    required String courseTitle,
    required String sourceUrl,
    Map<String, dynamic> metadata = const {},
  }) async {
    await init();

    if (isDownloaded(id)) {
      return _items[id];
    }

    if (isDownloading(id)) {
      return _items[id];
    }

    final ext = _deriveExtension(sourceUrl, type);
    final safeFileName = _sanitizeFileName('${type.name}_${itemId}_${DateTime.now().millisecondsSinceEpoch}$ext');
    final targetPath = '${_downloadsDirectory!.path}/$safeFileName';

    final cancelToken = CancelToken();
    _cancelTokens[id] = cancelToken;

    var item = DownloadItemModel(
      id: id,
      itemId: itemId,
      type: type,
      title: title,
      courseId: courseId,
      courseTitle: courseTitle,
      sourceUrl: sourceUrl,
      localPath: targetPath,
      fileName: safeFileName,
      status: DownloadStatus.downloading,
      createdAt: DateTime.now(),
      metadata: metadata,
    );

    _items[id] = item;
    _progressController.add(item);

    DateTime lastNotifyTime = DateTime.now();
    double lastNotifiedProgress = 0.0;

    try {
      await _dio.download(
        sourceUrl,
        targetPath,
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
          if (total <= 0) return;
          final currentProgress = (received / total).clamp(0.0, 1.0);

          final now = DateTime.now();
          final bool shouldNotify = (currentProgress - lastNotifiedProgress).abs() >= 0.03 ||
              now.difference(lastNotifyTime).inMilliseconds >= 250 ||
              currentProgress >= 1.0;

          if (shouldNotify) {
            lastNotifyTime = now;
            lastNotifiedProgress = currentProgress;

            item = item.copyWith(
              fileSizeBytes: total,
              downloadedBytes: received,
              progress: currentProgress,
              status: DownloadStatus.downloading,
            );
            _items[id] = item;
            _progressController.add(item);
          }
        },
      );

      final downloadedFile = File(targetPath);
      final finalSize = await downloadedFile.exists() ? await downloadedFile.length() : item.fileSizeBytes;

      item = item.copyWith(
        fileSizeBytes: finalSize,
        downloadedBytes: finalSize,
        progress: 1.0,
        status: DownloadStatus.completed,
      );

      _items[id] = item;
      _cancelTokens.remove(id);
      await _persistRegistry();
      _progressController.add(item);
      return item;
    } on DioException catch (dioErr) {
      if (CancelToken.isCancel(dioErr)) {
        debugPrint('[DownloadService] Download cancelled: $id');
        _cleanupFailedFile(targetPath);
        _items.remove(id);
        _cancelTokens.remove(id);
        return null;
      }

      debugPrint('[DownloadService] DioException: ${dioErr.message}');
      _cleanupFailedFile(targetPath);

      item = item.copyWith(
        status: DownloadStatus.failed,
        error: dioErr.message ?? 'Network download error',
      );
      _items[id] = item;
      _cancelTokens.remove(id);
      _progressController.add(item);
      return item;
    } catch (e) {
      debugPrint('[DownloadService] Unexpected error downloading $id: $e');
      _cleanupFailedFile(targetPath);

      item = item.copyWith(
        status: DownloadStatus.failed,
        error: e.toString(),
      );
      _items[id] = item;
      _cancelTokens.remove(id);
      _progressController.add(item);
      return item;
    }
  }

  Future<DownloadItemModel?> saveBytesAsDownload({
    required String id,
    required int itemId,
    required DownloadType type,
    required String title,
    required int courseId,
    required String courseTitle,
    required String sourceUrl,
    required Uint8List bytes,
    required String extension,
    Map<String, dynamic> metadata = const {},
  }) async {
    await init();

    final safeFileName = _sanitizeFileName(
      '${type.name}_${itemId}_${DateTime.now().millisecondsSinceEpoch}$extension',
    );
    final targetPath = '${_downloadsDirectory!.path}/$safeFileName';

    try {
      final file = File(targetPath);
      await file.writeAsBytes(bytes, flush: true);

      final item = DownloadItemModel(
        id: id,
        itemId: itemId,
        type: type,
        title: title,
        courseId: courseId,
        courseTitle: courseTitle,
        sourceUrl: sourceUrl,
        localPath: targetPath,
        fileName: safeFileName,
        fileSizeBytes: bytes.length,
        downloadedBytes: bytes.length,
        progress: 1.0,
        status: DownloadStatus.completed,
        createdAt: DateTime.now(),
        metadata: metadata,
      );

      _items[id] = item;
      await _persistRegistry();
      _progressController.add(item);
      return item;
    } catch (e) {
      debugPrint('[DownloadService] Failed to save bytes as download: $e');
      return null;
    }
  }

  void _cleanupFailedFile(String filePath) {
    try {
      final f = File(filePath);
      if (f.existsSync()) {
        f.deleteSync();
      }
    } catch (_) {}
  }

  void cancelDownload(String id) {
    final token = _cancelTokens[id];
    if (token != null && !token.isCancelled) {
      token.cancel('User requested cancel');
    }
    _cancelTokens.remove(id);

    final item = _items[id];
    if (item != null) {
      _cleanupFailedFile(item.localPath);
      _items.remove(id);
      _progressController.add(
        item.copyWith(status: DownloadStatus.idle, progress: 0.0),
      );
    }
  }

  Future<void> deleteDownload(String id) async {
    cancelDownload(id);

    final item = _items[id];
    if (item != null) {
      try {
        final f = File(getLocalFilePath(id) ?? item.localPath);
        if (await f.exists()) {
          await f.delete();
        }
      } catch (e) {
        debugPrint('[DownloadService] Error deleting file: $e');
      }

      _items.remove(id);
      await _persistRegistry();
      _progressController.add(
        item.copyWith(status: DownloadStatus.idle, progress: 0.0),
      );
    }
  }

  Future<void> clearAllDownloads() async {
    for (final token in _cancelTokens.values) {
      if (!token.isCancelled) token.cancel();
    }
    _cancelTokens.clear();

    for (final item in _items.values) {
      try {
        final f = File(getLocalFilePath(item.id) ?? item.localPath);
        if (f.existsSync()) f.deleteSync();
      } catch (_) {}
    }

    _items.clear();
    await _persistRegistry();

    if (_downloadsDirectory != null && await _downloadsDirectory!.exists()) {
      try {
        await for (final entity in _downloadsDirectory!.list()) {
          if (entity is File) await entity.delete();
        }
      } catch (_) {}
    }
  }

  int getTotalDownloadedBytes() {
    int total = 0;
    for (final item in _items.values) {
      if (item.isCompleted) {
        total += item.fileSizeBytes > 0 ? item.fileSizeBytes : item.downloadedBytes;
      }
    }
    return total;
  }

  String getFormattedTotalSize() {
    final bytes = getTotalDownloadedBytes();
    if (bytes <= 0) return '0 MB';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  void dispose() {
    _progressController.close();
  }
}
