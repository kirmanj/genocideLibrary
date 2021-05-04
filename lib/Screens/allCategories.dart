import 'package:librarygenocide/Screens/categories.dart';
import 'package:flutter/material.dart';

class AllCategories extends StatefulWidget {
  @override
  _AllCategoriesState createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: height,
            width: width,
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.01,
                ),
                Container(
                  width: width * 0.98,
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Theme.of(context).accentColor,
                            size: 22.0,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      Padding(
                        padding: EdgeInsets.only(right: 25.0),
                        child: Hero(
                          tag: "CatTitle",
                          child: new Text('بەشەکان',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).accentColor,
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    //color: Colors.grey[900],
                    height: height * 0.9,
                    width: width,
                    child: Categories())
              ],
            ),
          ),
        ),
      ),
    );
  }
}
