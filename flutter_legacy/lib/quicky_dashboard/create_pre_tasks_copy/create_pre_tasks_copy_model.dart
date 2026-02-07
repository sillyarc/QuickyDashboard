import '/flutter_flow/flutter_flow_util.dart';
import '/quicky_dashboard/bar/bar_widget.dart';
import 'create_pre_tasks_copy_widget.dart' show CreatePreTasksCopyWidget;
import 'package:flutter/material.dart';

class CreatePreTasksCopyModel
    extends FlutterFlowModel<CreatePreTasksCopyWidget> {
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
  // State field(s) for yourName widget.
  FocusNode? yourNameFocusNode1;
  TextEditingController? yourNameTextController1;
  String? Function(BuildContext, String?)? yourNameTextController1Validator;
  // State field(s) for yourName widget.
  FocusNode? yourNameFocusNode2;
  TextEditingController? yourNameTextController2;
  String? Function(BuildContext, String?)? yourNameTextController2Validator;

  @override
  void initState(BuildContext context) {
    barModel = createModel(context, () => BarModel());
  }

  @override
  void dispose() {
    barModel.dispose();
    yourNameFocusNode1?.dispose();
    yourNameTextController1?.dispose();

    yourNameFocusNode2?.dispose();
    yourNameTextController2?.dispose();
  }
}
