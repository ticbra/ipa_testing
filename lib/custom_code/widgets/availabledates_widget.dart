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

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'global.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:gentlemens_shop/components/urgent_term_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.all(16.0),
            child: AvailabledatesWidget(),
          ),
        ),
      ),
    );
  }
}

class AvailabledatesWidget extends StatefulWidget {
  const AvailabledatesWidget({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _AvailabledatesWidgetState createState() => _AvailabledatesWidgetState();
  static int numberOfSelectedButtons = 0;
}

class _AvailabledatesWidgetState extends State<AvailabledatesWidget>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  String? previousValue;
  String? selectedButton;
  ValueNotifier<Map<String, bool>> selectedButtons =
      ValueNotifier<Map<String, bool>>({});
  String? previousGlobalUrlValue;
  bool initialDataLoaded = false;
  DateTime? previousDate;
  String? previousEmployeeId;
  String _previousGlobalUrl = "";
  get availableSlots => null;
  String bookTime = "";

  @override
  void initState() {
    super.initState();
    fetchInitialData();
    _triggerContainerTap();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController?.dispose(); // Dispose the AnimationController
    super.dispose();
  }

  void fetchInitialData() async {
    try {
      if (FFAppState().bookTime == Null || FFAppState().bookTime.isEmpty) {
        print("EEEEEEEEEEEEEEEEEEEEEEEEE");
        FFAppState().bookTime = '';
      }
      await fetchJsonData();
      setState(() {
        initialDataLoaded = true;
      });
    } catch (error) {
      print('Failed to fetch initial data: $error');
    }
  }

  void visibleButtons() {
    if (FFAppState().bookEmployee > 0 && FFAppState().intButtonsCount > 0) {
      FFAppState().boolDisabled = true;
    } else {
      FFAppState().boolDisabled = false;
    }
  }

  Future<Map<String, dynamic>> fetchJsonData() async {
    print("Fetch Json data in Available dates Widget " + globalUrl.value);
    final response = await http.get(Uri.parse(globalUrl.value));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  List<List<Map<String, String>>> extractTimeTo(Map<String, dynamic> data) {
    Map<String, List<Map<String, String>>> timeCategories = {};

    // Loop over each category (e.g., "Jutro", "Popodne", "Večer")
    for (var categoryData in data['availability']['times']) {
      String category = categoryData['title'];

      // Check if the category already exists, if not initialize it
      if (!timeCategories.containsKey(category)) {
        timeCategories[category] = [];
      }

      // Loop over each term in the category
      for (var term in categoryData['terms']) {
        timeCategories[category]?.add({
          'time': term['time'].toString(),
          'time_to': term['time_to'].toString(),
          'disabled': term['disabled'].toString(),
        });
      }
    }

    // Convert the map into a list of lists
    List<List<Map<String, String>>> resultList = timeCategories.values.toList();

    return resultList;
  }

  Future<String> fetchFirstAvailableAppointment() async {
    final response = await http.get(Uri.parse(globalUrl.value));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      String firstAvailableAppointment = data['first_available_appointment'];

      // Parse the date string into a DateTime object
      DateTime parsedDate = DateTime.parse(firstAvailableAppointment);

      // Format the DateTime object into a string with the format dd.mm.yyyy
      String formattedDate = DateFormat('dd.MM.yyyy').format(parsedDate);

      return formattedDate;
    } else {
      throw Exception('Failed to load data');
    }
  }

  void updateBookingTime(String time) {
    // Update the FFAppState with the new booking time
    FFAppState().bookTime = time;

    // Parse the globalUrl to extract its components
    Uri url = Uri.parse(globalUrl.value);

    // Extracting all query parameters, including handling multiple values for the same name
    Map<String, List<String>> queryParams = Map.from(url.queryParametersAll);

    // Update the 'time' query parameter directly
    queryParams['time'] = [time]; // Replace with the new time

    // Manually rebuild the query string to maintain 'services[]' and other parameters
    var queryString = queryParams.entries.expand((entry) {
      // For parameters that can have multiple values, like 'services[]'
      return entry.value.map((value) =>
          '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(value)}');
    }).join('&');

    // Reconstruct the URL with the updated query string
    String updatedUrl = Uri(
      scheme: url.scheme,
      userInfo: url.userInfo,
      host: url.host,
      port: url.port,
      path: url.path,
      query: queryString, // Use the manually constructed query string
    ).toString();

    // Update the globalUrl
    globalUrl.value = updatedUrl;
  }

  void _triggerContainerTap() {
    Future.delayed(Duration(seconds: 0), () {
      final gestureDetector =
          context.findAncestorWidgetOfExactType<GestureDetector>();
      gestureDetector?.onTap?.call();
    });
  }

  Future<int> countAvailableEmployees() async {
    try {
      final response = await http.get(Uri.parse(globalUrl.value));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        var employees = data['availability']['employees'] as List;

        var anySelected = employees.any((e) => e['selected'] == true);

        var availableEmployees =
            employees.where((e) => e['disabled'] == false).toList();

        return availableEmployees.length;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      return 0;
    }
  }

  List<String> extractTimeCategories(Map<String, dynamic> data) {
    List<String> timeCategories = [];

    // Loop over each category (e.g., "Jutro", "Popodne", "Večer")
    for (var categoryData in data['availability']['times']) {
      String category = categoryData['title'];
      timeCategories.add(category);
    }

    return timeCategories;
  }

  String extractBarberName(Map<String, dynamic> data) {
    if (data.containsKey('booking') && data['booking'] != null) {
      return data['booking']['employee_name'] ?? 'Nepoznato';
    }

    return 'Nepoznato';
  }

  String extractEmployyeText(Map<String, dynamic> data) {
    if (data.containsKey('booking') && data['booking'] != null) {
      return data['unavailable_employee_text'] ?? 'Nepoznato';
    }

    return 'Nepoznato';
  }

  int countAvailableTimes(List<List<Map<String, String>>> timeGroups) {
    int availableCount = 0;

    for (var group in timeGroups) {
      for (var timeSlot in group) {
        if (timeSlot['disabled'] != 'true') {
          availableCount++;
        }
      }
    }

    return availableCount;
  }

  String removeTimeFromUrl(String url) {
    // Parsing the URL
    Uri uri = Uri.parse(url);

    // Extracting the query parameters, including duplicates
    Map<String, List<String>> allQueryParameters = uri.queryParametersAll;

    // Initialize a list to hold individual query parameter strings
    List<String> queryParamStrings = [];

    // Handle multiple services by creating individual query parameter strings
    if (allQueryParameters.containsKey('services[]')) {
      allQueryParameters['services[]']!.forEach((service) {
        queryParamStrings
            .add('services%5B%5D=${Uri.encodeComponent(service.trim())}');
      });
    }

    // Add other query parameters if present, excluding 'time'
    allQueryParameters.forEach((key, value) {
      if (key != 'time') {
        value.forEach(
            (v) => queryParamStrings.add('$key=${Uri.encodeComponent(v)}'));
      }
    });

    // Construct the new URL without the 'time' parameter
    String queryString = queryParamStrings.join('&');
    String updatedUrl = '${uri.scheme}://${uri.host}${uri.path}?${queryString}';
    globalUrl.value = updatedUrl;
    return updatedUrl;
  }

  bool hasSelectedTime(
      List<List<Map<String, String>>> timeGroups, String selectedTime) {
    for (var group in timeGroups) {
      for (var timeSlot in group) {
        if (timeSlot['time'] == selectedTime &&
            timeSlot['disabled'] != 'true') {
          return true;
        }
      }
    }
    return false;
  }

  String fixUrlFormat(String globalUrl) {
    // Prvo parsiraj URL da bi se identifikovale komponente
    Uri uri = Uri.parse(globalUrl);

    // Ekstrahuj sve komponente URL-a
    String scheme = uri.scheme;
    String host = uri.host;
    String path = uri.path;
    String query = uri.query;

    // Pronađi i ispravi problematične delove u query parametrima
    // Na primer, zameni dvostruke '?' sa '&' i '%3D' sa '='
    query = query.replaceAll('%3F', '&').replaceAll('%3D', '=');

    // Ponovo parsiraj query parametre nakon ispravke
    Map<String, String> fixedQueryParams = Uri.splitQueryString(query);

    // Ponovo izgradi URI sa ispravljenim query parametrima
    Uri fixedUri = Uri(
      scheme: scheme,
      host: host,
      path: path,
      queryParameters: fixedQueryParams,
    );

    return fixedUri.toString();
  }

  void updateGlobalUrlRemovingEmployee() async {
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

      if (FFAppState().countAvailableEmployees == 1) {
        FFAppState().availableEmployeeReg = true;
      }

      // Parse the URL to extract all other query parameters
      Uri uri = Uri.parse(url);
      Map<String, String> queryParams = Map.from(uri.queryParameters);

      // Rebuild the query string without the employee parameter
      queryParams.remove('employee');
      String queryString = Uri(queryParameters: queryParams).query;

      // Rebuild the final URL
      url = '${uri.scheme}://${uri.host}${uri.path}?$queryString';
      globalUrl.value = fixUrlFormat(url); // Fix the URL format
      FFAppState().bookEmployee = -1;
      print("updateGlobalUrlRemovingEmployee: " + globalUrl.value);
    }

    print("bookTime: ${FFAppState().bookTime}");
    print("bookEmployee: ${FFAppState().bookEmployee}");
    print("availableEmployeeReg: ${FFAppState().availableEmployeeReg}");
  }

  @override
  Widget build(BuildContext context) {
    print("Vrijeme " + FFAppState().bookTime);

    void extractTimeFromUrl(String url) {
      // Parse the URL
      Uri uri = Uri.parse(url);

      // Proverite da li bookTime nije prazan
      if (FFAppState().bookTime.isNotEmpty) {
        // Izvucite 'time' query parametar
        String? time = uri.queryParameters['time'];

        // Ažurirajte bookTime samo ako time nije null
        if (time != null) {
          FFAppState().bookTime = time;
        }
      }
    }

    void initializeSelectedTime(List<List<Map<String, String>>> timeGroups) {
      extractTimeFromUrl(globalUrl.value);
      print("Đurđa " + FFAppState().bookTime);
      String bookTime = FFAppState().bookTime;
      if (bookTime.isNotEmpty) {
        bool found = false;
        for (int groupIndex = 0;
            groupIndex < timeGroups.length && !found;
            groupIndex++) {
          for (int timeIndex = 0;
              timeIndex < timeGroups[groupIndex].length && !found;
              timeIndex++) {
            final timeSlotData = timeGroups[groupIndex][timeIndex];
            String time = timeSlotData['time'] ?? '';
            final buttonID = '${groupIndex}_$timeIndex';
            if (time == bookTime) {
              selectedButtons.value[buttonID] = true;
              found = true;
            }
          }
        }
        selectedButtons.notifyListeners();
      }
    }

    return GestureDetector(
      onTap: () => _triggerContainerTap(),
      child: Container(
        color: Color(0xFF212529),
        child: Center(
          child: ValueListenableBuilder<String>(
            valueListenable: globalUrl, // Define globalUrl somewhere
            builder: (BuildContext context, String value, Widget? child) {
              return FutureBuilder<int>(
                future: countAvailableEmployees(),
                builder: (context, countSnapshot) {
                  if (countSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: SpinKitCircle(
                        color: Color(0xFFE4C87F),
                        size: 50.0,
                      ),
                    );
                  }

                  if (countSnapshot.hasError) {
                    return Text('Error: ${countSnapshot.error}');
                  }

                  FFAppState().countAvailableEmployees =
                      countSnapshot.data ?? 0;

                  return FutureBuilder<Map<String, dynamic>>(
                    future: fetchJsonData(), // Define fetchJsonData() function
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting &&
                          !FFAppState().displayReservation) {
                        return Center(
                          child: SpinKitCircle(
                            color: Color(0xFFE4C87F),
                            size: 50.0,
                          ),
                        );
                      } else if (snapshot.hasData) {
                        List<List<Map<String, String>>> timeGroups =
                            extractTimeTo(snapshot.data!);

                        // Initialize selected button based on FFAppState().bookTime
                        initializeSelectedTime(timeGroups);

                        int availableTimesCount =
                            countAvailableTimes(timeGroups);

                        bool allTimesDisabled = availableTimesCount == 0;

                        List<String> categoryTitles = extractTimeCategories(
                            snapshot.data!); // Define extractTimeTo() function
                        String employeesName =
                            extractBarberName(snapshot.data!);
                        String unavailable_employee_text_new =
                            extractEmployyeText(snapshot.data!);
                        bookTime = FFAppState().bookTime;
                        bool isSelectedNew = false;
                        FFAppState().notReservation = false;
                        if (bookTime.isNotEmpty) {
                          for (var group in timeGroups) {
                            for (var timeSlot in group) {
                              if (timeSlot['time'] == bookTime) {
                                isSelectedNew = true;
                                FFAppState().notReservation = false;
                                if (timeSlot['disabled'] == 'true') {
                                  FFAppState().notReservation = true;
                                }
                              }
                            }
                          }

                          if (!isSelectedNew) {
                            FFAppState().notReservation = true;
                          }
                        }

                        return ValueListenableBuilder<Map<String, bool>>(
                          valueListenable:
                              selectedButtons, // Define selectedButtons
                          builder: (context, value, child) {
                            if (!initialDataLoaded) {
                              return Text("Loading...");
                            }

                            int maxTimeSlots = timeGroups.fold<int>(
                              0,
                              (max, group) =>
                                  group.length > max ? group.length : max,
                            );

                            Widget buildButtonOrEmptySpace(
                                int groupIndex, int timeIndex) {
                              if (timeIndex < timeGroups[groupIndex].length) {
                                final timeSlotData =
                                    timeGroups[groupIndex][timeIndex];
                                String time = timeSlotData['time'] ?? '';
                                final buttonID = '${groupIndex}_$timeIndex';
                                bool isDisabled = timeSlotData['disabled'] ==
                                    'true'; // Initially check if the timeslot is marked as disabled
                                bool isSelected = FFAppState().bookTime == time;
                                bool isTimeAvailable = hasSelectedTime(
                                    timeGroups, FFAppState().bookTime);

                                if (isTimeAvailable) {
                                  FFAppState().notReservation = false;
                                } else {
                                  FFAppState().notReservation = true;
                                }

                                return Padding(
                                  padding: EdgeInsets.only(
                                      top: 15.0,
                                      right:
                                          20.0), // Apply padding to the right only
                                  child: ElevatedButton(
                                    onPressed: isDisabled
                                        ? null // If disabled, button does not respond to presses
                                        : () {
                                            setState(() {
                                              // If a button is selected, deselect it
                                              if (selectedButtons.value
                                                      .containsKey(buttonID) &&
                                                  selectedButtons
                                                      .value[buttonID]!) {
                                                selectedButtons
                                                    .value[buttonID] = false;
                                                FFAppState().bookTime = "";
                                                removeTimeFromUrl(globalUrl
                                                    .value); // Update the globalUrl with the selected time
                                                // Remove the existing time from the URL
                                              } else {
                                                // Before selecting a new button, deselect all others
                                                selectedButtons.value
                                                    .forEach((key, value) {
                                                  selectedButtons.value[key] =
                                                      false;
                                                });

                                                // Select the new button
                                                selectedButtons
                                                    .value[buttonID] = true;
                                                String newTime =
                                                    timeGroups[groupIndex]
                                                                [timeIndex]
                                                            ['time'] ??
                                                        '';
                                                FFAppState().notReservation =
                                                    false;
                                                FFAppState().bookTime = newTime;
                                                updateBookingTime(newTime);
                                                FFAppState().boolTime = false;
                                              }
                                              // This part is to make sure that only one button can be selected at a time
                                              AvailabledatesWidget
                                                      .numberOfSelectedButtons =
                                                  selectedButtons.value
                                                          .containsValue(true)
                                                      ? 1
                                                      : 0;
                                              FFAppState().intButtonsCount =
                                                  selectedButtons.value
                                                          .containsValue(true)
                                                      ? 1
                                                      : 0;
                                              if (FFAppState().bookTime != "") {
                                                selectedButtons
                                                    .value[buttonID] = true;
                                                FFAppState().bookTime = time;
                                              }

                                              selectedButtons.notifyListeners();
                                              visibleButtons();
                                            });
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isDisabled
                                          ? Color(0xFF000000).withOpacity(
                                              0.2) // Disabled button color
                                          : isSelected // Check if the button is selected
                                              ? Color(
                                                  0xFFE4C87F) // Selected button color
                                              : Color(
                                                  0xFF000000), // Default button color, // Default button color
                                      minimumSize: Size(double.infinity, 0),
                                      fixedSize: Size.fromHeight(50.0),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 6), // Adjust pad
                                      side: BorderSide(
                                        color: isDisabled
                                            ? Color(0xFFE4C87F).withOpacity(
                                                0.2) // Border color is black when disabled
                                            : Color(
                                                0xFFE4C87F), // Border color is gold (#E4C87F) otherwise
                                        width: 1.0,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                    ),
                                    child: Text(
                                      '${timeSlotData['time']} - ${timeSlotData['time_to']}',
                                      style: TextStyle(
                                        color: isDisabled
                                            ? Colors.white.withOpacity(
                                                0.7) // Faded text for disabled button
                                            : isSelected // Check if the button is selected
                                                ? Colors
                                                    .black // Text color for selected button
                                                : Colors
                                                    .white, // Default text color
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily:
                                            GoogleFonts.ptSans().fontFamily,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return SizedBox(); // If not within the index, return an empty space that takes up no space
                            }

                            List<Widget> timeSlotRows = [];
                            for (int i = 0; i < maxTimeSlots; i++) {
                              List<Widget> buttonsForRow = [
                                buildButtonOrEmptySpace(0, i),
                                buildButtonOrEmptySpace(1, i),
                                buildButtonOrEmptySpace(2, i)
                              ]
                                  .where((widget) => widget != null)
                                  .toList(); // Filter out the null widgets

                              if (buttonsForRow.isNotEmpty) {
                                timeSlotRows.add(
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0), // Add padding here
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: buttonsForRow
                                          .map((e) => Expanded(child: e!))
                                          .toList(),
                                    ),
                                  ),
                                );
                              }
                            }
                            FFAppState().displayReservation = false;
                            if (allTimesDisabled &&
                                FFAppState().countAvailableEmployees == 0) {
                              return FutureBuilder<String>(
                                future: fetchFirstAvailableAppointment(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<String> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    // Display a loading indicator with the color 0xFFE4C87F.
                                    return Center(
                                      child: SpinKitCircle(
                                        color: Color(0xFFE4C87F),
                                        size: 50.0,
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    // Handle any errors that occurred during fetching.
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    // Build your UI once the future has a value.
                                    return Padding(
                                      padding: EdgeInsets.all(12),
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: Color(0x0000000),
                                          border: Border.all(
                                            color: Color(0xFFE4C87F),
                                            width: 1,
                                          ),
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.all(16),
                                                child: FadeTransition(
                                                  opacity:
                                                      _animationController!,
                                                  child: Text(
                                                    unavailable_employee_text_new,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          GoogleFonts.ptSans()
                                                              .fontFamily,
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              SizedBox(
                                                width: 300,
                                                height: 45,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    FFAppState()
                                                        .boolDateChanged = true;
                                                    String stringDate =
                                                        snapshot.data!;

                                                    final inputFormat =
                                                        DateFormat(
                                                            'dd.MM.yyyy');
                                                    DateTime parsedDate =
                                                        inputFormat
                                                            .parse(stringDate);
                                                    FFAppState().bookDate =
                                                        DateFormat('yyyy-MM-dd')
                                                            .format(parsedDate);

                                                    String
                                                        formattedSelectedDay =
                                                        DateFormat('yyyy-MM-dd')
                                                            .format(parsedDate);
                                                    globalUrl.value = globalUrl
                                                        .value
                                                        .replaceFirst(
                                                      RegExp(
                                                          r"date=\d{4}-\d{2}-\d{2}"),
                                                      "date=$formattedSelectedDay",
                                                    );
                                                    FFAppState().bothDisabled =
                                                        false;

                                                    // Optionally, update the day name in FFAppState
                                                    // clearSelectedButtons(); // Uncomment if needed
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color(0xFFE4C87F),
                                                    side: BorderSide(
                                                      color: Color(0xFFE4C87F),
                                                      width: 1,
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    textStyle: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    snapshot.data ?? '',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Color(0xFF212529),
                                                      fontSize: 16,
                                                      fontFamily:
                                                          GoogleFonts.ptSans()
                                                              .fontFamily,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 16,
                                              ),
                                              SizedBox(
                                                width: 300,
                                                height: 45,
                                                child: StatefulBuilder(
                                                  builder:
                                                      (BuildContext context,
                                                          StateSetter s) {
                                                    return MouseRegion(
                                                      child: ElevatedButton(
                                                        onPressed: () async {
                                                          FFAppState()
                                                              .specialUrl = '';
                                                          FFAppState()
                                                                  .specialUrl =
                                                              globalUrl.value;
                                                          await showDialog(
                                                            context: context,
                                                            builder:
                                                                (dialogContext) {
                                                              return Dialog(
                                                                elevation: 0,
                                                                insetPadding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                child:
                                                                    const UrgentTermWidget(),
                                                              );
                                                            },
                                                          ).then((value) =>
                                                              setState(() {}));
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          side: BorderSide(
                                                            color: Color(
                                                                0xFFE4C87F),
                                                            width: 1,
                                                          ),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                          ),
                                                          textStyle: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                        child: RichText(
                                                          textAlign:
                                                              TextAlign.center,
                                                          text: TextSpan(
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                            ),
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    "Upiši se na listu čekanja ",
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'PT Sans',
                                                                  color: Color(
                                                                      0xFFE4C87F),
                                                                ),
                                                              ),
                                                              WidgetSpan(
                                                                alignment:
                                                                    PlaceholderAlignment
                                                                        .middle,
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              4),
                                                                  color: Color(
                                                                      0xFFDC3545),
                                                                  child: Text(
                                                                    "NOVO",
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'PT Sans',
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              // Optionally, add more UI elements as needed.
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              );
                            }

                            if (allTimesDisabled &&
                                FFAppState().countAvailableEmployees != 0) {
                              return FutureBuilder<String>(
                                future: fetchFirstAvailableAppointment(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<String> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    // Display a loading indicator with the color 0xFFE4C87F.
                                    return Center(
                                      child: SpinKitCircle(
                                        color: Color(0xFFE4C87F),
                                        size: 50.0,
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    // Handle any errors that occurred during fetching.
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    // Build your UI once the future has a value.
                                    return Padding(
                                      padding: EdgeInsets.all(12),
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: Colors
                                              .black, // Changed color to black
                                          border: Border.all(
                                            color: Color(0xFFE4C87F),
                                            width: 1,
                                          ),
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.all(16),
                                                child: FadeTransition(
                                                  opacity:
                                                      _animationController!,
                                                  child: Text(
                                                    unavailable_employee_text_new,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontFamily:
                                                          GoogleFonts.ptSans()
                                                              .fontFamily,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              SizedBox(
                                                width: 300,
                                                height: 45,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    FFAppState()
                                                        .boolDateChanged = true;
                                                    String stringDate =
                                                        snapshot.data!;

                                                    final inputFormat =
                                                        DateFormat(
                                                            'dd.MM.yyyy');
                                                    DateTime parsedDate =
                                                        inputFormat
                                                            .parse(stringDate);
                                                    FFAppState().bookDate =
                                                        DateFormat('yyyy-MM-dd')
                                                            .format(parsedDate);

                                                    String
                                                        formattedSelectedDay =
                                                        DateFormat('yyyy-MM-dd')
                                                            .format(parsedDate);
                                                    globalUrl.value = globalUrl
                                                        .value
                                                        .replaceFirst(
                                                      RegExp(
                                                          r"date=\d{4}-\d{2}-\d{2}"),
                                                      "date=$formattedSelectedDay",
                                                    );
                                                    FFAppState().bothDisabled =
                                                        false;

                                                    // Optionally, update the day name in FFAppState
                                                    // clearSelectedButtons(); // Uncomment if needed
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color(0xFFE4C87F),
                                                    side: BorderSide(
                                                      color: Color(0xFFE4C87F),
                                                      width: 1,
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    textStyle: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily:
                                                          GoogleFonts.ptSans()
                                                              .fontFamily,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    snapshot.data ?? '',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Color(0xFF212529),
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 16,
                                              ),
                                              SizedBox(
                                                width: 300,
                                                height: 45,
                                                child: StatefulBuilder(
                                                  builder:
                                                      (BuildContext context,
                                                          StateSetter s) {
                                                    return MouseRegion(
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          FFAppState()
                                                                  .clearSelectedEmployee =
                                                              true;
                                                          updateGlobalUrlRemovingEmployee();
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          side: BorderSide(
                                                            color: Color(
                                                                0xFFE4C87F),
                                                            width: 1,
                                                          ),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                          ),
                                                          textStyle: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontFamily:
                                                                'PT Sans',
                                                          ),
                                                        ),
                                                        child: RichText(
                                                          textAlign:
                                                              TextAlign.center,
                                                          text: TextSpan(
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                            ),
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    "Provjeri dostupnost ostalih barbera na odabrani datum",
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'PT Sans',
                                                                  color: Color(
                                                                      0xFFE4C87F),
                                                                ),
                                                              ),
                                                              // Optionally, add more UI elements as needed.
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height: 16,
                                              ),
                                              SizedBox(
                                                width: 300,
                                                height: 45,
                                                child: StatefulBuilder(
                                                  builder:
                                                      (BuildContext context,
                                                          StateSetter s) {
                                                    return MouseRegion(
                                                      child: ElevatedButton(
                                                        onPressed: () async {
                                                          FFAppState()
                                                              .specialUrl = '';
                                                          FFAppState()
                                                                  .specialUrl =
                                                              globalUrl.value;
                                                          await showDialog(
                                                            context: context,
                                                            builder:
                                                                (dialogContext) {
                                                              return Dialog(
                                                                elevation: 0,
                                                                insetPadding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                child:
                                                                    const UrgentTermWidget(),
                                                              );
                                                            },
                                                          ).then((value) =>
                                                              setState(() {}));
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          side: BorderSide(
                                                            color: Color(
                                                                0xFFE4C87F),
                                                            width: 1,
                                                          ),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                          ),
                                                          textStyle: TextStyle(
                                                            fontFamily:
                                                                'PT Sans',
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                        child: RichText(
                                                          textAlign:
                                                              TextAlign.center,
                                                          text: TextSpan(
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                            ),
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    "Upiši se na listu čekanja ",
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'PT Sans',
                                                                  color: Color(
                                                                      0xFFE4C87F),
                                                                ),
                                                              ),
                                                              WidgetSpan(
                                                                alignment:
                                                                    PlaceholderAlignment
                                                                        .middle,
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              4),
                                                                  color: Color(
                                                                      0xFFDC3545),
                                                                  child: Text(
                                                                    "NOVO",
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'PT Sans',
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              // Optionally, add more UI elements as needed.
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              );
                            }

                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(height: 8.0),
                                  // Headers with added styling
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        for (int i = 0;
                                            i < timeGroups.length;
                                            i++)
                                          Expanded(
                                            child: Text(
                                              categoryTitles[i].toUpperCase(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: GoogleFonts.ptSans()
                                                    .fontFamily,
                                                fontSize: 14.0,
                                                color: Color(0xFFE4C87F),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  ...timeSlotRows, // Spread the list of widgets
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        return Text("");
                      }
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
