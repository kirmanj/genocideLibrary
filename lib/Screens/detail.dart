import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:librarygenocide/Screens/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageDialog extends StatefulWidget {
  String imageLink;
  DocumentSnapshot bookSnapshots;
  List<String> favoritsList;
  ImageDialog(this.imageLink, this.bookSnapshots, this.favoritsList);

  @override
  _ImageDialogState createState() =>
      _ImageDialogState(imageLink, bookSnapshots, favoritsList);
}

class _ImageDialogState extends State<ImageDialog> {
  String imageLink;
  DocumentSnapshot bookSnapshots;
  List<String> favoritsList;
  _ImageDialogState(this.imageLink, this.bookSnapshots, this.favoritsList);

  getTotal(String str) {
    List input = str.toString().split("");
    List output = [];
    for (int i = 0; i < input.length; i++) {
      if (input[i] == "0") {
        output.add("٠");
      } else if (input[i] == "1") {
        output.add("١");
      } else if (input[i] == "2") {
        output.add("٢");
      } else if (input[i] == "3") {
        output.add("٣");
      } else if (input[i] == "4") {
        output.add("٤");
      } else if (input[i] == "5") {
        output.add("٥");
      } else if (input[i] == "6") {
        output.add("٦");
      } else if (input[i] == "7") {
        output.add("٧");
      } else if (input[i] == "8") {
        output.add("٨");
      } else if (input[i] == "9") {
        output.add("٩");
      }
    }
    return output.join();
  }

  getData() async {
    SharedPreferences vaforitePrefrences =
        await SharedPreferences.getInstance();

    setState(() {
      favoritsList = vaforitePrefrences.getStringList("favoritsList");
    });
    if (favoritsList == null) {
      print('nullll');
      favoritsList = List<String>();
    }
    print("getData");
    print(favoritsList);
  }

  saveData() async {
    SharedPreferences vaforitePrefrences =
        await SharedPreferences.getInstance();
    vaforitePrefrences.setStringList("favoritsList", favoritsList);
    print(favoritsList);
    //print(favoritsList.isEmpty);
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).highlightColor,
          ),
        ),
        width: width * 0.8,
        height: height * 0.7,
        child: Container(
            child: Container(
          color: Theme.of(context).accentColor,
          child: Column(
            children: [
              Container(
                  width: width * 0.3,
                  height: height * 0.3,
                  child: Image.network(
                    imageLink,
                    fit: BoxFit.cover,
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Row(
                  children: [
                    Container(
                        width: width * 0.52,
                        height: height * 0.13,
                        child: Text(
                          (bookSnapshots['name']),
                          textAlign: TextAlign.end,
                          //overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )),
                    Container(
                        width: width * 0.2,
                        height: height * 0.13,
                        child: Text(
                          "ناوی کتێب",
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Container(
                        width: width * 0.55,
                        child: Text(
                          bookSnapshots['author'] + '\t\t\t',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            wordSpacing: 0,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )),
                    Container(
                        width: width * 0.17,
                        child: Text(
                          "ناوی نوسەر",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            wordSpacing: 0,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        width: width * 0.7,
                        padding: EdgeInsets.only(top: height * 0.05),
                        child: Text(
                          getTotal(bookSnapshots['publishDate'].toString()) +
                              '\t\t\t\t\t\t' +
                              "سالی چاپ",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              (bookSnapshots['pdfLink'].isEmpty)
                  ? Container()
                  : RaisedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PDFBOOK(
                                      name: bookSnapshots['name'],
                                      pdfUrl: bookSnapshots['pdfLink'],
                                    )));
                      },
                      child: Text("خوێندنەوە"),
                    ),
            ],
          ),
        )),
      ),
    );
  }
}
