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
    apiKey: 'AIzaSyDlJqVpBcj9zffFS8AjcNm3uPQFSb9C0yk',
    appId: '1:1000615191036:web:2d7b18e2a9bcbfd5d25279',
    messagingSenderId: '1000615191036',
    projectId: 'alpabiz',
    authDomain: 'alpabiz.firebaseapp.com',
    storageBucket: 'alpabiz.appspot.com',
    measurementId: 'G-XJPZKCSS25',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAOQj5h4WJzSX8YqLXWG0Tm6ckdHyysu-M',
    appId: '1:1000615191036:android:7f90a62fcc264f6dd25279',
    messagingSenderId: '1000615191036',
    projectId: 'alpabiz',
    storageBucket: 'alpabiz.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBQeg4G-1baTOApm2mXlXkWMN2wZ21kvzw',
    appId: '1:1000615191036:ios:8b67f9d4c63106b4d25279',
    messagingSenderId: '1000615191036',
    projectId: 'alpabiz',
    storageBucket: 'alpabiz.appspot.com',
    iosClientId: '1000615191036-se5cgqbsgpon4479jke43jjqa6dkehkd.apps.googleusercontent.com',
    iosBundleId: 'com.example.alpabiz',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBQeg4G-1baTOApm2mXlXkWMN2wZ21kvzw',
    appId: '1:1000615191036:ios:8b67f9d4c63106b4d25279',
    messagingSenderId: '1000615191036',
    projectId: 'alpabiz',
    storageBucket: 'alpabiz.appspot.com',
    iosClientId: '1000615191036-se5cgqbsgpon4479jke43jjqa6dkehkd.apps.googleusercontent.com',
    iosBundleId: 'com.example.alpabiz',
  );
}