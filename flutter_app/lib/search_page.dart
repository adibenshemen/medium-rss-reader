import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:medium_feed_reader/rss_feed.dart';
import 'package:medium_feed_reader/search_bar_rss.dart';
import 'package:medium_feed_reader/search_history_list.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<Map<String, dynamic>> _articlesList = [];
  List<String> _searchHistory = [];
  bool _submitted = false;
  bool _userHasPosts = true;
  bool _historyLoaded = false;
  String _pageTitle = '';
  String _searchBarHintText = 'Enter Medium username';

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  Future<void> _sendUserInputToServer(String userInput) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': userInput,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        _searchBarHintText = 'Enter Medium username';
        _pageTitle = data['title'];
        if ((data['articles'] as List).isNotEmpty) {
          _userHasPosts = true;
          _articlesList = (data['articles'] as List).map((article) {
            return {
              'title': article['title'] ?? 'No Title',
              'pubDate': article['pubDate'] ?? 'No Date',
              'creator': article['creator'] ?? '',
              'content': article['content'] ?? '',
              'link': article['link'] ?? '',
            };
          }).toList();
        } else {
          _userHasPosts = false;
        }

        _searchHistory = List<String>.from(data['history']);
      });
    } else {
      setState(() {
        _searchBarHintText = '${data['error']}. Please try again';
      });
    } 
  }

  void _onSubmit() async {
    final searchQuery = _controller.text;
    _submitted = true;
    if (searchQuery.isNotEmpty) {
      await _sendUserInputToServer(searchQuery);
      _controller.clear();
      _focusNode.requestFocus();
    }
  }

  void _loadSearchHistory() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      final Map<String, dynamic> decodedResponse = jsonDecode(response.body);
      final List<String> history =
          List<String>.from(decodedResponse['history']);

      _historyLoaded = true;

      setState(() {
        _searchHistory = history;
      });
    } catch (error) {
      _historyLoaded = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100),
        child: Column(
          children: [
            const SizedBox(height: 50),
            SearchBarRss(
              controller: _controller,
              focusNode: _focusNode,
              hintText: _searchBarHintText,
              onSubmit: _onSubmit,
            ),
            const SizedBox(height: 20),
              if (_searchHistory.isNotEmpty)
                SearchHistory(
                  searchHistory: _searchHistory,
                  onHistoryTap: _onSubmit,
                  controller: _controller,
                  historyLoaded: _historyLoaded,
                ),
            const SizedBox(height: 20),
            RssFeed(
              articlesList: _articlesList,
              submitted: _submitted,
              pageTitle: _pageTitle,
              userHasPosts: _userHasPosts,
            ),
          ],
        ),
      ),
    );
  }
}