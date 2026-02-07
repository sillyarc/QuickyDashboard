import '/flutter_flow/flutter_flow_util.dart';
import '/quicky_dashboard/web_nav/web_nav_widget.dart';
import '/index.dart';
import 'dashboard_quicky_tasks_copy_copy_widget.dart'
    show DashboardQuickyTasksCopyCopyWidget;
import 'package:flutter/material.dart';

class DashboardQuickyTasksCopyCopyModel
    extends FlutterFlowModel<DashboardQuickyTasksCopyCopyWidget> {
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
