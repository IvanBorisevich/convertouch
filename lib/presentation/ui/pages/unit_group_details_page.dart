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

const double _verticalSpacing = 12;

const EdgeInsets _pagePadding = EdgeInsets.only(
  left: 10,
  top: 10,
  right: 10,
  bottom: 0,
);

class ConvertouchUnitGroupDetailsPage extends StatelessWidget {
  const ConvertouchUnitGroupDetailsPage({super.key});

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
            return ConvertouchPage(
              title: unitGroupDetailsState.isExistingGroup
                  ? 'Group Info'
                  : 'New Group',
              colors: appColors[appState.theme].page,
              body: SingleChildScrollView(
                child: Container(
                  padding: _pagePadding,
                  child: Column(
                    children: [
                      ConvertouchDetailsItem(
                        name: "Group Name",
                        draftValue: unitGroupDetailsState.draftGroup.name,
                        savedValue: unitGroupDetailsState.savedGroup.name,
                        editable: !unitGroupDetailsState.savedGroup.oob,
                        inputBoxColor: inputBoxColor,
                        onValueChanged: (value) {
                          unitGroupDetailsController.updateGroupName(
                            context,
                            newValue: value,
                          );
                        },
                      ),
                      ConvertouchDetailsItem(
                        name: "Conversion Type",
                        savedValue: unitGroupDetailsState
                            .draftGroup.conversionType.name,
                        inputBoxColor: inputBoxColor,
                        topMargin: _verticalSpacing,
                      ),
                      ConvertouchDetailsItem(
                        name: "Values Type",
                        savedValue:
                            unitGroupDetailsState.draftGroup.valueType.name,
                        inputBoxColor: inputBoxColor,
                        topMargin: _verticalSpacing,
                      ),
                      ConvertouchDetailsItem(
                        name: "Values Minimum",
                        visible:
                            unitGroupDetailsState.draftGroup.minValue != null,
                        savedValue:
                            unitGroupDetailsState.draftGroup.minValue?.altOrRaw,
                        inputBoxColor: inputBoxColor,
                        topMargin: _verticalSpacing,
                      ),
                      ConvertouchDetailsItem(
                        name: "Values Maximum",
                        visible:
                            unitGroupDetailsState.draftGroup.maxValue != null,
                        savedValue:
                            unitGroupDetailsState.draftGroup.maxValue?.altOrRaw,
                        inputBoxColor: inputBoxColor,
                        topMargin: _verticalSpacing,
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
                                savedValue:
                                    jobState.currentLastRefreshedStr ?? 'Never',
                                inputBoxColor: inputBoxColor,
                                topMargin: _verticalSpacing,
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
}
