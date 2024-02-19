import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/unit_group_details_page/unit_group_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_group_details_page/unit_group_details_events.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_events.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_states.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/textbox.dart';
import 'package:convertouch/presentation/ui/style/color/color_set.dart';
import 'package:convertouch/presentation/ui/style/color/color_state_variation.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitGroupDetailsPage extends StatefulWidget {
  const ConvertouchUnitGroupDetailsPage({super.key});

  @override
  State createState() => _ConvertouchUnitGroupDetailsPageState();
}

class _ConvertouchUnitGroupDetailsPageState
    extends State<ConvertouchUnitGroupDetailsPage> {
  late final TextEditingController _unitGroupNameController;

  @override
  void initState() {
    _unitGroupNameController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder((appState) {
      ColorStateVariation<TextBoxColorSet> textBoxColor =
          unitGroupTextBoxColors[appState.theme]!;
      ButtonColorSet floatingButtonColor =
          unitGroupsPageFloatingButtonColors[appState.theme]!;

      return MultiBlocListener(
        listeners: [
          unitGroupsBlocListener([
            StateHandler<UnitGroupsFetched>((state) {
              if (state.modifiedUnitGroup != null) {
                BlocProvider.of<UnitsBloc>(context).add(
                  ModifyGroup(
                    modifiedGroup: state.modifiedUnitGroup!,
                  ),
                );
              }
            }),
          ]),
        ],
        child: unitGroupDetailsBlocBuilder((unitGroupDetailsState) {
          _unitGroupNameController.text = unitGroupDetailsState.draftGroup.name;

          return ConvertouchPage(
            title: unitGroupDetailsState.editMode
                ? "Edit Unit Group"
                : "New Unit Group",
            body: Container(
              padding: const EdgeInsetsDirectional.fromSTEB(7, 15, 7, 0),
              child: Column(
                children: [
                  ConvertouchTextBox(
                    controller: _unitGroupNameController,
                    onChanged: (value) {
                      BlocProvider.of<UnitGroupDetailsBloc>(context).add(
                        UpdateUnitGroupName(
                          newValue: value,
                        ),
                      );
                    },
                    label: "Name",
                    hintText: unitGroupDetailsState.savedGroup.name,
                    theme: appState.theme,
                    customColor: textBoxColor,
                  ),
                  ConvertouchTextBox(
                    text: unitGroupDetailsState.draftGroup.conversionType.name,
                    disabled: true,
                    label: "Conversion Type",
                    hintText: unitGroupDetailsState.savedGroup.name,
                    theme: appState.theme,
                    customColor: textBoxColor,
                  ),
                  Visibility(
                    visible: !unitGroupDetailsState.editMode,
                    child: infoNote(
                      context: context,
                      backgroundColor: const Color(0xFFF1EBFF),
                      child: RichText(
                        text: TextSpan(
                          children: const <TextSpan>[
                            TextSpan(
                              text: 'Note: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: 'Currently only ',
                            ),
                            TextSpan(
                              text: 'static',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: ' conversion type (coefficients) '
                                  'is supported for custom unit groups',
                            ),
                          ],
                          style: TextStyle(
                            color: textBoxColor.regular.foreground,
                            fontWeight: FontWeight.w500,
                            fontFamily: quicksandFontFamily,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: conversionBlocBuilder((conversionState) {
              return ConvertouchFloatingActionButton(
                icon: Icons.check_outlined,
                visible: unitGroupDetailsState.canChangedBeSaved,
                onClick: () {
                  BlocProvider.of<UnitGroupsBloc>(context).add(
                    SaveUnitGroup(
                      unitGroupToBeSaved: unitGroupDetailsState.draftGroup,
                      conversionGroupId:
                          conversionState.conversion.unitGroup?.id,
                    ),
                  );
                },
                colorSet: floatingButtonColor,
              );
            }),
          );
        }),
      );
    });
  }

  @override
  void dispose() {
    _unitGroupNameController.dispose();
    super.dispose();
  }
}
