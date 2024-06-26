// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
/// 

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
        return windows;
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
    apiKey: 'AIzaSyDY2lMV38b_xMa1EMXlGY9AWnBV5lNiwRA',
    appId: '1:594061634848:web:1956f203fe468b828efb45',
    messagingSenderId: '594061634848',
    projectId: 'machine-monitory',
    authDomain: 'machine-monitory.firebaseapp.com',
    storageBucket: 'machine-monitory.appspot.com',
    measurementId: 'G-N90D19BQ8X',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCPCDrAXuAdAzjeUsWVwMaV7GtkiJfBKUI',
    appId: '1:594061634848:android:1c6e77cec9d0cd578efb45',
    messagingSenderId: '594061634848',
    projectId: 'machine-monitory',
    storageBucket: 'machine-monitory.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA6Ewfn83mAlfDrxrLsy_rn_3FVG9AYA8A',
    appId: '1:594061634848:ios:ee0e0b32cb70e05b8efb45',
    messagingSenderId: '594061634848',
    projectId: 'machine-monitory',
    storageBucket: 'machine-monitory.appspot.com',
    iosBundleId: 'com.example.machineMonitory',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA6Ewfn83mAlfDrxrLsy_rn_3FVG9AYA8A',
    appId: '1:594061634848:ios:ee0e0b32cb70e05b8efb45',
    messagingSenderId: '594061634848',
    projectId: 'machine-monitory',
    storageBucket: 'machine-monitory.appspot.com',
    iosBundleId: 'com.example.machineMonitory',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDY2lMV38b_xMa1EMXlGY9AWnBV5lNiwRA',
    appId: '1:594061634848:web:1295152336f2cfbe8efb45',
    messagingSenderId: '594061634848',
    projectId: 'machine-monitory',
    authDomain: 'machine-monitory.firebaseapp.com',
    storageBucket: 'machine-monitory.appspot.com',
    measurementId: 'G-RX86XFXBY9',
  );
}