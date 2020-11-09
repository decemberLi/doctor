import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomerPDFViewer extends StatefulWidget {
  final String title;
  final String url;

  CustomerPDFViewer(this.title, this.url)
      : assert(title != null || title.length != 0),
        assert(url != null || url.length != 0);

  @override
  State<StatefulWidget> createState() => _CustomerPDFViewerState();

  static openDefaultPreViewPage(
      BuildContext context, String title, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerPDFViewer(title, url),
      ),
    );
  }
}

class _CustomerPDFViewerState extends State<CustomerPDFViewer> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadPDFDocument();
  }

  bool _isLoaded = false;
  PDFDocument _document;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: !_isLoaded
            ? Center(child: CircularProgressIndicator())
            : PDFViewer(
                document: _document,
                zoomSteps: 5,
                navigationBuilder: null,
                scrollDirection: Axis.vertical,
                showIndicator: false,
                showPicker: false,
              ),
      ),
    );
  }

  Future<PDFDocument> _loadPDFDocument() async {
    _document = await PDFDocument.fromURL(widget.url);
    print('pdfDocument');
    setState(() {
      _isLoaded = true;
    });
  }
}
