import 'package:librarygenocide/Screens/detail.dart';
import 'package:librarygenocide/Screens/pdf.dart';
import 'package:librarygenocide/elements/emptyCategory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryList extends StatefulWidget {
  final String categoryId, categoryName;
  CategoryList(this.categoryId, this.categoryName);
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  List<DocumentSnapshot> bookSnapshots;
  List<String> bookImages;
  List<bool> favorites;
  List<String> favoritsList = List<String>();

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

  getBooks() {
    int i = 0;
    FirebaseFirestore.instance
        .collection('books')
        .where("categoryId", isEqualTo: widget.categoryId)
        .get()
        .then((value) {
      bookSnapshots = new List<DocumentSnapshot>(value.docs.length);
      bookImages = new List<String>(bookSnapshots.length);
      favorites = new List<bool>(bookSnapshots.length);
      value.docs.forEach((element) async {
        Reference storage = FirebaseStorage.instance
            .ref()
            .child('books/${element['imagePath']}');

        String url = await storage.getDownloadURL();

        setState(() {
          bookSnapshots[i] = element;
          bookImages[i] = (url);
          print(bookSnapshots[i]['pdfShow']);
          favorites[i] = false;
        });
        print(bookImages);
        i++;
      });
    }).whenComplete(() {
      uploadImage();
    });
  }

  uploadImage() {
    int i = bookSnapshots.length - 1;
    bookSnapshots.forEach((element) async {
      Reference storage =
          FirebaseStorage.instance.ref().child('books/${element['imagePath']}');
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
    getData();
    getBooks();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Theme.of(context).accentColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).accentColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: Theme.of(context).highlightColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0,
          title: Container(
            width: width,
            child: Hero(
              tag: widget.categoryId,
              child: Text(
                widget.categoryName,
                textAlign: TextAlign.end,
                style: TextStyle(
                    fontSize: 24, color: Theme.of(context).primaryColor),
              ),
            ),
          ),
        ),
        body: (bookSnapshots == null)
            ? EmptyCategory()
            : Container(
                width: width,
                child: Container(
                  height: height,
                  width: width * 0.97,
                  padding: EdgeInsets.only(
                      left: width * 0.025, right: width * 0.025),
                  color: Theme.of(context).accentColor,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: bookSnapshots.length,
                      itemBuilder: (context, i) {
                        return (bookSnapshots[i] != null)
                            ? Container(
                                margin: EdgeInsets.only(
                                    bottom: height * 0.01, top: height * 0.01),
                                height: height * 0.15,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Theme.of(context)
                                              .highlightColor
                                              .withOpacity(0.9),
                                          blurRadius: 10.0)
                                    ]),
                                child: GestureDetector(
                                  onTap: () async {
                                    await showDialog(
                                        context: context,
                                        builder: (_) => ImageDialog(
                                            bookImages[i],
                                            bookSnapshots[i],
                                            favoritsList));
                                  },
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          // color: Colors.red,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                      width: width * 0.52,
                                                      height: height * 0.05,
                                                      padding: EdgeInsets.only(
                                                          top: 4),
                                                      child: Text(
                                                        (bookSnapshots[i]
                                                            ['name']),
                                                        textAlign:
                                                            TextAlign.end,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Theme.of(context)
                                                                  .accentColor,
                                                        ),
                                                      )),
                                                  Container(
                                                      width: width * 0.2,
                                                      height: height * 0.05,
                                                      padding: EdgeInsets.only(
                                                          top: 4),
                                                      child: Text(
                                                        "ناوی کتێب",
                                                        textAlign:
                                                            TextAlign.end,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Theme.of(context)
                                                                  .accentColor,
                                                        ),
                                                      )),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                      width: width * 0.55,
                                                      child: Text(
                                                        bookSnapshots[i]
                                                                ['author'] +
                                                            '\t\t\t',
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: TextStyle(
                                                          wordSpacing: 0,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Theme.of(context)
                                                                  .accentColor,
                                                        ),
                                                      )),
                                                  Container(
                                                      width: width * 0.17,
                                                      child: Text(
                                                        "ناوی نوسەر",
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: TextStyle(
                                                          wordSpacing: 0,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Theme.of(context)
                                                                  .accentColor,
                                                        ),
                                                      )),
                                                ],
                                              ),
                                              Container(
                                                //height: 30,
                                                //color: Colors.green,
                                                width: width * 0.72,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        IconButton(
                                                          icon: Icon(
                                                            (favoritsList !=
                                                                    null)
                                                                ? (favoritsList.contains(
                                                                        bookSnapshots[i]
                                                                            .id))
                                                                    ? Icons
                                                                        .favorite
                                                                    : Icons
                                                                        .favorite_border
                                                                : Icons
                                                                    .favorite_border,
                                                            size: 22,
                                                          ),
                                                          color: Theme.of(
                                                                  context)
                                                              .highlightColor,
                                                          onPressed: () {
                                                            if (favoritsList !=
                                                                null) {
                                                              favoritsList.contains(
                                                                  bookSnapshots[
                                                                          i]
                                                                      .id);
                                                              if (favoritsList
                                                                  .contains(
                                                                      bookSnapshots[
                                                                              i]
                                                                          .id)) {
                                                                setState(() {
                                                                  favoritsList.remove(
                                                                      bookSnapshots[
                                                                              i]
                                                                          .id);
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  favoritsList.add(
                                                                      bookSnapshots[
                                                                              i]
                                                                          .id);
                                                                });
                                                              }
                                                              saveData();
                                                            }
                                                          },
                                                        ),
                                                        IconButton(
                                                          icon: Icon(
                                                            (bookSnapshots[i][
                                                                            'pdfLink']
                                                                        .isEmpty ||
                                                                    (bookSnapshots[i]
                                                                            [
                                                                            'pdfShow'] ==
                                                                        1))
                                                                ? null
                                                                : Icons
                                                                    .picture_as_pdf,
                                                            size: 22,
                                                          ),
                                                          color:
                                                              Theme.of(context)
                                                                  .accentColor,
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            PDFBOOK(
                                                                              name: bookSnapshots[i]['name'],
                                                                              pdfUrl: bookSnapshots[i]['pdfLink'],
                                                                            )));
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                        width: width * 0.3,
                                                        child: Text(
                                                          getTotal(bookSnapshots[
                                                                          i][
                                                                      'publishDate']
                                                                  .toString()) +
                                                              '\t\t\t\t\t\t' +
                                                              "سالی چاپ",
                                                          textAlign:
                                                              TextAlign.end,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Theme.of(
                                                                    context)
                                                                .accentColor,
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: width * 0.025,
                                        ),
                                        Container(
                                            width: width * 0.2,
                                            height: height,
                                            child: Image.network(
                                              bookImages[i],
                                              fit: BoxFit.cover,
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                color: Theme.of(context).accentColor,
                                height: height,
                              );
                      }),
                ),
              ));
  }
}

// class ImageDialog extends StatelessWidget {
//   String imageLink;
//   DocumentSnapshot bookSnapshots;
//   List<String> favoritsList;
//   ImageDialog(this.imageLink, this.bookSnapshots, this.favoritsList);
//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//     return Dialog(
//       child: Container(
//         width: width * 0.8,
//         height: height * 0.7,
//         child: Container(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Container(
//                 // color: Colors.red,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                             width: width * 0.52,
//                             height: height * 0.05,
//                             child: Text(
//                               (bookSnapshots['name']),
//                               textAlign: TextAlign.end,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.bold,
//                                 color: Theme.of(context).accentColor,
//                               ),
//                             )),
//                         Container(
//                             width: width * 0.2,
//                             height: height * 0.05,
//                             child: Text(
//                               "ناوی کتێب",
//                               textAlign: TextAlign.end,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.bold,
//                                 color: Theme.of(context).accentColor,
//                               ),
//                             )),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Container(
//                             width: width * 0.55,
//                             child: Text(
//                               bookSnapshots['author'] + '\t\t\t',
//                               textAlign: TextAlign.end,
//                               style: TextStyle(
//                                 wordSpacing: 0,
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.bold,
//                                 color: Theme.of(context).accentColor,
//                               ),
//                             )),
//                         Container(
//                             width: width * 0.17,
//                             child: Text(
//                               "ناوی نوسەر",
//                               textAlign: TextAlign.end,
//                               style: TextStyle(
//                                 wordSpacing: 0,
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.bold,
//                                 color: Theme.of(context).accentColor,
//                               ),
//                             )),
//                       ],
//                     ),
//                     Expanded(
//                       child: Container(
//                         width: width * 0.72,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 IconButton(
//                                   icon: Icon(
//                                     (favoritsList != null)
//                                         ? (favoritsList
//                                                 .contains(bookSnapshots[i].id))
//                                             ? Icons.favorite
//                                             : Icons.favorite_border
//                                         : Icons.favorite_border,
//                                     size: 22,
//                                   ),
//                                   color: Theme.of(context).highlightColor,
//                                   onPressed: () {
//                                     if (favoritsList != null) {
//                                       favoritsList
//                                           .contains(bookSnapshots.id);
//                                       if (favoritsList
//                                           .contains(bookSnapshots.id)) {
//                                         setState(() {
//                                           favoritsList
//                                               .remove(bookSnapshots.id);
//                                         });
//                                       } else {
//                                         setState(() {
//                                           favoritsList.add(bookSnapshots.id);
//                                         });
//                                       }
//                                       saveData();
//                                     }
//                                   },
//                                 ),
//                                 IconButton(
//                                   icon: Icon(
//                                     (bookSnapshots['pdfLink'].isEmpty)
//                                         ? null
//                                         : Icons.picture_as_pdf,
//                                     size: 22,
//                                   ),
//                                   color: Theme.of(context).accentColor,
//                                   onPressed: () {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) => PDFBOOK(
//                                                   name: bookSnapshots
//                                                       ['name'],
//                                                   pdfUrl: bookSnapshots
//                                                       ['pdfLink'],
//                                                 )));
//                                   },
//                                 ),
//                               ],
//                             ),
//                             Container(
//                                 width: width * 0.3,
//                                 child: Text(
//                                   getTotal(bookSnapshots['publishDate']
//                                           .toString()) +
//                                       '\t\t\t\t\t\t' +
//                                       "سالی چاپ",
//                                   textAlign: TextAlign.end,
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.bold,
//                                     color: Theme.of(context).accentColor,
//                                   ),
//                                 )),
//                           ],
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 width: width * 0.025,
//               ),
//               Container(
//                   width: width * 0.2,
//                   height: height,
//                   child: Image.network(
//                     imageLink,
//                     fit: BoxFit.cover,
//                   )),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
