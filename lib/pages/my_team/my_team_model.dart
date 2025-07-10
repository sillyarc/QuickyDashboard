import '/components/all_users_app_widget.dart';
import '/components/web_nav/web_nav_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'my_team_widget.dart' show MyTeamWidget;
import 'package:flutter/material.dart';

class MyTeamModel extends FlutterFlowModel<MyTeamWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for webNav component.
  late WebNavModel webNavModel;
  // Model for AllUsersApp component.
  late AllUsersAppModel allUsersAppModel;

  @override
  void initState(BuildContext context) {
    webNavModel = createModel(context, () => WebNavModel());
    allUsersAppModel = createModel(context, () => AllUsersAppModel());
  }

  @override
  void dispose() {
    webNavModel.dispose();
    allUsersAppModel.dispose();
  }
}
