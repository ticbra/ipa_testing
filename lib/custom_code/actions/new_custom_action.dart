// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:go_router/go_router.dart';

Future newCustomAction(BuildContext context) async {
  // Route to 'UserPage' when user is logged in
  if (FFAppState().UserLoggedIn == 1) {
    context.push('UserPage');
  }
}
