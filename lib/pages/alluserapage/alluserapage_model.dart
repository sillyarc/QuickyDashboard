import '/components/bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'alluserapage_widget.dart' show AlluserapageWidget;
import 'package:flutter/material.dart';

class AlluserapageModel extends FlutterFlowModel<AlluserapageWidget> {
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
