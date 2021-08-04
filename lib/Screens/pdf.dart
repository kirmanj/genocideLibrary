import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';

class PDFBOOK extends StatefulWidget {
  String pdfUrl, name;
  PDFBOOK({this.pdfUrl, this.name});
  @override
  _PDFBOOKState createState() => _PDFBOOKState();
}

class _PDFBOOKState extends State<PDFBOOK> {
  bool _isLoading = true;
  PDFDocument document;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    String bookUrl = widget.pdfUrl;
    Reference storagePdf = FirebaseStorage.instance.ref().child('pdf/$bookUrl');
    String pdfUrl = await storagePdf.getDownloadURL();

    setState(() => _isLoading = true);

    document = await PDFDocument.fromURL(pdfUrl);

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Theme.of(context).highlightColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Theme.of(context).accentColor,
        title: Text(
          widget.name,
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
      body: _isLoading
          ? Center(
              child: Text("...جاوەروان بە",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )),
            )
          : Container(
              color: Theme.of(context).accentColor,
              child: Center(
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : PDFViewer(
                        document: document,
                        scrollDirection: Axis.vertical,
                        zoomSteps: 1,
                        pickerIconColor: Theme.of(context).primaryColor,
                        pickerButtonColor: Theme.of(context).accentColor,
                      ),
              ),
            ),
    );
  }
}
