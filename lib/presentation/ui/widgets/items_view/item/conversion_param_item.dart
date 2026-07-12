import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/controller/conversion_controller.dart';
import 'package:convertouch/presentation/controller/refreshing_job_controller.dart';
import 'package:convertouch/presentation/controller/units_controller.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/conversion_item.dart';
import 'package:flutter/material.dart';

const double _calculationSuffixIconWidth = 40;

class ConversionParamItem extends StatelessWidget {
  final ConversionParamValueModel paramValue;
  final String? conversionGroupName;
  final ConversionParamSetValueModel? conversionParams;
  final bool calculationSwitchersVisible;
  final ConversionItemColorScheme colors;
  final WidgetColorScheme dialogColors;
  final ConvertouchUITheme theme;

  const ConversionParamItem({
    required this.paramValue,
    this.conversionGroupName,
    this.conversionParams,
    this.calculationSwitchersVisible = false,
    required this.colors,
    required this.dialogColors,
    required this.theme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder(
      builderFunc: (appState) {
        return ConvertouchConversionItem(
          model: paramValue,
          conversionGroupName: conversionGroupName,
          conversionParams: conversionParams,
          draggable: false,
          removable: false,
          colors: colors,
          dialogColors: dialogColors,
          theme: theme,
          onUnitItemTap: () {
            unitsController.showUnitsForChangeInParam(
              context,
              paramValue: paramValue,
            );
          },
          onValueChanged: (value, {listValues}) {
            conversionController.editConversionParamValue(
              context,
              paramValue: paramValue,
              newValue: value,
              listValues: listValues,
              ifParamSetFilled: (conversion) {
                if (appState.refreshOnParamsChange) {
                  refreshingJobController.startRefreshingJob(
                    context,
                    unitGroupName: conversion.unitGroup.name,
                    params: conversion.params?.active,
                    srcUnit: conversion.srcUnitValue?.unit,
                    jobExecutionMode: JobExecutionMode.startNewJob,
                  );
                }
              },
              ifParamSetFilledPartiallyOrEmpty: (conversion) {
                refreshingJobController.stopRefreshingJob(
                  context,
                  unitGroupName: conversion.unitGroup.name,
                  paramSetName: conversion.params?.active?.paramSet.name,
                );
              },
            );
          },
          prefixWidgets: [
            calculationSwitchersVisible && paramValue.param.calculable
                ? GestureDetector(
                    onTap: () {
                      conversionController.toggleParamCalculable(
                        context,
                        paramId: paramValue.param.id,
                        paramSetId: paramValue.param.paramSetId,
                      );
                    },
                    child: Container(
                      width: _calculationSuffixIconWidth,
                      padding: const EdgeInsets.only(left: 2),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      child: Icon(
                        paramValue.calculated
                            ? Icons.calculate
                            : Icons.calculate_outlined,
                        color: paramValue.calculated
                            ? colors.suffixWidget.selected
                            : colors.suffixWidget.regular,
                      ),
                    ),
                  )
                : null,
          ],
        );
      },
    );
  }
}
