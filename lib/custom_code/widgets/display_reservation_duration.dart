// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'global.dart';
import 'package:google_fonts/google_fonts.dart';

class DisplayReservationDuration extends StatefulWidget {
  const DisplayReservationDuration({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _DisplayReservationDurationState createState() =>
      _DisplayReservationDurationState();
}

class _DisplayReservationDurationState
    extends State<DisplayReservationDuration> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: globalOutputNotifier,
      builder: (BuildContext context, String value, Widget? child) {
        return _buildContent(value);
      },
    );
  }

  Widget _buildContent(String value) {
    // Split the text into parts1 and parts2
    List<String> lines = value.split('\n');
    List<String> parts1 = lines[0].split(':');
    List<String> parts2 = lines[1].split(':');

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          color: Color(0xFF3B3B3B), // Set the container color to grey
          padding: EdgeInsets.all(16), // Add padding of 8 for all text
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    height: 14 / 12,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: parts1[0] + ':',
                    ),
                    TextSpan(
                      text: parts1[1],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.ptSans().fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8), // Add space between two RichTexts
              RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: parts2[0] + ':',
                    ),
                    TextSpan(
                      text: parts2[1],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.ptSans().fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
