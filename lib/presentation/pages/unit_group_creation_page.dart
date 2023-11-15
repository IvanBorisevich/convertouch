import 'package:convertouch/presentation/bloc/unit_groups/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups/unit_groups_events.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/pages/scaffold/scaffold.dart';
import 'package:convertouch/presentation/pages/scaffold/textbox.dart';
import 'package:convertouch/presentation/pages/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitGroupCreationPage extends StatefulWidget {
  const ConvertouchUnitGroupCreationPage({super.key});

  @override
  State createState() => _ConvertouchUnitGroupCreationPageState();
}

class _ConvertouchUnitGroupCreationPageState
    extends State<ConvertouchUnitGroupCreationPage> {
  final _controller = TextEditingController();

  bool _isApplyButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    return appBloc((appState) {
      return unitGroupCreationListener(
        context,
        ConvertouchScaffold(
          pageTitle: "New Unit Group",
          theme: appState.uiTheme,
          appBarRightWidgets: [
            checkIcon(
              context,
              isEnabled: _isApplyButtonEnabled,
              onPressedFunc: () {
                BlocProvider.of<UnitGroupsBloc>(context).add(
                  AddUnitGroup(
                    unitGroupName: _controller.text,
                  ),
                );
              },
              color: scaffoldColor[appState.uiTheme]!,
            ),
          ],
          body: Container(
            padding: const EdgeInsetsDirectional.fromSTEB(7, 15, 7, 0),
            child: ConvertouchTextBox(
              onChanged: (String value) async {
                setState(() {
                  _isApplyButtonEnabled = value.isNotEmpty;
                });
              },
              label: "Unit Group Name",
              controller: _controller,
              theme: appState.uiTheme,
              customColor: unitGroupTextBoxColor[appState.uiTheme],
            ),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
