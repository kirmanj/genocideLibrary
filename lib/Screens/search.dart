import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:librarygenocide/Screens/detail.dart';
import 'package:librarygenocide/Screens/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
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

  TextEditingController searchContoler = TextEditingController();
  List<DocumentSnapshot> booksSnapshot;
  List<String> bookImages;
  List<bool> favorites;
  List<Map> books;
  String urlDownload = '';
  List<Map> searchedbook;

  List<String> favoritsList = List<String>();

  getData() async {
    SharedPreferences vaforitePrefrences =
        await SharedPreferences.getInstance();

    setState(() {
      favoritsList = vaforitePrefrences.getStringList("favoritsList");
    });
    if (favoritsList == null) {
      favoritsList = List<String>();
    }
  }

  saveData() async {
    SharedPreferences vaforitePrefrences =
        await SharedPreferences.getInstance();
    vaforitePrefrences.setStringList("favoritsList", favoritsList);

    //print(favoritsList.isEmpty);
  }

  preparebook() {
    FirebaseFirestore.instance.collection('books').snapshots().listen((event) {
      setState(() {
        booksSnapshot = event.docs;
        books = new List<Map>(booksSnapshot.length);
      });
      searchbooks("");
    });
  }

  searchbooks(String search) {
    int i = 0;
    if (booksSnapshot != null) {
      booksSnapshot.forEach((element) {
        element.data();
        books[i] = {
          "author": element['author'].toString(),
          "authorDisplay": element['author'].toString().toLowerCase(),
          "imagePath": element['imagePath'].toString(),
          'id': element.id,
          "name": element['name'],
          "display": element['name'].toString().toLowerCase(),
          "publishDate": element['publishDate'],
          "pdfLink": element['pdfLink'],
          "pdfShow": element['pdfShow'],
        };
        i++;
      });
      setState(() {
        books = books;
      });
    }

    setState(() {
      searchedbook = books
          .where((Map item) => item['display'].startsWith(search.toLowerCase()))
          .toList();
      if (searchedbook.isEmpty) {
        searchedbook = books
            .where((Map item) =>
                item['authorDisplay'].startsWith(search.toLowerCase()))
            .toList();
      }

      urlbooks = List<String>(searchedbook.length);
      favorites = List<bool>(searchedbook.length);
    });
  }

  List<String> urlbooks;
  Future<String> getUrl(String url, int i) async {
    final ref = FirebaseStorage.instance.ref().child('books/' + url);
    urlbooks[i] = await ref.getDownloadURL();

    return urlbooks[i];
  }

  @override
  void initState() {
    preparebook();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: height,
            width: width,
            color: Theme.of(context).accentColor,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 20),
                  height: height * 0.08,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios,
                            color: Theme.of(context).primaryColor),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 0, left: 0),
                        child: Container(
                          width: width * 0.8,
                          decoration: BoxDecoration(
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black12,
                                ),
                              ],
                              color: Theme.of(context).primaryColor,
                              border: Border.all(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.1),
                              ),
                              borderRadius: BorderRadius.circular(15)),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      size: 18,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        (searchedbook == null)
                                            ? print("searchedbook")
                                            : searchedbook.clear();
                                        urlbooks = null;
                                        searchContoler.clear();
                                        searchbooks("");
                                      });
                                    },
                                  ),
                                ),
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Container(
                                    width: width * 0.55,
                                    child: TextField(
                                      controller: searchContoler,
                                      onChanged: (val) {
                                        searchbooks(val);
                                      },
                                      style: TextStyle(
                                          decoration: TextDecoration.none),
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelStyle: TextStyle(
                                            decoration: TextDecoration.none),
                                        labelText: "لێرە بگەرێ",
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    child: Icon(Icons.search,
                                        color: Theme.of(context).accentColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                (searchedbook == null)
                    ? Container()
                    : Container(
                        width: width * 0.95,
                        height: height * 0.85,
                        child: ListView.builder(
                            itemCount: searchedbook.length,
                            shrinkWrap: true,
                            itemBuilder: (context, i) {
                              favorites[i] = false;
                              return Container(
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
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    DocumentSnapshot book;
                                    FirebaseFirestore.instance
                                        .collection('books')
                                        .doc(searchedbook[i]["id"])
                                        .get()
                                        .then((value) {
                                      setState(() {
                                        book = value;
                                      });
                                    }).whenComplete(() async {
                                      await showDialog(
                                          context: context,
                                          builder: (_) => ImageDialog(
                                              urlbooks[i], book, favoritsList));
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                    width: width * 0.52,
                                                    height: height * 0.05,
                                                    child: Text(
                                                      (searchedbook[i]['name']),
                                                      textAlign: TextAlign.end,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
                                                            .accentColor,
                                                      ),
                                                    )),
                                                Container(
                                                    width: width * 0.2,
                                                    height: height * 0.05,
                                                    child: Text(
                                                      "ناوی کتێب",
                                                      textAlign: TextAlign.end,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
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
                                                      searchedbook[i]
                                                              ['author'] +
                                                          '\t\t\t',
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                        wordSpacing: 0,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
                                                            .accentColor,
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
                                                            .accentColor,
                                                      ),
                                                    )),
                                              ],
                                            ),
                                            Expanded(
                                              child: Container(
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
                                                                        searchedbook[i]
                                                                            [
                                                                            'id']))
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
                                                                  searchedbook[
                                                                      i]['id']);
                                                              if (favoritsList
                                                                  .contains(
                                                                      searchedbook[
                                                                              i]
                                                                          [
                                                                          'id'])) {
                                                                setState(() {
                                                                  favoritsList.remove(
                                                                      searchedbook[
                                                                              i]
                                                                          [
                                                                          'id']);
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  favoritsList.add(
                                                                      searchedbook[
                                                                              i]
                                                                          [
                                                                          'id']);
                                                                });
                                                              }
                                                              saveData();
                                                            }
                                                          },
                                                        ),
                                                        IconButton(
                                                          icon: Icon(
                                                            (searchedbook[i][
                                                                            'pdfLink']
                                                                        .isEmpty ||
                                                                    (searchedbook[i]
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
                                                                              name: searchedbook[i]['name'],
                                                                              pdfUrl: searchedbook[i]['pdfLink'],
                                                                            )));
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                        width: width * 0.3,
                                                        child: Text(
                                                          getTotal(searchedbook[
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
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * 0.025,
                                      ),
                                      Container(
                                        width: width * 0.17,
                                        height: height,
                                        child: FutureBuilder(
                                            future: getUrl(
                                                searchedbook[i]['imagePath'],
                                                i),
                                            builder: (_, snapshot) {
                                              if (snapshot.hasData) {
                                                return Container(
                                                  height: height * 0.2,
                                                  width: width * 0.2,
                                                  child: Image.network(
                                                    snapshot.data,
                                                    fit: BoxFit.fitHeight,
                                                  ),
                                                );
                                              } else {
                                                return Container(
                                                  height: height * 0.2,
                                                  width: width * 0.2,
                                                  child: Center(
                                                      child:
                                                          Text("waiting...")),
                                                );
                                              }
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
