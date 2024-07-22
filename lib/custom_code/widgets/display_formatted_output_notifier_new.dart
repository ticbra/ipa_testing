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

// Other imports remain the same

// Other imports remain the same

// Other imports remain the same

class DisplayFormattedOutputNotifierNew extends StatefulWidget {
  const DisplayFormattedOutputNotifierNew({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _DisplayFormattedOutputNotifierNewState createState() =>
      _DisplayFormattedOutputNotifierNewState();
}

class _DisplayFormattedOutputNotifierNewState
    extends State<DisplayFormattedOutputNotifierNew>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _bounceAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: globalDurationTime,
      builder: (BuildContext context, int price, Widget? child) {
        return _buildContent(price);
      },
    );
  }

  Widget _buildContent(int price) {
    String textToShow;
    IconData iconToShow;
    Color containerColor;
    Color textColor;
    Color iconColor;
    double fontSize;
    FontWeight fontWeight;
    MainAxisAlignment mainAxisAlignment;
    String fontFamily;

    if (FFAppState().durationMin == 0) {
      textToShow = 'Odaberi usluge';
      iconToShow = Icons.arrow_upward;
      containerColor = Color(0xFF3B3B3B);
      textColor = Colors.white; // Gold color
      iconColor = Color(0xFFE4C87F);
      fontSize = 14;
      fontWeight = FontWeight.normal;
      mainAxisAlignment = MainAxisAlignment.end;
      fontFamily = 'PT Sans';
    } else {
      textToShow = 'Odaberi termin';
      iconToShow = Icons.lock_clock; // Use your desired icon here
      containerColor = Color(0xFFE4C87F); // Gold color
      textColor = Colors.black;
      iconColor = Colors.black;
      fontSize = 16;
      fontWeight = FontWeight.w600;
      mainAxisAlignment = MainAxisAlignment.center;
      fontFamily = 'PT Sans';
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          color: containerColor,
          padding: EdgeInsets.all(16),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: mainAxisAlignment,
                  children: [
                    if (FFAppState().durationMin == 0)
                      Transform.translate(
                        offset: Offset(0, -_bounceAnimation.value),
                        child: Icon(
                          iconToShow,
                          color: iconColor,
                        ),
                      ),
                    if (FFAppState().durationMin > 0)
                      Icon(
                        iconToShow,
                        color: textColor,
                      ),
                    SizedBox(
                      width: 8,
                    ), // Add more space between the icon and text
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Text(
                        textToShow,
                        style: TextStyle(
                          fontFamily: GoogleFonts.ptSans().fontFamily,
                          color: textColor,
                          fontSize: fontSize,
                          fontWeight: fontWeight,
                        ),
                        textAlign: TextAlign.right,
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
