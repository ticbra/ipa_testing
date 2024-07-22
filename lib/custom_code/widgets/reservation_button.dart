// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'global.dart';
import '/app_state.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';

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

class ReservationButton extends StatefulWidget {
  const ReservationButton({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _ReservationButtonState createState() => _ReservationButtonState();
}

class _ReservationButtonState extends State<ReservationButton>
    with WidgetsBindingObserver {
  String appointmentTime = '';
  String startValue = '';
  String startTime = '';
  String wholeDate = '';
  String endTime = '';
  String employeeName = '';
  String employeeImage = '';
  List<Map<String, dynamic>> services = [];
  String endDuration = '';
  String endPrice = '';
  String endPriceFrom = '';
  String endPriceTo = '';
  String employeeNumber = "";
  DateTime? selectedDate;
  List<String> employeeTimes = [];
  String selectedTime = "Bilo koji";
  List<DateTime> selectedDateRange = [
    DateTime.now(),
    DateTime.now().add(Duration(days: 1)),
  ];
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  DateTime endForDate = DateTime.now();
  String? mode = "";
  String? firstText = "";
  String? secondText = "";
  DateTime wholeDateObj = DateTime.now();
  String dateNew = "";
  bool isLoading = true;
  List<Map<String, dynamic>> cards = [];
  Map<String, dynamic>? selectedCard;
  String? cardId;

  bool onlinePaymentChecked = true; // Set online payment as default
  bool storePaymentChecked = false;

  String paymentMethod = "online";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    FFAppState().availableEmployeeReg = false;
    _fetchDataFromUrl();
    _fetchCardsData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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

  Future<List<Map<String, dynamic>>> fetchJsonDataNew(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['availability']['employees']);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<bool> isEmployeeAvailable(
      String url, String employeeIdentifier) async {
    try {
      List<Map<String, dynamic>> availableEmployees =
          await fetchJsonDataNew(url);
      return availableEmployees
          .any((employee) => employee['id'] == employeeIdentifier);
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<int> getDefaultEmployeeId() async {
    try {
      List<Map<String, dynamic>> employees =
          await fetchJsonDataNew(globalUrl.value);

      var availableEmployees = employees
          .where((e) => e['disabled'] == false && e.containsKey('id'))
          .toList();

      if (availableEmployees.isNotEmpty) {
        return availableEmployees.first['id'];
      } else {
        return 123;
      }
    } catch (e) {
      print('Error fetching employee data: $e');
      return 123;
    }
  }

  void _fetchDataFromUrl() async {
    try {
      await fetchDataFromUrl();
    } catch (error) {
      print('Failed to fetch data: $error');
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
      sendBookingData();
    }
  }

  void _initializeAndSyncServices() {
    // Extract services from the globalUrl
    final Uri uri = Uri.parse(globalUrl.value);
    print("Global URL: " + globalUrl.value);

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

  Future<void> _sendBookingsData(String bookings) async {
    final base_url = domenString + '/mobile-app/api/v1/user/availability';

    final bookingLines = bookings.split('\n');
    String user_token = FFAppState().token;
    Map<String, String> queryParameters = {};
    String newDefinition;
    String newDate;
    String newTime;

    for (var line in bookingLines) {
      final parts = line.split(': ');
      if (parts.length == 2 && parts[0] != 'services[]') {
        queryParameters[parts[0]] = parts[1];
      }
    }

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
      queryParameters['date'] = newDate;
    }

    newTime = FFAppState().bookTime;
    if (FFAppState().bookDate.isNotEmpty) {
      if (!queryParameters.containsKey('time')) {
        queryParameters['time'] = newTime;
      }
    }

    _initializeAndSyncServices();

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
    uriWithServices.write('&lang=hr');
    uriWithServices.write('&date=${Uri.encodeComponent(newDate)}');
    uriWithServices.write('&time=${Uri.encodeComponent(newTime)}');
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
      } else if (FFAppState().availableEmployeeReg) {
        newDefinition = 'Trajanje: $duration min\nCijena: $totalPrice €';
      } else {
        newDefinition = 'Trajanje: $duration min\nCijena: $totalPrice €';
      }

      globalUrl.value = uriWithServices.toString();
      globalDurationTime.value = bookingDataMap['duration'];
      globalOutputNotifier.value = newDefinition;
    }
  }

  Future<void> fetchDataFromUrl() async {
    try {
      RegExp employeeRegEx = RegExp(r"[?&]employee=(\d+)");
      var match = employeeRegEx.firstMatch(globalUrl.value);
      if (FFAppState().countAvailableEmployees == 1 && match == null) {
        FFAppState().availableEmployeeReg = true;
      }
      if (!FFAppState().availableEmployeeReg) {
        employeeNumber = FFAppState().bookEmployee.toString();
      } else {
        if (match == null) {
          int defaultEmployeeId = await getDefaultEmployeeId();

          String id = defaultEmployeeId.toString();
          employeeNumber = id;
          FFAppState().bookEmployee = defaultEmployeeId;

          if (globalUrl.value.contains("?")) {
            globalUrl.value += "&employee=" + id;
          } else {
            globalUrl.value += "?employee=" + id;
          }

          _sendBookingsData(FFAppState().bookings);
        }
      }

      final String url = globalUrl.value;
      Uri uri = Uri.parse(url);

      final response = await http.get(uri);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        Map<String, dynamic> booking =
            Map<String, dynamic>.from(data['booking']);
        var employees = data['availability']['employees'] as List<dynamic>;

        String appointmentTimeNew = booking['appointment_time'] ?? 'null';
        String startHour = booking['start_time'] ?? 'null';
        String endHour = booking['end_time'] ?? 'null';
        String barberName = booking['employee_name'] ?? 'null';
        String barberImage = booking['employee_image'] ?? 'null';

        List<dynamic> servicesData = booking['services'];
        String fullDuration = booking['duration'].toString();
        String fullPrice = booking['total_price'].toString();
        String fullPriceFrom = booking['total_price_from'].toString();
        String fullPriceTo = booking['total_price_to'].toString();
        DateTime bookingDate = DateTime.parse(booking['date']);
        String formattedDate = DateFormat('dd.MM.yyyy').format(bookingDate);
        String formattedDateNew = DateFormat('yyyy-MM-dd').format(bookingDate);

        // Add debug print statements to check for null values
        print('appointmentTimeNew: $appointmentTimeNew');
        print('startHour: $startHour');
        print('endHour: $endHour');
        print('barberName: $barberName');
        print('barberImage: $barberImage');
        print('fullDuration: $fullDuration');
        print('fullPrice: $fullPrice');
        print('fullPriceFrom: $fullPriceFrom');
        print('fullPriceTo: $fullPriceTo');
        print('formattedDate: $formattedDate');
        print('formattedDateNew: $formattedDateNew');

        setState(() {
          appointmentTime = appointmentTimeNew;
          startTime = startHour;
          endTime = endHour;
          employeeName = barberName;
          employeeImage = barberImage;
          wholeDate = formattedDate;
          dateNew = formattedDateNew;
          services = servicesData.map((service) {
            return {
              'full_title': service['full_title'],
              'full_duration': service['full_duration'].toString(),
              'full_price': service['full_price'].toString(),
              'full_price_from': service['full_price_from'].toString(),
              'full_price_to': service['full_price_to'].toString(),
            };
          }).toList();
          endDuration = fullDuration;
          endPrice = fullPrice;
          endPriceFrom = fullPriceFrom;
          endPriceTo = fullPriceTo;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String convertEscapedUrl(String escapedUrl) {
    return escapedUrl.replaceAll(r'\/', '/');
  }

  Future<void> sendBookingData() async {
    String user_token = FFAppState().token;
    String endpoint = domenString + '/mobile-app/api/v1/user/$user_token/book';

    final servicesList = FFAppState()
        .bookServices
        .split(RegExp(r'[\n,]'))
        .where((service) => service.trim().isNotEmpty)
        .toList();

    Map<String, dynamic> payload = {
      'services': servicesList,
      'employee': FFAppState().bookEmployee,
      'time': FFAppState().bookTime,
      'date': dateNew,
      'lang': "hr",
      'online_payment': paymentMethod == "online" ? 1 : 0,
    };

    if (paymentMethod == "online" && cardId != null) {
      payload['card'] = cardId;
    }

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(payload),
    );

    Map<String, dynamic> responseData = jsonDecode(response.body);

    if (responseData['code'] == 0 && responseData['order_url'] == null) {
      context.push('/ThankYou');
    } else if (paymentMethod == "online" &&
        cardId == null &&
        responseData['order_url'] != null) {
      String normalUrl = responseData['order_url'].replaceAll(r'\/', '/');
      FFAppState().OrderUrl = normalUrl;
      FFAppState().OrderId = responseData['order_id'];
      context.push("/orderNewCard");
    } else {
      customAlertDialogLogin(
          context, responseData['title'], responseData['text']);
      print("Error: ${response.body}");
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

    // Determine if only the "addNew" card is available
    bool isAddNewSelected =
        selectedCard != null && selectedCard!['id'] == 'add_new';

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Color(0xFF343A40),
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.transparent, width: 2.0),
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Odabrane usluge',
                  style: TextStyle(
                    fontFamily: GoogleFonts.ptSerif().fontFamily,
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Divider(
                thickness: 1,
                color: Color(0xFF454d55),
              ),
              SizedBox(height: 0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: 16, bottom: 16, left: 15, right: 15),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Termin: ',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.8,
                                fontFamily: 'PT Sans'),
                          ),
                          TextSpan(
                            text: appointmentTime,
                            style: TextStyle(
                                color: Color(0xFFE4C87F),
                                fontSize: 14.8,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'PT Sans'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 16, left: 15, right: 15),
                    child: Row(
                      children: [
                        Text(
                          'Barber: ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.8,
                            fontFamily: 'PT Sans',
                          ),
                        ),
                        const SizedBox(width: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.network(
                            employeeImage,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          employeeName,
                          style: TextStyle(
                            color: Color(0xFFE4C87F),
                            fontSize: 14.8,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'PT Sans',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFF454d55),
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          child: Text(
                            service['full_title']!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: GoogleFonts.ptSans().fontFamily,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              service['full_duration']! + ' min',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: GoogleFonts.ptSans().fontFamily,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
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
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: GoogleFonts.ptSans().fontFamily,
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Text(
                          'UKUPNO',
                          style: TextStyle(
                            color: Color(0xFFe4c87f),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.ptSans().fontFamily,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Text(
                          '$endDuration min',
                          style: TextStyle(
                            color: Color(0xFFe4c87f),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.ptSans().fontFamily,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Text(
                          employeeNumber.isEmpty
                              ? (endPriceFrom == endPriceTo
                                  ? '$endPriceTo,00 €'
                                  : '$endPriceFrom,00 € - $endPriceTo,00 €')
                              : '$endPrice,00 €',
                          style: TextStyle(
                            color: Color(0xFFe4c87f),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.ptSans().fontFamily,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 16, right: 16, left: 16),
                child: Text(
                  "* Cijene usluga navedene su sukladno važećem cjeniku. Zadržavamo pravo promjene cijena bez prethodne najave.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontFamily: GoogleFonts.ptSans().fontFamily,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                child: Text(
                  'Napomena:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: GoogleFonts.ptSans().fontFamily,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16.0),
                    ),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: GoogleFonts.ptSans().fontFamily,
                    ),
                    cursorColor: Colors.black,
                    maxLines: null,
                    minLines: 3,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                child: Text(
                  'Odaberi Način plaćanja:',
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
                            sendBookingData();
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
                ),
            ],
          ),
        ),
      ),
    );
  }
}
