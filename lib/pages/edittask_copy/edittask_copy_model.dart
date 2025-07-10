import '/flutter_flow/flutter_flow_util.dart';
import 'edittask_copy_widget.dart' show EdittaskCopyWidget;
import 'package:flutter/material.dart';

class EdittaskCopyModel extends FlutterFlowModel<EdittaskCopyWidget> {
  ///  State fields for stateful widgets in this page.

  bool isDataUploading_uploadDataB15 = false;
  FFUploadedFile uploadedLocalFile_uploadDataB15 =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl_uploadDataB15 = '';

  // State field(s) for yourName widget.
  FocusNode? yourNameFocusNode;
  TextEditingController? yourNameTextController;
  String? Function(BuildContext, String?)? yourNameTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    yourNameFocusNode?.dispose();
    yourNameTextController?.dispose();
  }
}
