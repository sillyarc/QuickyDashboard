import '/flutter_flow/flutter_flow_util.dart';
import 'edit_steps_copy_copy_widget.dart' show EditStepsCopyCopyWidget;
import 'package:flutter/material.dart';

class EditStepsCopyCopyModel extends FlutterFlowModel<EditStepsCopyCopyWidget> {
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
