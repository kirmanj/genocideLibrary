import 'package:flutter/material.dart';
import 'package:librarygenocide/Screens/home-screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (crl) => HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: SafeArea(
        child: Container(
          height: height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  //  alignment: Alignment.topCenter,
                  fit: BoxFit.cover,
                  image: AssetImage("assets/anfal.jpg"))),
          child: Center(
              child: Container(
            height: height,
            width: width,
            color: Colors.black54,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height / 5,
                ),
                Text(
                  'کتێبخانەی جینوسایدی گەلی کورد',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 42,
                      fontWeight: FontWeight.bold),
                ),
                Center(
                  child: Container(
                    child: Image.asset(
                      'assets/lbrary.gif',
                      width: width * 0.7,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
