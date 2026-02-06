import '/components/web_nav_copy/web_nav_copy_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'chat_widget.dart' show ChatWidget;
import 'package:flutter/material.dart';

class ChatModel extends FlutterFlowModel<ChatWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for webNavCopy component.
  late WebNavCopyModel webNavCopyModel;
  // State field(s) for content widget.
  ScrollController? contentScrollController;
  // State field(s) for ListView widget.
  ScrollController? listViewController;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  bool isDataUploading_uploadData432423gg = false;
  FFUploadedFile uploadedLocalFile_uploadData432423gg =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl_uploadData432423gg = '';

  @override
  void initState(BuildContext context) {
    webNavCopyModel = createModel(context, () => WebNavCopyModel());
    contentScrollController = ScrollController();
    listViewController = ScrollController();
  }

  @override
  void dispose() {
    webNavCopyModel.dispose();
    contentScrollController?.dispose();
    listViewController?.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
