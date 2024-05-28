import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/utils/number_value_utils.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/unit_group_details_page/unit_group_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_group_details_page/unit_group_details_events.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_events.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_states.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/widgets/info_box.dart';
import 'package:convertouch/presentation/ui/widgets/textbox.dart';
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
      TextBoxColorScheme textBoxColor = unitGroupTextBoxColors[appState.theme]!;
      ConvertouchColorScheme floatingButtonColor =
          unitGroupsPageFloatingButtonColors[appState.theme]!;
      ConvertouchColorScheme infoBoxColor =
          unitGroupPageInfoBoxColors[appState.theme]!;

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
            title: unitGroupDetailsState.isExistingGroup
                ? unitGroupDetailsState.savedGroup.name
                : "New Group",
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(
                  left: 20,
                  top: 23,
                  right: 20,
                  bottom: 0,
                ),
                child: Column(
                  children: [
                    unitGroupDetailsState.savedGroup.oob
                        ? ConvertouchInfoBox(
                            headerText: "Name",
                            bodyText: unitGroupDetailsState.savedGroup.name,
                            bodyColor: textBoxColor.foreground.regular,
                            margin: const EdgeInsets.only(
                              bottom: 20,
                            ),
                          )
                        : ConvertouchTextBox(
                            controller: _unitGroupNameController,
                            onChanged: (value) {
                              BlocProvider.of<UnitGroupDetailsBloc>(context)
                                  .add(
                                UpdateUnitGroupName(
                                  newValue: value,
                                ),
                              );
                            },
                            label: "Name",
                            hintText: unitGroupDetailsState.savedGroup.name,
                            theme: appState.theme,
                            customColor: textBoxColor,
                            disabled: unitGroupDetailsState.draftGroup.oob,
                          ),
                    ConvertouchInfoBox(
                      headerText: "Conversion Type",
                      bodyText:
                          unitGroupDetailsState.draftGroup.conversionType.name,
                      bodyColor: textBoxColor.foreground.regular,
                      margin: const EdgeInsets.only(
                        bottom: 20,
                      ),
                    ),
                    ConvertouchInfoBox(
                      headerText: "Values Type",
                      bodyText: unitGroupDetailsState.draftGroup.valueType.name,
                      bodyColor: textBoxColor.foreground.regular,
                      margin: const EdgeInsets.only(
                        bottom: 20,
                      ),
                    ),
                    ConvertouchInfoBox(
                      headerText: "Values Minimum",
                      bodyText: NumberValueUtils.formatValueScientific(
                        unitGroupDetailsState.draftGroup.minValue,
                        noValueStr: '-',
                      ),
                      bodyColor: textBoxColor.foreground.regular,
                      margin: const EdgeInsets.only(
                        bottom: 20,
                      ),
                    ),
                    ConvertouchInfoBox(
                      headerText: "Values Maximum",
                      bodyText: NumberValueUtils.formatValueScientific(
                        unitGroupDetailsState.draftGroup.maxValue,
                        noValueStr: '-',
                      ),
                      bodyColor: textBoxColor.foreground.regular,
                      margin: const EdgeInsets.only(
                        bottom: 20,
                      ),
                    ),
                    ConvertouchInfoBox(
                      headerText: "Refreshable",
                      bodyText: unitGroupDetailsState.draftGroup.refreshable
                          ? "Yes"
                          : "No",
                      bodyColor: textBoxColor.foreground.regular,
                      margin: const EdgeInsets.only(
                        bottom: 20,
                      ),
                    ),
                    ConvertouchInfoBox(
                      visible: !unitGroupDetailsState.isExistingGroup &&
                          !unitGroupDetailsState.draftGroup.oob,
                      background: infoBoxColor.background.regular,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 14,
                      ),
                      margin: const EdgeInsets.only(
                        bottom: 30,
                      ),
                      headerText: "Note",
                      child: RichText(
                        text: TextSpan(
                          children: const <TextSpan>[
                            TextSpan(
                              text: 'Currently only ',
                            ),
                            TextSpan(
                              text: 'static',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: ' conversion type (coefficients) and ',
                            ),
                            TextSpan(
                              text: 'decimal',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: ' value type are supported for '
                                  'custom unit groups',
                            ),
                          ],
                          style: TextStyle(
                            color: textBoxColor.foreground.regular,
                            fontWeight: FontWeight.w500,
                            fontFamily: quicksandFontFamily,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
                colorScheme: floatingButtonColor,
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
