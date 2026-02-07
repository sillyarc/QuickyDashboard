import '/components/web_nav_copy/web_nav_copy_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'support_b2_b_copy_widget.dart' show SupportB2BCopyWidget;
import 'package:flutter/material.dart';

class SupportB2BCopyModel extends FlutterFlowModel<SupportB2BCopyWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for webNavCopy component.
  late WebNavCopyModel webNavCopyModel;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {
    webNavCopyModel = createModel(context, () => WebNavCopyModel());
  }

  @override
  void dispose() {
    webNavCopyModel.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
