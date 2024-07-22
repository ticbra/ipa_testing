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
import 'dart:convert';
import 'global.dart';
import 'package:http/http.dart' as http;
import '/app_state.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class EmployeeWidget extends StatefulWidget {
  const EmployeeWidget({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _EmployeeWidgetState createState() => _EmployeeWidgetState();
}

class _EmployeeWidgetState extends State<EmployeeWidget>
    with WidgetsBindingObserver {
  int? selectedEmployeeId;
  List<Map<String, dynamic>> employees = [];
  bool atStart = true;
  bool atEnd = false;
  String imgUrl = '';
  String price = '';
  bool isSelected = false;
  String urlData = '';
  bool shouldUpdateCount = false;

  Map<int, bool> selectedEmployees = {};

  Future<List<Map<String, dynamic>>> fetchJsonDataNew(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['availability']['employees']);
    } else {
      throw Exception('Failed to load data');
    }
  }

  String extractTimeFromUrl(String url) {
    Uri uri = Uri.parse(url);
    return uri.queryParameters['time'] ?? '';
  }

  int extractEmployeeFromUrl(String url) {
    Uri uri = Uri.parse(url);
    String employeeStr = uri.queryParameters['employee'] ?? '';
    return int.tryParse(employeeStr) ?? 0; // Vraća 0 ako konverzija ne uspije
  }

  String convertToOkUrl(String url) {
    // Split the URL into base and query parts
    List<String> parts = url.split('?');
    if (parts.length != 2) {
      // If there is no query part, return the original URL
      return url;
    }

    String baseUrl = parts[0];
    String queryPart = parts[1];

    // Split the query part into individual parameters
    List<String> params = queryPart.split('&');

    // Ensure there is only one '?' in the final URL
    return '$baseUrl?${params.join('&')}';
  }

  void updateGlobalUrlWithEmployeeId(int? employeeId) async {
    String userToken = FFAppState().token;

    // Build the query parameters
    Map<String, String> queryParameters = {
      if (employeeId != null && employeeId != 0)
        'employee': employeeId.toString(),
      'lang': 'hr',
    };
    _initializeAndSyncServices();
    print("employee" + FFAppState().bookServices);

    // Parse the services string into a list of services
    final servicesList = FFAppState()
        .bookServices
        .split(RegExp(r'[\n,]'))
        .where((service) => service.trim().isNotEmpty)
        .toList();

    // Add services to queryParameters
    for (int i = 0; i < servicesList.length; i++) {
      queryParameters['services[$i]'] = servicesList[i];
    }

    // Extract and add the time parameter from the global URL
    String time = extractTimeFromUrl(globalUrl.value);
    if (time.isNotEmpty) {
      queryParameters['time'] = time;
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

    // Fetch the first available appointment date
    String firstDayCalendar = FFAppState().bookDate;

    // Update the global URL with the first day calendar
    updateGlobalUrlWithFirstDayCalendar(firstDayCalendar);
  }

  void updateGlobalUrlWithFirstDayCalendar(String firstDayCalendar) async {
    // Check if the global URL already contains the firstDayCalendar

    // Extract the existing query parameters from the global URL
    final uri = Uri.parse(globalUrl.value);
    final Map<String, String> queryParameters = Map.from(uri.queryParameters);

    // Parse the services string into a list of services
    final servicesList = FFAppState()
        .bookServices
        .split(RegExp(r'[\n,]'))
        .where((service) => service.trim().isNotEmpty)
        .toList();

    // Add services to queryParameters
    for (int i = 0; i < servicesList.length; i++) {
      queryParameters['services[$i]'] = servicesList[i];
    }

    // Add the firstDayCalendar to queryParameters
    queryParameters['date'] = firstDayCalendar;

    // Build the final URI with all query parameters
    final updatedUri = uri.replace(queryParameters: queryParameters);

    // Update the globalUrl with the complete URI
    globalUrl.value = updatedUri.toString();

    // Fetch new employees data
    employees = await fetchJsonDataNew(globalUrl.value);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Add the observer
    _initWidget();
  }

  void _initWidget() {
    int initialSelectedEmployeeId = FFAppState().bookEmployee;
    if (initialSelectedEmployeeId != 0) {
      selectedEmployees[initialSelectedEmployeeId] = true;
    }
    fetchAndUpdateEmployees();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // This block will execute when your widget comes back into view
      // However, it's triggered by app-wide state changes, not navigation events
      _initWidget();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove the observer
    super.dispose();
  }

  Future<void> _sendBookingsData(String bookings) async {
    final base_url = domenString + '/mobile-app/api/v1/user/availability';

    // Parse the bookings data
    final bookingLines = bookings.split('\n');
    String user_token = FFAppState().token;
    Map<String, String> queryParameters = {};
    String newDefinition;
    String newDate;
    String newTime;
    // Parse the other booking data
    for (var line in bookingLines) {
      final parts = line.split(': ');
      if (parts.length == 2 && parts[0] != 'services[]') {
        queryParameters[parts[0]] = parts[1];
      }
    }

    // Create the URI with the query parameters
    final uri = Uri(
      scheme: 'https',
      host: hostString,
      path: '/mobile-app/api/v1/user/$user_token/availability',
      queryParameters: queryParameters,
    );

    if (FFAppState().bookDate.isNotEmpty) {
      newDate = FFAppState().bookDate;
    } else {
      newDate = FFAppState().firstDayCalendar;
    }

    if (!queryParameters.containsKey('date')) {
      queryParameters['date'] = newDate; // Add the date to query parameters
    }

    newTime = FFAppState().bookTime;
    if (FFAppState().bookDate.isNotEmpty) {
      if (!queryParameters.containsKey('time')) {
        queryParameters['time'] = newTime; // Add the date to query parameters
      }
    }

    // Add the services[] query parameters
    StringBuffer uriWithServices = StringBuffer(uri.toString());
    if (FFAppState().bookServices != null &&
        FFAppState().bookServices.isNotEmpty) {
      List<String> servicesList = FFAppState()
          .bookServices
          .trim()
          .split(RegExp(r'[\n,]'))
          .where((s) => s.isNotEmpty)
          .toList();

      for (String service in servicesList) {
        uriWithServices.write('&services%5B%5D=$service');
      }
    }
    uriWithServices.write('&lang=hr'); // Add the lang parameter
    uriWithServices.write(
        '&date=${Uri.encodeComponent(newDate)}'); // Add the date parameter

    uriWithServices.write(
        '&time=${Uri.encodeComponent(newTime)}'); // Add the date parameter
    String employee = FFAppState().bookEmployee.toString();

    if (FFAppState().bookEmployee != 0) {
      uriWithServices.write('&employee=${Uri.encodeComponent(employee)}');
    }
    final response = await http.get(
      Uri.parse(uriWithServices.toString()),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      // Extract the 'services' list from the 'booking' key
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

      if (FFAppState().bookEmployee == 0 && priceEur == priceTo) {
        newDefinition = 'Trajanje: $duration min\nCijena: $priceEur €';
      } else if (FFAppState().bookEmployee == 0 && priceEur != priceTo) {
        newDefinition =
            'Trajanje: $duration min\nCijena: $priceEur € - $priceTo €';
      } else {
        // Format when an employee is selected
        newDefinition = 'Trajanje: $duration min\nCijena: $totalPrice €';
      }

      globalUrl.value = uriWithServices.toString();

      globalDurationTime.value = bookingDataMap['duration'];
      globalOutputNotifier.value = newDefinition;
      print("Employee" + globalOutputNotifier.value);
    }
  }

  void fetchAndUpdateEmployees() async {
    Uri url = Uri.parse(globalUrl.value);
    List<Map<String, dynamic>> newEmployees =
        await fetchJsonDataNew(globalUrl.value);
    employees = newEmployees;
    setState(() {});
  }

  void toggleEmployeeSelection(int employeeId) {
    bool isCurrentlySelected = selectedEmployees[employeeId] ?? false;

    // Clear all previous selections
    selectedEmployees.clear();

    // Toggle the selection
    if (!isCurrentlySelected) {
      // Select the new employee
      selectedEmployees[employeeId] = true;
    } else {
      // If the employee was already selected, this will deselect them
      // (selectedEmployees map is already cleared)
    }
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

  void _initializeAndSyncServices() {
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

    print("Extracted services: " + FFAppState().bookServices);

    // Split the bookServices to ensure no extra spaces or new lines
    final servicesList = FFAppState()
        .bookServices
        .split(RegExp(r'[\n,]'))
        .where((service) => service.trim().isNotEmpty)
        .toList();

    // Update the bookServices with the filtered list
    FFAppState().bookServices = servicesList.join(',');

    print("Filtered services: " + FFAppState().bookServices);
  }

  void updateGlobalUrlRemovingEmployee() {
    String url = globalUrl.value;

    // Pattern to match the 'employee' parameter and its value
    RegExp employeePattern = RegExp(r'([&?])employee=\d*');

    // Check if the URL contains the 'employee' parameter
    if (employeePattern.hasMatch(url)) {
      // Remove the 'employee' parameter
      url = url.replaceAll(employeePattern, '');

      // Handle potential leading '&' if 'employee' was not the first parameter
      url = url.replaceFirst('&', '?', url.indexOf('?') + 1);

      // Remove any potential trailing '?' or '&'
      if (url.endsWith('?') || url.endsWith('&')) {
        url = url.substring(0, url.length - 1);
      }

      // Update the global URL
      globalUrl.value = url;
    }
  }

  @override
  Widget build(BuildContext context) {
    int initialSelectedEmployeeId = FFAppState().bookEmployee;
    if (initialSelectedEmployeeId != 0) {
      selectedEmployees[initialSelectedEmployeeId] = true;
    }
    return ValueListenableBuilder<String>(
      valueListenable: globalUrl, // Assuming you have globalUrl defined.
      builder: (BuildContext context, String url, Widget? child) {
        //countAvailableEmployees(); // Call the function

        return FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchJsonDataNew(
              url), // Pass the globalUrl value as the parameter.
          builder: (BuildContext context,
              AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
            // Data has been fetched successfully.
            List<Map<String, dynamic>> employees =
                snapshot.data?.toList() ?? [];

            return Scaffold(
              backgroundColor: const Color(0xFF212529),
              body: Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: employees.map((Map<String, dynamic> employee) {
                      Color rankColor;
                      int rank = employee['rank_id'];
                      String rankName = employee['rank_name'] ?? '';
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

                      isSelected = employee['selected'];

                      imgUrl = (employee['img'] ?? '');
                      price = employee['total_price'] != null &&
                              employee['total_price'] > 0.0
                          ? '${(employee['total_price']).toStringAsFixed(2)} €'
                          : '';

                      return Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            // Check if the employee is not disabled before handling the tap
                            if (!(employee['disabled'] ?? false)) {
                              _handleEmployeeChange(employee['id']);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5), // Horizontal spacing
                            child: Opacity(
                              opacity: employee['disabled'] ? 0.5 : 1.0,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Container(
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
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            print(error); // Log the error
                                            return const Icon(Icons
                                                .error); // Show an error icon
                                          },
                                        ),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                          padding:
                                              const EdgeInsets.only(top: 2.0),
                                          child: Text(
                                            rankName.toUpperCase(),
                                            style: TextStyle(
                                              fontFamily: GoogleFonts.ptSans()
                                                  .fontFamily,
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
                                    visible: price.isNotEmpty &&
                                        !employee['disabled'],
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
                                              fontFamily: GoogleFonts.ptSans()
                                                  .fontFamily,
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
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
