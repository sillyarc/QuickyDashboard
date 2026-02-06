import '/components/navbar_ride_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'all_user_widget.dart' show AllUserWidget;
import 'package:flutter/material.dart';

class AllUserModel extends FlutterFlowModel<AllUserWidget> {
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

  // Model for navbarRide component.
  late NavbarRideModel navbarRideModel;

  @override
  void initState(BuildContext context) {
    navbarRideModel = createModel(context, () => NavbarRideModel());
  }

  @override
  void dispose() {
    navbarRideModel.dispose();
  }
}
