import 'package:flutter/material.dart';
import 'package:flutter_application_1/pdf_viewer_page.dart';

class MorningResultScreen extends StatelessWidget {
  final String pdfUrl;

  const MorningResultScreen({super.key, required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Morning Result'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: PDFViewerPage(pdfUrl: pdfUrl)));
  }
}
