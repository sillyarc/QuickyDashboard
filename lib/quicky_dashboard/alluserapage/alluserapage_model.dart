import '/flutter_flow/flutter_flow_util.dart';
import '/quicky_dashboard/web_nav/web_nav_widget.dart';
import 'alluserapage_widget.dart' show AlluserapageWidget;
import 'package:flutter/material.dart';

class AlluserapageModel extends FlutterFlowModel<AlluserapageWidget> {
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
