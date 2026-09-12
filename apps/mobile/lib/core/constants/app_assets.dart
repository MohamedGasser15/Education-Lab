class AppAssets {
  AppAssets._();

  // Base paths
  static const String _imagesPath = 'assets/images';
  static const String _soundsPath = 'assets/sounds';
  static const String _launcherPath = 'assets/launcher';

  // Images & Avatars
  static const String defaultAvatar = '$_imagesPath/default_avatar.png';
  static const String appIcon = '$_launcherPath/app_icon.png';

  // Sounds (for AudioPlayer AssetSource or direct assets)
  static const String soundSuccessRelative = 'sounds/success.mp3';
  static const String soundFailedRelative = 'sounds/failed.mp3';
  static const String soundSuccess = '$_soundsPath/success.mp3';
  static const String soundFailed = '$_soundsPath/failed.mp3';

  // Fonts
  static const String fontTajawal = 'Tajawal';
  static const String fontInter = 'Inter';
}