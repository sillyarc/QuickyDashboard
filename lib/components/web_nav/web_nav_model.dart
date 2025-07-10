import '/components/darkmode_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'web_nav_widget.dart' show WebNavWidget;
import 'package:flutter/material.dart';

class WebNavModel extends FlutterFlowModel<WebNavWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for darkmode component.
  late DarkmodeModel darkmodeModel;

  @override
  void initState(BuildContext context) {
    darkmodeModel = createModel(context, () => DarkmodeModel());
  }

  @override
  void dispose() {
    darkmodeModel.dispose();
  }
}
