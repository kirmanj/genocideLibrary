import 'package:librarygenocide/Screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(BaharkaLibrary());
}

class BaharkaLibrary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // primaryColor: Colors.greenAccent.shade700,
          // accentColor: Colors.greenAccent.shade700,
          primarySwatch: Colors.deepPurple,
          cursorColor: Colors.orange,
          textTheme: TextTheme(
            headline3: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 45.0,
              color: Colors.orange,
            ),
            button: TextStyle(
              fontFamily: 'OpenSans',
            ),
            subtitle1: TextStyle(fontFamily: 'NotoSans'),
            bodyText2: TextStyle(fontFamily: 'NotoSans'),
          ),
          primaryColor: Colors.white,
          highlightColor: Colors.red,
          accentColor: Colors.black,
        ),
        home: SplashScreen());
  }
}
