import '/components/web_nav_copy/web_nav_copy_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/quicky_dashboard/web_nav/web_nav_widget.dart';
import '/index.dart';
import 'quickysolutionsllcdashboard_widget.dart'
    show QuickysolutionsllcdashboardWidget;
import 'package:flutter/material.dart';

class QuickysolutionsllcdashboardModel
    extends FlutterFlowModel<QuickysolutionsllcdashboardWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for webNav component.
  late WebNavModel webNavModel;
  // Model for webNavCopy component.
  late WebNavCopyModel webNavCopyModel;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;

  @override
  void initState(BuildContext context) {
    webNavModel = createModel(context, () => WebNavModel());
    webNavCopyModel = createModel(context, () => WebNavCopyModel());
  }

  @override
  void dispose() {
    webNavModel.dispose();
    webNavCopyModel.dispose();
  }
}
