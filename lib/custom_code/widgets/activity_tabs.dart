// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async'; // Import the Timer package

import 'global.dart';

import 'package:gentlemens_shop/backend/api_requests/api_calls.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gentlemens_shop/components/reservation_detail_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

class ActivityTabs extends StatefulWidget {
  final double? width;
  final double? height;
  final String category; // Category passed when creating an instance

  const ActivityTabs(
      {Key? key, this.width, this.height, required this.category})
      : super(key: key);

  @override
  _ActivityTabsState createState() => _ActivityTabsState();
}

class _ActivityTabsState extends State<ActivityTabs>
    with WidgetsBindingObserver {
  Future? loadDataFuture;
  Timer? _timer; // Define a Timer
  Map<String, int> counts = {};
  Map<String, List<String>> bookingDetails = {};
  Map<String, List<String>> bookingNames = {};
  Map<String, List<String>> bookingDurations = {};
  Map<String, List<String>> bookingPrices = {};
  Map<String, List<String>> employeeNames = {};
  Map<String, List<String>> employeeImgUrls = {};
  Map<String, List<String>> bookingIds = {}; // Added for handling booking IDs
  Map<String, List<String>> notificationIds =
      {}; // Added for handling notification IDs
  Map<String, List<Map<String, dynamic>>> notifications =
      {}; // Added for handling notification details
  Map<String, List<DateTime?>> bookingCancelUntil =
      {}; // Added for cancel_until datetimes
  Map<String, List<bool>> bookingCanBeCancelled =
      {}; // Added for cancellation checks
  String title = "Obavijesti";
  String text = "Želite li obrisati obavijest? ";

  final Map<String, String> tabContent = {
    'next': 'Tvoja sljedeća rezervacija',
    'booking': 'Rezervacije',
    'special': 'Upiti za tehničke usluge',
    'waiting': 'Zahtjevi za listu čekanja',
    'urgent': 'Zahtjevi za hitan termin',
    'history': 'Povijest rezervacija',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadDataFuture = fetchData(widget.category);
    fetchNotifications();
    _timer = Timer.periodic(
        Duration(minutes: 5), (Timer t) => reloadWidget()); // Set the timer
  }

  void reloadWidget() {
    setState(() {
      loadDataFuture = fetchData(widget.category);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // App has come to the foreground, refresh data
      fetchData(widget.category);
      fetchNotifications();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Called when the widget is first created and when it is rebuilt
    fetchData(widget.category);
    fetchNotifications();
  }

  Future<void> fetchData(String category) async {
    final String token = FFAppState().token;
    final String url =
        domenString + '/mobile-app/api/v1/user/$token/bookings?type=$category';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> bookings = jsonDecode(response.body);
      setState(() {
        counts[category] = bookings.length;
        bookingDetails[category] = bookings
            .map<String>((b) => b['appointment_time'] ?? 'N/A')
            .toList();
        bookingNames[category] =
            bookings.map<String>((b) => b['name'] ?? 'N/A').toList();
        bookingDurations[category] = bookings
            .map<String>((b) => b['duration']?.toString() ?? 'N/A')
            .toList();
        bookingPrices[category] = bookings
            .map<String>((b) => b['price']?.toString() ?? 'N/A')
            .toList();
        employeeNames[category] =
            bookings.map<String>((b) => b['employee_name'] ?? 'N/A').toList();
        employeeImgUrls[category] =
            bookings.map<String>((b) => b['employee_image'] ?? 'N/A').toList();
        bookingIds[category] = bookings
            .map<String>((b) => b['id'].toString())
            .toList(); // Collecting IDs

        // Adding cancel_until to the map and checking if it is before now
        bookingCancelUntil[category] = bookings
            .map<DateTime?>((b) => b['cancel_until'] != null
                ? DateTime.parse(b['cancel_until'])
                : null)
            .toList();
        bookingCanBeCancelled[category] = bookings
            .map<bool>((b) => b['cancel_until'] != null
                ? isCancelUntilAfterNow(b['cancel_until'])
                : false)
            .toList();
      });
    } else {
      throw Exception(
          'Failed to fetch bookings. Status code: ${response.statusCode}');
    }
  }

  Future<void> AlertDialogForCloseButton(BuildContext context, String title,
      String text, int notificationId) async {
    showDialog(
      context:
          context, // This is necessary for locating the dialog within the widget tree.
      builder: (alertDialogContext) {
        // Builder provides a context used to navigate or style the dialog.
        return AlertDialog(
          backgroundColor:
              const Color(0xFF212529), // Custom dark background color
          title: Text(
            title, // Dynamic title based on function parameter.
            style: const TextStyle(color: Colors.white), // Title text in white
          ),
          content: Text(
            text, // Dynamic text based on function parameter.
            style:
                const TextStyle(color: Colors.white), // Content text in white
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Perform the PUT request here
                _markNotificationAsRead(notificationId);
                Navigator.pop(alertDialogContext); // Close the dialog
              },
              child: Text(
                'Ok', // Button text, could be made dynamic if needed.
                style: const TextStyle(
                  color:
                      const Color(0xFFE4C87F), // Custom gold color for the text
                ),
              ),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pop(alertDialogContext), // Closes the dialog.
              child: Text(
                'Poništi', // Button text, could be made dynamic if needed.
                style: const TextStyle(
                  color: const Color(0xFFE4C87F), // Custom color for the text
                ),
              ),
            ),
          ],
        );
      },
    );
  }

// Function to perform the PUT request to mark notification as read
  Future<void> _markNotificationAsRead(int notificationId) async {
    await PutNotificationCall.call(
      token: FFAppState().token,
      id: notificationId,
    );
    fetchData(widget.category);
    fetchNotifications();
  }

  bool isCancelUntilAfterNow(String cancelUntil) {
    DateTime cancelUntilDate = DateTime.parse(cancelUntil);
    DateTime now = DateTime.now();

    // Extract only the date and time parts for comparison
    String cancelUntilDateStr = cancelUntilDate.toString().substring(0, 16);
    String nowStr = now.toString().substring(0, 16);

    return DateTime.parse(cancelUntilDateStr).isAfter(DateTime.parse(nowStr));
  }

  Future<void> fetchNotifications() async {
    final String token = FFAppState().token;
    final String url =
        domenString + '/mobile-app/api/v1/user/$token/notifications';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> notificationData = jsonDecode(response.body);
      setState(() {
        notificationIds['new'] = [];
        notifications['new'] = [];
        for (final notification in notificationData) {
          notificationIds['new']!.add(notification['id'].toString());
          notifications['new']!.add({
            'id': notification['id'],
            'action': notification['action'],
            'subject': notification['subject'],
            'message': notification['message'],
            'created': notification['created'],
            'timestamp': notification['timestamp'],
            'created_time': notification['created_time'],
          });
        }
      });
    } else {
      throw Exception(
          'Failed to fetch notifications. Status code: ${response.statusCode}');
    }
  }

  Future<void> showCancelReservationDialog(
      BuildContext context, String bookingId) async {
    showDialog(
      context: context,
      builder: (alertDialogContext) {
        return AlertDialog(
          backgroundColor:
              const Color(0xFF212529), // Custom dark background color
          title: const Text(
            'Želite li otkazati rezervaciju?',
            style: TextStyle(color: Colors.white), // Title text in white
          ),
          content: const Text(
            'Rezervaciju je potrebno otkazati najkasnije 3 sata prije zakazanog termina kako bi se izbjeglo naplaćivanje usluge.',
            style: TextStyle(color: Colors.white), // Content text in white
          ),
          actions: [
            TextButton(
              onPressed: () async {
                var response = await DeleteReservationCall.call(
                  userToken: FFAppState().token,
                  id: bookingId,
                );

                if (response.statusCode == 204) {
                  Navigator.pop(alertDialogContext); // Close the dialog

                  // Reload the current page
                  fetchData(widget.category);
                } else {
                  print('Failed to delete the reservation');
                }
              },
              child: const Text(
                'Ok',
                style: TextStyle(
                  color: Color(0xFFE4C87F), // Custom gold color for the text
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(alertDialogContext); // Close the dialog
              },
              child: const Text(
                'Poništi',
                style: TextStyle(
                  color: Color(
                      0xFFE4C87F), // Custom color for the cancel button text
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SpinKitCircle(
              color: Color(0xFFE4C87F),
              size: 50.0,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        double paddingValue = (counts[widget.category] == 0 &&
                (widget.category == 'next' || widget.category == 'booking'))
            ? 0
            : 20;
        // Data is loaded, build the UI
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(paddingValue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((counts[widget.category] ?? 0) > 0)
                  Center(
                    // Wrap with Center widget to align text center
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: tabContent[widget.category] ?? "Default Text",
                            style: TextStyle(
                              fontFamily: GoogleFonts.ptSerif().fontFamily,
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          if (["urgent", "waiting", "special", "booking"]
                              .contains(widget.category))
                            TextSpan(
                              text: " (${counts[widget.category] ?? 0})",
                              style: TextStyle(
                                fontFamily: GoogleFonts.ptSerif().fontFamily,
                                color: Color(0xFF6c757d),
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                if (counts[widget.category] == 0 &&
                    (widget.category == 'next' || widget.category == 'booking'))
                  Container(
                    width: double.infinity,
                    height: MediaQuery.sizeOf(context).height * 0.75,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          domenString + '/images/cover-mobile.webp',
                        ),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 40, left: 20, right: 20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Barbers No1 in Rijeka',
                                  style: TextStyle(
                                    fontFamily:
                                        GoogleFonts.ptSerif().fontFamily,
                                    color: Colors.white,
                                    fontSize: 28,
                                  ),
                                ),
                                SizedBox(
                                    height:
                                        20), // Razmak između teksta i dugmeta
                                ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      FFAppState().bookings = '';
                                      FFAppState().bookServices = '';
                                      FFAppState().bookServicesList = [];
                                      FFAppState().bookTime = '0';
                                      FFAppState().bookEmployee = 0;
                                      FFAppState().boolSyncDate = false;
                                    });
                                    context.pushNamed('Reservation');
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
                                      'REZERVIRAJ TERMIN',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF212529),
                                        fontFamily:
                                            GoogleFonts.ptSans().fontFamily,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 10),
                if (counts[widget.category] != null &&
                    counts[widget.category]! > 0)
                  ...List.generate(
                    counts[widget.category] ?? 0,
                    (index) => buildBookingInfo(widget.category, index),
                  ),
                if (widget.category == 'next' &&
                    notifications['new'] != null &&
                    notifications['new']!.isNotEmpty)
                  Center(
                    // Wrap with Center widget to align text center
                    child: Text(
                      'Obavijesti',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: GoogleFonts.ptSerif().fontFamily,
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                if (widget.category == 'next' &&
                    notifications['new'] != null &&
                    notifications['new']!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...List.generate(
                        notifications['new']!.length,
                        (index) => buildBookingInfoNext(index),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildBookingInfo(String category, int index) {
    return Column(
      children: [
        SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF343A40),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bookingDetails[category]![index],
                style: TextStyle(
                  fontFamily: GoogleFonts.ptSans().fontFamily,
                  color: Color(0xFFe4c87f),
                  fontSize: 16,
                ),
              ),
              Divider(
                thickness: 1,
                color: Color(0xFF454d55),
              ),
              SizedBox(height: 8),
              Text(
                bookingNames[category]![index],
                style: TextStyle(
                  fontFamily: GoogleFonts.ptSans().fontFamily,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 8),
              if (employeeImgUrls[category]![index] != 'N/A' &&
                  employeeImgUrls[category]![index].isNotEmpty)
                Row(
                  children: [
                    ClipOval(
                      child: Image.network(
                        employeeImgUrls[category]![index],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Barber: ${employeeNames[category]![index]}",
                      style: TextStyle(
                        fontFamily: GoogleFonts.ptSans().fontFamily,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.white),
                  SizedBox(width: 4),
                  Text(
                    bookingDurations[category]![index],
                    style: TextStyle(
                      fontFamily: GoogleFonts.ptSans().fontFamily,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 16),
                  if (int.tryParse(bookingPrices[category]![index]) != null &&
                      int.tryParse(bookingPrices[category]![index]) != 0)
                    Row(
                      children: [
                        Icon(Icons.euro, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          bookingPrices[category]![index],
                          style: TextStyle(
                            fontFamily: GoogleFonts.ptSans().fontFamily,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              SizedBox(height: 20), // Space before the button
              if (["next", "booking", "history"]
                  .contains(category)) // Button for specific categories
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        String id = bookingIds[category]![index];
                        FFAppState().reservationId = int.parse(id);
                        await showDialog(
                          context: context,
                          builder: (dialogContext) {
                            return Dialog(
                              elevation: 0,
                              insetPadding: EdgeInsets.zero,
                              backgroundColor: Colors.transparent,
                              alignment: const AlignmentDirectional(0.0, 0.0)
                                  .resolve(Directionality.of(context)),
                              child: const ReservationDetailWidget(),
                            );
                          },
                        ).then((value) => setState(() {}));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF343A40),
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        side: BorderSide(color: Color(0xFFE4C87F), width: 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        'Detalji rezervacije',
                        style: TextStyle(
                          fontFamily: GoogleFonts.ptSans().fontFamily,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFE4C87F),
                        ),
                      ),
                    ),
                    if (["next", "booking"].contains(category) &&
                        (bookingCancelUntil[category]?[index] == null ||
                            bookingCanBeCancelled[category]![index]))
                      ElevatedButton(
                        onPressed: () async {
                          String id = bookingIds[category]![index];
                          FFAppState().reservationId = int.parse(id);
                          await showCancelReservationDialog(context, id);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF343A40),
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          side: BorderSide(color: Color(0xFFE4C87F), width: 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          'Otkaži rezervaciju',
                          style: TextStyle(
                            fontFamily: GoogleFonts.ptSans().fontFamily,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFE4C87F),
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
        SizedBox(height: 20), // Space between cards
      ],
    );
  }

  Widget buildBookingInfoNext(int index) {
    final String message = notifications['new']?[index]['message'] ?? 'N/A';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20), // Space between cards
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF343A40),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    notifications['new']?[index]['created_time'] ?? 'N/A',
                    style: TextStyle(
                      fontFamily: GoogleFonts.ptSans().fontFamily,
                      color: Color(0xFFe4c87f),
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Handle closing the notification here
                      // For example, you can remove it from the list of notifications
                      setState(() {
                        AlertDialogForCloseButton(context, title, text,
                            notifications['new']?[index]['id']);
                      });
                    },
                    icon: Icon(
                      Icons.close_outlined,
                      color: Color(0xFF454d55),
                      size: 18,
                    ),
                  ),
                ],
              ),
              Divider(
                thickness: 1,
                color: Color(0xFF454d55),
              ),
              SizedBox(height: 8),
              Text(
                notifications['new']?[index]['subject'] ?? 'N/A',
                style: TextStyle(
                  fontFamily: GoogleFonts.ptSans().fontFamily,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 8),
              RichText(
                text: _parseHtmlString(message),
              ),
            ],
          ),
        ),
        SizedBox(height: 20), // Space between cards
      ],
    );
  }

  TextSpan _parseHtmlString(String htmlString) {
    final RegExp linkRegExp = RegExp(
      r'<a[^>]+href=\"(.*?)\"[^>]*>(.*?)<\/a>',
      caseSensitive: false,
      multiLine: false,
    );

    final List<TextSpan> spans = [];
    int start = 0;

    for (final match in linkRegExp.allMatches(htmlString)) {
      if (match.start > start) {
        spans.add(
          TextSpan(
            text: htmlString.substring(start, match.start),
            style: TextStyle(
              fontFamily: GoogleFonts.ptSans().fontFamily,
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        );
      }

      final String linkText = match.group(2)!;
      final String linkUrl = match.group(1)!;

      spans.add(
        TextSpan(
          text: linkText,
          style: TextStyle(
            fontFamily: GoogleFonts.ptSans().fontFamily,
            color: Color(0xFFe4c87f),
            fontSize: 16,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              _launchUrl(linkUrl);
            },
        ),
      );

      start = match.end;
    }

    if (start < htmlString.length) {
      spans.add(
        TextSpan(
          text: htmlString.substring(start),
          style: TextStyle(
            fontFamily: GoogleFonts.ptSans().fontFamily,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      );
    }

    return TextSpan(children: spans);
  }

  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
