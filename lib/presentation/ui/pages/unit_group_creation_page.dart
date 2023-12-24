import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/unit_groups_bloc.dart';
import 'package:convertouch/domain/model/input/unit_groups_events.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/textbox.dart';
import 'package:convertouch/presentation/ui/style/colors.dart';
import 'package:convertouch/presentation/ui/style/model/color.dart';
import 'package:convertouch/presentation/ui/style/model/color_variation.dart';
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
    return appBlocBuilder((appState) {
      ConvertouchTextBoxColor textBoxColor =
          unitGroupTextBoxColors[appState.theme]!;
      FloatingButtonColorVariation floatingButtonColor =
          unitGroupsPageFloatingButtonColors[appState.theme]!;

      return unitGroupCreationListener(
        context,
        child: ConvertouchPage(
          appState: appState,
          title: "New Unit Group",
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
