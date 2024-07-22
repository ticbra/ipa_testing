import '/backend/api_requests/api_calls.dart';
import '/components/nav_bar_with_middle_button_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'user_page_widget.dart' show UserPageWidget;
import 'package:flutter/material.dart';

class UserPageModel extends FlutterFlowModel<UserPageWidget> {
  ///  Local state fields for this page.

  String reloadPage = '0';

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Backend Call - API (bookingsCount)] action in UserPage widget.
  ApiCallResponse? apiResultgux;
  // Stores action output result for [Backend Call - API (Profil)] action in UserPage widget.
  ApiCallResponse? apiResultxv3;
  // Model for NavBarWithMiddleButton component.
  late NavBarWithMiddleButtonModel navBarWithMiddleButtonModel;

  @override
  void initState(BuildContext context) {
    navBarWithMiddleButtonModel =
        createModel(context, () => NavBarWithMiddleButtonModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    navBarWithMiddleButtonModel.dispose();
  }
}
