import '/components/web_nav_copy/web_nav_copy_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'quicky_b2_b_widget.dart' show QuickyB2BWidget;
import 'package:flutter/material.dart';

class QuickyB2BModel extends FlutterFlowModel<QuickyB2BWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for webNavCopy component.
  late WebNavCopyModel webNavCopyModel;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;

  @override
  void initState(BuildContext context) {
    webNavCopyModel = createModel(context, () => WebNavCopyModel());
  }

  @override
  void dispose() {
    webNavCopyModel.dispose();
  }
}
