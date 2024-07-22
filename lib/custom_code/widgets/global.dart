// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Global variable
final globalOutputNotifier =
    ValueNotifier<String>('Trajanje: 0 min\nCijena: 0,00 €');
final ValueNotifier<int> globalDurationTime = ValueNotifier(0);
final ValueNotifier<String> globalUrl = ValueNotifier('');
final ValueNotifier<String> globalServicesJsonData = ValueNotifier('');
final ValueNotifier<int> countService = ValueNotifier(0);
final ValueNotifier<int> countSelectedButtons = ValueNotifier(0);
final ValueNotifier<bool> globalSelectedEmployee = ValueNotifier(false);
final String domenString = "https://gentlemensshop.hr.dev.enter-internet.com";
final String hostString = "gentlemensshop.hr.dev.enter-internet.com";

class GlobalUrlProvider with ChangeNotifier {
  String _globalUrl = '';

  String get globalUrl => _globalUrl;

  set globalUrl(String newUrl) {
    if (_globalUrl != newUrl) {
      _globalUrl = newUrl;
      notifyListeners();
    }
  }
}

class Global extends StatefulWidget {
  const Global({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _GlobalState createState() => _GlobalState();
}

class _GlobalState extends State<Global> {
  @override
  Widget build(BuildContext context) {
    // Your widget implementation here
    return Container();
  }
}
