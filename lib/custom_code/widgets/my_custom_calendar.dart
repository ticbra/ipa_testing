// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'global.dart';
import '/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class MyCustomCalendar extends StatefulWidget {
  const MyCustomCalendar({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _MyCustomCalendarState createState() => _MyCustomCalendarState();
}

class _MyCustomCalendarState extends State<MyCustomCalendar> {
  DateTime _focusedDay = DateTime.now();
  late DateTime firstDay = DateTime.now();
  late DateTime lastDay = DateTime.now();
  String disableNewDates = "";
  List<DateTime> disabledDates = [];
  List<DateTime> availableDates = [];
  int daysDifference = 0;
  DateTime? _selectedDay;
  List<DateTime> bothDisabledDates = [];
  bool firstPress = true;
  bool isLastDate = false;
  bool _isLoading = true;
  String previousUrl = "";

  Future<void> updateDisabledDateForCalendar(String url) async {
    _isLoading = true;
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      String jsonString = response.body;
      List<dynamic> jsonData = jsonDecode(jsonString)['availability']['dates'];
      List<DateTime> newDisabledDates = [];
      List<DateTime> newBothDisabledDates = [];

      for (Map<String, dynamic> item in jsonData) {
        DateTime date = DateTime.parse(item['date']);
        bool isDisabled =
            item['disabled'] == true || item['available'] == false;
        bool isBothDisabled =
            item['disabled'] == false && item['available'] == false;

        if (isDisabled) {
          newDisabledDates.add(date);
        }

        if (isBothDisabled) {
          newBothDisabledDates.add(date);
        }
      }
      if (mounted) {
        setState(() {
          disabledDates = newDisabledDates;
          bothDisabledDates = newBothDisabledDates;
        });
      }
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  Future<String> fetchFirstAvailableAppointment() async {
    Uri originalUri = Uri.parse(globalUrl.value);

    // Make the HTTP request to the global URL
    final response = await http.get(originalUri);

    if (response.statusCode == 200) {
      // Decode the JSON response
      Map<String, dynamic> data = jsonDecode(response.body);

      // Extract the first available appointment
      String firstAvailableAppointment = data['first_available_appointment'];

      // Return the first available appointment
      return firstAvailableAppointment;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }

  Future<void> processAppointmentData() async {
    try {
      await updateDisabledDateForCalendar(globalUrl.value);

      String firstAvailableDate = await fetchFirstAvailableAppointment();
      DateTime firstAvailableDateTime =
          DateFormat('yyyy-MM-dd').parse(firstAvailableDate);
      if (FFAppState().bookDate.isEmpty) {
        FFAppState().firstDayCalendar = firstAvailableDate;
        FFAppState().bookDate = FFAppState().firstDayCalendar;
      }
      // Set _selectedDay to the first available date

      _selectedDay = setCurrentDate(FFAppState().bookDate, firstAvailableDate);
      _focusedDay = setCurrentDate(FFAppState().bookDate, firstAvailableDate);

      // Set bookDayName in FFAppState based on the weekday of _selectedDay
      var wholeNames = {
        1: 'Ponedjeljak',
        2: 'Utorak',
        3: 'Srijeda',
        4: 'Četvrtak',
        5: 'Petak',
        6: 'Subota',
        7: 'Nedjelja'
      };

      if (_selectedDay != null) {
        FFAppState().bookDayName = wholeNames[_selectedDay!.weekday]!;
      } else {
        // Handle the case where _selectedDay is null
      }

      _triggerContainerTap();
    } catch (error) {
      print('Error fetching first available appointment: $error');
    }

    if (mounted) {
      setState(() {
        _isLoading = false; // Set to false when data is fully loaded
      });
    }
  }

  DateTime setCurrentDate(String bookDate, String firstAvailableDate) {
    DateTime currentDate;

    if (bookDate.isEmpty) {
      // Parse firstAvailableDate into a DateTime object
      currentDate = DateFormat('yyyy-MM-dd').parse(firstAvailableDate);
    } else {
      // Parse bookDate into a DateTime object
      currentDate = DateFormat('yyyy-MM-dd').parse(bookDate);
    }

    return currentDate;
  }

  DateTime setCurrentDateNew(String bookDate) {
    DateTime currentDate;

    // Parse bookDate into a DateTime object
    currentDate = DateFormat('yyyy-MM-dd').parse(bookDate);

    return currentDate;
  }

  Future<void> extractDatesFromGlobalUrl() async {
    final response = await http.get(Uri.parse(globalUrl.value));

    if (response.statusCode == 200) {
      String jsonString = response.body;
      Map<String, dynamic> jsonData = jsonDecode(jsonString);

      // Check if the 'range' object exists
      if (jsonData.containsKey('range')) {
        Map<String, dynamic> range = jsonData['range'];

        // Check if 'start' and 'end' keys exist in the 'range' object
        if (range.containsKey('start') && range.containsKey('end')) {
          firstDay = DateTime.parse(range['start']);
          lastDay = DateTime.parse(range['end']);
        } else {
          // Handle the case where 'start' or 'end' keys are missing in the 'range' object
          throw Exception('Missing date information in JSON response');
        }

        // Here you can use firstDay and lastDay as needed
        // For example, setting them to your state variables
      } else {
        throw Exception(
            'Failed to load data: "range" object not found in JSON response');
      }
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();

    // Trigger the asynchronous operations without awaiting them in initState
    Future.microtask(() async {
      await extractDatesFromGlobalUrl();
      await processAppointmentData();
      // Update your state if needed
    });
  }

  // Added this function
  void _triggerContainerTap() {
    Future.delayed(Duration(seconds: 0), () {
      if (mounted) {
        setState(() {
          //FFAppState().boolDisabled = false;
        });
      }
      final gestureDetector =
          context.findAncestorWidgetOfExactType<GestureDetector>();
      gestureDetector?.onTap?.call();
      // Remove employee ID from globalUrl only when a new date is selected

      //globalUrl.value = globalUrl.value.replaceAll(RegExp(r"employee=\d+"), "");
    });
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  int getVisibleDaysBasedOnResolution() {
    double screenWidth = MediaQuery.of(context).size.width;
    double dayWidth = 74.0; // width of a day column

    // Subtracting width taken up by the chevrons, adjust if your chevrons occupy different space
    double availableWidth = screenWidth - (2 * 40.0);

    int visibleDays = (availableWidth / dayWidth).floor();

    return visibleDays;
  }

  bool isDateDisabled(DateTime date) {
    return disabledDates.any((disabledDate) => isSameDay(disabledDate, date));
  }

  bool isDateBothDisabled(DateTime date) {
    return bothDisabledDates
        .any((bothDisabledDate) => isSameDay(bothDisabledDate, date));
  }

  bool checkIfLastDate(DateTime focusedDay) {
    int visibleDays = getVisibleDaysBasedOnResolution();
    DateTime checkDate = focusedDay.add(Duration(days: visibleDays));

    final DateTime justLastDay =
        DateTime(lastDay.year, lastDay.month, lastDay.day);
    final DateTime justCheckDate =
        DateTime(checkDate.year, checkDate.month, checkDate.day);

    // Instead of checking for the exact same moment, check if justCheckDate is after or the same as justLastDay
    return justCheckDate.isAfter(justLastDay) ||
        justCheckDate.isAtSameMomentAs(justLastDay);
  }

  void updateGlobalUrlWithDate(DateTime selectedDate) {
    // Format the selected date as yyyy-MM-dd
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    FFAppState().bookDate = formattedDate;

    // Parse the globalUrl to extract its components
    Uri url = Uri.parse(globalUrl.value);

    // Extracting all query parameters, including handling multiple values for the same name
    Map<String, List<String>> queryParams = Map.from(url.queryParametersAll);

    // Update the 'date' query parameter directly
    queryParams['date'] = [formattedDate]; // Replace with the new date

    // Manually rebuild the query string to maintain 'services[]' and other parameters
    var queryString = queryParams.entries.expand((entry) {
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

    // Only update the globalUrl if it has changed
    if (globalUrl.value != updatedUrl) {
      globalUrl.value = updatedUrl;
    }

    // Extract the duration from the updated globalUrl
    extractFullDurationFromUrl(updatedUrl);
  }

  void extractFullDurationFromUrl(String url) async {
    // Parse the URL to get the query parameters
    Uri uri = Uri.parse(url);

    // Fetch the response from the globalUrl
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      // Extract the 'booking' key from the response
      Map<String, dynamic> bookingDataMap = jsonResponse['booking'];

      // Extract the necessary information
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

      // Extract the full duration directly from the 'booking' data structure
      int fullDuration = bookingDataMap['duration'];

      String duration = fullDuration.toString();
      FFAppState().priceToEur = priceToEur ?? 0.0;
      FFAppState().totalPriceEur = totalPriceEur ?? 0.0;
      String priceEur = FFAppState().priceEur != null
          ? FFAppState().priceEur.toStringAsFixed(2)
          : '0.00';

      String priceTo =
          priceToEur != null ? priceToEur.toStringAsFixed(2) : '0.00';
      String totalPrice =
          totalPriceEur != null ? totalPriceEur.toStringAsFixed(2) : '0.00';

      String newDefinition;
      if (FFAppState().bookEmployee == 0 && priceEur == priceTo) {
        newDefinition = 'Trajanje: $duration min\nCijena: $priceEur €';
      } else if (FFAppState().bookEmployee == 0 && priceEur != priceTo) {
        newDefinition =
            'Trajanje: $duration min\nCijena: $priceEur € - $priceTo €';
      } else {
        // Format when an employee is selected
        newDefinition = 'Trajanje: $duration min\nCijena: $totalPrice €';
      }

      globalDurationTime.value = fullDuration;
      globalOutputNotifier.value = newDefinition;

      // Print the extracted full duration
      print("Full Duration: $fullDuration");
    } else {
      print("Failed to fetch data from URL: ${response.statusCode}");
    }
  }

  void navigateToNextDayOrDays() {
    if (firstPress) {
      int visibleDays = getVisibleDaysBasedOnResolution();
      _focusedDay = _focusedDay.add(Duration(days: visibleDays));
      firstPress =
          false; // Reset firstPress to handle the logic for the first press
    } else {
      _focusedDay = _focusedDay
          .add(Duration(days: 1)); // Move to the next day on subsequent presses
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isFirstWeek() {
      DateTime startOfWeek = _focusedDay;
      return startOfWeek.isBefore(firstDay) || isSameDay(startOfWeek, firstDay);
    }

    bool isFirstDay(DateTime date) {
      isLastDate = false;
      final DateTime justDate = DateTime(date.year, date.month, date.day);
      final DateTime justFirstDay =
          DateTime(firstDay.year, firstDay.month, firstDay.day);
      return justDate.isAtSameMomentAs(justFirstDay);
    }

    int daysToGenerate = lastDay.difference(_focusedDay).inDays + 1;
    int visibleDays = getVisibleDaysBasedOnResolution();

    daysToGenerate = min(daysToGenerate, visibleDays);

    return ValueListenableBuilder(
      valueListenable: globalUrl, // Assuming globalUrl is a ValueNotifier
      builder: (context, value, child) {
        if (previousUrl != globalUrl.value) {
          previousUrl = globalUrl.value;
          updateDisabledDateForCalendar(globalUrl.value);

          _isLoading = false;
          if (FFAppState().boolDateChanged &&
              FFAppState().bookDate.isNotEmpty) {
            _selectedDay = setCurrentDateNew(FFAppState().bookDate);

            _focusedDay = setCurrentDateNew(FFAppState().bookDate);
            FFAppState().boolDateChanged = false;
          }
        }

        return Container(
          width: widget.width,
          height: 74,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: Color(0xFFE4C87F),
              width: 1.0,
            ),
            color: Color(0xFF000000),
          ),
          child: GestureDetector(
            onTap: _triggerContainerTap,
            child: Row(
              children: [
                // Left Chevron with 10% width
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 74.0,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Color(0xFFE4C87F),
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.chevron_left,
                        color: isFirstDay(_focusedDay)
                            ? Color(0xFFE4C87F).withOpacity(0.5)
                            : Color(0xFFE4C87F),
                        size: 40.0,
                      ),
                      padding: EdgeInsets.all(0),
                      onPressed: isFirstDay(_focusedDay)
                          ? null
                          : () {
                              // Only proceed to update the state if it's not the first day
                              if (mounted) {
                                setState(() {
                                  _focusedDay =
                                      _focusedDay.subtract(Duration(days: 1));
                                });
                              }
                            },
                    ),
                  ),
                ),

                // Day row with 80% width
                Expanded(
                  flex: 8,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(daysToGenerate, (index) {
                        DateTime date = _focusedDay.add(Duration(days: index));
                        bool isDisabled = isDateDisabled(date);

                        var dayNames = {
                          1: 'pon',
                          2: 'uto',
                          3: 'sri',
                          4: 'čet',
                          5: 'pet',
                          6: 'sub',
                          7: 'ned'
                        };

                        var wholeNames = {
                          1: 'ponedjeljak',
                          2: 'utorak',
                          3: 'srijeda',
                          4: 'četvrtak',
                          5: 'petak',
                          6: 'subota',
                          7: 'nedjelja'
                        };

                        var monthNames = {
                          1: 'siječnja',
                          2: 'veljača',
                          3: 'ožujka',
                          4: 'travnja',
                          5: 'svibnja',
                          6: 'lipnja',
                          7: 'srpnja',
                          8: 'kolovoza',
                          9: 'rujna',
                          10: 'listopada',
                          11: 'studenog',
                          12: 'prosinca'
                        };

                        return Opacity(
                          opacity: _isLoading ? 0.0 : (isDisabled ? 1.0 : 1.0),
                          child: InkWell(
                            onTap: () {
                              if (!isDisabled) {
                                FFAppState().bothDisabled = false;
                                if (mounted) {
                                  setState(() {
                                    if (_selectedDay != null &&
                                        isSameDay(_selectedDay!, date)) {
                                      FFAppState().bookDate = '';
                                    } else {
                                      _selectedDay = date;
                                      FFAppState().bookDate =
                                          DateFormat('yyyy-MM-dd').format(date);
                                    }

                                    updateGlobalUrlWithDate(date);
                                    _triggerContainerTap();
                                  });
                                }
                              }
                            },
                            child: Container(
                              width: 74.0,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Color(0xFFE4C87F),
                                    width: 1.0,
                                  ),
                                ),
                                color: _selectedDay != null &&
                                        isSameDay(_selectedDay!, date)
                                    ? Color(0xFFe4c87f)
                                    : null,
                              ),
                              child: InkWell(
                                onTap: isDateBothDisabled(date) || !isDisabled
                                    ? () {
                                        // Common action to update _selectedDay regardless of conditions
                                        _selectedDay = date;
                                        FFAppState().bothDisabled = false;

                                        if (isDateBothDisabled(date)) {
                                          // Actions for when the date is both disabled
                                          if (mounted) {
                                            setState(() {
                                              FFAppState().boolDateChanged =
                                                  false;
                                              FFAppState().bothDisabled = true;
                                              FFAppState().bookDate =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(date);

                                              // This condition seems redundant since _selectedDay is already set to date above
                                              if (!isSameDay(
                                                  _selectedDay!, date)) {
                                                _selectedDay = date;
                                                FFAppState().bookDate =
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(date);
                                              }

                                              updateGlobalUrlWithDate(date);
                                              FFAppState().bookDayName =
                                                  wholeNames[
                                                      _selectedDay!.weekday]!;
                                              _triggerContainerTap();
                                            });
                                          }
                                        } else if (!isDisabled) {
                                          // Actions for when the date is not disabled
                                          if (mounted) {
                                            setState(() {
                                              // This condition seems redundant as well for the same reason mentioned above
                                              if (!isSameDay(
                                                  _selectedDay!, date)) {
                                                _selectedDay = date;
                                                FFAppState().bookDate =
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(date);
                                              }

                                              updateGlobalUrlWithDate(date);
                                              FFAppState().bookDayName =
                                                  wholeNames[
                                                      _selectedDay!.weekday]!;
                                              _triggerContainerTap();
                                            });
                                          }
                                        }
                                      }
                                    : null,
                                child: Opacity(
                                  opacity: isDisabled ? 1.0 : 1.0,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 3),
                                        child: Text(
                                          dayNames[date.weekday]!,
                                          style: TextStyle(
                                            fontFamily:
                                                GoogleFonts.ptSans().fontFamily,
                                            color: isDisabled
                                                ? Color(0xFF777777)
                                                : (!isDisabled &&
                                                        _selectedDay != null &&
                                                        isSameDay(_selectedDay!,
                                                            date))
                                                    ? Colors.black
                                                    : Colors.white,
                                            fontSize: 12,
                                            height: 1.33,
                                            fontWeight: (!isDisabled &&
                                                    _selectedDay != null &&
                                                    isSameDay(
                                                        _selectedDay!, date))
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        date.day < 10
                                            ? '0${date.day}'
                                            : date.day.toString(),
                                        style: TextStyle(
                                          fontFamily:
                                              GoogleFonts.ptSans().fontFamily,
                                          color: isDisabled
                                              ? Color(0xFF777777)
                                              : (!isDisabled &&
                                                      _selectedDay != null &&
                                                      isSameDay(
                                                          _selectedDay!, date))
                                                  ? Colors.black
                                                  : Colors.white,
                                          fontSize: 24,
                                          height: 1.10,
                                          fontWeight: (!isDisabled &&
                                                  _selectedDay != null &&
                                                  isSameDay(
                                                      _selectedDay!, date))
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 4),
                                        child: Text(
                                          monthNames[date.month]!,
                                          style: TextStyle(
                                            fontFamily:
                                                GoogleFonts.ptSans().fontFamily,
                                            color: isDisabled
                                                ? Color(0xFF777777)
                                                : (!isDisabled &&
                                                        _selectedDay != null &&
                                                        isSameDay(_selectedDay!,
                                                            date))
                                                    ? Colors.black
                                                    : Colors.white,
                                            fontSize: 12,
                                            height: 1.33,
                                            fontWeight: (!isDisabled &&
                                                    _selectedDay != null &&
                                                    isSameDay(
                                                        _selectedDay!, date))
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    //),
                  ),
                ),
                // Right Chevron with 10% width
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 74.0,
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: Color(0xFF6F5F33),
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.chevron_right,
                        color: checkIfLastDate(_focusedDay)
                            ? Color(0xFFE4C87F).withOpacity(0.5)
                            : Color(0xFFE4C87F),
                        size: 40.0,
                      ),
                      padding: EdgeInsets.all(0),
                      onPressed: checkIfLastDate(_focusedDay)
                          ? null
                          : () {
                              // If it's not the last date, proceed with setState
                              if (mounted) {
                                setState(() {
                                  navigateToNextDayOrDays();
                                });
                              }
                            },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
