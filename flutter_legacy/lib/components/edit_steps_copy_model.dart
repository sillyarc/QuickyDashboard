import '/flutter_flow/flutter_flow_util.dart';
import 'edit_steps_copy_widget.dart' show EditStepsCopyWidget;
import 'package:flutter/material.dart';

class EditStepsCopyModel extends FlutterFlowModel<EditStepsCopyWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
