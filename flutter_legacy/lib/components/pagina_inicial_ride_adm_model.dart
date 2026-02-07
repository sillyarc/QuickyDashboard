import '/components/navbar_ride_widget.dart';
import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'pagina_inicial_ride_adm_widget.dart' show PaginaInicialRideAdmWidget;
import 'package:flutter/material.dart';

class PaginaInicialRideAdmModel
    extends FlutterFlowModel<PaginaInicialRideAdmWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for navbarRide component.
  late NavbarRideModel navbarRideModel;
  // State field(s) for Timer widget.
  final timerInitialTimeMs = 60000;
  int timerMilliseconds = 60000;
  String timerValue = StopWatchTimer.getDisplayTime(
    60000,
    hours: false,
    milliSecond: false,
  );
  FlutterFlowTimerController timerController =
      FlutterFlowTimerController(StopWatchTimer(mode: StopWatchMode.countDown));

  @override
  void initState(BuildContext context) {
    navbarRideModel = createModel(context, () => NavbarRideModel());
  }

  @override
  void dispose() {
    navbarRideModel.dispose();
    timerController.dispose();
  }
}
