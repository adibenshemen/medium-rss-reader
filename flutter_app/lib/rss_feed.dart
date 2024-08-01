import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medium_feed_reader/rss_article.dart';

class RssFeed extends StatefulWidget {
  const RssFeed({
    super.key,
    required this.articlesList,
    required this.submitted,
    required this.pageTitle,
    required this.userHasPosts,
  });

  final List<Map<String, dynamic>> articlesList;
  final String pageTitle;
  final bool submitted;
  final bool userHasPosts;

  @override
  State<RssFeed> createState() {
    return _RssFeedState();
  }
}

class _RssFeedState extends State<RssFeed> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.submitted)
          Text(
            widget.pageTitle,
            style: GoogleFonts.lato(fontSize: 28),
          ),
        const SizedBox(height: 30),
        if (widget.userHasPosts) ...[
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.articlesList.length,
            itemBuilder: (context, index) =>
                RssArticle(widget.articlesList[index]),
          ),
        ] else
          Text(
            'User has no posts yet.',
            style: GoogleFonts.lato(fontSize: 20),
          ),
      ],
    );
  }
}
