import '/components/nav_bar_with_middle_button_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'list_special_page_model.dart';
export 'list_special_page_model.dart';

class ListSpecialPageWidget extends StatefulWidget {
  const ListSpecialPageWidget({super.key});

  @override
  State<ListSpecialPageWidget> createState() => _ListSpecialPageWidgetState();
}

class _ListSpecialPageWidgetState extends State<ListSpecialPageWidget> {
  late ListSpecialPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListSpecialPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      FFAppState().bookings = '';
      FFAppState().bookServices = '';
      FFAppState().bookServicesList = [];
      FFAppState().bookDate = '';
      FFAppState().bookEmployee = 0;
      FFAppState().bookTime = '     ';
      setState(() {});
    });

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
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.sizeOf(context).height * 0.753,
                decoration: const BoxDecoration(
                  color: Color(0xFF212529),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height * 0.753,
                  child: custom_widgets.ActivityTabs(
                    width: double.infinity,
                    height: MediaQuery.sizeOf(context).height * 0.753,
                    category: 'special',
                  ),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(0.0, 1.0),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height * 0.12,
                  decoration: const BoxDecoration(
                    color: Color(0xFF212529),
                  ),
                  child: Align(
                    alignment: const AlignmentDirectional(0.0, 1.0),
                    child: wrapWithModel(
                      model: _model.navBarWithMiddleButtonModel,
                      updateCallback: () => setState(() {}),
                      child: const NavBarWithMiddleButtonWidget(
                        pageName: 'ActivityCopy2',
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
