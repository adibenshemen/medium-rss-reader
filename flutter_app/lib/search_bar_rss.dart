import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchBarRss extends StatelessWidget {
  const SearchBarRss({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final void Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onSubmitted: (_) => {onSubmit()},
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: onSubmit,
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(100, 46),
            textStyle: GoogleFonts.lato(),
          ),
          child: const Text(
            'Submit',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
