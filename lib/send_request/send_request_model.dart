import '/flutter_flow/flutter_flow_util.dart';
import 'send_request_widget.dart' show SendRequestWidget;
import 'package:flutter/material.dart';

class SendRequestModel extends FlutterFlowModel<SendRequestWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
