import '/components/bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'forgot_password_copy_widget.dart' show ForgotPasswordCopyWidget;
import 'package:flutter/material.dart';

class ForgotPasswordCopyModel
    extends FlutterFlowModel<ForgotPasswordCopyWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for bar component.
  late BarModel barModel;

  @override
  void initState(BuildContext context) {
    barModel = createModel(context, () => BarModel());
  }

  @override
  void dispose() {
    barModel.dispose();
  }
}
