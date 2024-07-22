import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_autocomplete_options_list.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_toggle_icon.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/permissions_util.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'login_page_model.dart';
export 'login_page_model.dart';

class LoginPageWidget extends StatefulWidget {
  const LoginPageWidget({super.key});

  @override
  State<LoginPageWidget> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget>
    with TickerProviderStateMixin {
  late LoginPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await requestPermission(notificationsPermission);
      if (FFAppState().UserLoggedIn == 1) {
        _model.apiResulthahCopy = await LoginCall.call(
          username: FFAppState().LoginUsername,
          password: FFAppState().LoginPassword,
        );

        FFAppState().token = getJsonField(
          (_model.apiResulthahCopy?.jsonBody ?? ''),
          r'''$.user''',
        ).toString().toString();
        setState(() {});
        _model.apiResultvruCopy = await UserCall.call(
          userToken: FFAppState().token,
        );

        FFAppState().usertoken = getJsonField(
          (_model.apiResultvruCopy?.jsonBody ?? ''),
          r'''$''',
        ).toString().toString();
        setState(() {});
        _model.apicallprofile = await ProfilCall.call(
          userToken: FFAppState().token,
        );

        FFAppState().userProfileName = getJsonField(
          (_model.apicallprofile?.jsonBody ?? ''),
          r'''$.first_name''',
        ).toString().toString();
        setState(() {});
        if (Navigator.of(context).canPop()) {
          context.pop();
        }
        context.pushNamed(
          'UserPage',
          extra: <String, dynamic>{
            kTransitionInfoKey: const TransitionInfo(
              hasTransition: true,
              transitionType: PageTransitionType.fade,
              duration: Duration(milliseconds: 200),
            ),
          },
        );
      }
    });

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => setState(() {}));
    _model.loginUsernameTxtTextController ??=
        TextEditingController(text: FFAppState().LoginUsername);

    _model.loginPasswordTxtTextController ??=
        TextEditingController(text: FFAppState().LoginPassword);

    _model.firstNameTxtTextController ??= TextEditingController();
    _model.firstNameTxtFocusNode ??= FocusNode();

    _model.lastNameTxtTextController ??= TextEditingController();
    _model.lastNameTxtFocusNode ??= FocusNode();

    _model.usernameTxtTextController ??= TextEditingController();
    _model.usernameTxtFocusNode ??= FocusNode();

    _model.phoneTxtTextController ??= TextEditingController();
    _model.phoneTxtFocusNode ??= FocusNode();

    _model.passwordTxtTextController ??= TextEditingController();
    _model.passwordTxtFocusNode ??= FocusNode();

    _model.confirmPasswordTxtTextController ??= TextEditingController();
    _model.confirmPasswordTxtFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFF212529),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: const AlignmentDirectional(0.0, 0.0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 50.0, 0.0, 10.0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      FFAppState().returnToReservation = true;
                      FFAppState().bookings = '';
                      FFAppState().bookServices = '';
                      FFAppState().bookServicesList = [];
                      FFAppState().bookDate = '';
                      FFAppState().bookEmployee = 0;
                      FFAppState().bookTime = '     ';
                      setState(() {});

                      context.pushNamed('LoginPage');
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/images/g-shop-logo.png',
                        width: 80.0,
                        height: 80.0,
                        fit: BoxFit.cover,
                        alignment: const Alignment(0.0, -1.0),
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                'GENTLMEN\'S SHOP',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).displayLarge.override(
                      fontFamily: 'PT Serif',
                      fontSize: 18.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                      lineHeight: 2.0,
                    ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: const AlignmentDirectional(0.0, 0.0),
                      child: ToggleIcon(
                        onPressed: () async {
                          setState(() => FFAppState().boolRegistration =
                              !FFAppState().boolRegistration);
                        },
                        value: FFAppState().boolRegistration,
                        onIcon: Icon(
                          Icons.how_to_reg,
                          color: FlutterFlowTheme.of(context).primary,
                          size: 30.0,
                        ),
                        offIcon: Icon(
                          Icons.login,
                          color: FlutterFlowTheme.of(context).primary,
                          size: 30.0,
                        ),
                      ),
                    ),
                    Align(
                      alignment: const AlignmentDirectional(0.0, 0.0),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                        child: Text(
                          FFAppState().boolRegistration
                              ? 'Registracija'
                              : 'Prijava',
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .override(
                                fontFamily: 'PT Serif',
                                color: Colors.white,
                                fontSize: 30.0,
                                letterSpacing: 0.0,
                              ),
                        ),
                      ),
                    ),
                  ].divide(const SizedBox(width: 10.0)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: const Alignment(0.0, 0),
                        child: TabBar(
                          labelColor: const Color(0xFFD9B24C),
                          labelStyle:
                              FlutterFlowTheme.of(context).bodySmall.override(
                                    fontFamily: 'PT Sans',
                                    fontSize: 20.0,
                                    letterSpacing: 0.0,
                                  ),
                          unselectedLabelStyle: const TextStyle(),
                          indicatorColor: FlutterFlowTheme.of(context).info,
                          tabs: const [
                            Tab(
                              text: 'Prijava',
                            ),
                            Tab(
                              text: 'Registracija',
                            ),
                          ],
                          controller: _model.tabBarController,
                          onTap: (i) async {
                            [
                              () async {
                                FFAppState().boolRegistration = false;
                                setState(() {});
                              },
                              () async {
                                FFAppState().boolRegistration = true;
                                setState(() {});
                              }
                            ][i]();
                          },
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _model.tabBarController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        16.0, 30.0, 16.0, 0.0),
                                    child: SizedBox(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.9,
                                      child: Autocomplete<String>(
                                        initialValue: TextEditingValue(
                                            text: FFAppState().LoginUsername),
                                        optionsBuilder: (textEditingValue) {
                                          if (textEditingValue.text == '') {
                                            return const Iterable<
                                                String>.empty();
                                          }
                                          return ['Option 1'].where((option) {
                                            final lowercaseOption =
                                                option.toLowerCase();
                                            return lowercaseOption.contains(
                                                textEditingValue.text
                                                    .toLowerCase());
                                          });
                                        },
                                        optionsViewBuilder:
                                            (context, onSelected, options) {
                                          return AutocompleteOptionsList(
                                            textFieldKey:
                                                _model.loginUsernameTxtKey,
                                            textController: _model
                                                .loginUsernameTxtTextController!,
                                            options: options.toList(),
                                            onSelected: onSelected,
                                            textStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily: 'PT Serif',
                                                      letterSpacing: 0.0,
                                                    ),
                                            textHighlightStyle: const TextStyle(),
                                            elevation: 4.0,
                                            optionBackgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryBackground,
                                            optionHighlightColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                            maxHeight: 200.0,
                                          );
                                        },
                                        onSelected: (String selection) {
                                          setState(() => _model
                                                  .loginUsernameTxtSelectedOption =
                                              selection);
                                          FocusScope.of(context).unfocus();
                                        },
                                        fieldViewBuilder: (
                                          context,
                                          textEditingController,
                                          focusNode,
                                          onEditingComplete,
                                        ) {
                                          _model.loginUsernameTxtFocusNode =
                                              focusNode;

                                          _model.loginUsernameTxtTextController =
                                              textEditingController;
                                          return TextFormField(
                                            key: _model.loginUsernameTxtKey,
                                            controller: textEditingController,
                                            focusNode: focusNode,
                                            onEditingComplete:
                                                onEditingComplete,
                                            onChanged: (_) =>
                                                EasyDebounce.debounce(
                                              '_model.loginUsernameTxtTextController',
                                              const Duration(milliseconds: 0),
                                              () async {
                                                FFAppState()
                                                        .CountWordsUsername =
                                                    _model
                                                        .loginUsernameTxtTextController
                                                        .text
                                                        .length;
                                                setState(() {});
                                                if (FFAppState()
                                                        .CountWordsUsername !=
                                                    0) {
                                                  FFAppState()
                                                          .boolCountWordsUsername =
                                                      false;
                                                  FFAppState()
                                                          .boolCpolorUsername =
                                                      false;
                                                  setState(() {});
                                                }
                                              },
                                            ),
                                            autofocus: true,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              labelText: 'E-mail *',
                                              labelStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .displayLarge
                                                      .override(
                                                        fontFamily: 'PT Sans',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                        letterSpacing: 0.0,
                                                      ),
                                              hintText:
                                                  FFAppState().LoginUsername,
                                              hintStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .displayLarge
                                                      .override(
                                                        fontFamily: 'PT Sans',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                        letterSpacing: 0.0,
                                                      ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FFAppState()
                                                          .boolCpolorUsername
                                                      ? const Color(0xFFDC3545)
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .secondary,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FFAppState()
                                                          .boolCpolorUsername
                                                      ? const Color(0xFFDC3545)
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .secondary,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              filled: true,
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .displayLarge
                                                .override(
                                                  fontFamily: 'PT Sans',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondary,
                                                  letterSpacing: 0.0,
                                                ),
                                            textAlign: TextAlign.center,
                                            cursorColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondary,
                                            validator: _model
                                                .loginUsernameTxtTextControllerValidator
                                                .asValidator(context),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  if (FFAppState().boolCountWordsUsername ==
                                      true)
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          5.0, 20.0, 0.0, 10.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Align(
                                            alignment:
                                                const AlignmentDirectional(0.0, -1.0),
                                            child: Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      16.0, 0.0, 16.0, 0.0),
                                              child: Container(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.9,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFDC3545),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(0.0),
                                                    bottomRight:
                                                        Radius.circular(0.0),
                                                    topLeft:
                                                        Radius.circular(0.0),
                                                    topRight:
                                                        Radius.circular(0.0),
                                                  ),
                                                  shape: BoxShape.rectangle,
                                                  border: Border.all(
                                                    color: const Color(0xFFDC3545),
                                                  ),
                                                ),
                                                child: Visibility(
                                                  visible: FFAppState()
                                                          .boolCountWordsUsername ==
                                                      true,
                                                  child: Align(
                                                    alignment:
                                                        const AlignmentDirectional(
                                                            0.0, 1.0),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  10.0,
                                                                  0.0,
                                                                  10.0,
                                                                  0.0),
                                                      child: Text(
                                                        getJsonField(
                                                          (_model.apiResult49j
                                                                  ?.jsonBody ??
                                                              ''),
                                                          r'''$.messages.username[0]''',
                                                        ).toString(),
                                                        textAlign:
                                                            TextAlign.start,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'PT Serif',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary,
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  Align(
                                    alignment: const AlignmentDirectional(1.0, 0.0),
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          16.0, 15.0, 16.0, 2.0),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.pushNamed('PasswordRecovery');
                                        },
                                        child: Text(
                                          'Zaboravio sam lozinku',
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                fontFamily: 'PT Sans',
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        16.0, 20.0, 16.0, 0.0),
                                    child: SizedBox(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.9,
                                      child: Autocomplete<String>(
                                        initialValue: TextEditingValue(
                                            text: FFAppState().LoginPassword),
                                        optionsBuilder: (textEditingValue) {
                                          if (textEditingValue.text == '') {
                                            return const Iterable<
                                                String>.empty();
                                          }
                                          return ['Option 1'].where((option) {
                                            final lowercaseOption =
                                                option.toLowerCase();
                                            return lowercaseOption.contains(
                                                textEditingValue.text
                                                    .toLowerCase());
                                          });
                                        },
                                        optionsViewBuilder:
                                            (context, onSelected, options) {
                                          return AutocompleteOptionsList(
                                            textFieldKey:
                                                _model.loginPasswordTxtKey,
                                            textController: _model
                                                .loginPasswordTxtTextController!,
                                            options: options.toList(),
                                            onSelected: onSelected,
                                            textStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily: 'PT Serif',
                                                      letterSpacing: 0.0,
                                                    ),
                                            textHighlightStyle: const TextStyle(),
                                            elevation: 4.0,
                                            optionBackgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryBackground,
                                            optionHighlightColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                            maxHeight: 200.0,
                                          );
                                        },
                                        onSelected: (String selection) {
                                          setState(() => _model
                                                  .loginPasswordTxtSelectedOption =
                                              selection);
                                          FocusScope.of(context).unfocus();
                                        },
                                        fieldViewBuilder: (
                                          context,
                                          textEditingController,
                                          focusNode,
                                          onEditingComplete,
                                        ) {
                                          _model.loginPasswordTxtFocusNode =
                                              focusNode;

                                          _model.loginPasswordTxtTextController =
                                              textEditingController;
                                          return TextFormField(
                                            key: _model.loginPasswordTxtKey,
                                            controller: textEditingController,
                                            focusNode: focusNode,
                                            onEditingComplete:
                                                onEditingComplete,
                                            onChanged: (_) =>
                                                EasyDebounce.debounce(
                                              '_model.loginPasswordTxtTextController',
                                              const Duration(milliseconds: 0),
                                              () async {
                                                FFAppState()
                                                        .CountWordsPassword =
                                                    _model
                                                        .loginPasswordTxtTextController
                                                        .text
                                                        .length;
                                                FFAppState()
                                                        .boolCountWordsPassword =
                                                    false;
                                                setState(() {});
                                                if (FFAppState()
                                                        .CountWordsPassword !=
                                                    0) {
                                                  FFAppState()
                                                          .boolColorPassword =
                                                      false;
                                                  setState(() {});
                                                }
                                              },
                                            ),
                                            autofocus: true,
                                            textCapitalization:
                                                TextCapitalization.none,
                                            obscureText: !_model
                                                .loginPasswordTxtVisibility,
                                            decoration: InputDecoration(
                                              labelText: 'Password *',
                                              labelStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .displayLarge
                                                      .override(
                                                        fontFamily: 'PT Sans',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                        letterSpacing: 0.0,
                                                      ),
                                              hintStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .displayLarge
                                                      .override(
                                                        fontFamily: 'PT Sans',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                        letterSpacing: 0.0,
                                                      ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FFAppState()
                                                          .boolColorPassword
                                                      ? const Color(0xFFDC3545)
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .secondary,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FFAppState()
                                                          .boolColorPassword
                                                      ? const Color(0xFFDC3545)
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .secondary,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              suffixIcon: InkWell(
                                                onTap: () => setState(
                                                  () => _model
                                                          .loginPasswordTxtVisibility =
                                                      !_model
                                                          .loginPasswordTxtVisibility,
                                                ),
                                                focusNode: FocusNode(
                                                    skipTraversal: true),
                                                child: Icon(
                                                  _model.loginPasswordTxtVisibility
                                                      ? Icons
                                                          .visibility_outlined
                                                      : Icons
                                                          .visibility_off_outlined,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondary,
                                                  size: 22,
                                                ),
                                              ),
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .displayLarge
                                                .override(
                                                  fontFamily: 'PT Sans',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondary,
                                                  letterSpacing: 0.0,
                                                ),
                                            textAlign: TextAlign.center,
                                            cursorColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondary,
                                            validator: _model
                                                .loginPasswordTxtTextControllerValidator
                                                .asValidator(context),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  if (FFAppState().boolCountWordsPassword)
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          5.0, 20.0, 0.0, 10.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Align(
                                            alignment:
                                                const AlignmentDirectional(0.0, -1.0),
                                            child: Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      16.0, 0.0, 16.0, 0.0),
                                              child: Container(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.9,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFDC3545),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(0.0),
                                                    bottomRight:
                                                        Radius.circular(0.0),
                                                    topLeft:
                                                        Radius.circular(0.0),
                                                    topRight:
                                                        Radius.circular(0.0),
                                                  ),
                                                  shape: BoxShape.rectangle,
                                                  border: Border.all(
                                                    color: const Color(0xFFDC3545),
                                                  ),
                                                ),
                                                child: Visibility(
                                                  visible: FFAppState()
                                                      .boolCountWordsPassword,
                                                  child: Align(
                                                    alignment:
                                                        const AlignmentDirectional(
                                                            0.0, 1.0),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  10.0,
                                                                  0.0,
                                                                  10.0,
                                                                  0.0),
                                                      child: Text(
                                                        FFAppState()
                                                            .stringCountWordsPassword,
                                                        textAlign:
                                                            TextAlign.start,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'PT Serif',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary,
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  Align(
                                    alignment: const AlignmentDirectional(0.0, 0.0),
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          16.0, 40.0, 16.0, 20.0),
                                      child: FFButtonWidget(
                                        onPressed: () async {
                                          FFAppState().CountWordsUsername =
                                              _model
                                                  .loginUsernameTxtTextController
                                                  .text
                                                  .length;
                                          setState(() {});
                                          FFAppState().CountWordsPassword =
                                              _model
                                                  .loginPasswordTxtTextController
                                                  .text
                                                  .length;
                                          FFAppState().boolCountWordsPassword =
                                              false;
                                          setState(() {});
                                          _model.apiResult49j =
                                              await LoginCall.call(
                                            username: _model
                                                .loginUsernameTxtTextController
                                                .text,
                                            password: _model
                                                .loginPasswordTxtTextController
                                                .text,
                                          );

                                          FFAppState().StatusLogin =
                                              getJsonField(
                                            (_model.apiResult49j?.jsonBody ??
                                                ''),
                                            r'''$.status''',
                                          ).toString();
                                          FFAppState().token = getJsonField(
                                            (_model.apiResult49j?.jsonBody ??
                                                ''),
                                            r'''$.user''',
                                          ).toString();
                                          FFAppState().user = getJsonField(
                                            (_model.apiResult49j?.jsonBody ??
                                                ''),
                                            r'''$.status''',
                                          ).toString();
                                          setState(() {});
                                          _model.apiResult83x =
                                              await UserCall.call(
                                            userToken: FFAppState().token,
                                          );

                                          if (FFAppState().user == 'ok') {
                                            _model.apiResultckd =
                                                await ProfilCall.call(
                                              userToken: FFAppState().token,
                                            );

                                            FFAppState().userProfileName =
                                                getJsonField(
                                              (_model.apiResultckd?.jsonBody ??
                                                  ''),
                                              r'''$.first_name''',
                                            ).toString();
                                            FFAppState()
                                                .boolCountWordsPassword = false;
                                            FFAppState().boolCpolorUsername =
                                                false;
                                            FFAppState().boolColorPassword =
                                                false;
                                            setState(() {});
                                            if (Navigator.of(context)
                                                .canPop()) {
                                              context.pop();
                                            }
                                            context.pushNamed(
                                              'UserPage',
                                              extra: <String, dynamic>{
                                                kTransitionInfoKey:
                                                    const TransitionInfo(
                                                  hasTransition: true,
                                                  transitionType:
                                                      PageTransitionType.fade,
                                                  duration: Duration(
                                                      milliseconds: 200),
                                                ),
                                              },
                                            );

                                            FFAppState().UserLoggedIn = 1;
                                            setState(() {});
                                            FFAppState().LoginUsername = _model
                                                .loginUsernameTxtTextController
                                                .text;
                                            FFAppState().LoginPassword = _model
                                                .loginPasswordTxtTextController
                                                .text;
                                            setState(() {});
                                            FFAppState().returnToReservation =
                                                true;
                                            FFAppState().bookings = '';
                                            FFAppState().bookServices = '';
                                            FFAppState().bookServicesList = [];
                                            FFAppState().bookDate = '';
                                            FFAppState().bookEmployee = 0;
                                            FFAppState().bookStatus = '';
                                            setState(() {});
                                          } else {
                                            FFAppState().UserLoggedIn = 0;
                                            setState(() {});
                                            FFAppState().LoginUsername = _model
                                                .loginUsernameTxtTextController
                                                .text;
                                            FFAppState().LoginPassword = _model
                                                .loginPasswordTxtTextController
                                                .text;
                                            setState(() {});
                                            if (FFAppState()
                                                    .CountWordsUsername ==
                                                0) {
                                              FFAppState()
                                                      .boolCountWordsUsername =
                                                  true;
                                              setState(() {});
                                            } else {
                                              FFAppState()
                                                      .boolCountWordsUsername =
                                                  false;
                                              setState(() {});
                                            }

                                            if ((FFAppState()
                                                        .CountWordsPassword ==
                                                    0) &&
                                                (FFAppState()
                                                        .CountWordsUsername ==
                                                    0)) {
                                              FFAppState()
                                                      .boolCountWordsPassword =
                                                  true;
                                              FFAppState()
                                                      .stringCountWordsPassword =
                                                  getJsonField(
                                                (_model.apiResult49j
                                                        ?.jsonBody ??
                                                    ''),
                                                r'''$.messages.password[0]''',
                                              ).toString();
                                              FFAppState().boolCpolorUsername =
                                                  true;
                                              FFAppState().boolColorPassword =
                                                  true;
                                              setState(() {});
                                            } else {
                                              FFAppState().boolCpolorUsername =
                                                  false;
                                              FFAppState().boolColorPassword =
                                                  false;
                                              setState(() {});
                                            }

                                            if ((FFAppState()
                                                        .CountWordsPassword !=
                                                    0) &&
                                                (FFAppState()
                                                        .CountWordsUsername ==
                                                    0)) {
                                              FFAppState()
                                                      .boolCountWordsPassword =
                                                  false;
                                              FFAppState().boolColorPassword =
                                                  false;
                                              FFAppState().boolCpolorUsername =
                                                  true;
                                              setState(() {});
                                            }
                                            if ((FFAppState()
                                                        .CountWordsPassword !=
                                                    0) &&
                                                (FFAppState()
                                                        .CountWordsUsername !=
                                                    0)) {
                                              FFAppState()
                                                      .stringCountWordsPassword =
                                                  getJsonField(
                                                (_model.apiResult49j
                                                        ?.jsonBody ??
                                                    ''),
                                                r'''$.text''',
                                              ).toString();
                                              FFAppState()
                                                      .boolCountWordsPassword =
                                                  true;
                                              FFAppState().boolCpolorUsername =
                                                  false;
                                              FFAppState().boolColorPassword =
                                                  false;
                                              setState(() {});
                                            }
                                            FFAppState().StatusLogin =
                                                getJsonField(
                                              (_model.apiResult49j?.jsonBody ??
                                                  ''),
                                              r'''$.status''',
                                            ).toString();
                                            FFAppState().token = getJsonField(
                                              (_model.apiResult49j?.jsonBody ??
                                                  ''),
                                              r'''$.user''',
                                            ).toString();
                                            FFAppState().user = getJsonField(
                                              (_model.apiResult49j?.jsonBody ??
                                                  ''),
                                              r'''$.status''',
                                            ).toString();
                                            setState(() {});
                                            if ((FFAppState()
                                                        .CountWordsUsername !=
                                                    0) &&
                                                (FFAppState()
                                                        .CountWordsPassword ==
                                                    0)) {
                                              FFAppState()
                                                      .boolCountWordsPassword =
                                                  true;
                                              FFAppState()
                                                      .stringCountWordsPassword =
                                                  getJsonField(
                                                (_model.apiResult49j
                                                        ?.jsonBody ??
                                                    ''),
                                                r'''$.messages.password[0]''',
                                              ).toString();
                                              FFAppState().boolCpolorUsername =
                                                  false;
                                              FFAppState().boolColorPassword =
                                                  true;
                                              setState(() {});
                                            }
                                          }

                                          setState(() {});
                                        },
                                        text: 'PRIJAVA',
                                        options: FFButtonOptions(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.9,
                                          height: 50.0,
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          iconPadding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          color: const Color(0xFFD9B24C),
                                          textStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleMedium
                                                  .override(
                                                    fontFamily: 'PT Sans',
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                          elevation: 2.0,
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: const AlignmentDirectional(0.0, -1.0),
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 10.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Nemaš račun?',
                                            textAlign: TextAlign.start,
                                            style: FlutterFlowTheme.of(context)
                                                .displayLarge
                                                .override(
                                                  fontFamily: 'PT Sans',
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsetsDirectional.fromSTEB(
                                                    5.0, 0.0, 0.0, 0.0),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                setState(() {
                                                  _model.tabBarController!
                                                      .animateTo(
                                                    1,
                                                    duration: const Duration(
                                                        milliseconds: 300),
                                                    curve: Curves.ease,
                                                  );
                                                });
                                              },
                                              child: Text(
                                                'Registriraj se',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .override(
                                                          fontFamily: 'PT Sans',
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                        ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        0.0, 10.0, 0.0, 0.0),
                                    child: Text(
                                      '© 2024 Gentlemen\'s Shop',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'PT Serif',
                                            color: FlutterFlowTheme.of(context)
                                                .secondary,
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        16.0, 30.0, 16.0, 0.0),
                                    child: SizedBox(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.9,
                                      child: TextFormField(
                                        controller:
                                            _model.firstNameTxtTextController,
                                        focusNode: _model.firstNameTxtFocusNode,
                                        autofocus: true,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Ime *',
                                          labelStyle: FlutterFlowTheme.of(
                                                  context)
                                              .displayLarge
                                              .override(
                                                fontFamily: 'PT Sans',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                letterSpacing: 0.0,
                                              ),
                                          hintStyle: FlutterFlowTheme.of(
                                                  context)
                                              .displayLarge
                                              .override(
                                                fontFamily: 'PT Sans',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                letterSpacing: 0.0,
                                              ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FFAppState().boolFirstName
                                                  ? const Color(0xFFDC3545)
                                                  : FlutterFlowTheme.of(context)
                                                      .secondary,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FFAppState().boolFirstName
                                                  ? const Color(0xFFDC3545)
                                                  : FlutterFlowTheme.of(context)
                                                      .primary,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          filled: true,
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .displayLarge
                                            .override(
                                              fontFamily: 'PT Sans',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondary,
                                              letterSpacing: 0.0,
                                            ),
                                        textAlign: TextAlign.center,
                                        cursorColor:
                                            FlutterFlowTheme.of(context)
                                                .secondary,
                                        validator: _model
                                            .firstNameTxtTextControllerValidator
                                            .asValidator(context),
                                      ),
                                    ),
                                  ),
                                  if (FFAppState().boolFirstName)
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          5.0, 20.0, 0.0, 10.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Align(
                                            alignment:
                                                const AlignmentDirectional(0.0, -1.0),
                                            child: Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      16.0, 0.0, 16.0, 0.0),
                                              child: Container(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.9,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFDC3545),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(0.0),
                                                    bottomRight:
                                                        Radius.circular(0.0),
                                                    topLeft:
                                                        Radius.circular(0.0),
                                                    topRight:
                                                        Radius.circular(0.0),
                                                  ),
                                                  shape: BoxShape.rectangle,
                                                  border: Border.all(
                                                    color: const Color(0xFFDC3545),
                                                  ),
                                                ),
                                                child: Visibility(
                                                  visible: FFAppState()
                                                      .boolFirstName,
                                                  child: Align(
                                                    alignment:
                                                        const AlignmentDirectional(
                                                            0.0, 1.0),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  10.0,
                                                                  0.0,
                                                                  10.0,
                                                                  0.0),
                                                      child: Text(
                                                        FFAppState()
                                                            .stringFirstNameRegistration,
                                                        textAlign:
                                                            TextAlign.start,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'PT Serif',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary,
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        16.0, 20.0, 16.0, 0.0),
                                    child: SizedBox(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.9,
                                      child: TextFormField(
                                        controller:
                                            _model.lastNameTxtTextController,
                                        focusNode: _model.lastNameTxtFocusNode,
                                        autofocus: true,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Prezime *',
                                          labelStyle: FlutterFlowTheme.of(
                                                  context)
                                              .displayLarge
                                              .override(
                                                fontFamily: 'PT Sans',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                letterSpacing: 0.0,
                                              ),
                                          hintStyle: FlutterFlowTheme.of(
                                                  context)
                                              .displayLarge
                                              .override(
                                                fontFamily: 'PT Sans',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                letterSpacing: 0.0,
                                              ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FFAppState().boolLastName
                                                  ? const Color(0xFFDC3545)
                                                  : FlutterFlowTheme.of(context)
                                                      .secondary,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FFAppState().boolLastName
                                                  ? const Color(0xFFDC3545)
                                                  : FlutterFlowTheme.of(context)
                                                      .primary,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          filled: true,
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .displayLarge
                                            .override(
                                              fontFamily: 'PT Sans',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondary,
                                              letterSpacing: 0.0,
                                            ),
                                        textAlign: TextAlign.center,
                                        cursorColor:
                                            FlutterFlowTheme.of(context)
                                                .secondary,
                                        validator: _model
                                            .lastNameTxtTextControllerValidator
                                            .asValidator(context),
                                      ),
                                    ),
                                  ),
                                  if (FFAppState().boolLastName)
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          5.0, 20.0, 0.0, 10.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Align(
                                            alignment:
                                                const AlignmentDirectional(0.0, -1.0),
                                            child: Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      16.0, 0.0, 16.0, 0.0),
                                              child: Container(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.9,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFDC3545),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(0.0),
                                                    bottomRight:
                                                        Radius.circular(0.0),
                                                    topLeft:
                                                        Radius.circular(0.0),
                                                    topRight:
                                                        Radius.circular(0.0),
                                                  ),
                                                  shape: BoxShape.rectangle,
                                                  border: Border.all(
                                                    color: const Color(0xFFDC3545),
                                                  ),
                                                ),
                                                child: Visibility(
                                                  visible:
                                                      FFAppState().boolLastName,
                                                  child: Align(
                                                    alignment:
                                                        const AlignmentDirectional(
                                                            0.0, 1.0),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  10.0,
                                                                  0.0,
                                                                  10.0,
                                                                  0.0),
                                                      child: Text(
                                                        FFAppState()
                                                            .stringLastNameRegistration,
                                                        textAlign:
                                                            TextAlign.start,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'PT Serif',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary,
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        16.0, 20.0, 16.0, 0.0),
                                    child: SizedBox(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.9,
                                      child: TextFormField(
                                        controller:
                                            _model.usernameTxtTextController,
                                        focusNode: _model.usernameTxtFocusNode,
                                        autofocus: true,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'E-mail *',
                                          labelStyle: FlutterFlowTheme.of(
                                                  context)
                                              .displayLarge
                                              .override(
                                                fontFamily: 'PT Sans',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                letterSpacing: 0.0,
                                              ),
                                          hintStyle: FlutterFlowTheme.of(
                                                  context)
                                              .displayLarge
                                              .override(
                                                fontFamily: 'PT Sans',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                letterSpacing: 0.0,
                                              ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FFAppState()
                                                      .boolEmailRegistration
                                                  ? const Color(0xFFDC3545)
                                                  : FlutterFlowTheme.of(context)
                                                      .secondary,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FFAppState()
                                                      .boolEmailRegistration
                                                  ? const Color(0xFFDC3545)
                                                  : FlutterFlowTheme.of(context)
                                                      .primary,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          filled: true,
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .displayLarge
                                            .override(
                                              fontFamily: 'PT Sans',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondary,
                                              letterSpacing: 0.0,
                                            ),
                                        textAlign: TextAlign.center,
                                        cursorColor:
                                            FlutterFlowTheme.of(context)
                                                .secondary,
                                        validator: _model
                                            .usernameTxtTextControllerValidator
                                            .asValidator(context),
                                      ),
                                    ),
                                  ),
                                  if (FFAppState().boolEmailRegistration)
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          5.0, 20.0, 0.0, 10.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Align(
                                            alignment:
                                                const AlignmentDirectional(0.0, -1.0),
                                            child: Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      16.0, 0.0, 16.0, 0.0),
                                              child: Container(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.9,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFDC3545),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(0.0),
                                                    bottomRight:
                                                        Radius.circular(0.0),
                                                    topLeft:
                                                        Radius.circular(0.0),
                                                    topRight:
                                                        Radius.circular(0.0),
                                                  ),
                                                  shape: BoxShape.rectangle,
                                                  border: Border.all(
                                                    color: const Color(0xFFDC3545),
                                                  ),
                                                ),
                                                child: Visibility(
                                                  visible: FFAppState()
                                                      .boolEmailRegistration,
                                                  child: Align(
                                                    alignment:
                                                        const AlignmentDirectional(
                                                            0.0, 1.0),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  10.0,
                                                                  0.0,
                                                                  10.0,
                                                                  0.0),
                                                      child: Text(
                                                        FFAppState()
                                                            .stringEmailRegistration,
                                                        textAlign:
                                                            TextAlign.start,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'PT Serif',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary,
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        16.0, 20.0, 16.0, 0.0),
                                    child: SizedBox(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.9,
                                      child: TextFormField(
                                        controller:
                                            _model.phoneTxtTextController,
                                        focusNode: _model.phoneTxtFocusNode,
                                        autofocus: true,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Mobitel *',
                                          labelStyle: FlutterFlowTheme.of(
                                                  context)
                                              .displayLarge
                                              .override(
                                                fontFamily: 'PT Sans',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                letterSpacing: 0.0,
                                              ),
                                          hintStyle: FlutterFlowTheme.of(
                                                  context)
                                              .displayLarge
                                              .override(
                                                fontFamily: 'PT Sans',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                letterSpacing: 0.0,
                                              ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FFAppState().boolPhone
                                                  ? const Color(0xFFDC3545)
                                                  : FlutterFlowTheme.of(context)
                                                      .secondary,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FFAppState().boolPhone
                                                  ? const Color(0xFFDC3545)
                                                  : FlutterFlowTheme.of(context)
                                                      .primary,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          filled: true,
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .displayLarge
                                            .override(
                                              fontFamily: 'PT Sans',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondary,
                                              letterSpacing: 0.0,
                                            ),
                                        textAlign: TextAlign.center,
                                        cursorColor:
                                            FlutterFlowTheme.of(context)
                                                .secondary,
                                        validator: _model
                                            .phoneTxtTextControllerValidator
                                            .asValidator(context),
                                      ),
                                    ),
                                  ),
                                  if (FFAppState().boolPhone)
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          5.0, 20.0, 0.0, 10.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Align(
                                            alignment:
                                                const AlignmentDirectional(0.0, -1.0),
                                            child: Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      16.0, 0.0, 16.0, 0.0),
                                              child: Container(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.9,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFDC3545),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(0.0),
                                                    bottomRight:
                                                        Radius.circular(0.0),
                                                    topLeft:
                                                        Radius.circular(0.0),
                                                    topRight:
                                                        Radius.circular(0.0),
                                                  ),
                                                  shape: BoxShape.rectangle,
                                                  border: Border.all(
                                                    color: const Color(0xFFDC3545),
                                                  ),
                                                ),
                                                child: Visibility(
                                                  visible:
                                                      FFAppState().boolPhone,
                                                  child: Align(
                                                    alignment:
                                                        const AlignmentDirectional(
                                                            0.0, 1.0),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  10.0,
                                                                  0.0,
                                                                  10.0,
                                                                  0.0),
                                                      child: Text(
                                                        FFAppState()
                                                            .StringPhoneRegistration,
                                                        textAlign:
                                                            TextAlign.start,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'PT Serif',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary,
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        16.0, 20.0, 16.0, 0.0),
                                    child: SizedBox(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.9,
                                      child: TextFormField(
                                        controller:
                                            _model.passwordTxtTextController,
                                        focusNode: _model.passwordTxtFocusNode,
                                        autofocus: true,
                                        textCapitalization:
                                            TextCapitalization.none,
                                        obscureText:
                                            !_model.passwordTxtVisibility,
                                        decoration: InputDecoration(
                                          labelText: 'Lozinka *',
                                          labelStyle: FlutterFlowTheme.of(
                                                  context)
                                              .displayLarge
                                              .override(
                                                fontFamily: 'PT Sans',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                letterSpacing: 0.0,
                                              ),
                                          hintStyle: FlutterFlowTheme.of(
                                                  context)
                                              .displayLarge
                                              .override(
                                                fontFamily: 'PT Sans',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                letterSpacing: 0.0,
                                              ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FFAppState()
                                                      .boolPasswordRegistration
                                                  ? const Color(0xFFDC3545)
                                                  : FlutterFlowTheme.of(context)
                                                      .secondary,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FFAppState()
                                                      .boolPasswordRegistration
                                                  ? const Color(0xFFDC3545)
                                                  : FlutterFlowTheme.of(context)
                                                      .primary,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          suffixIcon: InkWell(
                                            onTap: () => setState(
                                              () => _model
                                                      .passwordTxtVisibility =
                                                  !_model.passwordTxtVisibility,
                                            ),
                                            focusNode:
                                                FocusNode(skipTraversal: true),
                                            child: Icon(
                                              _model.passwordTxtVisibility
                                                  ? Icons.visibility_outlined
                                                  : Icons
                                                      .visibility_off_outlined,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondary,
                                              size: 22,
                                            ),
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .displayLarge
                                            .override(
                                              fontFamily: 'PT Sans',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondary,
                                              letterSpacing: 0.0,
                                            ),
                                        textAlign: TextAlign.center,
                                        cursorColor:
                                            FlutterFlowTheme.of(context)
                                                .secondary,
                                        validator: _model
                                            .passwordTxtTextControllerValidator
                                            .asValidator(context),
                                      ),
                                    ),
                                  ),
                                  if (FFAppState().boolPasswordRegistration)
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          5.0, 20.0, 0.0, 10.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Align(
                                            alignment:
                                                const AlignmentDirectional(0.0, -1.0),
                                            child: Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      16.0, 0.0, 16.0, 0.0),
                                              child: Container(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.9,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFDC3545),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(0.0),
                                                    bottomRight:
                                                        Radius.circular(0.0),
                                                    topLeft:
                                                        Radius.circular(0.0),
                                                    topRight:
                                                        Radius.circular(0.0),
                                                  ),
                                                  shape: BoxShape.rectangle,
                                                  border: Border.all(
                                                    color: const Color(0xFFDC3545),
                                                  ),
                                                ),
                                                child: Visibility(
                                                  visible: FFAppState()
                                                      .boolPasswordRegistration,
                                                  child: Align(
                                                    alignment:
                                                        const AlignmentDirectional(
                                                            0.0, 1.0),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  10.0,
                                                                  0.0,
                                                                  10.0,
                                                                  0.0),
                                                      child: Text(
                                                        FFAppState()
                                                            .stringPasswordRegistration,
                                                        textAlign:
                                                            TextAlign.start,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'PT Serif',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary,
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        16.0, 20.0, 16.0, 0.0),
                                    child: SizedBox(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.9,
                                      child: TextFormField(
                                        controller: _model
                                            .confirmPasswordTxtTextController,
                                        focusNode:
                                            _model.confirmPasswordTxtFocusNode,
                                        autofocus: true,
                                        textCapitalization:
                                            TextCapitalization.none,
                                        obscureText: !_model
                                            .confirmPasswordTxtVisibility,
                                        decoration: InputDecoration(
                                          labelText: 'Ponovi lozinku *',
                                          labelStyle: FlutterFlowTheme.of(
                                                  context)
                                              .displayLarge
                                              .override(
                                                fontFamily: 'PT Sans',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                letterSpacing: 0.0,
                                              ),
                                          hintStyle: FlutterFlowTheme.of(
                                                  context)
                                              .displayLarge
                                              .override(
                                                fontFamily: 'PT Sans',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                letterSpacing: 0.0,
                                              ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FFAppState()
                                                      .boolPasswordRepeatRegistration
                                                  ? const Color(0xFFDC3545)
                                                  : FlutterFlowTheme.of(context)
                                                      .secondary,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FFAppState()
                                                      .boolPasswordRepeatRegistration
                                                  ? const Color(0xFFDC3545)
                                                  : FlutterFlowTheme.of(context)
                                                      .primary,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          suffixIcon: InkWell(
                                            onTap: () => setState(
                                              () => _model
                                                      .confirmPasswordTxtVisibility =
                                                  !_model
                                                      .confirmPasswordTxtVisibility,
                                            ),
                                            focusNode:
                                                FocusNode(skipTraversal: true),
                                            child: Icon(
                                              _model.confirmPasswordTxtVisibility
                                                  ? Icons.visibility_outlined
                                                  : Icons
                                                      .visibility_off_outlined,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondary,
                                              size: 22,
                                            ),
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .displayLarge
                                            .override(
                                              fontFamily: 'PT Sans',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondary,
                                              letterSpacing: 0.0,
                                            ),
                                        textAlign: TextAlign.center,
                                        cursorColor:
                                            FlutterFlowTheme.of(context)
                                                .secondary,
                                        validator: _model
                                            .confirmPasswordTxtTextControllerValidator
                                            .asValidator(context),
                                      ),
                                    ),
                                  ),
                                  if ((FFAppState()
                                              .boolPasswordRepeatRegistration ==
                                          true) ||
                                      (FFAppState().boolNewRegistration ==
                                          true))
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          5.0, 20.0, 0.0, 10.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Align(
                                            alignment:
                                                const AlignmentDirectional(0.0, -1.0),
                                            child: Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      16.0, 0.0, 16.0, 0.0),
                                              child: Container(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.9,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFDC3545),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(0.0),
                                                    bottomRight:
                                                        Radius.circular(0.0),
                                                    topLeft:
                                                        Radius.circular(0.0),
                                                    topRight:
                                                        Radius.circular(0.0),
                                                  ),
                                                  shape: BoxShape.rectangle,
                                                  border: Border.all(
                                                    color: const Color(0xFFDC3545),
                                                  ),
                                                ),
                                                child: Visibility(
                                                  visible: (FFAppState()
                                                              .boolPasswordRepeatRegistration ==
                                                          true) ||
                                                      (FFAppState()
                                                              .boolNewRegistration ==
                                                          true),
                                                  child: Align(
                                                    alignment:
                                                        const AlignmentDirectional(
                                                            0.0, 1.0),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  10.0,
                                                                  0.0,
                                                                  10.0,
                                                                  0.0),
                                                      child: Text(
                                                        FFAppState()
                                                            .stringPasswordRepeatRegistration,
                                                        textAlign:
                                                            TextAlign.start,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'PT Serif',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary,
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        16.0, 20.0, 16.0, 20.0),
                                    child: FFButtonWidget(
                                      onPressed: () async {
                                        FFAppState().boolNewRegistration =
                                            false;
                                        setState(() {});
                                        _model.apiResult3ls =
                                            await RegistrationCall.call(
                                          username: _model
                                              .usernameTxtTextController.text,
                                          password: _model
                                              .passwordTxtTextController.text,
                                          firstName: _model
                                              .firstNameTxtTextController.text,
                                          lastName: _model
                                              .lastNameTxtTextController.text,
                                          email: _model
                                              .usernameTxtTextController.text,
                                          phone: _model
                                              .phoneTxtTextController.text,
                                          privacyPolicy: '1',
                                          newsletter: '1',
                                          passwordRepeat: _model
                                              .confirmPasswordTxtTextController
                                              .text,
                                        );

                                        FFAppState().token = getJsonField(
                                          (_model.apiResult3ls?.jsonBody ?? ''),
                                          r'''$.user''',
                                        ).toString();
                                        FFAppState().user = getJsonField(
                                          (_model.apiResult3ls?.jsonBody ?? ''),
                                          r'''$.status''',
                                        ).toString();
                                        setState(() {});
                                        if (FFAppState().user == 'error') {
                                          FFAppState().intFirstNameCount =
                                              _model.firstNameTxtTextController
                                                  .text.length;
                                          FFAppState().intLastNameCount = _model
                                              .lastNameTxtTextController
                                              .text
                                              .length;
                                          FFAppState().intphoneCount = _model
                                              .phoneTxtTextController
                                              .text
                                              .length;
                                          FFAppState().countEmailRegistration =
                                              _model.usernameTxtTextController
                                                  .text.length;
                                          FFAppState()
                                                  .countPasswordRegistration =
                                              _model.passwordTxtTextController
                                                  .text.length;
                                          FFAppState()
                                                  .countPasswordRepeatRegistration =
                                              _model
                                                  .confirmPasswordTxtTextController
                                                  .text
                                                  .length;
                                          setState(() {});
                                          if (FFAppState().intFirstNameCount ==
                                              0) {
                                            FFAppState().boolFirstName = true;
                                            FFAppState()
                                                    .stringFirstNameRegistration =
                                                getJsonField(
                                              (_model.apiResult3ls?.jsonBody ??
                                                  ''),
                                              r'''$.messages.first_name[0]''',
                                            ).toString();
                                            setState(() {});
                                          } else {
                                            FFAppState().boolFirstName = false;
                                            setState(() {});
                                          }

                                          if (FFAppState().intLastNameCount ==
                                              0) {
                                            FFAppState().boolLastName = true;
                                            FFAppState()
                                                    .stringLastNameRegistration =
                                                getJsonField(
                                              (_model.apiResult3ls?.jsonBody ??
                                                  ''),
                                              r'''$.messages.last_name[0]''',
                                            ).toString();
                                            setState(() {});
                                          } else {
                                            FFAppState().boolLastName = false;
                                            setState(() {});
                                          }

                                          FFAppState()
                                                  .stringEmailForRegistration =
                                              getJsonField(
                                            (_model.apiResult3ls?.jsonBody ??
                                                ''),
                                            r'''$.messages.email[0]''',
                                          ).toString();
                                          setState(() {});
                                          if (FFAppState()
                                                  .stringEmailForRegistration ==
                                              'null') {
                                            FFAppState().boolEmailRegistration =
                                                false;
                                            setState(() {});
                                          } else {
                                            FFAppState().boolEmailRegistration =
                                                true;
                                            FFAppState()
                                                    .stringEmailRegistration =
                                                getJsonField(
                                              (_model.apiResult3ls?.jsonBody ??
                                                  ''),
                                              r'''$.messages.email[0]''',
                                            ).toString();
                                            setState(() {});
                                          }

                                          if (FFAppState().intphoneCount == 0) {
                                            FFAppState().boolPhone = true;
                                            FFAppState()
                                                    .StringPhoneRegistration =
                                                getJsonField(
                                              (_model.apiResult3ls?.jsonBody ??
                                                  ''),
                                              r'''$.messages.phone[0]''',
                                            ).toString();
                                            setState(() {});
                                          } else {
                                            FFAppState().boolPhone = false;
                                            setState(() {});
                                          }

                                          FFAppState()
                                                  .stringPasswordForRegistration =
                                              getJsonField(
                                            (_model.apiResult3ls?.jsonBody ??
                                                ''),
                                            r'''$.messages.password[0]''',
                                          ).toString();
                                          setState(() {});
                                          if (FFAppState()
                                                  .stringPasswordForRegistration ==
                                              'null') {
                                            FFAppState()
                                                    .boolPasswordRegistration =
                                                false;
                                            setState(() {});
                                          } else {
                                            FFAppState()
                                                    .boolPasswordRegistration =
                                                true;
                                            FFAppState()
                                                    .stringPasswordRegistration =
                                                getJsonField(
                                              (_model.apiResult3ls?.jsonBody ??
                                                  ''),
                                              r'''$.messages.password[0]''',
                                            ).toString();
                                            setState(() {});
                                          }

                                          FFAppState()
                                                  .stringPasswordRepeatRegistrationNull =
                                              getJsonField(
                                            (_model.apiResult3ls?.jsonBody ??
                                                ''),
                                            r'''$.messages.password_repeat[0]''',
                                          ).toString();
                                          setState(() {});
                                          if (FFAppState()
                                                  .stringPasswordRepeatRegistrationNull ==
                                              'null') {
                                            FFAppState()
                                                    .boolPasswordRepeatRegistration =
                                                false;
                                            setState(() {});
                                          } else {
                                            FFAppState()
                                                    .boolPasswordRepeatRegistration =
                                                true;
                                            FFAppState()
                                                    .stringPasswordRepeatRegistration =
                                                getJsonField(
                                              (_model.apiResult3ls?.jsonBody ??
                                                  ''),
                                              r'''$.messages.password_repeat[0]''',
                                            ).toString();
                                            setState(() {});
                                          }

                                          if ((FFAppState().boolLastName ==
                                                  false) &&
                                              (FFAppState()
                                                      .boolFirstName ==
                                                  false) &&
                                              ((FFAppState()
                                                          .boolPhone ==
                                                      false) &&
                                                  (FFAppState()
                                                          .boolEmailRegistration ==
                                                      false) &&
                                                  (FFAppState()
                                                          .boolPasswordRegistration ==
                                                      false) &&
                                                  (FFAppState()
                                                          .boolPasswordRepeatRegistration ==
                                                      false))) {
                                            FFAppState()
                                                    .stringPasswordRepeatRegistration =
                                                getJsonField(
                                              (_model.apiResult3ls?.jsonBody ??
                                                  ''),
                                              r'''$.text''',
                                            ).toString();
                                            FFAppState().boolNewRegistration =
                                                true;
                                            setState(() {});
                                          }
                                        } else {
                                          await actions
                                              .customAlertDialogRegistration(
                                            context,
                                            getJsonField(
                                              (_model.apiResult3ls?.jsonBody ??
                                                  ''),
                                              r'''$.title''',
                                            ).toString(),
                                            getJsonField(
                                              (_model.apiResult3ls?.jsonBody ??
                                                  ''),
                                              r'''$.text''',
                                            ).toString(),
                                          );
                                        }

                                        setState(() {});
                                      },
                                      text: 'REGISTRIRACIJA',
                                      options: FFButtonOptions(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.9,
                                        height: 50.0,
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 0.0),
                                        iconPadding:
                                            const EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: const Color(0xFFD9B24C),
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .override(
                                              fontFamily: 'PT Sans',
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w800,
                                            ),
                                        elevation: 2.0,
                                        borderSide: const BorderSide(
                                          color: Colors.transparent,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: const AlignmentDirectional(0.0, -1.0),
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 10.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              setState(() {
                                                _model.tabBarController!
                                                    .animateTo(
                                                  0,
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                  curve: Curves.ease,
                                                );
                                              });
                                            },
                                            child: Text(
                                              'Prijavi se',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .override(
                                                        fontFamily: 'PT Sans',
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                      ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        0.0, 10.0, 0.0, 20.0),
                                    child: Text(
                                      '© 2024 Gentlemen\'s Shop',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'PT Serif',
                                            color: FlutterFlowTheme.of(context)
                                                .secondary,
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
