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
    apiKey: 'AIzaSyC5rP_M0XP8lX3_-FChkv1_7Qd7yFz20cI',
    appId: '1:469876198103:web:f3d89b0725c9bba76dfe92',
    messagingSenderId: '469876198103',
    projectId: 'billsplittapp',
    authDomain: 'billsplittapp.firebaseapp.com',
    storageBucket: 'billsplittapp.appspot.com',
    measurementId: 'G-J1GGCRBJSD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDuk0HYl6fJ3XLU1zZzce6bQyQIpzJD64w',
    appId: '1:469876198103:android:479058527187a4c96dfe92',
    messagingSenderId: '469876198103',
    projectId: 'billsplittapp',
    storageBucket: 'billsplittapp.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCABQuP7HOq_XnhTLHPTKFFU4YyxCqDz4o',
    appId: '1:469876198103:ios:85faf39eb5c9ca376dfe92',
    messagingSenderId: '469876198103',
    projectId: 'billsplittapp',
    storageBucket: 'billsplittapp.appspot.com',
    androidClientId: '469876198103-37j14ctjitf2gp7rvana3stcpt4dt5l3.apps.googleusercontent.com',
    iosClientId: '469876198103-0ctg6l333jsm7onagvpllqrt8ercjs91.apps.googleusercontent.com',
    iosBundleId: 'com.example.billsplitFlutter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCABQuP7HOq_XnhTLHPTKFFU4YyxCqDz4o',
    appId: '1:469876198103:ios:85faf39eb5c9ca376dfe92',
    messagingSenderId: '469876198103',
    projectId: 'billsplittapp',
    storageBucket: 'billsplittapp.appspot.com',
    androidClientId: '469876198103-37j14ctjitf2gp7rvana3stcpt4dt5l3.apps.googleusercontent.com',
    iosClientId: '469876198103-0ctg6l333jsm7onagvpllqrt8ercjs91.apps.googleusercontent.com',
    iosBundleId: 'com.example.billsplitFlutter',
  );
}
