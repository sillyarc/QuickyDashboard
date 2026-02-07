import '/components/web_nav_copy/web_nav_copy_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'chatb2b_widget.dart' show Chatb2bWidget;
import 'package:flutter/material.dart';

class Chatb2bModel extends FlutterFlowModel<Chatb2bWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for webNavCopy component.
  late WebNavCopyModel webNavCopyModel;

  @override
  void initState(BuildContext context) {
    webNavCopyModel = createModel(context, () => WebNavCopyModel());
  }

  @override
  void dispose() {
    webNavCopyModel.dispose();
  }
}
