import 'package:librarygenocide/Screens/adminPannel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  int admin;
  LoginPage({this.admin});
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  String getEmail = "";
  String getPassword = "";
  bool forget = false;
  GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  loged() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passController.text);
      FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: _emailController.text)
          .limit(1)
          .get()
          .then((value) {
        value.docs.first.reference.update({'password': _passController.text});
      });

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AdminPannel()));

      FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('هیچ هەژمارێک نییە بەم ناونیشانە'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ));
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('ژمارەی نهێنیەکەت هەلەیە'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ));
        print('Wrong password provided for that user.');
      }
    }
  }

  signUp() async {
    if (_formKey.currentState.validate()) {
      UserCredential _result;
      try {
        _result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text, password: _passController.text);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('ژمارە نهێنیەکە زور لاوازە'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ));

          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('ئەم هەژمارە لە ئێستادا هەیە'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ));
          print('The account already exists for that email.');
        }
      } catch (e) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(e),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ));
        print(e);
      }
      User user = _result.user;

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'email': _emailController.text,
        'password': _passController.text,
        'userRole': 1,
        'imagePath': '',
        'displayName': '',
        'phoneNo': 750,
      });

      String email = _emailController.text;
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('$email فەرمانبەر زیاد کرا'),
        backgroundColor: Theme.of(context).accentColor,
        duration: Duration(seconds: 1),
      ));

      if (_result.user != null) {
        Future.delayed(const Duration(seconds: 1), () {});
      }
    }
  }

  passwordReset() {
    if (_formKey.currentState.validate()) {
      print(_emailController.text);
      try {
        FirebaseAuth.instance
            .sendPasswordResetEmail(email: _emailController.text)
            .then((v) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(' سەردانی ئیمێلەکەت بکە'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 5),
          ));
          // FirebaseFirestore.instance
          //     .collection('users')
          //     .where('email', isEqualTo: _emailController.text)
          //     .limit(1)
          //     .get()
          //     .then((value) {
          //   value.docs.first.reference.update({data});
          // });
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-email') {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('ئیمێلەکە هەلەیە'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ));
        } else if (e.code == 'user-not-found') {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('ئەم هەژمارە نەدوزرایەوە'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = TextFormField(
      validator: (val) {
        if (val.isEmpty) {
          return 'ئیمەیل بەتالە';
        } else {
          return null;
        }
      },
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      validator: (val) {
        if (_emailController.text.isNotEmpty) {
          if (val.isEmpty) {
            return 'پاسوردەکەت هەلەیە';
          } else {
            return null;
          }
        }
      },
      controller: _passController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          if (forget) {
            passwordReset();
          } else if (widget.admin == 1) {
            signUp();
          } else {
            if (_formKey.currentState.validate()) {
              loged();
            }
          }

          // Navigator.push(context, MaterialPageRoute(builder: (ctx) => Home()));
        },
        padding: EdgeInsets.all(8),
        color: Theme.of(context).accentColor,
        child: Text(
            forget
                ? "ناردن"
                : widget.admin == 1
                    ? 'زیادکردنی فەرمانبەر'
                    : 'چونەژوورەوە',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        forget ? "بگەرێوە" : 'ژمارەی نهێنیت لەبیرکردووە؟',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        setState(() {
          forget = !forget;
        });
      },
    );

    double width = MediaQuery.of(context).size.width;

    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back_ios, color: Theme.of(context).accentColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        child: Container(
          height: height * 0.8,
          child: Center(
            child: Card(
              elevation: 0,
              child: Container(
                width: width * 0.9,
                height: height * 0.6,
                color: Theme.of(context).primaryColor,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Center(
                        child: Text('چونەژورەوە',
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(height: 30.0),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              email,
                              SizedBox(height: 8.0),
                              forget ? Container() : password,
                            ],
                          )),
                      loginButton,
                      forgotLabel,
                      SizedBox(
                        height: height * 0.1,
                      ),
                      Center(
                        child: Text('چونەژوورەوە تایبەت بە ئەدمین تەنها',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 18,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
