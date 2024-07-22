import '/backend/api_requests/api_calls.dart';
import '/components/nav_bar_with_middle_button_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'pofil_page_widget.dart' show PofilPageWidget;
import 'package:flutter/material.dart';

class PofilPageModel extends FlutterFlowModel<PofilPageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Backend Call - API (BookingHistory)] action in Container widget.
  ApiCallResponse? apiResultn40;
  // Stores action output result for [Backend Call - API (Orders)] action in Container widget.
  ApiCallResponse? apiResultmrp;
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
