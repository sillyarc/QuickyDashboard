import '/flutter_flow/flutter_flow_util.dart';
import '/quicky_dashboard/bar/bar_widget.dart';
import 'quicky_test_real_time_widget.dart' show QuickyTestRealTimeWidget;
import 'package:flutter/material.dart';

class QuickyTestRealTimeModel
    extends FlutterFlowModel<QuickyTestRealTimeWidget> {
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
