import '/flutter_flow/flutter_flow_util.dart';
import 'select_dispute_widget.dart' show SelectDisputeWidget;
import 'package:flutter/material.dart';

class SelectDisputeModel extends FlutterFlowModel<SelectDisputeWidget> {
  ///  Local state fields for this component.

  List<String> riders = ['Ride Visitor', 'Ride Bahamian'];
  void addToRiders(String item) => riders.add(item);
  void removeFromRiders(String item) => riders.remove(item);
  void removeAtIndexFromRiders(int index) => riders.removeAt(index);
  void insertAtIndexInRiders(int index, String item) =>
      riders.insert(index, item);
  void updateRidersAtIndex(int index, Function(String) updateFn) =>
      riders[index] = updateFn(riders[index]);

  ///  State fields for stateful widgets in this component.

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
