import '/backend/backend.dart';
import '/components/componet_drivers_r_l_t1_widget.dart';
import '/components/componet_drivers_r_l_t2_widget.dart';
import '/components/componet_user1_widget.dart';
import '/components/componet_user2_widget.dart';
import '/components/navbar_ride_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'map_real_time_model.dart';
export 'map_real_time_model.dart';

class MapRealTimeWidget extends StatefulWidget {
  const MapRealTimeWidget({super.key});

  @override
  State<MapRealTimeWidget> createState() => _MapRealTimeWidgetState();
}

class _MapRealTimeWidgetState extends State<MapRealTimeWidget> {
  late MapRealTimeModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MapRealTimeModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<RideOrdersRecord>>(
      stream: queryRideOrdersRecord(),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Center(
            child: SizedBox(
              width: 50.0,
              height: 50.0,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).primary,
                ),
              ),
            ),
          );
        }
        List<RideOrdersRecord> containerRideOrdersRecordList = snapshot.data!;

        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(),
          child: Stack(
            children: [
              StreamBuilder<List<UsersRecord>>(
                stream: queryUsersRecord(),
                builder: (context, snapshot) {
                  // Customize what your widget looks like when it's loading.
                  if (!snapshot.hasData) {
                    return Center(
                      child: SizedBox(
                        width: 50.0,
                        height: 50.0,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                      ),
                    );
                  }
                  List<UsersRecord> mapAllUsersRealTimeUsersRecordList =
                      snapshot.data!;

                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: custom_widgets.MapAllUsersRealTime(
                      width: double.infinity,
                      height: double.infinity,
                      users: mapAllUsersRealTimeUsersRecordList,
                      rideOrders: containerRideOrdersRecordList,
                      webApiKey: 'AIzaSyCFBfcNHFg97sM7EhKnAP4OHIoY3Q8Y_xQ',
                      componenteUsersClick: (DocumentReference users) =>
                          ComponetUser1Widget(),
                      componenteDriversClick: (DocumentReference users) =>
                          ComponetDriversRLT1Widget(),
                      componenteDriverSOS: (DocumentReference users) =>
                          ComponetDriversRLT2Widget(),
                      componenteUsersSOS: (DocumentReference users) =>
                          ComponetUser2Widget(),
                    ),
                  );
                },
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(18.0, 18.0, 18.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            'assets/images/ride_gradient_190_fb9000_fbb125.png',
                            width: 203.7,
                            height: 76.1,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          width: 200.0,
                          height: 50.0,
                          child: custom_widgets.LifeTime(
                            width: 200.0,
                            height: 50.0,
                          ),
                        ),
                        wrapWithModel(
                          model: _model.navbarRideModel,
                          updateCallback: () => safeSetState(() {}),
                          child: NavbarRideWidget(),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 6.0,
                                    color: Color(0xFF141414),
                                    offset: Offset(
                                      1.0,
                                      3.0,
                                    ),
                                  )
                                ],
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFC97200),
                                    FlutterFlowTheme.of(context).accent3
                                  ],
                                  stops: [0.0, 1.0],
                                  begin: AlignmentDirectional(-0.34, 1.0),
                                  end: AlignmentDirectional(0.34, -1.0),
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.person_rounded,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 24.0,
                              ),
                            ),
                            Container(
                              width: 200.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 6.0,
                                    color: Color(0xFF141414),
                                    offset: Offset(
                                      1.0,
                                      3.0,
                                    ),
                                  )
                                ],
                                gradient: LinearGradient(
                                  colors: [
                                    FlutterFlowTheme.of(context).accent2,
                                    FlutterFlowTheme.of(context).accent3
                                  ],
                                  stops: [0.0, 1.0],
                                  begin: AlignmentDirectional(-0.34, 1.0),
                                  end: AlignmentDirectional(0.34, -1.0),
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    14.0, 0.0, 14.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      width: 30.0,
                                      height: 30.0,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.asset(
                                        'assets/images/meio_circulo_inferior_preto_512_corrigido.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Text(
                                      FFLocalizations.of(context).getText(
                                        'nn9aov30' /* Dark Theme */,
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                    FaIcon(
                                      FontAwesomeIcons.solidBell,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      size: 20.0,
                                    ),
                                  ].divide(SizedBox(width: 14.0)),
                                ),
                              ),
                            ),
                          ].divide(SizedBox(width: 10.0)),
                        ),
                      ],
                    ),
                  ].divide(SizedBox(height: 20.0)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
