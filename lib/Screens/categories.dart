import 'package:librarygenocide/Screens/category_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
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
    return output.join() + " " + "پەرتووک";
  }

  List<DocumentSnapshot> categories;

  getCats() {
    FirebaseFirestore.instance.collection("categories").get().then((value) {
      print("value");
      print(value.docs);
      categories = value.docs;
      categories.forEach((element) {
        if (element['name'] == 'سەرجەم') {
          categories.remove(element);
        }
        setState(() {
          categories = categories;
        });
      });
    });
  }

  @override
  void initState() {
    getCats();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("categories").snapshots(),
        builder: (_, snapshot) {
          return (categories == null)
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: GridView.builder(
                    //    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: categories.length ?? 0,
                    itemBuilder: (_, index) {
                      if (snapshot.hasData) {
                        DocumentSnapshot shops = categories[index];

                        return (shops['name'] == 'سەرجەم')
                            ? Visibility(visible: false, child: Container())
                            : Container(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (crl) => CategoryList(
                                                shops.id, shops['name'])));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0,
                                        right: 10,
                                        bottom: 10,
                                        top: 10),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).accentColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Theme.of(context)
                                                      .accentColor
                                                      .withOpacity(0.5),
                                                  blurRadius: 10.0)
                                            ]),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: height * 0.1,
                                              child: Center(
                                                child: Hero(
                                                  tag: shops.id,
                                                  child: Text(
                                                    shops
                                                        .data()[''
                                                            'name']
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 24,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: height * 0.06,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              child: Center(
                                                child: Text(
                                                  getTotal(shops
                                                      .data()[''
                                                          'total']
                                                      .toString()),
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                ),
                              );
                      }
                      return Container(
                        child: Text("ببورە هیچ پەرتووکێک نییە"),
                      );
                    },
                  ),
                );
        });
  }
}
