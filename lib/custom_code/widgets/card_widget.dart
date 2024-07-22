// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'global.dart';
import '/app_state.dart';
import 'package:google_fonts/google_fonts.dart';

class CardWidget extends StatefulWidget {
  const CardWidget({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  List<Map<String, dynamic>> cards = [];
  Map<String, dynamic>? selectedCard;
  String? cardId;

  @override
  void initState() {
    super.initState();
    _fetchCardsData();
  }

  Future<void> _fetchCardsData() async {
    String userToken = FFAppState().token;
    String date = FFAppState().bookDate;
    final String url2 =
        domenString + '/mobile-app/api/v1/user/$userToken/cards?date=$date';

    try {
      final response = await http.get(
        Uri.parse(url2),
        headers: {},
      );

      if (response.statusCode == 200) {
        List<dynamic> cardDataList = jsonDecode(response.body);
        setState(() {
          cards = cardDataList.map((cardData) {
            return {
              'id': cardData['id'],
              'name': cardData['name'],
              'number': cardData['number'],
              'expiration_date': cardData['expiration_date'],
              'icon': cardData['icon'],
              'isDefault': cardData['default'],
              'enabled': cardData[
                  'enabled'], // Assuming 'enabled' property exists in response
            };
          }).toList();

          // Select the first enabled card initially, or an empty default value if "Dodaj Novu karticu" is the only card
          selectedCard = cards.firstWhere(
            (card) => card['enabled'] && card['id'] != 'add_new',
            orElse: () => {
              'id': 'add_new',
              'name': 'Add New Card',
              'number': '',
              'expiration_date': '',
              'icon': '',
              'isDefault': false,
              'enabled': true,
            },
          );

          // Save the selected card ID at the beginning
          cardId =
              selectedCard!['id'] != 'add_new' ? selectedCard!['id'] : null;
        });
      } else {
        throw Exception('Failed to load cards data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching card data: $e');
      throw e;
    }
  }

  void _handleCardSelection(Map<String, dynamic> card) {
    setState(() {
      selectedCard = card;
    });

    if (card['id'] == 'add_new') {
      // Handle the "Add New Card" action here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Color(0xFF343A40), // Blue container
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: Colors.transparent, width: 2.0),
        ),
        width: widget.width,
        height: widget.height,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                'Upravljanje karticama',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: GoogleFonts.ptSans().fontFamily,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        children: [
                          ...cards.map((card) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 30.0),
                              decoration: BoxDecoration(
                                color: selectedCard != null &&
                                        selectedCard!['id'] == card['id']
                                    ? Color(0xFFE4C87F)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  color: Color(0xFF454d55),
                                ),
                              ),
                              child: InkWell(
                                onTap: card['id'] == 'add_new'
                                    ? () => _handleCardSelection(card)
                                    : null, // Only allow tapping "Add New Card"
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  child: Row(
                                    children: [
                                      if (card['icon'] != '')
                                        Image.network(
                                          card['icon'],
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            print(error); // Log the error
                                            return const Icon(Icons
                                                .error); // Show an error icon
                                          },
                                        ),
                                      const SizedBox(width: 10),
                                      Text(
                                        card['name'],
                                        style: TextStyle(
                                          color: selectedCard != null &&
                                                  selectedCard!['id'] ==
                                                      card['id']
                                              ? Colors.black
                                              : Colors.white,
                                          fontSize: 16,
                                          fontFamily:
                                              GoogleFonts.ptSans().fontFamily,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        card['number'],
                                        style: TextStyle(
                                          color: selectedCard != null &&
                                                  selectedCard!['id'] ==
                                                      card['id']
                                              ? Colors.black
                                              : Colors.white,
                                          fontSize: 16,
                                          fontFamily:
                                              GoogleFonts.ptSans().fontFamily,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        card['expiration_date'],
                                        style: TextStyle(
                                          color: selectedCard != null &&
                                                  selectedCard!['id'] ==
                                                      card['id']
                                              ? Color(0xFF6c757d)
                                              : Color(0xFF6c757d),
                                          fontSize: 16,
                                          fontFamily:
                                              GoogleFonts.ptSans().fontFamily,
                                        ),
                                      ),
                                      Spacer(),
                                      if (selectedCard != null &&
                                          selectedCard!['id'] == card['id'])
                                        Icon(
                                          card['id'] == 'add_new'
                                              ? Icons.add
                                              : Icons.check,
                                          color: Colors.black,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          Container(
                            margin: EdgeInsets.only(bottom: 30.0),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: Color(0xFF454d55),
                              ),
                            ),
                            child: InkWell(
                              onTap: () =>
                                  _handleCardSelection({'id': 'add_new'}),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                child: Row(
                                  children: [
                                    Text(
                                      'Dodaj novu karticu',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily:
                                            GoogleFonts.ptSans().fontFamily,
                                      ),
                                    ),
                                    Spacer(),
                                    if (selectedCard != null &&
                                        selectedCard!['id'] == 'add_new')
                                      Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
