// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCigL1MAhyLp4ZkpNYmuG7yqoX4O41dTrA',
    appId: '1:758027068093:web:b96907c6adcf0979f14dd4',
    messagingSenderId: '758027068093',
    projectId: 'praticalworkamov2023-b4207',
    authDomain: 'praticalworkamov2023-b4207.firebaseapp.com',
    storageBucket: 'praticalworkamov2023-b4207.appspot.com',
    measurementId: 'G-DWXNTRY4LX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA_XlbRQAO694l0Okpvqhypj-Mj9lh4qtE',
    appId: '1:758027068093:android:eb432992b774fee9f14dd4',
    messagingSenderId: '758027068093',
    projectId: 'praticalworkamov2023-b4207',
    storageBucket: 'praticalworkamov2023-b4207.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDzoulrG1BU5G_lPiW-qikxxfR9pymgIqw',
    appId: '1:758027068093:ios:c5183e2800f0a887f14dd4',
    messagingSenderId: '758027068093',
    projectId: 'praticalworkamov2023-b4207',
    storageBucket: 'praticalworkamov2023-b4207.appspot.com',
    iosBundleId: 'com.example.tpFlutter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDzoulrG1BU5G_lPiW-qikxxfR9pymgIqw',
    appId: '1:758027068093:ios:0a7cf8e693928946f14dd4',
    messagingSenderId: '758027068093',
    projectId: 'praticalworkamov2023-b4207',
    storageBucket: 'praticalworkamov2023-b4207.appspot.com',
    iosBundleId: 'com.example.tpFlutter.RunnerTests',
  );
}
