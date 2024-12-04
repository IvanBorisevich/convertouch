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
    final unitGroupDetailsBloc = BlocProvider.of<UnitGroupDetailsBloc>(context);
    final unitGroupsBloc = BlocProvider.of<UnitGroupsBloc>(context);
    final singleGroupBloc = BlocProvider.of<SingleGroupBloc>(context);
    final conversionBloc = BlocProvider.of<ConversionBloc>(context);
    final navigationBloc = BlocProvider.of<NavigationBloc>(context);

    return appBlocBuilder(
      builderFunc: (appState) {
        TextBoxColorScheme textBoxColor =
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
                                unitGroupDetailsBloc.add(
                                  UpdateUnitGroupName(
                                    newValue: value,
                                  ),
                                );
                              },
                              label: "Name",
                              hintText: unitGroupDetailsState.savedGroup.name,
                              colors: textBoxColor,
                              disabled: unitGroupDetailsState.draftGroup.oob,
                            ),
                      ConvertouchInfoBox(
                        headerText: "Conversion Type",
                        bodyText: unitGroupDetailsState
                            .draftGroup.conversionType.name,
                        bodyColor: textBoxColor.foreground.regular,
                        margin: const EdgeInsets.only(
                          bottom: 20,
                        ),
                      ),
                      ConvertouchInfoBox(
                        headerText: "Values Type",
                        bodyText:
                            unitGroupDetailsState.draftGroup.valueType.name,
                        bodyColor: textBoxColor.foreground.regular,
                        margin: const EdgeInsets.only(
                          bottom: 20,
                        ),
                      ),
                      ConvertouchInfoBox(
                        visible:
                            unitGroupDetailsState.draftGroup.minValue.exists,
                        headerText: "Values Minimum",
                        bodyText: unitGroupDetailsState
                            .draftGroup.minValue.scientific,
                        bodyColor: textBoxColor.foreground.regular,
                        margin: const EdgeInsets.only(
                          bottom: 20,
                        ),
                      ),
                      ConvertouchInfoBox(
                        visible:
                            unitGroupDetailsState.draftGroup.maxValue.exists,
                        headerText: "Values Maximum",
                        bodyText: unitGroupDetailsState
                            .draftGroup.maxValue.scientific,
                        bodyColor: textBoxColor.foreground.regular,
                        margin: const EdgeInsets.only(
                          bottom: 20,
                        ),
                      ),
                      refreshingJobsBlocBuilder(
                        builderFunc: (jobState) {
                          if (!unitGroupDetailsState.draftGroup.refreshable) {
                            return const SizedBox.shrink();
                          }
                          return Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                  top: 10,
                                  bottom: 30,
                                ),
                                child: Divider(
                                  height: 1,
                                  indent: 5,
                                  endIndent: 5,
                                  color: Colors.white70,
                                ),
                              ),
                              ConvertouchInfoBox(
                                headerText: "Last refreshed",
                                bodyText: jobState.currentCompletedAt,
                                bodyColor: textBoxColor.foreground.regular,
                                margin: const EdgeInsets.only(
                                  bottom: 20,
                                ),
                              ),
                              ConvertouchInfoBox(
                                headerText: "Data Source",
                                bodyText: jobState.currentDataSourceUrl,
                                bodyColor: textBoxColor.foreground.regular,
                                margin: const EdgeInsets.only(
                                  bottom: 20,
                                ),
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
