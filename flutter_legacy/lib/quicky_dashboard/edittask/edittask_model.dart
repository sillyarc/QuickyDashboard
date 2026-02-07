import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/quicky_dashboard/bar/bar_widget.dart';
import 'edittask_widget.dart' show EdittaskWidget;
import 'package:flutter/material.dart';

class EdittaskModel extends FlutterFlowModel<EdittaskWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for bar component.
  late BarModel barModel;
  bool isDataUploading_uploadDataB1598 = false;
  FFUploadedFile uploadedLocalFile_uploadDataB1598 =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl_uploadDataB1598 = '';

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for yourName widget.
  FocusNode? yourNameFocusNode1;
  TextEditingController? yourNameTextController1;
  String? Function(BuildContext, String?)? yourNameTextController1Validator;
  // State field(s) for yourName widget.
  FocusNode? yourNameFocusNode2;
  TextEditingController? yourNameTextController2;
  String? Function(BuildContext, String?)? yourNameTextController2Validator;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // State field(s) for yourName widget.
  FocusNode? yourNameFocusNode3;
  TextEditingController? yourNameTextController3;
  String? Function(BuildContext, String?)? yourNameTextController3Validator;

  @override
  void initState(BuildContext context) {
    barModel = createModel(context, () => BarModel());
  }

  @override
  void dispose() {
    barModel.dispose();
    textFieldFocusNode?.dispose();
    textController1?.dispose();

    yourNameFocusNode1?.dispose();
    yourNameTextController1?.dispose();

    yourNameFocusNode2?.dispose();
    yourNameTextController2?.dispose();

    yourNameFocusNode3?.dispose();
    yourNameTextController3?.dispose();
  }
}
