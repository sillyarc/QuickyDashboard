import '/components/bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'taskspreprontas_widget.dart' show TaskspreprontasWidget;
import 'package:flutter/material.dart';

class TaskspreprontasModel extends FlutterFlowModel<TaskspreprontasWidget> {
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
