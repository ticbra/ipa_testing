import '/components/nav_bar_with_middle_button_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'list_special_page_widget.dart' show ListSpecialPageWidget;
import 'package:flutter/material.dart';

class ListSpecialPageModel extends FlutterFlowModel<ListSpecialPageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
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
