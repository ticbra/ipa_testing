import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'nav_bar_with_middle_button_model.dart';
export 'nav_bar_with_middle_button_model.dart';

class NavBarWithMiddleButtonWidget extends StatefulWidget {
  const NavBarWithMiddleButtonWidget({
    super.key,
    required this.pageName,
  });

  final String? pageName;

  @override
  State<NavBarWithMiddleButtonWidget> createState() =>
      _NavBarWithMiddleButtonWidgetState();
}

class _NavBarWithMiddleButtonWidgetState
    extends State<NavBarWithMiddleButtonWidget> {
  late NavBarWithMiddleButtonModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NavBarWithMiddleButtonModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * 0.12,
      decoration: const BoxDecoration(
        color: Color(0xFF212529),
      ),
      child: Align(
        alignment: const AlignmentDirectional(0.0, -1.0),
        child: Stack(
          alignment: const AlignmentDirectional(0.0, 1.0),
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height * 0.1,
              decoration: const BoxDecoration(
                color: Color(0xFF212529),
              ),
              child: Align(
                alignment: const AlignmentDirectional(0.0, 1.0),
                child: Stack(
                  alignment: const AlignmentDirectional(0.0, 1.0),
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(0.0),
                      child: SvgPicture.asset(
                        'assets/images/nav-bg-dark.svg',
                        width: double.infinity,
                        height: 200.0,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            context.pushNamed('UserPage');
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10.0, 0.0, 0.0, 0.0),
                                child: FlutterFlowIconButton(
                                  borderColor: Colors.transparent,
                                  borderWidth: 1.0,
                                  icon: Icon(
                                    Icons.home_rounded,
                                    color: widget.pageName == 'UserPage'
                                        ? FlutterFlowTheme.of(context).primary
                                        : FlutterFlowTheme.of(context)
                                            .secondary,
                                    size: 30.0,
                                  ),
                                  onPressed: () async {
                                    if (widget.pageName != 'UserPage') {
                                      context.pushNamed('UserPage');
                                    }
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10.0, 0.0, 0.0, 0.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    if (widget.pageName != 'UserPage') {
                                      context.pushNamed('UserPage');
                                    }
                                  },
                                  child: Text(
                                    'Početna',
                                    style: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          fontFamily: 'PT Sans',
                                          color: widget.pageName == 'UserPage'
                                              ? FlutterFlowTheme.of(context)
                                                  .primary
                                              : FlutterFlowTheme.of(context)
                                                  .secondary,
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 48.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              FlutterFlowIconButton(
                                borderColor: Colors.transparent,
                                borderWidth: 1.0,
                                icon: Icon(
                                  Icons.schedule_rounded,
                                  color: widget.pageName ==
                                          'listReservationPage'
                                      ? FlutterFlowTheme.of(context).primary
                                      : FlutterFlowTheme.of(context).secondary,
                                  size: 30.0,
                                ),
                                onPressed: () async {
                                  if (widget.pageName !=
                                      'listReservationPage') {
                                    context.pushNamed('listReservationPage');
                                  }
                                },
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  if (widget.pageName !=
                                      'listReservationPage') {
                                    context.pushNamed('listReservationPage');
                                  }
                                },
                                child: Text(
                                  'Rezervacije',
                                  style: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                        fontFamily: 'PT Sans',
                                        color: widget.pageName ==
                                                'listReservationPage'
                                            ? FlutterFlowTheme.of(context)
                                                .primary
                                            : FlutterFlowTheme.of(context)
                                                .secondary,
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            FlutterFlowIconButton(
                              borderColor: Colors.transparent,
                              borderWidth: 1.0,
                              icon: Icon(
                                Icons.local_activity_outlined,
                                color: () {
                                  if (widget.pageName == 'ActivityCopy') {
                                    return FlutterFlowTheme.of(context).primary;
                                  } else if (widget.pageName ==
                                      'ActivityCopy2') {
                                    return FlutterFlowTheme.of(context).primary;
                                  } else {
                                    return FlutterFlowTheme.of(context)
                                        .secondary;
                                  }
                                }(),
                                size: 30.0,
                              ),
                              onPressed: () async {
                                if (widget.pageName != 'ActivityCopy') {
                                  context.pushNamed('ActivityCopy');
                                }
                              },
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                if (widget.pageName != 'ActivityCopy') {
                                  context.pushNamed('ActivityCopy');
                                }
                              },
                              child: Text(
                                'Aktivnosti',
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      fontFamily: 'PT Sans',
                                      color: () {
                                        if (widget.pageName ==
                                            'ActivityCopy') {
                                          return FlutterFlowTheme.of(context)
                                              .primary;
                                        } else if (widget.pageName ==
                                            'ActivityCopy2') {
                                          return FlutterFlowTheme.of(context)
                                              .primary;
                                        } else {
                                          return FlutterFlowTheme.of(context)
                                              .secondary;
                                        }
                                      }(),
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 10.0, 0.0),
                              child: FlutterFlowIconButton(
                                borderColor: Colors.transparent,
                                borderWidth: 1.0,
                                icon: Icon(
                                  Icons.account_circle,
                                  color: () {
                                    if (widget.pageName == 'Profil') {
                                      return FlutterFlowTheme.of(context)
                                          .primary;
                                    } else if (widget.pageName == 'Profil2') {
                                      return FlutterFlowTheme.of(context)
                                          .primary;
                                    } else {
                                      return FlutterFlowTheme.of(context)
                                          .secondary;
                                    }
                                  }(),
                                  size: 30.0,
                                ),
                                onPressed: () async {
                                  if (widget.pageName != 'Profil') {
                                    context.pushNamed('PofilPage');
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 10.0, 0.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  if (widget.pageName != 'Profil') {
                                    context.pushNamed('PofilPage');
                                  }
                                },
                                child: Text(
                                  'Profil',
                                  style: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                        fontFamily: 'PT Sans',
                                        color: () {
                                          if (widget.pageName == 'Profil') {
                                            return FlutterFlowTheme.of(context)
                                                .primary;
                                          } else if (widget.pageName ==
                                              'Profil2') {
                                            return FlutterFlowTheme.of(context)
                                                .primary;
                                          } else {
                                            return FlutterFlowTheme.of(context)
                                                .secondary;
                                          }
                                        }(),
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(0.0, -1.0),
              child: FlutterFlowIconButton(
                borderRadius: 30.0,
                borderWidth: 1.0,
                buttonSize: 60.0,
                fillColor: FlutterFlowTheme.of(context).primary,
                icon: Icon(
                  Icons.add,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 40.0,
                ),
                onPressed: () async {
                  FFAppState().bookings = '';
                  FFAppState().bookServices = '';
                  FFAppState().bookServicesList = [];
                  FFAppState().bookTime = '0';
                  FFAppState().bookEmployee = 0;
                  FFAppState().boolSyncDate = false;
                  setState(() {});

                  context.pushNamed('Reservation');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
