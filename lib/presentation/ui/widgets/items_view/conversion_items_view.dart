import 'package:collection/collection.dart';
import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_states.dart';
import 'package:convertouch/presentation/controller/conversion_controller.dart';
import 'package:convertouch/presentation/controller/unit_details_controller.dart';
import 'package:convertouch/presentation/controller/units_controller.dart';
import 'package:convertouch/presentation/ui/model/converted_values_view_model.dart';
import 'package:convertouch/presentation/ui/style/color/colors_factory.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/conversion_item.dart';
import 'package:convertouch/presentation/ui/widgets/no_items_info_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const double _spacing = 10;
const double _bottomSpacing = 85;

class ConvertouchConversionItemsView extends StatefulWidget {
  final UnitTapAction unitTapAction;
  final ConvertouchUITheme theme;

  const ConvertouchConversionItemsView({
    required this.unitTapAction,
    required this.theme,
    super.key,
  });

  @override
  State createState() => _ConvertouchConversionItemsViewState();
}

class _ConvertouchConversionItemsViewState
    extends State<ConvertouchConversionItemsView> {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<ConversionBloc, ConversionState,
        ConvertedValuesViewModel?>(
      selector: (state) {
        if (state is ConversionBuilt) {
          return ConvertedValuesViewModel(
            convertedValues: state.conversion.convertedUnitValues,
            sourceUnitId: state.conversion.srcUnitValue?.unit.id,
            unitGroup: state.conversion.unitGroup,
          );
        }

        return null;
      },
      builder: (_, viewModel) {
        if (viewModel == null) {
          return const SizedBox.shrink();
        }

        if (viewModel.convertedValues.isEmpty) {
          return Center(
            child: NoItemsInfoLabel(
              text: "No conversion items added",
              colors: appColors[widget.theme].unitsMenu.noItemsInfoBox,
            ),
          );
        }

        return ReorderableListView.builder(
          itemCount: viewModel.convertedValues.length,
          buildDefaultDragHandles: false,
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          proxyDecorator: (child, index, animation) {
            return Material(
              key: ValueKey(index),
              color: Colors.transparent,
              child: child,
            );
          },
          padding: const EdgeInsets.only(
            top: _spacing,
            bottom: _bottomSpacing,
            left: _spacing,
            right: _spacing,
          ),
          itemBuilder: (context, index) {
            String itemId = viewModel.convertedValues[index].id;
            int? srcUnitId = viewModel.sourceUnitId;
            int lastItemIndex = viewModel.convertedValues.length - 1;
            bool removable = viewModel.convertedValues.length >
                minimumNumberOfConversionItems;
            UnitGroupModel unitGroup = viewModel.unitGroup;
            List<int> convertedUnitValuesIds =
                viewModel.convertedValues.map((item) => item.unit.id).toList();

            return Padding(
              key: Key('$index'),
              padding: const EdgeInsets.only(
                bottom: _spacing,
              ),
              child: BlocSelector<ConversionBloc, ConversionState,
                  ConversionUnitValueModel?>(
                selector: (state) {
                  if (state is! ConversionBuilt) {
                    return null;
                  }

                  return state.conversion.convertedUnitValues
                      .firstWhereOrNull((element) => element.id == itemId);
                },
                builder: (_, unitValue) {
                  if (unitValue == null) {
                    return const SizedBox.shrink();
                  }

                  return ConvertouchConversionItem(
                    model: unitValue,
                    draggable: true,
                    index: index,
                    readonly: !unitValue.unit.invertible,
                    isSource: unitValue.unit.id == srcUnitId,
                    isLast: index == lastItemIndex,
                    removable: removable,
                    onUnitItemTap: () {
                      if (widget.unitTapAction ==
                          UnitTapAction.selectReplacingUnit) {
                        unitsController.showUnitsForChangeInConversionItem(
                          context,
                          currentUnitId: unitValue.unit.id,
                          unitGroupId: unitGroup.id,
                          convertedUnitValuesIds: convertedUnitValuesIds,
                        );
                      } else if (widget.unitTapAction ==
                          UnitTapAction.showUnitInfo) {
                        unitDetailsController.showUnitDetails(
                          context,
                          unit: unitValue.unit,
                          unitGroup: unitGroup,
                        );
                      }
                    },
                    onValueChanged: (value) {
                      conversionController.changeConversionItemValue(
                        context,
                        unitId: unitValue.unit.id,
                        newValue: value,
                      );
                    },
                    onItemRemoved: () {
                      conversionController.removeConversionItem(
                        context,
                        unitId: unitValue.unit.id,
                      );
                    },
                    colors: appColors[widget.theme].conversionItem,
                    dialogColors: appColors[widget.theme].dialog,
                  );
                },
              ),
            );
          },
          onReorderStart: (index) {
            FocusScope.of(context).unfocus();
          },
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final ConversionUnitValueModel item =
                  viewModel.convertedValues.removeAt(oldIndex);
              viewModel.convertedValues.insert(newIndex, item);
            });
          },
        );
      },
    );
  }
}
