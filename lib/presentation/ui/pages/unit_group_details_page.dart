import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_events.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_events.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_events.dart';
import 'package:convertouch/presentation/bloc/unit_group_details_page/unit_group_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_group_details_page/unit_group_details_events.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/single_group_bloc.dart';
import 'package:convertouch/presentation/ui/pages/basic_page.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/widgets/parameter_item.dart';
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
    final unitGroupDetailsBloc = BlocProvider.of<UnitGroupDetailsBloc>(context);
    final unitGroupsBloc = BlocProvider.of<UnitGroupsBloc>(context);
    final singleGroupBloc = BlocProvider.of<SingleGroupBloc>(context);
    final conversionBloc = BlocProvider.of<ConversionBloc>(context);
    final navigationBloc = BlocProvider.of<NavigationBloc>(context);

    return appBlocBuilder(
      builderFunc: (appState) {
        InputBoxColorScheme textBoxColor =
            unitGroupTextBoxColors[appState.theme]!;
        ConvertouchColorScheme floatingButtonColor =
            unitGroupsPageFloatingButtonColors[appState.theme]!;

        return unitGroupDetailsBlocBuilder(
          bloc: unitGroupDetailsBloc,
          builderFunc: (unitGroupDetailsState) {
            _unitGroupNameController.text =
                unitGroupDetailsState.draftGroup.name;

            return ConvertouchPage(
              title: unitGroupDetailsState.isExistingGroup
                  ? 'Group Info'
                  : 'New Group',
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
                      ConvertouchParameterItem(
                        name: "Name",
                        value: unitGroupDetailsState.savedGroup.name,
                        editable: !unitGroupDetailsState.savedGroup.oob,
                        valueChangeController: _unitGroupNameController,
                        onValueChanged: (value) {
                          unitGroupDetailsBloc.add(
                            UpdateUnitGroupName(
                              newValue: value,
                            ),
                          );
                        },
                        textBoxColor: textBoxColor,
                      ),
                      ConvertouchParameterItem(
                        name: "Conversion Type",
                        value: unitGroupDetailsState
                            .draftGroup.conversionType.name,
                        textBoxColor: textBoxColor,
                      ),
                      ConvertouchParameterItem(
                        name: "Values Type",
                        value: unitGroupDetailsState.draftGroup.valueType.name,
                        textBoxColor: textBoxColor,
                      ),
                      ConvertouchParameterItem(
                        name: "Values Minimum",
                        visible:
                            unitGroupDetailsState.draftGroup.minValue != null,
                        value: unitGroupDetailsState
                            .draftGroup.minValue?.alt,
                        textBoxColor: textBoxColor,
                      ),
                      ConvertouchParameterItem(
                        name: "Values Maximum",
                        visible:
                            unitGroupDetailsState.draftGroup.maxValue != null,
                        value: unitGroupDetailsState
                            .draftGroup.maxValue?.alt,
                        textBoxColor: textBoxColor,
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
                                  color: textBoxColor.border.regular,
                                ),
                              ),
                              ConvertouchParameterItem(
                                name: "Last Refreshed",
                                value:
                                    jobState.currentLastRefreshedStr ?? 'Never',
                                textBoxColor: textBoxColor,
                              ),
                              ConvertouchParameterItem(
                                name: "Data Source",
                                value: jobState.currentDataSourceUrl,
                                textBoxColor: textBoxColor,
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
                  unitGroupsBloc.add(
                    SaveItem(
                      item: unitGroupDetailsState.draftGroup,
                      onItemSave: (savedGroup) {
                        unitGroupsBloc.add(
                          const FetchItems(),
                        );
                        singleGroupBloc.add(
                          ShowGroup(unitGroup: savedGroup),
                        );
                        conversionBloc.add(
                          EditConversionGroup(
                            editedGroup: savedGroup,
                            onComplete: () {
                              navigationBloc.add(
                                const NavigateBack(),
                              );
                            },
                          ),
                        );
                      },
                    ),
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
