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

class OrdersWidget extends StatefulWidget {
  final double? width;
  final double? height;

  const OrdersWidget({Key? key, this.width, this.height}) : super(key: key);

  @override
  _OrdersWidgetState createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {
  Future<List<dynamic>>? _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = fetchOrders();
  }

  Future<List<dynamic>> fetchOrders() async {
    final String token = FFAppState().token;
    final String apiUrl = '$domenString/mobile-app/api/v1/user/$token/orders';
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load orders');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _ordersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SpinKitCircle(
              color: Color(0xFFE4C87F),
              size: 50.0,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No orders found.'));
        } else {
          return Container(
            width: widget.width,
            height: widget.height,
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final booking = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF343A40),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking['booking_date'],
                            style: TextStyle(
                              color: Color(0xFFE4C87F),
                              fontSize: 16,
                            ),
                          ),
                          Divider(
                            color: Color(0xFF454D55),
                            thickness: 1,
                            height: 1,
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Narudžba br. ${booking['number']}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24, // 1.75rem in Flutter
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'ID narudžbe: ${booking['order_id']}',
                            style: TextStyle(
                              color: Color(0xFFCCCCCC),
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'ID transakcije: ${booking['payment_transaction_id']}',
                            style: TextStyle(
                              color: Color(0xFFCCCCCC),
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          ...booking['items'].map<Widget>((item) {
                            return Row(
                              children: [
                                Text(
                                  '• ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '${item['name']} ${item['amount'].toStringAsFixed(2)} €',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                          SizedBox(height: 8.0),
                          Text(
                            'Ukupni iznos: ${booking['total_amount'].toStringAsFixed(2)} €',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Način plaćanja: ${booking['card']}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
