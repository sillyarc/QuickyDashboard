import '/components/darkmode_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'web_nav_copy_widget.dart' show WebNavCopyWidget;
import 'package:flutter/material.dart';

class WebNavCopyModel extends FlutterFlowModel<WebNavCopyWidget> {
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
