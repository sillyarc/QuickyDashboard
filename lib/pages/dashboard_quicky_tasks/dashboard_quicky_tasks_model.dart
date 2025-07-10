import '/components/web_nav/web_nav_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'dashboard_quicky_tasks_widget.dart' show DashboardQuickyTasksWidget;
import 'package:flutter/material.dart';

class DashboardQuickyTasksModel
    extends FlutterFlowModel<DashboardQuickyTasksWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for webNav component.
  late WebNavModel webNavModel;

  @override
  void initState(BuildContext context) {
    webNavModel = createModel(context, () => WebNavModel());
  }

  @override
  void dispose() {
    webNavModel.dispose();
  }
}
