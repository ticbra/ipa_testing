import '/components/nav_bar_with_middle_button_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'settings_profile_page_widget.dart' show SettingsProfilePageWidget;
import 'package:flutter/material.dart';

class SettingsProfilePageModel
    extends FlutterFlowModel<SettingsProfilePageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Model for NavBarWithMiddleButton component.
  late NavBarWithMiddleButtonModel navBarWithMiddleButtonModel1;
  // Model for NavBarWithMiddleButton component.
  late NavBarWithMiddleButtonModel navBarWithMiddleButtonModel2;

  @override
  void initState(BuildContext context) {
    navBarWithMiddleButtonModel1 =
        createModel(context, () => NavBarWithMiddleButtonModel());
    navBarWithMiddleButtonModel2 =
        createModel(context, () => NavBarWithMiddleButtonModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    navBarWithMiddleButtonModel1.dispose();
    navBarWithMiddleButtonModel2.dispose();
  }
}
