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
        DetailsItemColorsScheme detailsItemColors =
            appColors[appState.theme].unitGroupDetailsInputBox;
        WidgetColorScheme floatingButtonColor =
            appColors[appState.theme].unitGroupsPageFloatingButton;
        WidgetColorScheme dialogColors = appColors[appState.theme].dialog;

        return unitGroupDetailsBlocBuilder(
          bloc: unitGroupDetailsBloc,
          builderFunc: (pageState) {
            return ConvertouchPage(
              title: pageState.isExistingGroup ? 'Group Info' : 'New Group',
              colors: appColors[appState.theme].page,
              body: SingleChildScrollView(
                child: Container(
                  padding: _pagePadding,
                  child: Column(
                    children: [
                      ConvertouchDetailsItem(
                        name: "Group Name",
                        draftValue: pageState.draftGroup.name,
                        savedValue: pageState.savedGroup.name,
                        editable: !pageState.savedGroup.oob,
                        colors: detailsItemColors,
                        dialogColors: dialogColors,
                        theme: appState.theme,
                        onValueChanged: (value) {
                          unitGroupDetailsController.updateGroupName(
                            context,
                            newValue: value,
                          );
                        },
                      ),
                      ConvertouchDetailsItem(
                        name: "Conversion Type",
                        savedValue: pageState.draftGroup.conversionType.name,
                        colors: detailsItemColors,
                        dialogColors: dialogColors,
                        theme: appState.theme,
                        topMargin: _verticalSpacing,
                      ),
                      ConvertouchDetailsItem(
                        name: "Values Type",
                        savedValue: pageState.draftGroup.valueType.name,
                        colors: detailsItemColors,
                        dialogColors: dialogColors,
                        theme: appState.theme,
                        topMargin: _verticalSpacing,
                      ),
                      ConvertouchDetailsItem(
                        name: "Values Minimum",
                        visible: pageState.draftGroup.minValue != null,
                        savedValue: pageState.draftGroup.minValue?.itemName,
                        colors: detailsItemColors,
                        dialogColors: dialogColors,
                        theme: appState.theme,
                        topMargin: _verticalSpacing,
                      ),
                      ConvertouchDetailsItem(
                        name: "Values Maximum",
                        visible: pageState.draftGroup.maxValue != null,
                        savedValue: pageState.draftGroup.maxValue?.itemName,
                        colors: detailsItemColors,
                        dialogColors: dialogColors,
                        theme: appState.theme,
                        topMargin: _verticalSpacing,
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButton: ConvertouchFloatingActionButton(
                icon: Icons.check_outlined,
                visible: pageState.canChangesBeSaved,
                onClick: () {
                  groupsController.save(
                    context,
                    unitGroup: pageState.draftGroup,
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
