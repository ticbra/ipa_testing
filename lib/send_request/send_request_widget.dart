import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'send_request_model.dart';
export 'send_request_model.dart';

class SendRequestWidget extends StatefulWidget {
  const SendRequestWidget({super.key});

  @override
  State<SendRequestWidget> createState() => _SendRequestWidgetState();
}

class _SendRequestWidgetState extends State<SendRequestWidget> {
  late SendRequestModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SendRequestModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: const Color(0xFF222529),
          appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.sizeOf(context).height * 0.12),
            child: AppBar(
              backgroundColor: const Color(0xFF343A40),
              automaticallyImplyLeading: false,
              title: Align(
                alignment: const AlignmentDirectional(0.0, 0.0),
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    context.pushNamed('UserPage');
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: const AlignmentDirectional(0.0, 0.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            FFAppState().bookings = '';
                            FFAppState().bookServices = '';
                            FFAppState().bookServicesList = [];
                            FFAppState().bookDate = '';
                            FFAppState().bookEmployee = 0;
                            FFAppState().bookTime = '     ';
                            setState(() {});

                            context.pushNamed('UserPage');
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              'assets/images/g-shop-logo.png',
                              width: 60.0,
                              height: 60.0,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Align(
                          alignment: const AlignmentDirectional(0.0, 0.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              FFAppState().bookings = '';
                              FFAppState().bookServices = '';
                              FFAppState().bookServicesList = [];
                              FFAppState().bookDate = '';
                              FFAppState().bookEmployee = 0;
                              FFAppState().bookTime = '     ';
                              setState(() {});

                              context.pushNamed('UserPage');
                            },
                            child: Text(
                              'GENTLEMEN\'S SHOP',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .override(
                                    fontFamily: 'PT Serif',
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: const [],
              centerTitle: true,
              toolbarHeight: MediaQuery.sizeOf(context).height * 0.1,
              elevation: 2.0,
            ),
          ),
          body: SafeArea(
            top: true,
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height * 0.9,
              child: custom_widgets.SendRequest(
                width: double.infinity,
                height: MediaQuery.sizeOf(context).height * 0.9,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
