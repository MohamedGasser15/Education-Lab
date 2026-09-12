import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  AudioPlayer? _player;

  AudioPlayer get _audioPlayer {
    if (_player == null) {
      _player = AudioPlayer();
      _player!.setReleaseMode(ReleaseMode.stop);
      _player!.setPlayerMode(PlayerMode.lowLatency);
    }
    return _player!;
  }

  /// Play payment or task success sound (Success.mp3)
  Future<void> playSuccess() async {
    try {
      final player = _audioPlayer;
      await player.stop();
      await player.play(
        AssetSource('sounds/success.mp3'),
        mode: PlayerMode.lowLatency,
        volume: 1.0,
      );
    } catch (e) {
      debugPrint('SoundService playSuccess error: $e');
      SystemSound.play(SystemSoundType.click);
    }
  }

  /// Play payment or operation failure sound (Failed.mp3)
  Future<void> playFailed() async {
    try {
      final player = _audioPlayer;
      await player.stop();
      await player.play(
        AssetSource('sounds/failed.mp3'),
        mode: PlayerMode.lowLatency,
        volume: 1.0,
      );
    } catch (e) {
      debugPrint('SoundService playFailed error: $e');
      SystemSound.play(SystemSoundType.alert);
    }
  }

  void dispose() {
    _player?.dispose();
    _player = null;
  }
}
