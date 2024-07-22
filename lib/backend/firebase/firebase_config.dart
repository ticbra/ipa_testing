import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDFMb3fehUheNBywd90LVEunZ8RGBPvysw",
            authDomain: "login-page-8h9p0t.firebaseapp.com",
            projectId: "login-page-8h9p0t",
            storageBucket: "login-page-8h9p0t.appspot.com",
            messagingSenderId: "617511044198",
            appId: "1:617511044198:web:1e0c822ace100a692099a7"));
  } else {
    await Firebase.initializeApp();
  }
}
