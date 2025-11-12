import '/components/all_user_widget.dart';
import '/components/map_real_time_widget.dart';
import '/components/pagina_inicial_ride_adm_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import 'initial_page_widget.dart' show InitialPageWidget;
import 'package:flutter/material.dart';

class InitialPageModel extends FlutterFlowModel<InitialPageWidget> {
  ///  State fields for stateful widgets in this page.

  InstantTimer? instantTimer;
  // Model for PaginaInicialRideAdm component.
  late PaginaInicialRideAdmModel paginaInicialRideAdmModel;
  // Model for allUser component.
  late AllUserModel allUserModel;
  // Model for mapRealTime component.
  late MapRealTimeModel mapRealTimeModel;

  @override
  void initState(BuildContext context) {
    paginaInicialRideAdmModel =
        createModel(context, () => PaginaInicialRideAdmModel());
    allUserModel = createModel(context, () => AllUserModel());
    mapRealTimeModel = createModel(context, () => MapRealTimeModel());
  }

  @override
  void dispose() {
    instantTimer?.cancel();
    paginaInicialRideAdmModel.dispose();
    allUserModel.dispose();
    mapRealTimeModel.dispose();
  }
}
