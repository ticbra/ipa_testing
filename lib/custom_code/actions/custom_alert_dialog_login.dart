// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

/// Shows a custom alert dialog with dynamic title and content.
///
/// [context] is the BuildContext from which the dialog is launched.
/// [title] is the title displayed in the alert dialog.
/// [text] is the message displayed in the alert dialog.
Future<void> customAlertDialogLogin(
    BuildContext context, String title, String text) async {
  // showDialog is a built-in Flutter method that shows a Material dialog above the current contents of the app.
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
          style: const TextStyle(color: Colors.white), // Content text in white
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(alertDialogContext), // Closes the dialog.
            child: Text(
              'Ok', // Button text, could be made dynamic if needed.
              style: const TextStyle(
                color:
                    const Color(0xFFE4C87F), // Custom gold color for the text
              ),
            ),
          ),
        ],
      );
    },
  );
}
