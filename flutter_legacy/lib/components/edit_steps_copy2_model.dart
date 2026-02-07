import '/flutter_flow/flutter_flow_util.dart';
import 'edit_steps_copy2_widget.dart' show EditStepsCopy2Widget;
import 'package:flutter/material.dart';

class EditStepsCopy2Model extends FlutterFlowModel<EditStepsCopy2Widget> {
  ///  State fields for stateful widgets in this component.

  bool isDataUploading_uploadDataAzc = false;
  FFUploadedFile uploadedLocalFile_uploadDataAzc =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl_uploadDataAzc = '';

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();
  }
}
