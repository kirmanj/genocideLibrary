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
  List<String> profile = [
    'ساڵی ١٩٦٩ لە شاری هەولێر لە دایک بووە',
    'هەڵگری بڕوانامەی دبلۆمە ',
    'نوسەر و چالاکوانە لە بواری ناساندنی جینیوسایدی گەلی کوردستان ',
    'خاوەنی  ٢٣ پەرتووکی چاپکراوە',
    'خاوەنی چوار کورتە فلیمی دیکومێنتارییە',
    'کردنەوەی ٨ پێشانگای وێنە و بەلگەنامەکان',
    'خاوەنی بیروکەی کردنەوەی بەشی جینوسایدی گەلی کورد لە پەرتووکخانەکان',
    'شارەزا لە زمانی کوردی، عەرەبی، تورکی، فارسی '
  ];

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    Reference storagePdf =
        FirebaseStorage.instance.ref().child('pdf/baroque.pdf');
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
      body: Container(
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
