// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/app_state.dart';
import 'package:google_fonts/google_fonts.dart';

import 'global.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: countSelectedButtons,
      builder: (context, value, child) {
        final bool isDisabled = value != 0;
        return Material(
          elevation:
              isDisabled ? 4 : 0, // Adjust elevation for disabled appearance
          color: Color(0xFFE4C87F), // Set background color to gold
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Set border radius here
          ),
          child: InkWell(
            onTap: isDisabled
                ? null
                : () {
                    // Handle the button tap event here
                    // Add your logic or function call
                  },
            child: Container(
              width: width,
              height: height,
              child: Center(
                child: Text(
                  'Rezerviraj',
                  style: TextStyle(
                    fontFamily: GoogleFonts.ptSans().fontFamily,
                    fontSize: 20,
                    fontWeight:
                        FontWeight.w800, // Postavite debljinu fonta na 800
                    color: Colors.black, // Set text color to black
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
