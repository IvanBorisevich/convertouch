import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/unit_group_details_page/unit_group_details_bloc.dart';
import 'package:convertouch/presentation/controller/conversion_controller.dart';
import 'package:convertouch/presentation/controller/groups_controller.dart';
import 'package:convertouch/presentation/controller/unit_group_details_controller.dart';
import 'package:convertouch/presentation/ui/pages/basic_page.dart';
import 'package:convertouch/presentation/ui/style/color/colors_factory.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/details_item.dart';
import 'package:convertouch/presentation/ui/widgets/floating_action_button.dart';
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
    super.initState();
    _unitGroupNameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final unitGroupDetailsBloc = BlocProvider.of<UnitGroupDetailsBloc>(context);

    return appBlocBuilder(
      builderFunc: (appState) {
        InputBoxColorScheme inputBoxColor =
            appColors[appState.theme].unitGroupDetailsInputBox;
        WidgetColorScheme floatingButtonColor =
            appColors[appState.theme].unitGroupsPageFloatingButton;

        return unitGroupDetailsBlocBuilder(
          bloc: unitGroupDetailsBloc,
          builderFunc: (unitGroupDetailsState) {
            _unitGroupNameController.text =
                unitGroupDetailsState.draftGroup.name;

            return ConvertouchPage(
              title: unitGroupDetailsState.isExistingGroup
                  ? 'Group Info'
                  : 'New Group',
              colors: appColors[appState.theme].page,
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
                      ConvertouchDetailsItem(
                        name: "Name",
                        value: unitGroupDetailsState.savedGroup.name,
                        editable: !unitGroupDetailsState.savedGroup.oob,
                        valueChangeController: _unitGroupNameController,
                        onValueChanged: (value) {
                          unitGroupDetailsController.updateGroupName(
                            context,
                            newValue: value,
                          );
                        },
                        inputBoxColor: inputBoxColor,
                      ),
                      ConvertouchDetailsItem(
                        name: "Conversion Type",
                        value: unitGroupDetailsState
                            .draftGroup.conversionType.name,
                        inputBoxColor: inputBoxColor,
                      ),
                      ConvertouchDetailsItem(
                        name: "Values Type",
                        value: unitGroupDetailsState.draftGroup.valueType.name,
                        inputBoxColor: inputBoxColor,
                      ),
                      ConvertouchDetailsItem(
                        name: "Values Minimum",
                        visible:
                            unitGroupDetailsState.draftGroup.minValue != null,
                        value:
                            unitGroupDetailsState.draftGroup.minValue?.altOrRaw,
                        inputBoxColor: inputBoxColor,
                      ),
                      ConvertouchDetailsItem(
                        name: "Values Maximum",
                        visible:
                            unitGroupDetailsState.draftGroup.maxValue != null,
                        value:
                            unitGroupDetailsState.draftGroup.maxValue?.altOrRaw,
                        inputBoxColor: inputBoxColor,
                      ),
                      refreshingJobsBlocBuilder(
                        builderFunc: (jobState) {
                          if (!unitGroupDetailsState.draftGroup.refreshable) {
                            return const SizedBox.shrink();
                          }
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  bottom: 30,
                                ),
                                child: Divider(
                                  height: 1,
                                  indent: 5,
                                  endIndent: 5,
                                  color: inputBoxColor.textBox.border.regular,
                                ),
                              ),
                              ConvertouchDetailsItem(
                                name: "Last Refreshed",
                                value:
                                    jobState.currentLastRefreshedStr ?? 'Never',
                                inputBoxColor: inputBoxColor,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButton: ConvertouchFloatingActionButton(
                icon: Icons.check_outlined,
                visible: unitGroupDetailsState.canChangesBeSaved,
                onClick: () {
                  groupsController.save(
                    context,
                    unitGroup: unitGroupDetailsState.draftGroup,
                    onSaved: (savedGroup) {
                      conversionController.editConversionGroup(
                        context,
                        modifiedGroup: savedGroup,
                      );
                    },
                  );
                },
                colorScheme: floatingButtonColor,
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _unitGroupNameController.dispose();
    super.dispose();
  }
}
