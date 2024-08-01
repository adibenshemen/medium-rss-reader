import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchHistory extends StatelessWidget {
  const SearchHistory({
    super.key,
    required this.searchHistory,
    required this.onHistoryTap,
    required this.controller,
    required this.historyLoaded,
  });

  final List<String> searchHistory;
  final void Function() onHistoryTap;
  final TextEditingController controller;
  final bool historyLoaded;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (historyLoaded) ...[
          Text(
            'Search History:',
            style: GoogleFonts.lato(
              fontSize: 18,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: searchHistory.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(
                searchHistory[index],
                style: GoogleFonts.lato(),
              ),
              onTap: () {
                controller.text = searchHistory[index];
                onHistoryTap();
              },
            ),
          ),
        ] else
          Text(
            'Something went wrong loading search history',
            style: GoogleFonts.lato(
              fontSize: 18,
            ),
          ),
      ],
    );
  }
}
