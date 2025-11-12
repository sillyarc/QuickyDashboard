import '/flutter_flow/flutter_flow_util.dart';
import 'create_event_copy_copy_widget.dart' show CreateEventCopyCopyWidget;
import 'package:flutter/material.dart';

class CreateEventCopyCopyModel
    extends FlutterFlowModel<CreateEventCopyCopyWidget> {
  ///  Local state fields for this component.

  int? photoNumber;

  DocumentReference? instructor;

  ///  State fields for stateful widgets in this component.

  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
