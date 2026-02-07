import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/quicky_dashboard/bar/bar_widget.dart';
import 'create_pre_tasks_widget.dart' show CreatePreTasksWidget;
import 'package:flutter/material.dart';

class CreatePreTasksModel extends FlutterFlowModel<CreatePreTasksWidget> {
  ///  Local state fields for this page.

  List<String> steps = [];
  void addToSteps(String item) => steps.add(item);
  void removeFromSteps(String item) => steps.remove(item);
  void removeAtIndexFromSteps(int index) => steps.removeAt(index);
  void insertAtIndexInSteps(int index, String item) =>
      steps.insert(index, item);
  void updateStepsAtIndex(int index, Function(String) updateFn) =>
      steps[index] = updateFn(steps[index]);

  List<String> materials = [];
  void addToMaterials(String item) => materials.add(item);
  void removeFromMaterials(String item) => materials.remove(item);
  void removeAtIndexFromMaterials(int index) => materials.removeAt(index);
  void insertAtIndexInMaterials(int index, String item) =>
      materials.insert(index, item);
  void updateMaterialsAtIndex(int index, Function(String) updateFn) =>
      materials[index] = updateFn(materials[index]);

  double? materialValue;

  ///  State fields for stateful widgets in this page.

  // Model for bar component.
  late BarModel barModel;
  bool isDataUploading_uploadDataB17598 = false;
  FFUploadedFile uploadedLocalFile_uploadDataB17598 =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl_uploadDataB17598 = '';

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;
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
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    textFieldFocusNode3?.dispose();
    textController3?.dispose();

    yourNameFocusNode1?.dispose();
    yourNameTextController1?.dispose();

    yourNameFocusNode2?.dispose();
    yourNameTextController2?.dispose();

    yourNameFocusNode3?.dispose();
    yourNameTextController3?.dispose();
  }
}
