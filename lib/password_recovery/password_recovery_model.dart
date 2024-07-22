import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'password_recovery_widget.dart' show PasswordRecoveryWidget;
import 'package:flutter/material.dart';

class PasswordRecoveryModel extends FlutterFlowModel<PasswordRecoveryWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for Login_Username_txt widget.
  FocusNode? loginUsernameTxtFocusNode;
  TextEditingController? loginUsernameTxtTextController;
  String? Function(BuildContext, String?)?
      loginUsernameTxtTextControllerValidator;
  // Stores action output result for [Backend Call - API (PasswordRecovery)] action in Button widget.
  ApiCallResponse? apiResultje9;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    loginUsernameTxtFocusNode?.dispose();
    loginUsernameTxtTextController?.dispose();
  }
}
