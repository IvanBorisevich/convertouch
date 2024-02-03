import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_events.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_states.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/textbox.dart';
import 'package:convertouch/presentation/ui/style/color/color_set.dart';
import 'package:convertouch/presentation/ui/style/color/color_state_variation.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitGroupCreationPage extends StatefulWidget {
  const ConvertouchUnitGroupCreationPage({super.key});

  @override
  State createState() => _ConvertouchUnitGroupCreationPageState();
}

class _ConvertouchUnitGroupCreationPageState
    extends State<ConvertouchUnitGroupCreationPage> {
  late final TextEditingController _controller;

  bool _isApplyButtonEnabled = false;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder((appState) {
      ColorStateVariation<TextBoxColorSet> textBoxColor =
          unitGroupTextBoxColors[appState.theme]!;
      ButtonColorSet floatingButtonColor =
          unitGroupsPageFloatingButtonColors[appState.theme]!;

      return BlocListener<UnitGroupsBloc, UnitGroupsState>(
        listener: (_, unitGroupsState) {
          if (unitGroupsState is UnitGroupExists) {
            showAlertDialog(
              context,
              message:
                  "Unit group '${unitGroupsState.unitGroupName}' already exist",
            );
          } else if (unitGroupsState is UnitGroupsFetched) {
            Navigator.of(context).pop();
          }
        },
        child: ConvertouchPage(
          title: "New Unit Group",
          body: Container(
            padding: const EdgeInsetsDirectional.fromSTEB(7, 15, 7, 0),
            child: ConvertouchTextBox(
              controller: _controller,
              onChanged: (value) {
                setState(() {
                  _isApplyButtonEnabled = value.isNotEmpty;
                });
              },
              label: "Unit Group Name",
              theme: appState.theme,
              customColor: textBoxColor,
            ),
          ),
          floatingActionButton: ConvertouchFloatingActionButton(
            icon: Icons.check_outlined,
            visible: _isApplyButtonEnabled,
            onClick: () {
              BlocProvider.of<UnitGroupsBloc>(context).add(
                AddUnitGroup(
                  unitGroupName: _controller.text,
                ),
              );
            },
            background: floatingButtonColor.background,
            foreground: floatingButtonColor.foreground,
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
