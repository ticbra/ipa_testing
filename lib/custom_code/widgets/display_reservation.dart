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

class DisplayReservation extends StatefulWidget {
  const DisplayReservation({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _DisplayReservationState createState() => _DisplayReservationState();
}

class _DisplayReservationState extends State<DisplayReservation>
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
    return ValueListenableBuilder<String>(
      valueListenable: globalUrl,
      builder: (BuildContext context, String url, Widget? child) {
        return ValueListenableBuilder<int>(
          valueListenable: globalDurationTime,
          builder: (BuildContext context, int price, Widget? child) {
            return _buildContent(price);
          },
        );
      },
    );
  }

  String extractTimeFromUrl(String url) {
    // Parse the URL
    Uri uri = Uri.parse(url);

    // Extract the 'time' query parameter
    String? time = uri.queryParameters['time'];

    // Update bookTime only if it's not empty and time is not null
    if (FFAppState().bookTime.isNotEmpty && time != null) {
      FFAppState().bookTime = time;
    }

    // Return the value of time or '1' if time is null
    return time ?? '';
  }

  String extractEmployeeFromUrl(String url) {
    Uri uri = Uri.parse(url);
    return uri.queryParameters['employee'] ?? '';
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

    if (FFAppState().bookTime == "" || FFAppState().notReservation) {
      textToShow = 'Odaberi termin';
      FFAppState().boolTime = true;
      FFAppState().boolReservation = false;
      iconToShow = Icons.arrow_upward;
      containerColor = Color(0xFF3B3B3B);
      textColor = Colors.white; // Gold color
      iconColor = Color(0xFFE4C87F);
      fontSize = 14;
      fontWeight = FontWeight.normal;
      mainAxisAlignment = MainAxisAlignment.end;
      fontFamily = 'PT Sans';
    } else if (FFAppState().bookTime != "" &&
        FFAppState().countAvailableEmployees > 1 &&
        extractEmployeeFromUrl(globalUrl.value).isEmpty) {
      textToShow = 'Odaberi djelatnika';
      FFAppState().boolCount = true;
      FFAppState().boolReservation = false;
      iconToShow = Icons.arrow_upward;
      containerColor = Color(0xFF3B3B3B);
      textColor = Colors.white; // Gold color
      iconColor = Color(0xFFE4C87F);
      fontSize = 14;
      fontWeight = FontWeight.normal;
      mainAxisAlignment = MainAxisAlignment.end;
      fontFamily = 'PT Sans';
    } else if (extractTimeFromUrl(globalUrl.value).isEmpty &&
        FFAppState().countAvailableEmployees > 1 &&
        FFAppState().isDisabledEmployee) {
      textToShow = 'Odaberi djelatnika';
      FFAppState().boolCount = true;
      FFAppState().boolReservation = false;
      iconToShow = Icons.arrow_upward;
      containerColor = Color(0xFF3B3B3B);
      textColor = Colors.white; // Gold color
      iconColor = Color(0xFFE4C87F);
      fontSize = 14;
      fontWeight = FontWeight.normal;
      mainAxisAlignment = MainAxisAlignment.end;
      fontFamily = 'PT Sans';
    } else if (FFAppState().notReservation) {
      textToShow = '';
      FFAppState().boolTime = true;
      FFAppState().boolReservation = false;
      iconToShow = Icons.arrow_upward;
      containerColor = Color(0xFF3B3B3B);
      textColor = Colors.white; // Gold color
      iconColor = Colors.transparent;
      fontSize = 14;
      fontWeight = FontWeight.normal;
      mainAxisAlignment = MainAxisAlignment.end;
      fontFamily = 'PT Sans';
    } else {
      textToShow = 'Rezerviraj';
      iconToShow = Icons.calendar_today; // Use your desired icon here
      containerColor = Color(0xFFE4C87F); // Gold color
      textColor = Colors.black;
      FFAppState().boolReservation = true;
      FFAppState().boolCount = false;
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
                    Icon(
                      iconToShow,
                      color: iconColor,
                    ),
                    SizedBox(width: 8), // Space between icon and text
                    Text(
                      textToShow,
                      style: TextStyle(
                        color: textColor,
                        fontSize: fontSize,
                        fontWeight: fontWeight,
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
