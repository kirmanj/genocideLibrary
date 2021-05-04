import 'package:librarygenocide/Screens/category_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class NewBook extends StatefulWidget {
  @override
  _NewBookState createState() => _NewBookState();
}

class _NewBookState extends State<NewBook> {
  List<DocumentSnapshot> bookSnapshots;
  List<String> bookImages;

  getBooks() {
    int i = 0;
    FirebaseFirestore.instance.collection('books').get().then((value) {
      bookSnapshots = new List<DocumentSnapshot>(value.docs.length);

      bookImages = new List<String>(bookSnapshots.length);

      value.docs.forEach((element) async {
        Reference storage = FirebaseStorage.instance
            .ref()
            .child('books/${element['imagePath']}');
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
    getBooks();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    double width = MediaQuery.of(context).size.width;
    return (bookSnapshots == null)
        ? Container()
        : GridView.builder(
            scrollDirection: Axis.horizontal,
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 12 / 13, crossAxisCount: 1),
            itemCount: bookSnapshots.length,
            itemBuilder: (_, index) {
              return (bookSnapshots[index] == null)
                  ? Container()
                  : InkWell(
                      onTap: () {
                        DocumentSnapshot cat;
                        FirebaseFirestore.instance
                            .collection('categories')
                            .doc(bookSnapshots[index]['categoryId'])
                            .get()
                            .then((value) {
                          setState(() {
                            cat = value;
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (crl) =>
                                      CategoryList(cat.id, cat['name'])));
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            height: height * 0.15,
                            width: width * 0.2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    bookImages[index] ?? ' ',
                                  )),
                            ),
                          ),
                          Text(
                            bookSnapshots[index]['name'] ?? '',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ],
                      ),
                    );
            },
          );
  }
}
