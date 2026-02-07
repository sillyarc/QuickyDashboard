import '/components/web_nav_copy/web_nav_copy_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'support_b2_b_widget.dart' show SupportB2BWidget;
import 'package:flutter/material.dart';

class SupportB2BModel extends FlutterFlowModel<SupportB2BWidget> {
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
