import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'login_page_widget.dart' show LoginPageWidget;
import 'package:flutter/material.dart';

class LoginPageModel extends FlutterFlowModel<LoginPageWidget> {
  ///  Local state fields for this page.

  String fcmtoken = '123';

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Backend Call - API (Login)] action in LoginPage widget.
  ApiCallResponse? apiResulthahCopy;
  // Stores action output result for [Backend Call - API (User)] action in LoginPage widget.
  ApiCallResponse? apiResultvruCopy;
  // Stores action output result for [Backend Call - API (Profil)] action in LoginPage widget.
  ApiCallResponse? apicallprofile;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // State field(s) for Login_Username_txt widget.
  final loginUsernameTxtKey = GlobalKey();
  FocusNode? loginUsernameTxtFocusNode;
  TextEditingController? loginUsernameTxtTextController;
  String? loginUsernameTxtSelectedOption;
  String? Function(BuildContext, String?)?
      loginUsernameTxtTextControllerValidator;
  // State field(s) for Login_Password_txt widget.
  final loginPasswordTxtKey = GlobalKey();
  FocusNode? loginPasswordTxtFocusNode;
  TextEditingController? loginPasswordTxtTextController;
  String? loginPasswordTxtSelectedOption;
  late bool loginPasswordTxtVisibility;
  String? Function(BuildContext, String?)?
      loginPasswordTxtTextControllerValidator;
  // Stores action output result for [Backend Call - API (Login)] action in Button widget.
  ApiCallResponse? apiResult49j;
  // Stores action output result for [Backend Call - API (User)] action in Button widget.
  ApiCallResponse? apiResult83x;
  // Stores action output result for [Backend Call - API (Profil)] action in Button widget.
  ApiCallResponse? apiResultckd;
  // State field(s) for FirstName_txt widget.
  FocusNode? firstNameTxtFocusNode;
  TextEditingController? firstNameTxtTextController;
  String? Function(BuildContext, String?)? firstNameTxtTextControllerValidator;
  // State field(s) for Last_Name_txt widget.
  FocusNode? lastNameTxtFocusNode;
  TextEditingController? lastNameTxtTextController;
  String? Function(BuildContext, String?)? lastNameTxtTextControllerValidator;
  // State field(s) for Username_txt widget.
  FocusNode? usernameTxtFocusNode;
  TextEditingController? usernameTxtTextController;
  String? Function(BuildContext, String?)? usernameTxtTextControllerValidator;
  // State field(s) for Phone_txt widget.
  FocusNode? phoneTxtFocusNode;
  TextEditingController? phoneTxtTextController;
  String? Function(BuildContext, String?)? phoneTxtTextControllerValidator;
  // State field(s) for Password_txt widget.
  FocusNode? passwordTxtFocusNode;
  TextEditingController? passwordTxtTextController;
  late bool passwordTxtVisibility;
  String? Function(BuildContext, String?)? passwordTxtTextControllerValidator;
  // State field(s) for Confirm_Password_txt widget.
  FocusNode? confirmPasswordTxtFocusNode;
  TextEditingController? confirmPasswordTxtTextController;
  late bool confirmPasswordTxtVisibility;
  String? Function(BuildContext, String?)?
      confirmPasswordTxtTextControllerValidator;
  // Stores action output result for [Backend Call - API (Registration)] action in Button widget.
  ApiCallResponse? apiResult3ls;

  @override
  void initState(BuildContext context) {
    loginPasswordTxtVisibility = false;
    passwordTxtVisibility = false;
    confirmPasswordTxtVisibility = false;
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    tabBarController?.dispose();
    loginUsernameTxtFocusNode?.dispose();

    loginPasswordTxtFocusNode?.dispose();

    firstNameTxtFocusNode?.dispose();
    firstNameTxtTextController?.dispose();

    lastNameTxtFocusNode?.dispose();
    lastNameTxtTextController?.dispose();

    usernameTxtFocusNode?.dispose();
    usernameTxtTextController?.dispose();

    phoneTxtFocusNode?.dispose();
    phoneTxtTextController?.dispose();

    passwordTxtFocusNode?.dispose();
    passwordTxtTextController?.dispose();

    confirmPasswordTxtFocusNode?.dispose();
    confirmPasswordTxtTextController?.dispose();
  }
}
