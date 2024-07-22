import '/backend/api_requests/api_calls.dart';
import '/components/nav_bar_with_middle_button_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'activity_copy_widget.dart' show ActivityCopyWidget;
import 'package:flutter/material.dart';

class ActivityCopyModel extends FlutterFlowModel<ActivityCopyWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Backend Call - API (bookingsCount)] action in ActivityCopy widget.
  ApiCallResponse? apiResultgux;
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
