import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:librarygenocide/Screens/loginTestPage.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  bool isFilter = false;
  String about =
      "کتێبخانا گشتی بەحرکە: ۳ـ٥ـ۲٠۱۲ کراوەتەوە، خاوەنی زياتر لە ( ۲٠٠٠ ) کتێب و گوڤارە لە ۱۳ بوارادا، ( فەلسەفە، مێژوو، ئەدەب، ياسا، رامياری، بەشی مندالان، ئاين،زمان، زانست، کشتوکال، کومەلايەتی، زانياری گشتی، جوگرافيا )يە بە زمانی کوردی ، فارسی، عەرەبی، ئينگليزی، هەروەها ژمارەيەک لە لێکولينەوەی زانستی ماجستێرو دکتورا هەن. لدويف ئامار و تومارا فەرميا کتێبخانێ لسالا ۲٠۱٥ ، ( ٥۸۹ ) کەسان پەرتووک وەرگرتينە بو مال، ( ٤٤٦ کور  )، ( ۱٤۳ کچ ) سەرەدانا کتێبخانێ يا کری ";

  List<DocumentSnapshot> bookSnapshots;
  List<String> bookImages;
  CarouselController buttonCarouselController = CarouselController();
  List<String> profileList = [
    'سالی ١٩٦٩ لە شاری هەولێر لە دایکبووە',
    'هەلگری بڕوانامەی دبلوومە',
    'نوسەر و چالاکوان لە بواری ناساندنی جینوسایدی گەلی کورد',
    'خاوەنی ٢٣ پەرتووکی چاپکراو',
    'خاوەنی ٤ کورتە فلیمی دیکومێنتاری',
    'کردنەوەی ٨ پێشانگای وێنە و بەلگەنامەکان',
  ];

  getBooks() {
    int i = 0;
    FirebaseFirestore.instance.collection('library').get().then((value) {
      bookSnapshots = new List<DocumentSnapshot>(value.docs.length);

      bookImages = new List<String>(bookSnapshots.length);

      value.docs.forEach((element) async {
        Reference storage = FirebaseStorage.instance
            .ref()
            .child('library/${element['imagePath']}');
        String url = await storage.getDownloadURL();
        setState(() {
          bookSnapshots[i] = element;
          bookImages[i] = (url);
        });
        print(bookImages);
        i++;
      });
      print(bookSnapshots);
    }).whenComplete(() {
      uploadImage();
    });
  }

  uploadImage() {
    int i = bookSnapshots.length - 1;
    bookSnapshots.forEach((element) async {
      Reference storage = FirebaseStorage.instance
          .ref()
          .child('library/${element['imagePath']}');
      String url = await storage.getDownloadURL();
      setState(() {
        bookImages[i] = (url);
      });
      print(bookImages);
      i--;
    });
  }

  @override
  void initState() {
    getBooks();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Theme.of(context).accentColor,
        body: Container(
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: height * 0.075,
                //   color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close,
                          color: Theme.of(context).highlightColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'کتێبخانەی جینوسایدی گەلی کورد',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.person,
                          color: Theme.of(context).highlightColor),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                    ),
                  ],
                ),
              ),
              Container(
                width: width * 0.95,
                height: height * 0.6,
                // color: Colors.red,
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          left: width * 0.2, top: height * 0.05),
                      child: ListTile(
                        title: Text(
                          "رێکارێ مزویری",
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: width * 0.65,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Theme.of(context).highlightColor,
                        ),
                      ),
                      height: height * 0.2,
                      width: width * 0.3,
                      child: Image.asset(
                        'assets/author.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context)
                                  .highlightColor
                                  .withOpacity(0.9),
                              blurRadius: 15.0)
                        ],
                        color: Theme.of(context).accentColor,
                        border: Border.all(
                          color: Theme.of(context).highlightColor,
                        ),
                      ),
                      height: height * 0.4,
                      margin: EdgeInsets.only(top: height * 0.2),
                      padding: EdgeInsets.only(right: 10),
                      child: ListView.builder(
                        itemCount: profileList.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      profileList[index],
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '-  ',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  height: height * 0.12,
                  // width: width,
                  //color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "powered by SmartSolution",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        child: Image.asset("assets/smartLogo.png"),
                      )
                    ],
                  ))
            ],
          ),
        ));
  }
}
