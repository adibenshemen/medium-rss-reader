import 'package:flutter/material.dart';
import 'package:medium_feed_reader/search_page.dart';
import 'package:google_fonts/google_fonts.dart';

class RssReaderApp extends StatelessWidget {
  const RssReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Medium RSS Reader',
            style: GoogleFonts.lato(),
          ),
        ),
        body: const SearchPage(),
      ),
    );
  }
}