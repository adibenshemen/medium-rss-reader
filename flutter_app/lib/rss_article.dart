import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';

class RssArticle extends StatefulWidget {
  const RssArticle(this.content, {super.key});

  final Map<String, dynamic> content;

  @override
  State<RssArticle> createState() {
    return _RssArticleState();
  }
}

class _RssArticleState extends State<RssArticle> {
  @override
  void initState() {
    super.initState();
  }

  String _parseDateFormat(String date) {
    DateFormat rssDateFormat = DateFormat('EEE, dd MMM yyyy HH:mm:ss Z');
    DateTime parsedDate = rssDateFormat.parse(date);
    String formattedDate = DateFormat('EEEE, d MMMM y').format(parsedDate);

    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.content['title'],
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (widget.content['creator'] != '')
          Text(widget.content['creator'],
              style: const TextStyle(
                fontSize: 16,
              )),
        Text(
          'Published on ${_parseDateFormat(widget.content['pubDate'])}',
        ),
        HtmlWidget(
          widget.content['content'],
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
