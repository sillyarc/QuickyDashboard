import '/components/navbar_ride_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'map_real_time_widget.dart' show MapRealTimeWidget;
import 'package:flutter/material.dart';

class MapRealTimeModel extends FlutterFlowModel<MapRealTimeWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for navbarRide component.
  late NavbarRideModel navbarRideModel;

  @override
  void initState(BuildContext context) {
    navbarRideModel = createModel(context, () => NavbarRideModel());
  }

  @override
  void dispose() {
    navbarRideModel.dispose();
  }
}
