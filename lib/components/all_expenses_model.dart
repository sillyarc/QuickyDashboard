import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'all_expenses_widget.dart' show AllExpensesWidget;
import 'package:flutter/material.dart';

class AllExpensesModel extends FlutterFlowModel<AllExpensesWidget> {
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

  // State field(s) for PaginatedDataTable widget.
  final paginatedDataTableController1 =
      FlutterFlowDataTableController<dynamic>();
  // State field(s) for PaginatedDataTable widget.
  final paginatedDataTableController2 =
      FlutterFlowDataTableController<dynamic>();
  // State field(s) for PaginatedDataTable widget.
  final paginatedDataTableController3 =
      FlutterFlowDataTableController<dynamic>();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    paginatedDataTableController1.dispose();
    paginatedDataTableController2.dispose();
    paginatedDataTableController3.dispose();
  }
}
