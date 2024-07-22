import '/flutter_flow/flutter_flow_util.dart';
import 'order_new_card_widget.dart' show OrderNewCardWidget;
import 'package:flutter/material.dart';

class OrderNewCardModel extends FlutterFlowModel<OrderNewCardWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
