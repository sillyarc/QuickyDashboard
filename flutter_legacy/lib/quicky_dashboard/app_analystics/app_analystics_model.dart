import '/flutter_flow/flutter_flow_util.dart';
import '/quicky_dashboard/bar/bar_widget.dart';
import 'app_analystics_widget.dart' show AppAnalysticsWidget;
import 'package:flutter/material.dart';

class AppAnalysticsModel extends FlutterFlowModel<AppAnalysticsWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for bar component.
  late BarModel barModel;

  @override
  void initState(BuildContext context) {
    barModel = createModel(context, () => BarModel());
  }

  @override
  void dispose() {
    barModel.dispose();
  }
}
