import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyCym8xmw8dJCz3INIkKQ-o1HLknj24BMLs",
            authDomain: "locker-app-41fc8.firebaseapp.com",
            projectId: "locker-app-41fc8",
            storageBucket: "locker-app-41fc8.appspot.com",
            messagingSenderId: "952323710384",
            appId: "1:952323710384:web:a7eeeea332e99099ffca75",
            measurementId: "G-4CN38CX2BE"));
  } else {
    await Firebase.initializeApp();
  }
}
