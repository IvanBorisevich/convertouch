import 'package:convertouch/presenter/bloc/unit_groups_bloc.dart';
import 'package:convertouch/presenter/events/unit_groups_events.dart';
import 'package:convertouch/view/scaffold/bloc_wrappers.dart';
import 'package:convertouch/view/scaffold/scaffold.dart';
import 'package:convertouch/view/scaffold/textbox.dart';
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
    return unitGroupCreationListener(
      context,
      ConvertouchScaffold(
        pageTitle: "New Unit Group",
        appBarRightWidgets: [
          checkIcon(context, isEnabled: _isApplyButtonEnabled,
              onPressedFunc: () {
            BlocProvider.of<UnitGroupsBloc>(context)
                .add(AddUnitGroup(unitGroupName: _controller.text));
          }),
        ],
        body: Container(
          padding: const EdgeInsetsDirectional.fromSTEB(7, 8, 7, 0),
          child: ConvertouchTextBox(
            onChanged: (String value) async {
              setState(() {
                _isApplyButtonEnabled = value.isNotEmpty;
              });
            },
            label: "Unit Group Name",
            controller: _controller,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
