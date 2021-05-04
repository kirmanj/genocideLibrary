import 'dart:async';
import 'package:flutter/material.dart';

class EmptyCategory extends StatefulWidget {
  EmptyCategory({
    Key key,
  }) : super(key: key);

  @override
  _EmptyCategoryState createState() => _EmptyCategoryState();
}

class _EmptyCategoryState extends State<EmptyCategory> {
  bool loading = true;

  @override
  void initState() {
    Timer(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      color: Theme.of(context).accentColor,
      child: Column(
        children: <Widget>[
          loading
              ? Column(
                  children: [
                    SizedBox(
                      height: screenHeight / 3,
                    ),
                    Center(
                        child: CircularProgressIndicator(
                      backgroundColor: Theme.of(context).primaryColor,
                    )),
                  ],
                )
              : Column(
                  children: [
                    SizedBox(
                      height: screenHeight / 3,
                    ),
                    Center(
                      child: Text(
                        "ببورە هیچ پەرتووکێک نییە",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                  ],
                )
        ],
      ),
    );
  }
}
