import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'password_recovery_model.dart';
export 'password_recovery_model.dart';

class PasswordRecoveryWidget extends StatefulWidget {
  const PasswordRecoveryWidget({super.key});

  @override
  State<PasswordRecoveryWidget> createState() => _PasswordRecoveryWidgetState();
}

class _PasswordRecoveryWidgetState extends State<PasswordRecoveryWidget> {
  late PasswordRecoveryModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PasswordRecoveryModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      FFAppState().intRecoveryCount = 1;
      FFAppState().boolStatusRecovery = false;
      setState(() {});
    });

    _model.loginUsernameTxtTextController ??= TextEditingController();
    _model.loginUsernameTxtFocusNode ??= FocusNode();

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
          child: Wrap(
            spacing: 0.0,
            runSpacing: 0.0,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            direction: Axis.horizontal,
            runAlignment: WrapAlignment.start,
            verticalDirection: VerticalDirection.down,
            clipBehavior: Clip.none,
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
              Align(
                alignment: const AlignmentDirectional(0.0, -1.0),
                child: Text(
                  'GENTLEMEN\'S SHOP',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).displayLarge.override(
                        fontFamily: 'PT Sans',
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                        lineHeight: 2.0,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lock_reset,
                      color: FlutterFlowTheme.of(context).primary,
                      size: 46.0,
                    ),
                    Align(
                      alignment: const AlignmentDirectional(0.0, 0.0),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(6.0, 0.0, 0.0, 0.0),
                        child: Text(
                          'Promjena lozinke',
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .override(
                                fontFamily: 'PT Serif',
                                color: Colors.white,
                                fontSize: 32.0,
                                letterSpacing: 0.0,
                              ),
                        ),
                      ),
                    ),
                  ].divide(const SizedBox(width: 10.0)),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 30.0, 16.0, 0.0),
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  child: TextFormField(
                    controller: _model.loginUsernameTxtTextController,
                    focusNode: _model.loginUsernameTxtFocusNode,
                    onChanged: (_) => EasyDebounce.debounce(
                      '_model.loginUsernameTxtTextController',
                      const Duration(milliseconds: 0),
                      () async {
                        FFAppState().intRecoveryCount =
                            _model.loginUsernameTxtTextController.text.length;
                        setState(() {});
                        if (FFAppState().intRecoveryCount == 0) {
                          FFAppState().StatusRecovery = '';
                          setState(() {});
                        }
                      },
                    ),
                    autofocus: true,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'E-mail *',
                      labelStyle:
                          FlutterFlowTheme.of(context).displayLarge.override(
                                fontFamily: 'PT Sans',
                                color: FlutterFlowTheme.of(context).secondary,
                                letterSpacing: 0.0,
                              ),
                      hintStyle:
                          FlutterFlowTheme.of(context).displayLarge.override(
                                fontFamily: 'PT Sans',
                                color: FlutterFlowTheme.of(context).secondary,
                                letterSpacing: 0.0,
                              ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: (FFAppState().StatusRecovery == 'error') ||
                                  (FFAppState().intRecoveryCount == 0)
                              ? const Color(0xFFDC3545)
                              : FlutterFlowTheme.of(context).secondary,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FFAppState().boolStatusRecovery ||
                                  (FFAppState().intRecoveryCount == 0)
                              ? const Color(0xFFDC3545)
                              : FlutterFlowTheme.of(context).primary,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).error,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).error,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                    ),
                    style: FlutterFlowTheme.of(context).displayLarge.override(
                          fontFamily: 'PT Sans',
                          color: FlutterFlowTheme.of(context).secondary,
                          letterSpacing: 0.0,
                        ),
                    textAlign: TextAlign.center,
                    cursorColor: FlutterFlowTheme.of(context).secondary,
                    validator: _model.loginUsernameTxtTextControllerValidator
                        .asValidator(context),
                  ),
                ),
              ),
              if (FFAppState().boolStatusRecovery)
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(5.0, 20.0, 0.0, 10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: const AlignmentDirectional(0.0, -1.0),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * 0.9,
                            decoration: BoxDecoration(
                              color: const Color(0xFFDC3545),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(0.0),
                                bottomRight: Radius.circular(0.0),
                                topLeft: Radius.circular(0.0),
                                topRight: Radius.circular(0.0),
                              ),
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                color: const Color(0xFFDC3545),
                              ),
                            ),
                            child: Visibility(
                              visible: FFAppState().boolStatusRecovery,
                              child: Align(
                                alignment: const AlignmentDirectional(0.0, 1.0),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      10.0, 0.0, 10.0, 0.0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      context.pushNamed('ProfileEdit');
                                    },
                                    child: Text(
                                      FFAppState().emailRecoveryNew,
                                      textAlign: TextAlign.start,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'PT Serif',
                                            color: FlutterFlowTheme.of(context)
                                                .secondary,
                                            letterSpacing: 0.0,
                                          ),
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
                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 20.0, 16.0, 0.0),
                child: FFButtonWidget(
                  onPressed: () async {
                    _model.apiResultje9 = await PasswordRecoveryCall.call(
                      email: _model.loginUsernameTxtTextController.text,
                    );

                    FFAppState().StatusRecovery = getJsonField(
                      (_model.apiResultje9?.jsonBody ?? ''),
                      r'''$.status''',
                    ).toString();
                    setState(() {});
                    if (FFAppState().StatusRecovery == 'ok') {
                      await actions.customAlertDialogLogin(
                        context,
                        getJsonField(
                          (_model.apiResultje9?.jsonBody ?? ''),
                          r'''$.title''',
                        ).toString(),
                        getJsonField(
                          (_model.apiResultje9?.jsonBody ?? ''),
                          r'''$.text''',
                        ).toString(),
                      );
                      setState(() {
                        _model.loginUsernameTxtTextController?.clear();
                      });
                      FFAppState().boolStatusRecovery = false;
                      setState(() {});
                    } else {
                      FFAppState().emailRecovery = getJsonField(
                        (_model.apiResultje9?.jsonBody ?? ''),
                        r'''$.messages.email[0]''',
                      ).toString();
                      setState(() {});
                      FFAppState().emailRecoveryNew =
                          FFAppState().emailRecovery == 'null'
                              ? getJsonField(
                                  (_model.apiResultje9?.jsonBody ?? ''),
                                  r'''$.text''',
                                ).toString()
                              : FFAppState().emailRecovery;
                      setState(() {});
                      FFAppState().boolStatusRecovery = true;
                      setState(() {});
                    }

                    setState(() {});
                  },
                  text: 'POŠALJI',
                  options: FFButtonOptions(
                    width: MediaQuery.sizeOf(context).width * 0.9,
                    height: 50.0,
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    iconPadding:
                        const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle:
                        FlutterFlowTheme.of(context).titleMedium.override(
                              fontFamily: 'PT Sans',
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w800,
                            ),
                    elevation: 2.0,
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(0.0, 0.0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      context.pushNamed('LoginPage');
                    },
                    child: Text(
                      'Prijavi se',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'PT Sans',
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                          ),
                    ),
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
