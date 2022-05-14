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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAhs9QxUYCdSK4TSbTmoUFNyvMUvgq5JYg',
    appId: '1:571080901585:web:7503080e619f2f193e16f0',
    messagingSenderId: '571080901585',
    projectId: 'my-first-project-c8992',
    authDomain: 'my-first-project-c8992.firebaseapp.com',
    storageBucket: 'my-first-project-c8992.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDLfCT6Bp0xpFXO5RRWlYA4b6XRqSU_Yiw',
    appId: '1:571080901585:android:8eaf4637d40f494c3e16f0',
    messagingSenderId: '571080901585',
    projectId: 'my-first-project-c8992',
    storageBucket: 'my-first-project-c8992.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDnhuBbJ0WE67OSTVvXzowmWFZ2LKCR5BQ',
    appId: '1:571080901585:ios:7069de25ea19bba03e16f0',
    messagingSenderId: '571080901585',
    projectId: 'my-first-project-c8992',
    storageBucket: 'my-first-project-c8992.appspot.com',
    iosClientId: '571080901585-07grafnrikhoq5a7g48lv7j0dln8jkm1.apps.googleusercontent.com',
    iosBundleId: 'com.example.doctorApp',
  );
}
