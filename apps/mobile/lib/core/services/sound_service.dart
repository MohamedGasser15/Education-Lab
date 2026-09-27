import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/constants/app_assets.dart';
import 'package:mobile/core/utils/app_logger.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;

  SoundService._internal() {
    _initAudioContext();
  }

  void _initAudioContext() {
    try {
      AudioPlayer.global.setAudioContext(
        AudioContext(
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.playback,
            options: const {
              AVAudioSessionOptions.defaultToSpeaker,
            },
          ),
          android: const AudioContextAndroid(
            isSpeakerphoneOn: true,
            stayAwake: false,
            contentType: AndroidContentType.music,
            usageType: AndroidUsageType.media,
            audioFocus: AndroidAudioFocus.gain,
          ),
        ),
      );
    } catch (e) {
      AppLogger.w('Failed to set global AudioContext: $e', tag: 'SoundService');
    }
  }

  /// Play payment or task success sound (success.mp3)
  Future<void> playSuccess() async {
    try {
      final player = AudioPlayer();
      player.setReleaseMode(ReleaseMode.release);
      await player.play(
        AssetSource(AppAssets.soundSuccessRelative),
        volume: 1.0,
      );
    } catch (e) {
      AppLogger.w(
        'playSuccess primary failed: $e, trying BytesSource fallback',
        tag: 'SoundService',
      );
      try {
        final byteData = await rootBundle.load(AppAssets.soundSuccess);
        final bytes = byteData.buffer.asUint8List();
        final fallbackPlayer = AudioPlayer();
        fallbackPlayer.setReleaseMode(ReleaseMode.release);
        await fallbackPlayer.play(
          BytesSource(bytes, mimeType: 'audio/mp3'),
          volume: 1.0,
        );
      } catch (e2) {
        AppLogger.w('playSuccess BytesSource failed: $e2', tag: 'SoundService');
        SystemSound.play(SystemSoundType.click);
      }
    }
  }

  /// Play payment or operation failure sound (failed.mp3)
  Future<void> playFailed() async {
    try {
      final player = AudioPlayer();
      player.setReleaseMode(ReleaseMode.release);
      await player.play(
        AssetSource(AppAssets.soundFailedRelative),
        volume: 1.0,
      );
    } catch (e) {
      AppLogger.w(
        'playFailed primary failed: $e, trying BytesSource fallback',
        tag: 'SoundService',
      );
      try {
        final byteData = await rootBundle.load(AppAssets.soundFailed);
        final bytes = byteData.buffer.asUint8List();
        final fallbackPlayer = AudioPlayer();
        fallbackPlayer.setReleaseMode(ReleaseMode.release);
        await fallbackPlayer.play(
          BytesSource(bytes, mimeType: 'audio/mp3'),
          volume: 1.0,
        );
      } catch (e2) {
        AppLogger.w('playFailed BytesSource failed: $e2', tag: 'SoundService');
        SystemSound.play(SystemSoundType.alert);
      }
    }
  }

  void dispose() {}
}
