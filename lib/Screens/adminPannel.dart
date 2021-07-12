import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class AdminPannel extends StatefulWidget {
  @override
  _AdminPannelState createState() => _AdminPannelState();
}

class _AdminPannelState extends State<AdminPannel> {
  DocumentSnapshot user;
  bool isBook = true;
  bool buttonVisibilty = true;
  bool onPanel = false;

  changeToArabNum(String str) {
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

  changeToEnglishbNum(String str) {
    List input = str.toString().split("");
    List output = [];
    for (int i = 0; i < input.length; i++) {
      if (input[i] == "٠") {
        output.add("0");
      } else if (input[i] == "١") {
        output.add("1");
      } else if (input[i] == "٢") {
        output.add("2");
      } else if (input[i] == "٣") {
        output.add("3");
      } else if (input[i] == "٤") {
        output.add("4");
      } else if (input[i] == "٥") {
        output.add("5");
      } else if (input[i] == "٦") {
        output.add("6");
      } else if (input[i] == "٧") {
        output.add("7");
      } else if (input[i] == "٨") {
        output.add("8");
      } else if (input[i] == "٩") {
        output.add("9");
      }
    }
    return output.join();
  }

  List<DocumentSnapshot> bookSnapshots;
  DocumentSnapshot bookEditSnapshot;
  int editBookFlag;
  List<String> bookImages;
  List<bool> favorites;
  // .where("categoryId", isNotEqualTo: "7EXKjUtgz3Yw8710iVd8")

  List<Map> cats;
  List<String> catsInedx = [];
  String dropDownValue;
  String categoryControl;
  String categoryControlForEdit;
  String editBookImage;
  int j = 0;
  GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController bookName = TextEditingController();

  TextEditingController writeName = TextEditingController();
  TextEditingController bookCategory = TextEditingController();
  TextEditingController yearOfBook = TextEditingController();

  String userImage;
  File _imageFile;
  String fileName;

  bool isRead = false;
  PanelController panelController = PanelController();

  getBooks() {
    int i = 0;
    FirebaseFirestore.instance.collection('categories').get().then((value) {
      cats = new List<Map>(value.docs.length);
      value.docs.forEach((element) {
        setState(() {
          cats[j] = {
            "name": element['name'],
            'id': element.id,
          };
          catsInedx.add(element['name']);
          //print(cats);
        });
        if (element['name'] == dropDownValue) {
          setState(() {
            categoryControl = element.id;
          });
        }
        setState(() {
          cats = cats;
        });
        j++;
      });
      setState(() {
        dropDownValue = value.docs.first['name'];
      });
    });
    FirebaseFirestore.instance.collection('books').get().then((value) {
      bookSnapshots = new List<DocumentSnapshot>(value.docs.length);
      bookImages = new List<String>(bookSnapshots.length);

      favorites = new List<bool>(bookSnapshots.length);

      value.docs.forEach((element) async {
        Reference storage = FirebaseStorage.instance
            .ref()
            .child('books/${element['imagePath'] ?? ''}');
        String url = await storage.getDownloadURL();
        setState(() {
          bookSnapshots[i] = element;
          bookImages[i] = (url);
          favorites[i] = false;
        });
        i++;
      });
    }).whenComplete(() {
      if (bookSnapshots != null) {
        uploadImage();
      }
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
      //print(bookImages);
      i--;
    });
  }

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((value) {
      setState(() {
        _imageFile = value;
      });
    });
    setState(() {
      fileName = basename(_imageFile.path);
    });
    Reference storage = FirebaseStorage.instance.ref().child('books/$fileName');
    UploadTask storageUploadTask = storage.putFile(_imageFile);
    storageUploadTask.whenComplete(() async {
      String path = await storage.getDownloadURL();
      setState(() {
        userImage = path;
      });
    });
  }

  showAlertDialog(BuildContext context, String categoryCon) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(
        "داخستن",
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("دلینیام",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
      onPressed: () {
        ////print(categoryCon);
        FirebaseFirestore.instance
            .collection('books')
            .where("categoryId", isEqualTo: categoryCon)
            .get()
            .then((snapshot) {
          snapshot.docs.forEach((element) {
            element.reference.delete();
          });
        });
        FirebaseFirestore.instance
            .collection('categories')
            .doc(categoryCon)
            .delete();
        getBooks();
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AdminPannel()));
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [Text("زانیاری")],
      ),
      content: (categoryCon != "سەرجەم")
          ? Text(
              " ئاگادار بە لەگەل سرینەوەی ئەم بەشە، هەموو پەرتووکەکانی سەر ئەم بەشە دەسرێنەوە، دلنیای؟",
              textAlign: TextAlign.right,
            )
          : Text(
              " ببورە، ناتوانی ئەم بەشە بسریەوە، تکایە بەشێکی تر هەلبژێرە",
              textAlign: TextAlign.right,
            ),
      actions: [
        (categoryCon != "سەرجەم") ? continueButton : null,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
      body: SafeArea(
        child: SlidingUpPanel(
          maxHeight: height * 0.8,
          minHeight: height * 0.075,
          controller: panelController,
          onPanelOpened: () {
            setState(() {
              onPanel = !onPanel;
            });
            if ((favorites.contains(true))) {
              bookName.text = bookEditSnapshot['name'];
              writeName.text = bookEditSnapshot['author'];
              userImage = editBookImage;

              yearOfBook.text =
                  changeToArabNum(bookEditSnapshot['publishDate'].toString());
              FirebaseFirestore.instance
                  .collection("categories")
                  .doc(bookEditSnapshot['categoryId'])
                  .get()
                  .then((value) {
                categoryControl = value.id;
                dropDownValue = value['name'];
              });
            } else {
              setState(() {
                bookName.text = "";
                fileName = null;
                writeName.text = "";
                yearOfBook.text = "";
                _imageFile = null;
                userImage = null;
              });
            }
          },
          onPanelClosed: () {
            setState(() {
              onPanel = !onPanel;
            });
          },
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(25), topLeft: Radius.circular(25)),
          panel: Container(
            child: Column(
              children: [
                (favorites == null)
                    ? Container()
                    : (favorites.contains(true))
                        ? Container(
                            width: width * 0.9,
                            padding: EdgeInsets.only(top: 10),
                            child: InkWell(
                              child: Container(
                                width: width * 0.45,
                                child: Text('گورینی پەرتووک',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'sans-serif-light',
                                      color: Colors.yellow[900],
                                    )),
                              ),
                            ),
                          )
                        : Container(
                            width: width * 0.9,
                            padding: EdgeInsets.only(top: 10),
                            child: Container(
                              width: width * 0.45,
                              child: Text('زیادکردنی پەرتووک',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontFamily: 'sans-serif-light',
                                      color: Colors.black)),
                            ),
                          ),
                Form(
                    key: _formKey,
                    child: Container(
                      width: width * 0.8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              validator: (val) {
                                if (val.isEmpty) {
                                  return 'ناوی پەرتووک ناکرێت بەتال بێت';
                                } else {
                                  return null;
                                }
                              },
                              controller: bookName,
                              textAlign: TextAlign.end,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                  fontSize: 18,
                                ),
                                labelStyle: TextStyle(
                                  fontSize: 18,
                                ),
                                labelText: "ناوی پەرتووک",
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              validator: (val) {
                                if (val.isEmpty) {
                                  return 'ناوی نوسەر ناکرێت بەتال بێت';
                                } else {
                                  return null;
                                }
                              },
                              controller: writeName,
                              textAlign: TextAlign.end,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                  fontSize: 18,
                                ),
                                labelStyle: TextStyle(
                                  fontSize: 18,
                                ),
                                labelText: "ناوی نوسەر",
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              validator: (val) {
                                if (val.isEmpty) {
                                  return 'سالی چاپ ناکرێت بەتال بێت';
                                } else {
                                  return null;
                                }
                              },
                              controller: yearOfBook,
                              textAlign: TextAlign.end,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                  fontSize: 18,
                                ),
                                labelStyle: TextStyle(
                                  fontSize: 18,
                                ),
                                labelText: "سالی چاپ",
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          ListTile(
                            trailing: Text(': بەش ',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: 'sans-serif-light',
                                    color: Colors.black)),
                            title: Container(
                              child: Text(dropDownValue ?? '',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontFamily: 'sans-serif-light',
                                      color: Colors.black)),
                            ),
                          )
                        ],
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
                Padding(
                    padding: EdgeInsets.only(top: 0.0),
                    child: new Stack(fit: StackFit.loose, children: <Widget>[
                      new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(
                            width: 25,
                          ),
                          TextButton(
                              child: Container(
                                width: width * 0.23,
                                decoration: new BoxDecoration(
                                  color: Theme.of(context).accentColor,
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(10)),
                                ),
                                child: Text(
                                  (favorites == null)
                                      ? "چاوەرێکە"
                                      : (!favorites.contains(true) ??
                                              false || !isBook)
                                          ? "زیاد بکە"
                                          : "بگورە",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 26, color: Colors.white),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  if (!isBook) {
                                    FirebaseFirestore.instance
                                        .collection('categories')
                                        .add({
                                      "name": bookName.text,
                                      "total": 0,
                                    });
                                  } else if (favorites.contains(true)) {
                                    cats.forEach((element) {
                                      if (element['name'] == dropDownValue) {
                                        categoryControl = element['id'];
                                      }
                                    });
                                    FirebaseFirestore.instance
                                        .collection('books')
                                        .doc(bookEditSnapshot.id)
                                        .update({
                                      "author": writeName.text,
                                      "categoryId": categoryControl,
                                      "name": bookName.text,
                                      "publishDate": int.parse(
                                          changeToEnglishbNum(yearOfBook.text))
                                    });
                                  } else {
                                    cats.forEach((element) {
                                      if (element['name'] == dropDownValue) {
                                        categoryControl = element['id'];
                                      }
                                    });

                                    FirebaseFirestore.instance
                                        .collection('books')
                                        .add({
                                      "author": writeName.text,
                                      "categoryId": categoryControl,
                                      "imagePath": fileName,
                                      "name": bookName.text,
                                      "publishDate": int.parse(yearOfBook.text),
                                      'pdfLink': ''
                                    });
                                  }
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AdminPannel()));
                                }
                              }),
                          SizedBox(
                            width: 35,
                          ),
                          (!isBook)
                              ? Container()
                              : Padding(
                                  padding: EdgeInsets.only(right: 20.0),
                                  child: Container(
                                    width: width * 0.25,
                                    height: height * 0.2,
                                    decoration: new BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      borderRadius: new BorderRadius.all(
                                          new Radius.circular(10)),
                                    ),
                                    child: (userImage != null)
                                        ? Image.network(userImage)
                                        : InkWell(
                                            onTap: () {
                                              chooseFile();
                                            },
                                            child: Center(
                                                child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "وێنەی پەرتووکەکە زیاد بکە",
                                                  textAlign: TextAlign.center,
                                                ),
                                                Icon(
                                                  CupertinoIcons
                                                      .photo_on_rectangle,
                                                ),
                                              ],
                                            )),
                                          ),
                                  ),
                                ),
                        ],
                      )
                    ])),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              color: Theme.of(context).accentColor,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Theme.of(context).highlightColor,
                            size: 22.0,
                          ),
                          onPressed: () {
                           // showAlertDialogSignOut(context);
                            FirebaseAuth.instance.signOut();
                            Navigator.pop(context);
                          }),
                      Padding(
                        padding: EdgeInsets.only(right: 5.0),
                        child: Text('ئەدمین',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                              fontFamily: 'sans-serif-light',
                            )),
                      ),
                      (cats != null)
                          ? Container(
                              child: (dropDownValue == null || !onPanel)
                                  ? Container()
                                  : DropdownButton(
                                      icon: (onPanel)
                                          ? Icon(
                                              CupertinoIcons
                                                  .chevron_down_square,
                                              color: Colors.yellow[900],
                                            )
                                          : Icon(
                                              CupertinoIcons.sort_down,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                      value: dropDownValue,
                                      dropdownColor:
                                          Theme.of(context).accentColor,
                                      items: catsInedx
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: TextStyle(
                                                color: (onPanel)
                                                    ? Colors.yellow[900]
                                                    : Theme.of(context)
                                                        .primaryColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          dropDownValue = value;
                                          if (!onPanel) {
                                            //print(cats);
                                            cats.forEach((element) {
                                              if (element['name'] == value) {
                                                categoryControl = element['id'];
                                              }
                                            });
                                          }
                                        });
                                      }),
                            )
                          : Container(),
                    ],
                  ),
                  ((bookSnapshots != null))
                      ? Column(
                          children: [
                            Container(
                              width: width,
                              child: Container(
                                height: height * 0.85,
                                width: width * 0.5,
                                padding: EdgeInsets.only(
                                    left: width * 0.025, right: width * 0.025),
                                color: Theme.of(context).accentColor,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: bookSnapshots.length,
                                    itemBuilder: (context, i) {
                                      if (bookSnapshots[i] != null) {
                                        return (((bookSnapshots[i]
                                                            ['categoryId'] ==
                                                        categoryControl) ||
                                                    (dropDownValue ==
                                                        dropDownValue)) ||
                                                onPanel)
                                            ? Container(
                                                margin: EdgeInsets.only(
                                                    bottom: height * 0.01,
                                                    top: height * 0.01),
                                                height: height * 0.15,
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Theme.of(
                                                                  context)
                                                              .highlightColor
                                                              .withOpacity(0.9),
                                                          blurRadius: 10.0)
                                                    ]),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      // color: Colors.red,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                  width: width *
                                                                      0.52,
                                                                  height:
                                                                      height *
                                                                          0.05,
                                                                  child: Text(
                                                                    (bookSnapshots[
                                                                            i][
                                                                        'name']),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .accentColor,
                                                                    ),
                                                                  )),
                                                              Container(
                                                                  width: width *
                                                                      0.2,
                                                                  height:
                                                                      height *
                                                                          0.05,
                                                                  child: Text(
                                                                    "ناوی کتێب",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .accentColor,
                                                                    ),
                                                                  )),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                  width: width *
                                                                      0.55,
                                                                  child: Text(
                                                                    bookSnapshots[i]
                                                                            [
                                                                            'author'] +
                                                                        '\t\t\t',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                    style:
                                                                        TextStyle(
                                                                      wordSpacing:
                                                                          0,
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .accentColor,
                                                                    ),
                                                                  )),
                                                              Container(
                                                                  width: width *
                                                                      0.17,
                                                                  child: Text(
                                                                    "ناوی نوسەر",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                    style:
                                                                        TextStyle(
                                                                      wordSpacing:
                                                                          0,
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .accentColor,
                                                                    ),
                                                                  )),
                                                            ],
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              width:
                                                                  width * 0.72,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    child: Row(
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            Container(
                                                                              width: width * 0.075,
                                                                              child: IconButton(
                                                                                icon: Icon(
                                                                                  Icons.delete,
                                                                                  color: Colors.red,
                                                                                  size: 20,
                                                                                ),
                                                                                color: Theme.of(context).primaryColor,
                                                                                onPressed: () {
                                                                                  FirebaseFirestore.instance.collection('books').doc(bookSnapshots[i].id).delete().whenComplete(() {
                                                                                    getBooks();
                                                                                  });
                                                                                },
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              width: width * 0.075,
                                                                              child: IconButton(
                                                                                icon: Icon(
                                                                                  (!favorites[i]) ? Icons.edit : Icons.edit_off,
                                                                                  size: 20,
                                                                                ),
                                                                                color: Theme.of(context).accentColor,
                                                                                onPressed: () {
                                                                                  setState(() {
                                                                                    if ((editBookFlag == i) && !favorites[i]) {
                                                                                      editBookFlag = null;
                                                                                    }
                                                                                    if (!favorites[i]) {
                                                                                      panelController.open();
                                                                                    }
                                                                                    favorites[i] = true;
                                                                                    editBookImage = bookImages[i];
                                                                                    bookEditSnapshot = bookSnapshots[i];
                                                                                    if (editBookFlag != null) {
                                                                                      favorites[editBookFlag] = false;
                                                                                    }
                                                                                    editBookFlag = i;
                                                                                  });

                                                                                  //print(favorites);
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                      width:
                                                                          width *
                                                                              0.3,
                                                                      child:
                                                                          Text(
                                                                        changeToArabNum(bookSnapshots[i]['publishDate'].toString()) +
                                                                            '\t\t\t\t\t\t' +
                                                                            "سالی چاپ",
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              Theme.of(context).accentColor,
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
                                                        width: width * 0.2,
                                                        height: height,
                                                        child: Image.network(
                                                          bookImages[i],
                                                          fit: BoxFit.cover,
                                                        )),
                                                  ],
                                                ),
                                              )
                                            : Container();
                                      } else {
                                       return Container();
                                      }
                                    }),
                              ),
                            )
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showAlertDialogSignOut(BuildContext context) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        FirebaseAuth.instance.signOut();
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(""),
      content: Text("ئایا دڵنیایت لەوەی کە دەتەوێت بچیتە دەرەوە"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}



