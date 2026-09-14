import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/models/download_item_model.dart';

void main() {
  group('DownloadItemModel Tests', () {
    test('Correctly computes formattedSize for various byte ranges', () {
      final itemZero = DownloadItemModel(
        id: 'lecture_1',
        itemId: 1,
        type: DownloadType.video,
        title: 'Introduction to Flutter',
        courseId: 10,
        courseTitle: 'Flutter Masterclass',
        sourceUrl: 'https://example.com/video1.mp4',
        localPath: '/data/user/0/edulab_downloads/video_1.mp4',
        fileSizeBytes: 0,
        createdAt: DateTime.now(),
      );
      expect(itemZero.formattedSize, '0 MB');

      final itemKb = itemZero.copyWith(fileSizeBytes: 512 * 1024);
      expect(itemKb.formattedSize, '512.0 KB');

      final itemMb = itemZero.copyWith(fileSizeBytes: 25 * 1024 * 1024);
      expect(itemMb.formattedSize, '25.0 MB');
    });

    test('Serializes to map/JSON and deserializes accurately', () {
      final original = DownloadItemModel(
        id: 'lecture_42',
        itemId: 42,
        type: DownloadType.video,
        title: 'Advanced State Management',
        courseId: 5,
        courseTitle: 'Flutter Clean Architecture',
        sourceUrl: 'https://example.com/lecture_42.mp4',
        localPath: '/tmp/edulab_downloads/video_42.mp4',
        fileSizeBytes: 10485760,
        downloadedBytes: 10485760,
        progress: 1.0,
        status: DownloadStatus.completed,
        createdAt: DateTime(2026, 9, 14, 2, 0, 0),
        metadata: {'duration': 420, 'sectionId': 3},
      );

      final jsonStr = original.toJson();
      final restored = DownloadItemModel.fromJson(jsonStr);

      expect(restored.id, original.id);
      expect(restored.itemId, original.itemId);
      expect(restored.type, DownloadType.video);
      expect(restored.title, original.title);
      expect(restored.courseId, original.courseId);
      expect(restored.courseTitle, original.courseTitle);
      expect(restored.localPath, original.localPath);
      expect(restored.status, DownloadStatus.completed);
      expect(restored.isCompleted, isTrue);
      expect(restored.isDownloading, isFalse);
      expect(restored.metadata['duration'], 420);
    });

    test('Status flags reflect correctly based on DownloadStatus', () {
      final downloadingItem = DownloadItemModel(
        id: 'cert_1',
        itemId: 1,
        type: DownloadType.certificate,
        title: 'Flutter Certificate',
        courseId: 10,
        courseTitle: 'Flutter Course',
        sourceUrl: 'https://example.com/cert.pdf',
        localPath: '/tmp/cert.pdf',
        status: DownloadStatus.downloading,
        progress: 0.45,
        createdAt: DateTime.now(),
      );

      expect(downloadingItem.isDownloading, isTrue);
      expect(downloadingItem.isCompleted, isFalse);
      expect(downloadingItem.isFailed, isFalse);

      final failedItem = downloadingItem.copyWith(status: DownloadStatus.failed, error: 'Timeout');
      expect(failedItem.isFailed, isTrue);
      expect(failedItem.isDownloading, isFalse);
      expect(failedItem.error, 'Timeout');
    });

    test('effectiveFileName derives from fileName, localPath, or fallback', () {
      final itemWithFileName = DownloadItemModel(
        id: 'lecture_100',
        itemId: 100,
        type: DownloadType.video,
        title: 'Title',
        courseId: 1,
        courseTitle: 'Course',
        sourceUrl: 'https://example.com/v.mp4',
        localPath: '/old/uuid/edulab_downloads/video_100_abc.mp4',
        fileName: 'video_100_abc.mp4',
        createdAt: DateTime(2026, 9, 14),
      );
      expect(itemWithFileName.effectiveFileName, 'video_100_abc.mp4');

      final itemWithoutFileName = DownloadItemModel(
        id: 'lecture_101',
        itemId: 101,
        type: DownloadType.video,
        title: 'Title',
        courseId: 1,
        courseTitle: 'Course',
        sourceUrl: 'https://example.com/v.mp4',
        localPath: '/old/uuid/edulab_downloads/video_101_xyz.mp4',
        createdAt: DateTime(2026, 9, 14),
      );
      expect(itemWithoutFileName.effectiveFileName, 'video_101_xyz.mp4');
    });
  });
}
