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
    apiKey: 'AIzaSyB-BxfCVhECJnIQVAUumLFgK1zzpHsKY7k',
    appId: '1:222781847153:web:2d82643e58c22723bfcdd0',
    messagingSenderId: '222781847153',
    projectId: 'cloud-firestore-26511',
    authDomain: 'cloud-firestore-26511.firebaseapp.com',
    storageBucket: 'cloud-firestore-26511.appspot.com',
    measurementId: 'G-JW4XSJNE3P',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA08s_r8hCscK57oY0iUM3VhzK0zLOAPp0',
    appId: '1:222781847153:android:e1a400b0b4405042bfcdd0',
    messagingSenderId: '222781847153',
    projectId: 'cloud-firestore-26511',
    storageBucket: 'cloud-firestore-26511.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC1kOtiIEQ6I89-x4M1QyUbhvXPZHZFvdw',
    appId: '1:222781847153:ios:ba8cafe6da8f69c7bfcdd0',
    messagingSenderId: '222781847153',
    projectId: 'cloud-firestore-26511',
    storageBucket: 'cloud-firestore-26511.appspot.com',
    iosBundleId: 'com.example.internshipProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC1kOtiIEQ6I89-x4M1QyUbhvXPZHZFvdw',
    appId: '1:222781847153:ios:c06c4ea86251d517bfcdd0',
    messagingSenderId: '222781847153',
    projectId: 'cloud-firestore-26511',
    storageBucket: 'cloud-firestore-26511.appspot.com',
    iosBundleId: 'com.example.internshipProject.RunnerTests',
  );
}
