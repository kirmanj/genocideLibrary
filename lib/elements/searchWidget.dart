import 'package:librarygenocide/Screens/search.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10, top: 0),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Search()));
        },
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black12,
                  // offset: Offset(1.0, 6.0),
                  //blurRadius: 10.0,
                ),
              ],
              color: Theme.of(context).primaryColor,
              border: Border.all(
                color: Theme.of(context).focusColor.withOpacity(0.1),
              ),
              borderRadius: BorderRadius.circular(15)),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  "گەران بەدوای کتێبەکان",
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.caption.merge(TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).accentColor,
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 5),
                child: Icon(Icons.search, color: Theme.of(context).accentColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
