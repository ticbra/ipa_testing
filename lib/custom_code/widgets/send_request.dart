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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color activeColor;
  final Color fillColor;
  final Color colorNew;
  final bool useCheckIcon;
  final int width;
  final int height;

  const RoundCheckbox({
    Key? key,
    required this.value,
    this.onChanged,
    required this.activeColor,
    required this.fillColor,
    this.useCheckIcon = true,
    required this.width,
    required this.height,
    required this.colorNew,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChanged != null
          ? () {
              onChanged!(!value);
            }
          : null,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: value ? activeColor : fillColor,
          border: Border.all(
            color: colorNew, // Updated this line
            width: 2,
          ),
        ),
        child: value
            ? useCheckIcon
                ? Icon(
                    Icons.check,
                    size: 20,
                    color: Color(0xFFE4C87F),
                  )
                : Icon(
                    Icons.add,
                    size: 20,
                    color: Color(0xFFE4C87F),
                  )
            : null,
      ),
    );
  }
}

class SendRequest extends StatefulWidget {
  const SendRequest({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _SendRequestState createState() => _SendRequestState();
}

class _SendRequestState extends State<SendRequest> {
  String startValue = '';
  String startTime = '';
  String endTime = '';
  String employeeName = '';
  List<Map<String, dynamic>> services = [];
  String endDuration = '';
  String endPrice = '';
  String endPriceFrom = '';
  String endPriceTo = '';
  String employeeNumber = "";
  List<String> employeeNames = [];
  List<String> employeeNamesAndIds = [];
  String selectedEmployeeName = '';
  String selectedEmployeeNameValue = '';
  String selectedEmployeeId = '';
  DateTime? selectedDate;
  List<String> employeeTimes = [];
  String selectedTime = "Bilo koji"; // Set your default value here
  List<DateTime?> selectedDateRange = [
    DateTime.now(), // Start date of the range
    DateTime.now().add(Duration(days: 1)), // End date of the range
  ];
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  DateTime endForDate = DateTime.now();
  String? mode = "";
  String? firstText = "";
  String? secondText = "";
  String urlText = "";
  late TextEditingController _controller;
  bool isLoading = true; // Loading state
  List<Map<String, dynamic>> cards = [];
  Map<String, dynamic>? selectedCard;
  String? cardId;

  bool onlinePaymentChecked = true; // Set online payment as default
  bool storePaymentChecked = false;

  String paymentMethod = "online";

  @override
  void initState() {
    super.initState();

    fetchDataFromUrl().then((_) {
      _controller = TextEditingController();
      if (mounted) {
        setState(() {
          isLoading = false; // Data loaded, set loading to false
        });
      }
    });
    _fetchCardsData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

          // Select the first enabled card initially, or the "Dodaj Novu karticu" if it is the only card
          selectedCard = cards.firstWhere(
            (card) => card['enabled'] && card['id'] != 'add_new',
            orElse: () => {
              'id': 'add_new',
              'name': 'Dodaj Novu karticu',
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
      // Update the card ID in FFAppState
      cardId = card['id'] == 'add_new' ? null : card['id'];
    });

    // Automatically proceed with the booking process if "Dodaj Novu karticu" is selected
    if (card['id'] == 'add_new') {
      sendBookingDataAdjusted();
    }
  }

  Future<void> fetchDataFromUrl() async {
    if (mounted) {
      Uri currentUrl = Uri.parse(FFAppState().specialUrl);

      List<String> queryParamStrings = [];
      Map<String, List<String>> allQueryParameters =
          currentUrl.queryParametersAll;

      if (!allQueryParameters.containsKey('services') &&
          !allQueryParameters.containsKey('services[]')) {
        queryParamStrings.add('services=all');
      }

      allQueryParameters.forEach((key, value) {
        if (key == 'services[]') {
          value.forEach((service) {
            queryParamStrings
                .add('services%5B%5D=${Uri.encodeComponent(service.trim())}');
          });
        }
      });

      String? bookTime =
          FFAppState().bookTime; // Adjust as necessary, using nullable type
      RegExp modeRegEx = RegExp(r"&mode=[a-zA-Z]+");
      bool hasMode = modeRegEx.hasMatch(FFAppState().specialUrl);

      // // Adding checks for nullable states
      if (FFAppState().boolWaiting) {
        FFAppState().specialUrl += '&mode=waiting';
        FFAppState().boolWaiting = false;
      }
      if (FFAppState().boolUrgent) {
        FFAppState().specialUrl += '&mode=urgent';
        FFAppState().boolUrgent = false;
      }

      RegExp employeeRegEx = RegExp(r"[?&]employee=(\d+)");
      String? employeeNumberNew; // Declare as nullable
      var match = employeeRegEx.firstMatch(FFAppState().specialUrl);
      if (match != null) {
        employeeNumberNew =
            match.group(1); // No need for ?? "" as it's already nullable
      }

      Uri uri = Uri.parse(FFAppState().specialUrl);

      employeeNumber = FFAppState().bookEmployee.toString();

      mode = uri.queryParameters['mode']; // Handle as nullable

      List<String>? displayTexts = getTextsBasedOnMode(
          mode); // Ensure this function can handle null inputs

      // Using .first and .last safely with defaults
      firstText =
          displayTexts.isNotEmpty ? displayTexts.first : 'Default First Text';
      secondText =
          displayTexts.isNotEmpty ? displayTexts.last : 'Default Second Text';

      final response = await http.get(Uri.parse(FFAppState().specialUrl));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        Map<String, dynamic>? booking = data['booking'] != null
            ? Map<String, dynamic>.from(data['booking'])
            : null;
        var employees =
            data['availability']?['employees'] as List<dynamic>? ?? [];

        var availableEmployeeNames = ['Bilo koji'];
        availableEmployeeNames.addAll(employees
            .where((employee) => employee['available'] == true)
            .map((employee) => employee['name'].toString()));

        var availableEmployeeNameIds = employees
            .where((employee) =>
                employee['available'] == true) // Filter for available employees
            .map((employee) =>
                "${employee['name']} - ${employee['id']}") // Combine name and ID into a string
            .toList(); // Convert to a List
        employeeNamesAndIds = availableEmployeeNameIds;
        Map<String, dynamic> range = Map<String, dynamic>.from(data['range']);

        startDate = DateTime.parse(range['start']!);
        DateTime? endDate = startDate?.add(Duration(days: 1));
        endForDate = DateTime.parse(range['end']!);
        selectedDateRange = [startDate, endDate];

        // Use null-aware operators to handle possible null values
        String startHour = booking?['start_time']?.toString() ?? "";
        String endHour = booking?['end_time']?.toString() ?? "";
        String barberName = booking?['employee_name']?.toString() ?? "";

        List<Map<String, String>> allServices = [];
        if (booking != null && booking['services'] is List) {
          List<dynamic> servicesData = booking['services'];
          servicesData.forEach((service) {
            allServices.add({
              'full_title': service['full_title'].toString(),
              'full_duration': service['full_duration'].toString(),
              'full_price': service['full_price'].toString(),
              'full_price_from': service['full_price_from'].toString(),
              'full_price_to': service['full_price_to'].toString(),
            });
          });

          employeeNames = availableEmployeeNames;
          employeeTimes = [
            "Bilo koji",
            "Ujutro (07-12h)",
            "Popodne (12-17h)",
            "Večer (17-20h)"
          ];

          selectedEmployeeName =
              employeeNumberNew?.isEmpty ?? true ? 'Bilo koji' : barberName;
          if (selectedEmployeeName == "Bilo koji") {
            employeeNumber = '';
          }

          setState(() {
            startTime = startHour;
            endTime = endHour;
            employeeName = barberName;

            services = allServices;
            endDuration = booking['duration'].toString();
            endPrice = booking['total_price'].toString();
            endPriceFrom = booking['total_price_from'].toString();
            endPriceTo = booking['total_price_to'].toString();
            isLoading = false; // Data loaded, set loading to false
          });
        }
      }
    }
    // Continue your logic here...
  }

  Color _getLastMonthIconColor(int displayedMonth) {
    if (displayedMonth == startDate.month) {
      // If the displayed month is the same as startDate, apply opacity to the last month icon
      return Color(0xFFe4c87f).withOpacity(0.5);
    } else {
      // Otherwise, use the full color for the last month icon
      return Color(0xFFe4c87f);
    }
  }

  Color _getNextMonthIconColor(int displayedMonth) {
    if (displayedMonth == endForDate.month) {
      // If the displayed month is the same as endForDate, apply opacity to the next month icon
      return Color(0xFFe4c87f).withOpacity(0.5);
    } else {
      // Otherwise, use the full color for the next month icon
      return Color(0xFFe4c87f);
    }
  }

  void extractParametersFromGlobalUrl() {
    String dateForThis;

    // Debug print to check the content of globalUrl
    print('Global Url content: ' + globalUrl.value);

    // Extract the query parameters from the globalUrl
    final Uri uri = Uri.parse(globalUrl.value);

    // Extract services from query parameters
    final List<String> servicesFromUrl = [];
    uri.queryParameters.forEach((key, value) {
      if (key.startsWith('services[')) {
        servicesFromUrl.add(value);
      }
    });

    // Initialize bookServices with services from URL
    FFAppState().bookServices = servicesFromUrl.join(',');

    // Split the bookServices to ensure no extra spaces or new lines
    final servicesList = FFAppState()
        .bookServices
        .split(RegExp(r'[\n,]'))
        .where((service) => service.trim().isNotEmpty)
        .toList();

    // Update the bookServices with the filtered list
    FFAppState().bookServices = servicesList.join(',');

    // Debug print to check the parsed service list
    print('Parsed services list: $servicesList');

    // Debug print to check the updated bookServices
    print('Updated bookServices: ${FFAppState().bookServices}');

    // Extract the date from query parameters
    if (uri.queryParameters.containsKey('date')) {
      FFAppState().bookDate = uri.queryParameters['date']!;
    }

    if (FFAppState().bookDate.isEmpty) {
      dateForThis = FFAppState().firstDayCalendar;
    } else {
      dateForThis = FFAppState().bookDate;
    }

    // Debug print to check the updated bookDate
    print('Updated bookDate: $dateForThis');

    // You can use servicesList and dateForThis further in your code as needed
  }

  Future<void> sendBookingDataAdjusted() async {
    String userToken = FFAppState().token;

    String endpoint = domenString + '/mobile-app/api/v1/user/$userToken/book';

    // Services list parsing adjusted for newline character as delimiter
    if (FFAppState().modeSpecial) {
      extractParametersFromGlobalUrl();
    }

    List<int> servicesList = FFAppState()
        .bookServices
        .split(RegExp(r'[\n,]'))
        .map((id) => int.tryParse(id.trim()) ?? 0)
        .where((id) => id != 0)
        .toList();

    // Debug print to check the parsed service list
    print('Parsed services list: $servicesList');

    // Employee name and picked time adjustments
    String? employee = employeeNumber;

    Map<String, String?> formattedTime = formatSelectedTime(selectedTime);
    String dateForThis;
    if (FFAppState().bookDate.isEmpty) {
      dateForThis = FFAppState().firstDayCalendar;
    } else {
      dateForThis = FFAppState().bookDate;
    }

    Map<String, String> formattedDates =
        formatDateTimeRange(selectedDateRange.cast<DateTime>());

    String pickedDateFrom = formattedDates['start']!;
    String pickedDateTo = formattedDates['end']!;
    String savedText = _controller.text;

    // Prepare the data payload
    Map<String, dynamic> payload = {
      'services': servicesList,
      'employee': employee,
      'date': dateForThis,
      'request_time_from': formattedTime[
          'from'], // Assuming these should match the formatted time
      'request_time_to': formattedTime['to'],
      'request_date_from': pickedDateFrom,
      'note': savedText,
      'request_date_to': pickedDateTo,
      'mode': mode, // Adjusted to reflect the required format
      'lang': 'hr',
      'online_payment': paymentMethod == "online" ? 1 : 0,
      'card': cardId, // Include the cardId in the payload
    };

    // Debug print to check the payload
    print('Payload: ${json.encode(payload)}');

    // Sending the POST request with the adjusted payload
    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(payload),
    );

    Map<String, dynamic> responseData = jsonDecode(response.body);

    if (responseData['code'] == 0 && responseData['order_url'] == null) {
      context.go('/ThankYou');
    } else if (paymentMethod == "online" &&
        cardId == null &&
        responseData['order_url'] != null) {
      String normalUrl = responseData['order_url'].replaceAll(r'\/', '/');
      FFAppState().OrderUrl = normalUrl;
      FFAppState().OrderId = responseData['order_id'];
      context.go("/orderNewCard");
    } else {
      customAlertDialogLogin(
          context, responseData['title'], responseData['text']);
      print("Error: ${response.body}");
    }
  }

  Map<String, String> formatDateTimeRange(List<DateTime> selectedDateRange) {
    // Initial return values in case of error
    Map<String, String> result = {
      'start': '',
      'end': '',
    };

    // Ensure there are exactly two dates in the range
    if (selectedDateRange.length != 2) {
      print('Error: Expected exactly two dates.');
      return result;
    }

    // Retrieve start and end dates from the range
    DateTime startDate =
        selectedDateRange[0]; // Assuming this is your original date
    DateTime newStartDate = startDate.add(Duration(hours: 1)); // Add one hour
    DateTime endDate = selectedDateRange[1];
    DateTime newEndDate = endDate.add(Duration(hours: 1));

    // Format the dates
    final dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.sss'Z'");

    // Since the example dates are in UTC, convert dates to UTC before formatting
    String formattedStartDate = dateFormat.format(newStartDate.toUtc());
    String formattedEndDate = dateFormat.format(newEndDate.toUtc());

    // Update result with formatted dates
    result = {
      'start': formattedStartDate,
      'end': formattedEndDate,
    };

    return result;
  }

  Map<String, String?> formatSelectedTime(String? selectedTime) {
    if (selectedTime == null || selectedTime == "Bilo koji") {
      return {'from': null, 'to': null};
    }

    Map<String, String> timeMappings = {
      "Ujutro (07-12h)": "07:00-12:00",
      "Popodne (12-17h)": "12:00-17:00",
      "Večer (17-20h)": "17:00-20:00",
    };

    // Splitting the mapped string into from and to times
    String? timeRange = timeMappings[selectedTime];
    if (timeRange != null) {
      var times = timeRange.split('-');
      return {'from': times[0], 'to': times[1]};
    }

    return {'from': null, 'to': null};
  }

  Future<void> updateServicePricesBasedOnUrlChanges() async {
    try {
      Uri currentUrl = Uri.parse(FFAppState().specialUrl);

      globalUrl.value = currentUrl.toString();
      final response = await http.get(currentUrl);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        List<Map<String, dynamic>> updatedServices = [];

        Map<String, dynamic>? booking = data['booking'] != null
            ? Map<String, dynamic>.from(data['booking'])
            : null;

        if (booking != null && booking['services'] is List) {
          List<dynamic> servicesData = booking['services'];

          servicesData.forEach((service) {
            String fullTitle =
                service['full_title']?.toString() ?? 'Unknown Service';
            String fullDuration =
                service['full_duration']?.toString() ?? 'Unknown Duration';
            String fullPrice = service['full_price']?.toString() ?? '0';
            String fullPriceFrom =
                service['full_price_from']?.toString() ?? '0';
            String fullPriceTo = service['full_price_to']?.toString() ?? '0';

            String priceDisplay;
            if (fullPriceFrom == fullPriceTo) {
              priceDisplay = '$fullPriceTo,00 €';
            } else {
              priceDisplay = '$fullPriceFrom,00 € - $fullPriceTo,00 €';
            }

            updatedServices.add({
              'full_title': fullTitle,
              'full_duration': fullDuration,
              'full_price_display': priceDisplay, // Adjusted key for clarity
              'full_price': fullPrice, // Original price, kept for reference
              'full_price_from':
                  fullPriceFrom, // Original from price, kept for reference
              'full_price_to':
                  fullPriceTo, // Original to price, kept for reference
            });
          });

          // Since setState() is specific to Flutter, ensure this update logic is placed correctly within your Flutter app context
          if (mounted) {
            setState(() {
              services = updatedServices;
              endPrice = booking['total_price'].toString();
              endPriceFrom = booking['total_price_from'].toString();
              endPriceTo = booking['total_price_to'].toString();
            });
          }
        }
      } else {
        print('Failed to fetch updated data based on URL changes');
      }
    } catch (e) {
      print('Error while updating service prices based on URL changes: $e');
    }
  }

  void _selectDate(BuildContext context) async {
    final List<DateTime>? pickedRange = await showDialog<List<DateTime>>(
      context: context,
      builder: (BuildContext context) {
        // Local state for the dialog
        List<DateTime> tempSelectedRange = List.from(selectedDateRange);

        bool firstMonth = true; // Initialize firstMonth variable
        bool lastMonth = false; // Initialize lastMonth variable

        return Theme(
          data: ThemeData.dark().copyWith(
            dialogBackgroundColor: Color(0xFF212529),
          ),
          child: AlertDialog(
            title: Text(
              'Raspon',
              style: TextStyle(color: Color(0xFFe4c87f), fontFamily: 'PT Sans'),
            ),
            content: Container(
              width: double.maxFinite,
              child: Localizations.override(
                context: context,
                locale: const Locale('hr'), // Croatian locale
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CalendarDatePicker2(
                          config: CalendarDatePicker2Config(
                            calendarType: CalendarDatePicker2Type.range,
                            firstDate: startDate,
                            lastMonthIcon: Icon(
                              Icons.chevron_left,
                              color: firstMonth
                                  ? Color(0xFFe4c87f).withOpacity(0.5)
                                  : Color(0xFFe4c87f),
                            ),
                            nextMonthIcon: Icon(
                              Icons.chevron_right,
                              color: lastMonth
                                  ? Color(0xFFe4c87f).withOpacity(0.5)
                                  : Color(0xFFe4c87f),
                            ),
                            lastDate: endForDate,
                            selectedDayHighlightColor: Color(0xFFe4c87f),
                            weekdayLabelTextStyle: TextStyle(
                              color: Color(0xFFe4c87f),
                              fontFamily: GoogleFonts.ptSans().fontFamily,
                            ),
                            selectedRangeHighlightColor: Color(0xFFe4c87f),
                            controlsTextStyle: TextStyle(
                              color: Color(0xFFe4c87f),
                              fontFamily: GoogleFonts.ptSans().fontFamily,
                            ),
                            centerAlignModePicker: true,
                            disabledDayTextStyle: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontFamily: GoogleFonts.ptSans().fontFamily,
                            ),
                            dayTextStyle: TextStyle(
                              color: Colors.white,
                              fontFamily: GoogleFonts.ptSans().fontFamily,
                            ),
                          ),
                          value: tempSelectedRange,
                          onValueChanged: (newDates) {
                            if (newDates != null && newDates.length <= 2) {
                              // Update the local state of the dialog
                              setState(() {
                                tempSelectedRange = newDates.cast<DateTime>();
                              });
                            }
                          },
                          onDisplayedMonthChanged: (newDate) {
                            // Update the local state of the dialog
                            setState(() {
                              int _currentDisplayedMonth =
                                  newDate.month; // newDate is a DateTime object
                              if (_currentDisplayedMonth == startDate.month) {
                                firstMonth = true;
                              } else {
                                firstMonth = false;
                              }

                              if (_currentDisplayedMonth == endForDate.month) {
                                lastMonth = true;
                              } else {
                                lastMonth = false;
                              }
                            });
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "Poništi",
                  style: TextStyle(
                    color: Color(0xFFe4c87f),
                    fontFamily: GoogleFonts.ptSans().fontFamily,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  "OK",
                  style: TextStyle(
                    color: Color(0xFFe4c87f),
                    fontFamily: GoogleFonts.ptSans().fontFamily,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(tempSelectedRange);
                },
              ),
            ],
          ),
        );
      },
    );

    if (pickedRange != null && pickedRange != selectedDateRange) {
      if (mounted) {
        setState(() {
          selectedDateRange = pickedRange;
        });
      }
    }
  }

  List<String> getTextsBasedOnMode(String? mode) {
    switch (mode) {
      case 'special':
        return ['Upit *', '* Želim poslati upit:'];
      case 'waiting':
        return ['Lista čekanja *', '* Želim se prijaviti na listu čekanja:'];
      case 'urgent':
        return ['Hitan termin *', '* Želim se prijaviti na hitni termin:'];
      default:
        // Provide more meaningful default texts if necessary
        return ['Default Title', 'Default Action Text'];
    }
  }

  Future<void> fetchAndExtractEmployeeId() async {
    try {
      final response = await http.get(Uri.parse(urlText));
      if (response.statusCode == 200) {
        Map<String, dynamic> data =
            jsonDecode(response.body); // Parse the JSON response
        var employees = data['availability']['employees'] as List<dynamic>;

        var selectedEmployee = employees.firstWhere(
          (employee) => employee['name'] == selectedEmployeeName,
          orElse: () => null,
        );

        if (selectedEmployee != null) {
        } else {}
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void updateUrlWithSelectedEmployee(String? selectedEmployeeId) {
    // If selectedEmployeeId is null, delete the employeeId from the URL
    if (selectedEmployeeId == null) {
      if (FFAppState().specialUrl.contains("?")) {
        // If the URL contains other parameters besides employee, remove only the employee parameter
        if (RegExp(r'&employee=\d+').hasMatch(FFAppState().specialUrl)) {
          FFAppState().specialUrl =
              FFAppState().specialUrl.replaceAll(RegExp(r'&employee=\d+'), '');
        } else if (RegExp(r'\?employee=\d+&')
            .hasMatch(FFAppState().specialUrl)) {
          // If employee parameter is at the beginning, remove it and ensure the next parameter now follows after ?
          FFAppState().specialUrl = FFAppState()
              .specialUrl
              .replaceAll(RegExp(r'\?employee=\d+&'), '?');
        } else {
          // If employee is the only parameter, remove it entirely, including the ?
          FFAppState().specialUrl =
              FFAppState().specialUrl.replaceAll(RegExp(r'\?employee=\d+'), '');
        }
      }
    } else {
      FFAppState().specialUrl =
          FFAppState().specialUrl.replaceAll(RegExp(r'&employee=\d+'), '');

      FFAppState().specialUrl += "&employee=$selectedEmployeeId";
    }

    updateServicePricesBasedOnUrlChanges();
  }

  void onSelectedEmployeeNameChanged(String? newValue) {
    if (newValue != null) {
      selectedEmployeeNameValue = newValue; // Update the selectedEmployeeName

      // Find the employee's ID from the list based on the employee's name
      String? selectedEmployeeId;
      for (var employeeNameId in employeeNamesAndIds) {
        if (employeeNameId.startsWith("$newValue -")) {
          // Extract the ID part after the " - " separator
          selectedEmployeeId = employeeNameId.split(" - ")[1];
          employeeNumber = selectedEmployeeId;
          break; // Exit the loop once the matching employee is found
        }
      }

      if (selectedEmployeeId != null) {
        updateUrlWithSelectedEmployee(selectedEmployeeId);
        // fetchDataAndUpdateState();
        FFAppState().bookEmployee = int.parse(selectedEmployeeId);
      } else {
        // Handle the case where an ID for the selected name wasn't found
        selectedEmployeeId = null;
        employeeNumber = '';
        FFAppState().bookEmployee = 0;
        updateUrlWithSelectedEmployee(selectedEmployeeId);
      }
    }
  }

  void _handlePaymentMethodChange(bool onlinePaymentSelected) {
    setState(() {
      onlinePaymentChecked = onlinePaymentSelected;
      storePaymentChecked = !onlinePaymentSelected;
      paymentMethod = onlinePaymentSelected ? "online" : "store";
      if (!onlinePaymentSelected) {
        selectedCard = null;
        cardId = null;
      } else {
        selectedCard = cards.firstWhere(
          (card) => card['enabled'] && card['id'] != 'add_new',
          orElse: () => {
            'id': 'add_new',
            'name': 'Dodaj Novu karticu',
            'number': '',
            'expiration_date': '',
            'icon': '',
            'isDefault': false,
            'enabled': true,
          },
        );
        cardId = selectedCard!['id'] != 'add_new' ? selectedCard!['id'] : null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: SpinKitCircle(
          color: Color(0xFFE4C87F),
          size: 50.0,
        ),
      );
    }
    bool isAddNewSelected =
        selectedCard != null && selectedCard!['id'] == 'add_new';
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Color(0xFF343A40), // Blue container
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.transparent, width: 2.0),
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0), // Added padding here
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Text(
                  'Odabrane usluge',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                    fontFamily: GoogleFonts.ptSerif().fontFamily,
                  ),
                ),
              ),
              Divider(
                thickness: 1,
                color: Color(0xFF454d55),
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Termin: ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: GoogleFonts.ptSans().fontFamily,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            firstText ?? '',
                            style: TextStyle(
                              color: Color(0xFFdc3545),
                              fontWeight: FontWeight.bold,
                              fontFamily: GoogleFonts.ptSans().fontFamily,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  'Barber:',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.ptSans().fontFamily,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(16),
                                          bottomRight: Radius.circular(0),
                                          topLeft: Radius.circular(16),
                                          topRight: Radius.circular(0),
                                        ),
                                        border: Border.all(
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.badge,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 0),
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(16.0),
                                              bottomRight:
                                                  Radius.circular(16.0),
                                            ),
                                            color: Colors.white,
                                            border: Border.all(
                                              color: Colors.white,
                                              style: BorderStyle.solid,
                                              width: 3,
                                            ),
                                          ),
                                          child: DropdownButton<String>(
                                            dropdownColor: Colors.white,
                                            value: selectedEmployeeName,
                                            icon: Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              color: Colors.black,
                                              size: 24,
                                            ),
                                            onChanged: (newValue) {
                                              if (mounted) {
                                                setState(() {
                                                  selectedEmployeeName =
                                                      newValue!;
                                                  onSelectedEmployeeNameChanged(
                                                      newValue);
                                                });
                                              }
                                            },
                                            items: employeeNames
                                                .map((String name) {
                                              return DropdownMenuItem<String>(
                                                value: name,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(width: 10),
                                                    Text(
                                                      name,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF212529),
                                                        fontFamily:
                                                            GoogleFonts.ptSans()
                                                                .fontFamily,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                            isExpanded: true,
                                            underline: Container(height: 0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            'U rasponu:',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontFamily: GoogleFonts.ptSans().fontFamily,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(0),
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(0),
                                  ),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                ),
                                child: Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 0),
                                  child: InkWell(
                                    onTap: () => _selectDate(context),
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(16.0),
                                          bottomRight: Radius.circular(16.0),
                                        ),
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.white,
                                          style: BorderStyle.solid,
                                          width: 3,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              width:
                                                  10), // Adjust spacing as needed
                                          Text(
                                            selectedDateRange[0] != null &&
                                                    selectedDateRange[1] != null
                                                ? "${selectedDateRange[0]!.day}-${selectedDateRange[0]!.month}-${selectedDateRange[0]!.year} do ${selectedDateRange[1]!.day}-${selectedDateRange[1]!.month}-${selectedDateRange[1]!.year}"
                                                : "Select Date Range",
                                            style: TextStyle(
                                              color: Color(0xFF212529),
                                              fontFamily: GoogleFonts.ptSans()
                                                  .fontFamily,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            'U vrijeme:',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontFamily: GoogleFonts.ptSans().fontFamily,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(0),
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(0),
                                  ),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                ),
                                child: Icon(
                                  Icons.lock_clock_outlined,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 0),
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(16.0),
                                        bottomRight: Radius.circular(16.0),
                                      ),
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.white,
                                        style: BorderStyle.solid,
                                        width: 3,
                                      ),
                                    ),
                                    child: DropdownButton<String>(
                                      dropdownColor: Colors.white,
                                      value: selectedTime,
                                      icon: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: Colors.black,
                                        size: 24,
                                      ),
                                      onChanged: (newValue) {
                                        if (mounted) {
                                          setState(() {
                                            selectedTime = newValue!;
                                          });
                                        }
                                      },
                                      items: employeeTimes.map((String time) {
                                        return DropdownMenuItem<String>(
                                          value: time,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(width: 10),
                                              Text(
                                                time,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Color(0xFF212529),
                                                  fontFamily:
                                                      GoogleFonts.ptSans()
                                                          .fontFamily,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                      isExpanded: true,
                                      underline: Container(
                                          height: 0), // Removes the underline
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFF454d55), // <--- border color
                    width: 1.0,
                  ),
                ),
              ),
              Table(
                columnWidths: {
                  0: FlexColumnWidth(3),
                  1: IntrinsicColumnWidth(),
                  2: IntrinsicColumnWidth(),
                },
                children: [
                  ...services.map((service) {
                    int index = services.indexOf(service);

                    return TableRow(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFF454d55),
                          ),
                        ),
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 20, top: 12, bottom: 12, right: 20),
                          child: Text(
                            service['full_title']!,
                            style: TextStyle(
                              fontFamily: GoogleFonts.ptSans().fontFamily,
                              color: Colors.white,
                              fontSize: 14.8,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 20, top: 12, bottom: 12, right: 20),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              service['full_duration']! + ' min',
                              style: TextStyle(
                                fontFamily: GoogleFonts.ptSans().fontFamily,
                                color: Colors.white,
                                fontSize: 14.8,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 20, top: 12, bottom: 12, right: 20),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              employeeNumber.isEmpty
                                  ? (service['full_price_from'] ==
                                          service['full_price_to']
                                      ? service['full_price_to']! + ',00 €'
                                      : service['full_price_from']! +
                                          ',00 € - ' +
                                          service['full_price_to']! +
                                          ',00 €')
                                  : service['full_price']! + ',00 €',
                              style: TextStyle(
                                fontFamily: GoogleFonts.ptSans().fontFamily,
                                color: Colors.white,
                                fontSize: 14.8,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 20, top: 12, bottom: 12, right: 20),
                        child: Text(
                          'UKUPNO',
                          style: TextStyle(
                            fontFamily: GoogleFonts.ptSans().fontFamily,
                            color: Color(0xFFe4c87f),
                            fontSize: 14.8,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 20, top: 12, bottom: 12, right: 20),
                        child: Text(
                          '$endDuration min', // Define endDuration
                          style: TextStyle(
                            fontFamily: GoogleFonts.ptSans().fontFamily,
                            color: Color(0xFFe4c87f),
                            fontSize: 14.8,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 20, top: 12, bottom: 12, right: 20),
                        child: Text(
                          employeeNumber.isEmpty
                              ? (endPriceFrom == endPriceTo
                                  ? '$endPriceTo,00 €' // Define endPriceTo
                                  : '$endPriceFrom,00 € - $endPriceTo,00 €') // Define endPriceFrom
                              : '$endPrice,00 €', // Define endPrice
                          style: TextStyle(
                            fontFamily: GoogleFonts.ptSans().fontFamily,
                            color: Color(0xFFe4c87f),
                            fontSize: 14.8,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                child: Text(
                  'Napomena',
                  style: TextStyle(
                    fontFamily: GoogleFonts.ptSans().fontFamily,
                    color: Colors.white,
                    fontSize: 14.8,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // White background color
                    borderRadius: BorderRadius.circular(
                        10.0), // Adjust the value for the desired curve
                  ),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      border: InputBorder.none, // No border
                      contentPadding:
                          EdgeInsets.all(16.0), // Padding inside the TextField
                    ),
                    style: TextStyle(
                      fontFamily: GoogleFonts.ptSans().fontFamily,
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    cursorColor: Colors.black,
                    maxLines: null, // Allow the TextField to expand vertically
                    minLines: 3,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                child: Text(
                  'Izaberi Način plaćanja:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: GoogleFonts.ptSans().fontFamily,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Column(
                children: [
                  InkWell(
                    onTap: () => _handlePaymentMethodChange(true),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: RoundCheckbox(
                            value: onlinePaymentChecked,
                            onChanged: (value) {
                              _handlePaymentMethodChange(value);
                            },
                            activeColor: Colors.transparent,
                            fillColor: Colors.transparent,
                            colorNew: onlinePaymentChecked
                                ? Color(0xFFE4C87F)
                                : Colors.white,
                            width: 20,
                            height: 20,
                          ),
                        ),
                        Text(
                          'Plaćanje online',
                          style: TextStyle(
                            color: onlinePaymentChecked
                                ? Color(0xFFE4C87F)
                                : Colors.white,
                            fontSize: 16,
                            fontFamily: GoogleFonts.ptSans().fontFamily,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  if (paymentMethod == "online")
                    Column(
                      children: [
                        ...cards.map((card) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 16.0), // Added margin here
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
                              onTap: () => _handleCardSelection(card),
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
                                    Opacity(
                                      opacity: card['enabled'] ? 1.0 : 0.5,
                                      child: Text(
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
                                    ),
                                    const SizedBox(width: 10),
                                    Opacity(
                                      opacity: card['enabled'] ? 1.0 : 0.5,
                                      child: Text(
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
                                    ),
                                    const SizedBox(width: 10),
                                    Opacity(
                                      opacity: card['enabled'] ? 1.0 : 0.5,
                                      child: Text(
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
                                    ),
                                    Spacer(),
                                    if (selectedCard != null &&
                                        selectedCard!['id'] == card['id'])
                                      Icon(
                                        Icons.check,
                                        color: Colors.black,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 16.0), // Added margin here
                          decoration: BoxDecoration(
                            color: selectedCard != null &&
                                    selectedCard!['id'] == 'add_new'
                                ? Color(0xFFE4C87F)
                                : Colors.transparent,
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
                                    'Dodaj Novu karticu i rezerviraj',
                                    style: TextStyle(
                                      color: selectedCard != null &&
                                              selectedCard!['id'] == 'add_new'
                                          ? Colors.black
                                          : Colors.white,
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
                                      color: Colors.black,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 16),
                  InkWell(
                    onTap: () => _handlePaymentMethodChange(false),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: RoundCheckbox(
                            value: storePaymentChecked,
                            onChanged: (value) {
                              _handlePaymentMethodChange(!value);
                            },
                            activeColor: Colors.transparent,
                            fillColor: Colors.transparent,
                            colorNew: storePaymentChecked
                                ? Color(0xFFE4C87F)
                                : Colors.white,
                            width: 20,
                            height: 20,
                          ),
                        ),
                        Text(
                          'Plaćanje u trgovini',
                          style: TextStyle(
                            color: storePaymentChecked
                                ? Color(0xFFE4C87F)
                                : Colors.white,
                            fontSize: 16,
                            fontFamily: GoogleFonts.ptSans().fontFamily,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              if (!isAddNewSelected)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: MouseRegion(
                        child: ElevatedButton(
                          onPressed: () {
                            sendBookingDataAdjusted();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFE4C87F),
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 48),
                            side: BorderSide(
                              color: Color(0xFFE4C87F),
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            child: Text(
                              'REZERVIRAJ',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF212529),
                                fontFamily: GoogleFonts.ptSans().fontFamily,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
