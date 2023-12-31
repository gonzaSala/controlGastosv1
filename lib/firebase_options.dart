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
    apiKey: 'AIzaSyDpD1NTb5uEORxMEI8qJUHyGL1TORAioak',
    appId: '1:797954929256:web:d9314531626ac84bc9c1dd',
    messagingSenderId: '797954929256',
    projectId: 'appcontrolgastos-d2b1f',
    authDomain: 'appcontrolgastos-d2b1f.firebaseapp.com',
    storageBucket: 'appcontrolgastos-d2b1f.appspot.com',
    measurementId: 'G-K1GF4QX5C1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB7FYJxA3R5rX_fxAS0dUOtGiK0Cfa6Aws',
    appId: '1:797954929256:android:8f59f84cefc4abf1c9c1dd',
    messagingSenderId: '797954929256',
    projectId: 'appcontrolgastos-d2b1f',
    storageBucket: 'appcontrolgastos-d2b1f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAbzdZUr8zn6OX4Oboo2REPq6quJZJuRGM',
    appId: '1:797954929256:ios:80c0d7edfc0c343ac9c1dd',
    messagingSenderId: '797954929256',
    projectId: 'appcontrolgastos-d2b1f',
    storageBucket: 'appcontrolgastos-d2b1f.appspot.com',
    iosBundleId: 'com.gonzaSala.appControlGastos',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAbzdZUr8zn6OX4Oboo2REPq6quJZJuRGM',
    appId: '1:797954929256:ios:d8779ff24ef3be76c9c1dd',
    messagingSenderId: '797954929256',
    projectId: 'appcontrolgastos-d2b1f',
    storageBucket: 'appcontrolgastos-d2b1f.appspot.com',
    iosBundleId: 'com.gonzaSala.appControlGastos.RunnerTests',
  );
}
