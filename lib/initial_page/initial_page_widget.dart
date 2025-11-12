import '/auth/firebase_auth/auth_util.dart';
import '/components/all_user_widget.dart';
import '/components/map_real_time_widget.dart';
import '/components/pagina_inicial_ride_adm_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'initial_page_model.dart';
export 'initial_page_model.dart';

class InitialPageWidget extends StatefulWidget {
  const InitialPageWidget({super.key});

  static String routeName = 'initialPage';
  static String routePath = 'initialPage';

  @override
  State<InitialPageWidget> createState() => _InitialPageWidgetState();
}

class _InitialPageWidgetState extends State<InitialPageWidget> {
  late InitialPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => InitialPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.instantTimer = InstantTimer.periodic(
        duration: Duration(milliseconds: 5000),
        callback: (timer) async {
          safeSetState(() {});
          _model.instantTimer?.cancel();
        },
        startImmediately: true,
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Title(
        title: 'initialPage',
        color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Color(0xFF232323),
            body: SafeArea(
              top: true,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (((currentUserDocument?.plataform.toList() ?? [])
                                    .contains('Ride Admin') ||
                                (currentUserDocument?.plataform.toList() ?? [])
                                    .contains('Ride Partner')) &&
                            (FFAppState().PagsRide == 'dashboard')) {
                          return Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: wrapWithModel(
                              model: _model.paginaInicialRideAdmModel,
                              updateCallback: () => safeSetState(() {}),
                              child: PaginaInicialRideAdmWidget(),
                            ),
                          );
                        } else if (((currentUserDocument?.plataform.toList() ?? [])
                                    .contains('Ride Admin') ||
                                (currentUserDocument?.plataform.toList() ?? [])
                                    .contains('Ride Partner')) &&
                            (FFAppState().PagsRide == 'Users')) {
                          return wrapWithModel(
                            model: _model.allUserModel,
                            updateCallback: () => safeSetState(() {}),
                            child: AllUserWidget(),
                          );
                        } else if (((currentUserDocument?.plataform.toList() ??
                                        [])
                                    .contains('Ride Admin') ||
                                (currentUserDocument?.plataform.toList() ?? [])
                                    .contains('Ride Partner')) &&
                            (FFAppState().PagsRide == 'map')) {
                          return wrapWithModel(
                            model: _model.mapRealTimeModel,
                            updateCallback: () => safeSetState(() {}),
                            child: MapRealTimeWidget(),
                          );
                        } else if (!(currentUserDocument?.plataform.toList() ??
                                    [])
                                .contains('Ride Admin') ||
                            !(currentUserDocument?.plataform.toList() ?? [])
                                .contains('Ride Partner')) {
                          return Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_sharp,
                                    color:
                                        FlutterFlowTheme.of(context).secondary,
                                    size: 40.0,
                                  ),
                                  Text(
                                    FFLocalizations.of(context).getText(
                                      'y0bpjfue' /* OOPS! You do not have permissi... */,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            fontStyle: FontStyle.italic,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.italic,
                                        ),
                                  ),
                                ].divide(SizedBox(height: 8.0)),
                              ),
                            ],
                          );
                        } else {
                          return Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_sharp,
                                    color:
                                        FlutterFlowTheme.of(context).secondary,
                                    size: 40.0,
                                  ),
                                  Text(
                                    FFLocalizations.of(context).getText(
                                      'rkpd38ij' /* OOPS! You do not have permissi... */,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            fontStyle: FontStyle.italic,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.italic,
                                        ),
                                  ),
                                ].divide(SizedBox(height: 8.0)),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
