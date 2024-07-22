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

import 'package:shared_preferences/shared_preferences.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '/app_state.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';

import 'global.dart';

import 'package:google_fonts/google_fonts.dart';

class DynamicRadioButtons extends StatefulWidget {
  const DynamicRadioButtons({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _DynamicRadioButtonsState createState() => _DynamicRadioButtonsState();
}

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

class _DynamicRadioButtonsState extends State<DynamicRadioButtons>
    with TickerProviderStateMixin {
  Set<String> _selectedValues = Set<String>();
  Map<String, Map<String, String>> _selectedServicesData = {};
  Map<String, Set<String>> _selectedExtraServices = {};
  List<String> _selectedServicesAndExtras = [];
  int? _durationMin;
  int? _countService;
  double? _priceEur;
  double? _price;
  double? _priceHrk;
  ValueNotifier<String> formattedOutputNotifier = ValueNotifier('');
  List<dynamic> services = [];
  String newDefinition = "";
  String _lastUrl = '';
  // Store enabled/disabled state for each service
  // Define AnimationController and Animation for blinking effect
  late AnimationController _animationController;
  bool offerSelected = false;
  bool offerRemoved = false;
  String? _lastOffer = '';
  String? _previousOffer = '';
  int variable = 0;
  bool isSelected = false;
  bool offerPressed = false;
  int _selectedServicesCount = 0;
  int _selectedOffersCount = 0;
  bool shouldDisableCheckbox = false;
  late Future<List<dynamic>> _servicesFuture;
  String urlForFetchFirst = '';
  bool offerSelectedDeselect = false;

  @override
  void initState() {
    super.initState();

    fetchServices(globalUrl.value);
    _servicesFuture = fetchServices(globalUrl.value);
    globalUrl.addListener(_updateServicesFuture);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      value: 1.0, // Set the initial value to 1.0
    );
    _animationController.animateTo(0.6); // Animation will go to 0.4 opacity
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });

    _animationController.forward();
  }

  void _updateServicesFuture() {
    if (mounted) {
      setState(() {
        _servicesFuture = fetchServices(globalUrl.value);
      });
    }
  }

  @override
  void dispose() {
    globalUrl.removeListener(_updateServicesFuture);
    _animationController.dispose();
    super.dispose();
  }

  Future<String> fetchFirstAvailableAppointment() async {
    final response = await http.get(Uri.parse(urlForFetchFirst));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      String firstAvailableAppointment = data['first_available_appointment'];
      return firstAvailableAppointment;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _sendBookingsData(String bookings) async {
    final userToken = FFAppState().token;
    final base_url = domenString + '/mobile-app/api/v1/user/availability';

    final bookingLines = bookings.split('\n');
    Map<String, String> queryParameters = {};

    _syncBookDateFromUrl();
    print("Book Date " + FFAppState().bookDate);

    // Parse the other booking data
    for (var line in bookingLines) {
      final parts = line.split(': ');
      if (parts.length == 2 && parts[0] != 'services[]') {
        queryParameters[parts[0]] = parts[1];
      }
    }

    final servicesList = FFAppState()
        .bookServices
        .split(RegExp(r'[\n,]'))
        .where((service) => service.trim().isNotEmpty)
        .toList();

    String employee = FFAppState().bookEmployee.toString();
    print("Dino employee " + FFAppState().bookEmployee.toString());
    if (FFAppState().bookEmployee != 0) {
      queryParameters['employee'] = employee;
    }

    for (int i = 0; i < servicesList.length; i++) {
      queryParameters['services[$i]'] = servicesList[i];
    }
    queryParameters['lang'] = 'hr'; // Add the lang parameter

    // Construct the URI with query parameters
    final uri = Uri(
      scheme: 'https',
      host: hostString,
      path: '/mobile-app/api/v1/user/$userToken/availability',
      queryParameters: queryParameters,
    );

    urlForFetchFirst = uri.toString();

    String newDate = '';

    // Fetch first available appointment if needed
    if (FFAppState().bookDate.isEmpty) {
      newDate = await fetchFirstAvailableAppointment();
    } else {
      newDate = FFAppState().bookDate;
    }

    queryParameters['date'] = newDate;

    // Update URI with the new date
    final updatedUri = Uri(
      scheme: uri.scheme,
      host: uri.host,
      path: uri.path,
      queryParameters: queryParameters,
    );

    // Make the request with updated URI
    final response = await http.get(
      updatedUri,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
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

      FFAppState().durationMin = bookingDataMap['duration'];
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
      if (FFAppState().bookServices == null ||
          FFAppState().bookServices.trim() == '') {
        FFAppState().durationMin = 0;
        FFAppState().priceEur = 0.0;
        FFAppState().priceToEur = 0.0;
        FFAppState().totalPriceEur = 0.0;
        duration = '0';
      }

      if (FFAppState().bookServices.isEmpty) {
        FFAppState().durationMin = 0;
        FFAppState().priceEur = 0.0;
        FFAppState().priceToEur = 0.0;
        FFAppState().totalPriceEur = 0.0;
        duration = '0';
      }

      if (FFAppState().bookEmployee == 0 && priceEur == priceTo) {
        newDefinition = 'Trajanje: $duration min\nCijena: $priceEur €';
      } else if (FFAppState().bookEmployee == 0 && priceEur != priceTo) {
        newDefinition =
            'Trajanje: $duration min\nCijena: $priceEur € - $priceTo €';
      } else if (FFAppState().bookServices.isEmpty) {
        newDefinition = 'Trajanje: 0.00 min\nCijena: 0.00';
      } else {
        // Format when an employee is selected
        newDefinition = 'Trajanje: $duration min\nCijena: $totalPrice €';
      }

      globalUrl.value = updatedUri.toString();

      globalDurationTime.value = bookingDataMap['duration'];
      globalOutputNotifier.value = newDefinition;
    } else {
      // Handle error if needed
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void _initializeAndSyncServices() {
    // Extract services from the globalUrl
    final Uri uri = Uri.parse(globalUrl.value);
    final List<String> servicesFromUrl =
        uri.queryParametersAll['services[]'] ?? [];

    // Initialize bookServices with services from URL
    FFAppState().bookServices = servicesFromUrl.join(',');

    // Ensure all selected services are in bookServices
    for (String serviceId in _selectedServicesAndExtras) {
      if (!FFAppState().bookServices.contains(serviceId)) {
        FFAppState().bookServices += ',${serviceId}';
      }
    }

    // Remove deselected services from bookServices
    List<String> currentServices = FFAppState().bookServices.split(',');
    currentServices.removeWhere(
        (serviceId) => !_selectedServicesAndExtras.contains(serviceId));

    // Update the bookServices with the filtered list
    FFAppState().bookServices = currentServices.join(',');

    // Extract employee from the globalUrl
    final String? employeeFromUrl = uri.queryParameters['employee'];
    if (employeeFromUrl != null && employeeFromUrl.isNotEmpty) {
      FFAppState().bookEmployee = int.tryParse(employeeFromUrl) ?? 0;
    } else {
      FFAppState().bookEmployee = 0;
    }
  }

  void _syncBookDateFromUrl() {
    // Extract date and time from the globalUrl
    final Uri uri = Uri.parse(globalUrl.value);
    print("Last " + globalUrl.value);
    final String? dateFromUrl = uri.queryParameters['date'];
    final String? timeFromUrl = uri.queryParameters['time'];

    // Update FFAppState().bookDate with the extracted date
    if (dateFromUrl != null && dateFromUrl.isNotEmpty) {
      if (!FFAppState().boolSyncDate) {
        FFAppState().bookDate = '';
      } else {
        FFAppState().bookDate = dateFromUrl;
      }
    }

    // Update FFAppState().bookTime with the extracted time
    if (timeFromUrl != null && timeFromUrl.isNotEmpty) {
      FFAppState().bookTime = timeFromUrl;
    }
  }

  void _updateSelectedServicesData(String value, String mainServiceId,
      Map<String, String> data, List<dynamic> allExtraServices) {
    if (mounted) {
      setState(() {
        if (_lastOffer != '') {
          _selectedValues.remove(_lastOffer);
          _selectedServicesData.remove(_lastOffer);
          offerRemoved = false;
        }

        if (_selectedValues.contains(value)) {
          // Deselecting the main service
          _selectedValues.remove(value);
          _selectedServicesData.remove(value);

          // Deselect associated extra services
          if (_selectedExtraServices.containsKey(value)) {
            Set<String> extraServicesCopy =
                Set<String>.from(_selectedExtraServices[value]!);
            for (String extraServiceTitle in extraServicesCopy) {
              String? extraServiceId = allExtraServices
                  .firstWhere(
                    (service) => service['title'] == extraServiceTitle,
                    orElse: () => null,
                  )?['id']
                  ?.toString();

              if (extraServiceId != null) {
                _selectedServicesAndExtras.remove(extraServiceId);
                _updateSelectedExtraServices(
                    value, mainServiceId, extraServiceTitle, extraServiceId,
                    forceRemove: true);
              }
            }
            _selectedExtraServices.remove(value);
          }

          // Remove main service ID from the list
          _selectedServicesAndExtras.remove(mainServiceId);
          FFAppState().bookServices = _removeServiceFromBooking(
              FFAppState().bookServices, mainServiceId);
        } else {
          if (_selectedValues.length < 3) {
            _selectedValues.add(value);
            _selectedServicesData[value] = data;
            _selectedServicesAndExtras.add(mainServiceId);
            FFAppState().bookServices =
                _addServiceToBooking(FFAppState().bookServices, mainServiceId);
          }
        }

        _selectedServicesCount = _selectedValues.length;
        _updateShouldDisableMainServices();
        _initializeAndSyncServices();

        _sendBookingsData(FFAppState().bookings);
      });
    }
  }

  void _updateSelectedOffersData(String value, String mainServiceId,
      Map<String, String> data, List<dynamic> allExtraServices) {
    if (mounted) {
      setState(() {
        // Remove the previously selected offer, if it exists
        if (_previousOffer != null && _previousOffer != value) {
          _selectedValues.remove(_previousOffer);
          _selectedServicesData.remove(_previousOffer);
          _selectedServicesAndExtras.remove(_previousOffer);
        }

        // Add the current offer if not already selected or update existing data
        if (!_selectedValues.contains(value)) {
          _selectedValues.add(value);
          _selectedServicesAndExtras.add(mainServiceId);
        }

        // Always update the data for the current offer
        _selectedServicesData[value] = data;

        // Update the previous offer tracker
        _previousOffer = value;
        offerRemoved =
            true; // Assuming this flag indicates that an update occurred
      });
    }
  }

  void _updateSelectedExtraServices(String mainService, String mainServiceId,
      String extraService, String extraServiceId,
      {bool forceRemove = false}) {
    if (mounted) {
      setState(() {
        // Remove the extra service
        if (_selectedExtraServices.containsKey(mainService) &&
            (_selectedExtraServices[mainService]!.contains(extraService) ||
                forceRemove)) {
          _selectedExtraServices[mainService]!.remove(extraService);
          _selectedServicesAndExtras.remove(extraServiceId);
          FFAppState().bookServices = _removeServiceFromBooking(
              FFAppState().bookServices, extraServiceId);

          // Only remove the main service if forceRemove is true
          if (forceRemove) {
            _removeMainService(mainService, mainServiceId);
          }
        }
        // Add the extra service
        else if (!_selectedExtraServices.containsKey(mainService) ||
            !_selectedExtraServices[mainService]!.contains(extraService)) {
          _selectedExtraServices.putIfAbsent(mainService, () => Set<String>());
          _selectedExtraServices[mainService]!.add(extraService);
          _selectedServicesAndExtras.add(extraServiceId);

          FFAppState().bookServices =
              _addServiceToBooking(FFAppState().bookServices, extraServiceId);
        }

        _initializeAndSyncServices();
        _sendBookingsData(FFAppState().bookings);
      });
    }
  }

  void _removeMainService(String mainService, String mainServiceId) {
    _selectedValues.remove(mainService);
    _selectedServicesData.remove(mainService);
    _selectedServicesAndExtras.remove(mainServiceId);
    FFAppState().bookServices =
        _removeServiceFromBooking(FFAppState().bookServices, mainServiceId);

    _selectedExtraServices.remove(mainService);
  }

  String _addServiceToBooking(String currentBookings, String serviceId) {
    if (currentBookings.isEmpty) {
      return serviceId;
    } else {
      return currentBookings +
          '\n' +
          serviceId; // Assuming newline separated list
    }
  }

  String _removeServiceFromBooking(String bookings, String serviceId) {
    var lines = bookings.split('\n');
    lines.removeWhere((line) => line.trim() == serviceId);
    return lines.join('\n');
  }

  Future<List<dynamic>> fetchServices(String baseUrl) async {
    String newDate;

    if (globalUrl.value.contains("&mode=special") &&
        globalUrl.value.contains("&services%5B%5D=")) {
      FFAppState().durationMin = 0;

      newDefinition = 'Trajanje: 0.00 min\nCijena: 0.00';
      globalOutputNotifier.value = newDefinition;
      print("Dinamyc Radio Buttons " + globalOutputNotifier.value);
      // Extract the mainServiceId from the URL
      var regex = RegExp(r"&services%5B%5D=([^&]+)");
      var match = regex.firstMatch(globalUrl.value);
      String? currentMainServiceId;

      if (match != null) {
        currentMainServiceId = match.group(1);
      }

      if (currentMainServiceId != null) {
        var newUrl = globalUrl.value;
        newUrl = newUrl.replaceAll("&mode=special", "");
        newUrl = newUrl.replaceAll("&services%5B%5D=$currentMainServiceId", "");
        baseUrl = newUrl;
        Future.microtask(() {
          if (currentMainServiceId != null) {
            globalUrl.value = newUrl;
          }
        });
      }
    }

    Uri uri = Uri.parse(globalUrl.value);

    try {
      final response = await http.get(Uri.parse(globalUrl.value));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        List<dynamic> services = data['availability']['services'];
        List<dynamic> offers = data['availability']['offers'];

        services.addAll(offers.map((offer) => {
              ...offer,
              'type': 'offer',
            }));

        return services;
      } else {
        print('Failed to load data: ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching services: $e');
      throw Exception('Error fetching services');
    }
  }

  bool checkSelectedAndServiceType(bool isSelected, bool serviceType) {
    offerSelected = isSelected && serviceType;

    return offerSelected;
  }

  bool isSelectedService(String value) {
    return _selectedValues.contains(value);
  }

  void deselectAllServices() {
    if (mounted) {
      setState(() {
        // Clear all selected services
        _selectedValues.clear();
        _selectedServicesData.clear();
        _selectedExtraServices.clear();

        // Reset related state if necessary
        _selectedServicesAndExtras.clear();
        FFAppState().bookServices =
            ""; // Clear any global state related to services, if used

        // You might need to update any other relevant parts of your state here
        // such as resetting costs, times, etc.
        FFAppState().durationMin = 0;
        FFAppState().priceEur = 0.0;
        FFAppState().priceToEur = 0.0;
        FFAppState().totalPriceEur = 0.0;
        globalOutputNotifier.value =
            'Trajanje: 0.00 min\nCijena: 0.00'; // Example reset
        shouldDisableCheckbox = false;
        offerSelectedDeselect = true;
      });
    }
  }

  void addMainServiceIdToGlobalUrl(String mainServiceId) {
    FFAppState().modeSpecial = true;
    FFAppState().boolSpecial = true;
    FFAppState().modeSpecialOffer = true;

    // Parse the current global URL
    Uri currentUrl = Uri.parse(globalUrl.value);

    // Create a new map of query parameters, excluding all 'services[]'
    var newQueryParameters =
        Map<String, dynamic>.from(currentUrl.queryParameters)
          ..removeWhere((key, value) => key.startsWith('services['));

    // Add mode and the last main service ID only
    newQueryParameters['mode'] = 'special';
    newQueryParameters['services[]'] = mainServiceId;

    // Reconstruct the URL with the new query parameters
    Uri newUrl = Uri(
      scheme: currentUrl.scheme,
      host: currentUrl.host,
      path: currentUrl.path,
      queryParameters: newQueryParameters,
    );

    // Update the global URL
    globalUrl.value = newUrl.toString();

    // Similarly update the FFAppState().bookings
    Uri bookingUrl =
        Uri.parse('?' + FFAppState().bookings); // Parsing existing bookings
    var bookingQueryParameters =
        Map<String, dynamic>.from(bookingUrl.queryParameters)
          ..removeWhere((key, value) => key == 'services[]');

    // Rebuild FFAppState().bookings with only the new main service
    bookingQueryParameters['services[]'] = mainServiceId;
    String updatedBookings = bookingQueryParameters.entries
        .map((entry) => '${entry.key}=${entry.value}')
        .join('&');
    FFAppState().bookings = updatedBookings;

    // Assume _addServiceToBooking simply adds the new service ID; here we reset first.
    FFAppState().bookServices = "";
    FFAppState().bookServices =
        _addServiceToBooking(FFAppState().bookServices, mainServiceId);

    offerPressed = true;
    _sendBookingsData(FFAppState().bookings);
    FFAppState().specialUrl = globalUrl.value;
    context.push('/sendRequest');
    deselectAllServices();
    FFAppState().newSpecial = true;
  }

// Example implementation of _addServiceToBooking

  bool isExtraServiceSelected(String mainService, String extraService) {
    return _selectedExtraServices.containsKey(mainService) &&
        _selectedExtraServices[mainService]!.contains(extraService);
  }

  void _updateShouldDisableMainServices() {
    shouldDisableCheckbox = _selectedServicesCount >= 3;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _servicesFuture,
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
        } else {
          List<dynamic> services = snapshot.data ?? [];
          // Filter services based only on 'available' status
          services = services
              .where((service) => service['available'] as bool? ?? false)
              .toList();
          return Container(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: services.length,
                    itemBuilder: (BuildContext context, int index) {
                      final service = services[index];
                      final serviceType = service['special'];
                      final value = service['title'];
                      final mainServiceId = service['id'].toString();
                      final description = service['description'];
                      final extra_description = service['extra_description'];
                      final durationMin = service['duration'];
                      final priceEur = service['price_from'];
                      final priceTo = service['price_to'];
                      final price = service['price'];
                      final bool available =
                          service['available'] as bool? ?? false;
                      final bool bestBuy =
                          service['best_buy'] as bool? ?? false;
                      final extraServices =
                          service['extra_services'] as List<dynamic>;
                      final bool shouldDisableMainServices =
                          _selectedServicesCount >= 3 &&
                              !offerSelectedDeselect &&
                              !serviceType;

                      isSelected = isSelectedService(service['title']);

                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (serviceType) {
                                offerSelected = true;
                                FFAppState().modeSpecialOffer = true;

                                _updateSelectedOffersData(
                                  value,
                                  mainServiceId,
                                  {
                                    "description": description,
                                    "extra_description": extra_description,
                                  },
                                  extraServices,
                                );
                              } else {
                                offerSelected = false;
                                FFAppState().modeSpecialOffer = false;

                                _updateSelectedServicesData(
                                  value,
                                  mainServiceId,
                                  {
                                    "description": description,
                                    "extra_description": extra_description,
                                  },
                                  extraServices,
                                );
                              }
                              if (!available || !serviceType) {
                                return; // Don't do anything when disabled
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: isSelected
                                        ? Colors.transparent
                                        : Color(0xFF454D55),
                                  ),
                                ),
                              ),
                              child: ListTileTheme(
                                textColor: isSelected
                                    ? Color(0xFFE4C87F)
                                    : shouldDisableMainServices || available
                                        ? Colors.grey
                                        : Colors.white,
                                iconColor: !available || shouldDisableCheckbox
                                    ? Colors.white
                                    : Color(0xFFE4C87F),
                                child: ListTile(
                                  title: Row(
                                    children: [
                                      Expanded(
                                        flex: 8,
                                        child: Row(
                                          children: [
                                            if (!serviceType)
                                              RoundCheckbox(
                                                value: _selectedValues
                                                    .contains(value),
                                                onChanged: !available ||
                                                        shouldDisableCheckbox
                                                    ? null
                                                    : (bool? newValue) {
                                                        _updateSelectedServicesData(
                                                          value,
                                                          mainServiceId,
                                                          {
                                                            "description":
                                                                description,
                                                            "extra_description":
                                                                extra_description,
                                                          },
                                                          extraServices,
                                                        );
                                                      },
                                                colorNew: isSelected
                                                    ? Color(
                                                        0xFFE4C87F) // Golden color when isSelected is true
                                                    : shouldDisableCheckbox
                                                        ? Color(
                                                            0xFF3C3E42) // Grey color when isSelected is false and shouldDisableCheckbox is true
                                                        : Colors
                                                            .white, // White color when isSelected is false and shouldDisableCheckbox is false
                                                activeColor: Colors.transparent,
                                                fillColor: Colors.transparent,
                                                width: 20,
                                                height: 20,
                                              ),
                                            if (serviceType)
                                              SizedBox(
                                                width: 20,
                                                height: 20,
                                              ),
                                            SizedBox(width: 10),
                                            Flexible(
                                              child: RichText(
                                                text: TextSpan(
                                                  style: TextStyle(
                                                    fontFamily:
                                                        GoogleFonts.ptSans()
                                                            .fontFamily,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: isSelected
                                                        ? Color(0xFFE4C87F)
                                                        : !available ||
                                                                shouldDisableMainServices
                                                            ? Color(0xFF3C3E42)
                                                            : Colors.white,
                                                    height: 1.2,
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: '$value',
                                                    ),
                                                    if (bestBuy) ...[
                                                      TextSpan(
                                                        text: '   ',
                                                      ),
                                                      TextSpan(
                                                        text: 'BEST BUY',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              GoogleFonts
                                                                      .ptSans()
                                                                  .fontFamily,
                                                          backgroundColor:
                                                              Color(0xFFDC3545),
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          height: 1.2,
                                                        ),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            '$durationMin min',
                                            style: TextStyle(
                                              fontFamily: GoogleFonts.ptSans()
                                                  .fontFamily,
                                              fontSize: 12,
                                              height: 1.2,
                                              color: isSelected
                                                  ? Color(0xFFE4C87F)
                                                  : !available ||
                                                          shouldDisableMainServices
                                                      ? Color(0xFF3C3E42)
                                                      : Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(right: 8.0),
                                            child: Text(
                                              FFAppState().bookEmployee == 0
                                                  ? (priceEur == priceTo
                                                      ? '$priceEur €'
                                                      : '$priceEur € - $priceTo €')
                                                  : ' $price €',
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                fontFamily: GoogleFonts.ptSans()
                                                    .fontFamily,
                                                fontSize: 12,
                                                height: 1.2,
                                                color: isSelected
                                                    ? Color(0xFFE4C87F)
                                                    : !available ||
                                                            shouldDisableMainServices
                                                        ? Color(0xFF3C3E42)
                                                        : Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: checkSelectedAndServiceType(
                                isSelected, !serviceType),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          50.0,
                                          10.0,
                                          0.0,
                                          0.0), // Adjust padding here
                                      child: Text(
                                        description,
                                        style: TextStyle(
                                          fontFamily:
                                              GoogleFonts.ptSans().fontFamily,
                                          color: Colors.white,
                                          fontSize: 12,
                                          height: 1.1667,
                                        ),
                                      ),
                                    ),
                                    for (var extraService in extraServices)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, left: 32.0),
                                        child: ListTileTheme(
                                          textColor: (_selectedExtraServices
                                                      .containsKey(value) &&
                                                  _selectedExtraServices[value]!
                                                      .contains(extraService[
                                                          'title']) &&
                                                  !available)
                                              ? Color(0xFFE4C87F)
                                              : Colors.white,
                                          iconColor: Colors.white,
                                          child: ListTile(
                                            title: InkWell(
                                              onTap: () {
                                                // Logic to handle tap
                                                _updateSelectedExtraServices(
                                                  value,
                                                  mainServiceId,
                                                  extraService['title'],
                                                  extraService['id'].toString(),
                                                );
                                              },
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 10,
                                                    child: Row(
                                                      children: [
                                                        RoundCheckbox(
                                                          useCheckIcon: false,
                                                          value: _selectedExtraServices
                                                                  .containsKey(
                                                                      value) &&
                                                              _selectedExtraServices[
                                                                      value]!
                                                                  .contains(
                                                                      extraService[
                                                                          'title']) &&
                                                              available,
                                                          onChanged:
                                                              (bool? newValue) {
                                                            _updateSelectedExtraServices(
                                                              value,
                                                              mainServiceId,
                                                              extraService[
                                                                  'title'],
                                                              extraService['id']
                                                                  .toString(),
                                                            );
                                                          },
                                                          colorNew: isExtraServiceSelected(
                                                                  value,
                                                                  extraService[
                                                                      'title'])
                                                              ? Color(
                                                                  0xFFE4C87F) // Gold color when the extra service is selected
                                                              : Colors.white,
                                                          activeColor:
                                                              Color.fromARGB(
                                                                  0, 254, 8, 8),
                                                          fillColor: Colors
                                                              .transparent,
                                                          width: 20,
                                                          height: 20,
                                                        ),
                                                        SizedBox(width: 10),
                                                        Flexible(
                                                          child: isExtraServiceSelected(
                                                                  value,
                                                                  extraService[
                                                                      'title'])
                                                              ? Text(
                                                                  '${extraService['title']}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        GoogleFonts.ptSans()
                                                                            .fontFamily,
                                                                    fontSize:
                                                                        12,
                                                                    height:
                                                                        1.6667,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Color(
                                                                        0xFFE4C87F),
                                                                  ),
                                                                )
                                                              : FadeTransition(
                                                                  opacity:
                                                                      _animationController,
                                                                  child: Text(
                                                                    '${extraService['title']}',
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          GoogleFonts.ptSans()
                                                                              .fontFamily,
                                                                      fontSize:
                                                                          12,
                                                                      height:
                                                                          1.6667,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 8),
                                                        child: Text(
                                                          '${extraService['price_from']} €',
                                                          textAlign:
                                                              TextAlign.end,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                GoogleFonts
                                                                        .ptSans()
                                                                    .fontFamily,
                                                            fontSize: 12,
                                                            height: 1.1667,
                                                            color: isExtraServiceSelected(
                                                                    value,
                                                                    extraService[
                                                                        'title'])
                                                                ? Color(
                                                                    0xFFE4C87F)
                                                                : Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0.0, 10.0, 0.0, 10.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          height:
                                              1, // Adjust the thickness of the line
                                          width: double
                                              .infinity, // Expand to full width
                                          color:
                                              Color(0xFFE4C87F), // Gold color
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: checkSelectedAndServiceType(
                                isSelected, serviceType),
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          50.0,
                                          10.0,
                                          0.0,
                                          0.0), // Adjust padding here
                                      child: Text(
                                        description,
                                        style: TextStyle(
                                          fontFamily:
                                              GoogleFonts.ptSans().fontFamily,
                                          color: Colors.white,
                                          fontSize: 12,
                                          height: 1.6667,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 50), // Add left margin here
                                      child: StatefulBuilder(
                                        builder: (BuildContext context,
                                            StateSetter setState) {
                                          return MouseRegion(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                addMainServiceIdToGlobalUrl(
                                                    mainServiceId);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: // Color when hovering
                                                    Colors
                                                        .transparent, // Transparent background when not hovering
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 20,
                                                    horizontal:
                                                        20), // Padding converted from rem

                                                side: BorderSide(
                                                  color: Color(
                                                      0xFFE4C87F), // Border color
                                                  width: 1,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12), // Border radius
                                                ),
                                              ),
                                              child: Text(
                                                'Pošalji upit za dogovor termina',
                                                style: TextStyle(
                                                  fontFamily:
                                                      GoogleFonts.ptSans()
                                                          .fontFamily,
                                                  fontSize:
                                                      16, // Font size converted from rem
                                                  fontWeight: FontWeight.w600,

                                                  color: Color(
                                                      0xFFE4C87F), // Change text color based on hover state
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0.0, 20.0, 0.0, 15.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          height: 1,
                                          width: double.infinity,
                                          color: Color(0xFF454d55),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
