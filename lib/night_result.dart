import 'package:flutter/material.dart';
import 'package:flutter_application_1/pdf_viewer_page.dart';

class NightResultScreen extends StatelessWidget {
  final String pdfUrl;

  const NightResultScreen({super.key, required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Night Result'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: PDFViewerPage(pdfUrl: pdfUrl)),
    );
  }
}
