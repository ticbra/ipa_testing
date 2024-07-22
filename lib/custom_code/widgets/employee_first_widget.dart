// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '/app_state.dart';
import 'global.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class EmployeeFirstWidget extends StatefulWidget {
  const EmployeeFirstWidget({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _EmployeeFirstWidgetState createState() => _EmployeeFirstWidgetState();
}

class _EmployeeFirstWidgetState extends State<EmployeeFirstWidget>
    with WidgetsBindingObserver {
  int? selectedEmployeeId;
  List<Map<String, dynamic>> employees = [];
  String imgUrl = '';
  String price = '';
  bool isSelected = false;
  String newDefinition = '';
  bool emptyPrice = false;

  Future<List<Map<String, dynamic>>> fetchJsonData(String url) async {
    print("Employee first  " + globalUrl.value);
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Decode the JSON response body into a map
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      // Process the response and update the state
      processResponseAndUpdateState(jsonResponse);

      // Continue to return the list of employees as originally intended
      return List<Map<String, dynamic>>.from(
          jsonResponse['availability']['employees']);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _initWidget();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _initWidget();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  void _initWidget() {
    String userToken = FFAppState().token;
    if (globalUrl.value.isEmpty || FFAppState().bookEmployee == 0) {
      globalUrl.value =
          domenString + '/mobile-app/api/v1/user/$userToken/availability';

      newDefinition = 'Trajanje: 0 min\nCijena: 0,00 €';
      FFAppState().bookDate = '';
      FFAppState().bookTime = '';
      FFAppState().durationMin = 0;
    }

    fetchAndUpdateEmployees();
  }

  void fetchAndUpdateEmployees() async {
    employees = await fetchJsonData(globalUrl.value);
  }

  Future<String> fetchFirstAvailableAppointment() async {
    final response = await http.get(Uri.parse(globalUrl.value));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      String firstAvailableAppointment = data['first_available_appointment'];

      return firstAvailableAppointment;
    } else {
      throw Exception('Failed to load data');
    }
  }

  int extractEmployeeFromUrl(String url) {
    Uri uri = Uri.parse(url);
    String employeeStr = uri.queryParameters['employee'] ?? '';
    return int.tryParse(employeeStr) ?? 0; // Vraća 0 ako konverzija ne uspije
  }

  String extractTimeFromUrl(String url) {
    Uri uri = Uri.parse(url);
    return uri.queryParameters['time'] ?? '';
  }

  String convertToOkUrl(String url) {
    // Split the URL into base and query parts
    int index = url.indexOf('?');
    if (index == -1) {
      // If there is no query part, return the original URL
      return url;
    }

    String baseUrl = url.substring(0, index);
    String queryPart = url.substring(index + 1);

    // Split the query part into individual parameters, taking care of multiple ?
    List<String> params = queryPart.split('&');
    List<String> cleanedParams = [];

    for (var param in params) {
      if (param.contains('?')) {
        cleanedParams.addAll(param.split('?'));
      } else {
        cleanedParams.add(param);
      }
    }

    // Ensure there is only one '?' in the final URL
    return '$baseUrl?${cleanedParams.join('&')}';
  }

  void _initializeAndSyncServices() {
    print("Prije " + globalUrl.value);
    String okUrl = convertToOkUrl(globalUrl.value);
    final Uri uri = Uri.parse(okUrl);
    print("Global URL: " + okUrl);

    // Extract services from query parameters
    final List<String> servicesFromUrl = [];
    uri.queryParameters.forEach((key, value) {
      if (key.startsWith('services[')) {
        servicesFromUrl.add(value);
      }
    });

    // Initialize bookServices with services from URL
    FFAppState().bookServices = servicesFromUrl.join(',');

    print("Servisi " + FFAppState().bookServices.toString());

    if (uri.queryParameters.containsKey('date')) {
      if (!FFAppState().boolSyncDate) {
        FFAppState().bookDate = '';
      } else {
        FFAppState().bookDate = uri.queryParameters['date']!;
      }
    }

    // final String? employeeFromUrl = uri.queryParameters['employee'];
    // if (employeeFromUrl != null && employeeFromUrl.isNotEmpty) {
    //   FFAppState().bookEmployee = int.tryParse(employeeFromUrl) ?? 0;
    // } else {
    //   FFAppState().bookEmployee = 0;
    // }
  }

  Future<void> updateGlobalUrlWithEmployeeId(int? employeeId) async {
    final userToken = FFAppState().token;

    // Build the query parameters
    Map<String, String> queryParameters = {
      'lang': 'hr',
      if (employeeId != null && employeeId != 0)
        'employee': employeeId.toString(),
    };

    _initializeAndSyncServices();

    // Extract the services from bookServices
    final servicesList = FFAppState()
        .bookServices
        .split(RegExp(r'[\n,]'))
        .where((service) => service.trim().isNotEmpty)
        .toList();

    print("Lista servisa " + servicesList.toString());

    // Add services to query parameters
    for (int i = 0; i < servicesList.length; i++) {
      queryParameters['services[$i]'] = servicesList[i];
    }
    if (FFAppState().bookTime.isNotEmpty &&
        FFAppState().bookTime.trim() != '') {
      queryParameters['time'] = FFAppState().bookTime;
    }
    // Build the final URI with all query parameters
    final uri = Uri(
      scheme: 'https',
      host: hostString,
      path: '/mobile-app/api/v1/user/$userToken/availability',
      queryParameters: queryParameters,
    );

    // Update the globalUrl with the complete URI
    globalUrl.value = uri.toString();
    print(globalUrl.value);
    print("Datum  " + FFAppState().bookDate);

    // Fetch the first available appointment date
    String firstDayCalendar;

    if (FFAppState().bookDate.isEmpty) {
      firstDayCalendar = await fetchFirstAvailableAppointment();
    } else {
      firstDayCalendar = FFAppState().bookDate;
    }

    // Update the global URL with the first day calendar
    await updateGlobalUrlWithFirstDayCalendar(
        firstDayCalendar, queryParameters);
  }

  Future<void> updateGlobalUrlWithFirstDayCalendar(
      String firstDayCalendar, Map<String, String> queryParameters) async {
    queryParameters['date'] = firstDayCalendar;

    final uri = Uri(
      scheme: 'https',
      host: hostString,
      path: '/mobile-app/api/v1/user/${FFAppState().token}/availability',
      queryParameters: queryParameters,
    );

    globalUrl.value = uri.toString();
    print("Time " + globalUrl.value);
  }

  void processResponseAndUpdateState(Map<String, dynamic> jsonResponse) {
    Map<String, dynamic> bookingDataMap = jsonResponse['booking'];

    double? priceToEur;
    double? totalPriceEur;
    var price = bookingDataMap['total_price_from'];
    FFAppState().priceEur = price is int ? price.toDouble() : price;
    var pricetoEurNew = bookingDataMap['total_price_to'];
    priceToEur =
        pricetoEurNew is int ? pricetoEurNew.toDouble() : pricetoEurNew;

    var totalPriceEurNew = bookingDataMap['total_price'];
    totalPriceEur = totalPriceEurNew is int
        ? totalPriceEurNew.toDouble()
        : totalPriceEurNew;

    String duration = FFAppState().durationMin != null
        ? FFAppState().durationMin.toString()
        : '0';
    FFAppState().priceToEur = priceToEur ?? 0.0;
    FFAppState().totalPriceEur = totalPriceEur ?? 0.0;
    String priceEur = FFAppState().priceEur != null
        ? FFAppState().priceEur.toStringAsFixed(2)
        : '0.00';

    String priceTo =
        priceToEur != null ? priceToEur.toStringAsFixed(2) : '0.00';

    String totalPrice =
        totalPriceEur != null ? totalPriceEur.toStringAsFixed(2) : '0.00';
    String userToken = FFAppState().token;
    if (FFAppState().bookEmployee <= 0 && priceEur == priceTo) {
      newDefinition = 'Trajanje: $duration min\nCijena: $priceEur €';
    } else if (FFAppState().bookEmployee <= 0 && priceEur != priceTo) {
      newDefinition =
          'Trajanje: $duration min\nCijena: $priceEur € - $priceTo €';
    } else {
      newDefinition = 'Trajanje: $duration min\nCijena: $totalPrice €';
    }
    globalOutputNotifier.value = newDefinition;
    print("First employee widget " + globalOutputNotifier.value);
  }

  void _handleEmployeeChange(int employeeId) {
    setState(() {
      FFAppState().bookEmployee = extractEmployeeFromUrl(globalUrl.value);
      selectedEmployeeId = FFAppState().bookEmployee;
      if (selectedEmployeeId == employeeId) {
        selectedEmployeeId = null;
        FFAppState().bookEmployee = 0;
        updateGlobalUrlRemovingEmployee();
        updateGlobalUrlWithEmployeeId(null);
      } else {
        selectedEmployeeId = employeeId;
        FFAppState().bookEmployee = employeeId;
        FFAppState().bookings += employeeId.toString();
        updateGlobalUrlWithEmployeeId(employeeId);
      }
    });
  }

  void updateGlobalUrlRemovingEmployee() {
    String url = globalUrl.value;
    RegExp employeePattern = RegExp(r'([&?])employee=\d*');
    if (employeePattern.hasMatch(url)) {
      url = url.replaceAll(employeePattern, '');
      url = url.replaceFirst('&', '?', url.indexOf('?') + 1);
      if (url.endsWith('?') || url.endsWith('&')) {
        url = url.substring(0, url.length - 1);
      }
      globalUrl.value = url;
      print("Removed Global Url " + globalUrl.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: globalUrl,
      builder: (BuildContext context, String url, Widget? child) {
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchJsonData(url),
          builder: (BuildContext context,
              AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
            List<Map<String, dynamic>> employees = snapshot.data ?? [];
            return Scaffold(
              backgroundColor: const Color(0xFF212529),
              body: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: employees.map((Map<String, dynamic> employee) {
                    Color rankColor;
                    int rank = employee['rank_id'];
                    String rankName = employee['rank_name'] ?? '';
                    if (FFAppState().bookEmployee == 0) {
                      isSelected = false;
                    } else {
                      isSelected = employee['selected'];
                    }
                    switch (rank) {
                      case 1:
                        rankColor = const Color(0xFFE4C87F);
                        break;
                      case 2:
                        rankColor = const Color(0xFFC0C0C0);
                        break;
                      case 3:
                        rankColor = Colors.white;
                        break;
                      default:
                        rankColor = Colors.transparent;
                    }
                    imgUrl = (employee['img'] ?? '');
                    price = employee['total_price'] != null &&
                            employee['total_price'] > 0.0
                        ? '${(employee['total_price']).toStringAsFixed(2)} €'
                        : '';
                    emptyPrice = price.isNotEmpty && employee['available'];
                    return GestureDetector(
                      onTap: employee['available']
                          ? () => _handleEmployeeChange(employee['id'])
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5), // Horizontal spacing
                        child: Opacity(
                          opacity: employee['available'] ? 1.0 : 0.5,
                          child: Column(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: rankColor,
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFFE4C87F)
                                        : Colors.black,
                                    width: 3.0,
                                  ),
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    imgUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      print(error);
                                      return const Icon(Icons.error);
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFFE4C87F)
                                      : Colors.black,
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFFE4C87F)
                                        : Colors.black,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${employee['name'] ?? ''}',
                                      style: TextStyle(
                                        fontFamily:
                                            GoogleFonts.ptSans().fontFamily,
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: isSelected
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                      softWrap: true,
                                      maxLines: 2,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2.0),
                                      child: Text(
                                        rankName.toUpperCase(),
                                        style: TextStyle(
                                          fontFamily:
                                              GoogleFonts.ptSans().fontFamily,
                                          fontSize: 10,
                                          height: 1,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                              Visibility(
                                visible: emptyPrice,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFFE4C87F)
                                        : Colors.transparent,
                                    border: isSelected
                                        ? Border.all(
                                            color: const Color(0xFFE4C87F),
                                            width: 1,
                                          )
                                        : null,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        price,
                                        style: TextStyle(
                                          fontFamily:
                                              GoogleFonts.ptSans().fontFamily,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: isSelected
                                              ? Colors.black
                                              : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
