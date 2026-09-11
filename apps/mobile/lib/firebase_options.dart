import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCGhmX9INsXobikeb6-_BbqDqdrzUdD_g4',
    appId: '1:488097605539:android:2bc3e1d7f50d0039339c16',
    messagingSenderId: '488097605539',
    projectId: 'education-lab-f121c',
    storageBucket: 'education-lab-f121c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBVRg9GFsQ9qXmTVeuJyYTOiZfAh_vll_A',
    appId: '1:488097605539:ios:72ee6c512d06667f339c16',
    messagingSenderId: '488097605539',
    projectId: 'education-lab-f121c',
    storageBucket: 'education-lab-f121c.firebasestorage.app',
    iosBundleId: 'eg.educationlab.app',
  );
}
