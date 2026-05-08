// File: lib/firebase_options.dart

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for all platforms.
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
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  /// Web
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyAl_HNPnc-VAZ1DEpGGIfix9ayGplwuPfc",
    authDomain: "smartlease-aaf09.firebaseapp.com",
    projectId: "smartlease-aaf09",
    storageBucket: "smartlease-aaf09.appspot.com",
    messagingSenderId: "13837249324",
    appId: "1:13837249324:web:eb580e0f3e2078b2401a89",
    measurementId: "G-ZNDTXZWP31",
  );

  /// Android
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyAl_HNPnc-VAZ1DEpGGIfix9ayGplwuPfc",
    appId: "1:13837249324:android:eb580e0f3e2078b2401a89",
    messagingSenderId: "13837249324",
    projectId: "smartlease-aaf09",
    storageBucket: "smartlease-aaf09.appspot.com",
  );

  /// iOS
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyAl_HNPnc-VAZ1DEpGGIfix9ayGplwuPfc",
    appId: "1:13837249324:ios:eb580e0f3e2078b2401a89",
    messagingSenderId: "13837249324",
    projectId: "smartlease-aaf09",
    storageBucket: "smartlease-aaf09.appspot.com",
    iosBundleId: "com.example.smartleaseFirebase",
  );

  /// macOS
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: "AIzaSyAl_HNPnc-VAZ1DEpGGIfix9ayGplwuPfc",
    appId: "1:13837249324:ios:eb580e0f3e2078b2401a89",
    messagingSenderId: "13837249324",
    projectId: "smartlease-aaf09",
    storageBucket: "smartlease-aaf09.appspot.com",
    iosBundleId: "com.example.smartleaseFirebase",
  );

  /// Windows
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: "AIzaSyAl_HNPnc-VAZ1DEpGGIfix9ayGplwuPfc",
    appId: "1:13837249324:web:eb580e0f3e2078b2401a89",
    messagingSenderId: "13837249324",
    projectId: "smartlease-aaf09",
    storageBucket: "smartlease-aaf09.appspot.com",
  );

  /// Linux
  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: "AIzaSyAl_HNPnc-VAZ1DEpGGIfix9ayGplwuPfc",
    appId: "1:13837249324:web:eb580e0f3e2078b2401a89",
    messagingSenderId: "13837249324",
    projectId: "smartlease-aaf09",
    storageBucket: "smartlease-aaf09.appspot.com",
  );
}
