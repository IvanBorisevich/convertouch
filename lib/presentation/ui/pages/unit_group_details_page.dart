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
                ? unitGroupDetailsState.draftGroup.name
                : "New Group",
            body: Container(
              padding: const EdgeInsets.only(
                left: 12,
                top: 15,
                right: 12,
                bottom: 0,
              ),
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
                    disabled: unitGroupDetailsState.draftGroup.oob,
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
                    visible: !unitGroupDetailsState.isExistingGroup &&
                        !unitGroupDetailsState.draftGroup.oob,
                    child: ConvertouchInfoBox(
                      background: infoBoxColor.background.regular,
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
                            color: textBoxColor.foreground.regular,
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
