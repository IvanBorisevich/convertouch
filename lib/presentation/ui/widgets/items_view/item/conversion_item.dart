import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/utils/input_validators/num_in_range_validator.dart';
import 'package:convertouch/domain/utils/input_validators/num_signs_validator.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/input_box.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/input_box_icon.dart';
import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

class ConvertouchConversionItem<M extends ItemValueModel>
    extends StatelessWidget {
  final M model;
  final String? conversionGroupName;
  final ConversionParamSetValueModel? conversionParams;
  final TooltipDirection tooltipDirection;
  final bool readonly;
  final void Function(
    ValueModel, {
    ListValuesFetchResult? listValues,
  })? onValueChanged;
  final List<ConvertouchInputBoxIcon> prefixWidgets;
  final List<ConvertouchInputBoxIcon> suffixWidgets;
  final ConversionItemColorScheme colors;
  final WidgetColorScheme dialogColors;
  final ConvertouchUITheme theme;

  const ConvertouchConversionItem({
    required this.model,
    this.conversionGroupName,
    this.conversionParams,
    this.tooltipDirection = TooltipDirection.down,
    this.readonly = false,
    this.onValueChanged,
    this.prefixWidgets = const [],
    this.suffixWidgets = const [],
    required this.colors,
    required this.dialogColors,
    required this.theme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ConvertouchInputBox(
      key: Key(model.id),
      model: model,
      conversionGroupName: conversionGroupName,
      conversionParams: conversionParams,
      readonly: readonly,
      colors: colors.inputBox,
      dialogColors: dialogColors,
      theme: theme,
      validators: [
        const NumSignsValidator(),
        NumInRangeValidator(model.min, model.max),
      ],
      floatingLabelBehavior: FloatingLabelBehavior.always,
      tooltipDirection: tooltipDirection,
      onValueChanged: onValueChanged,
      prefixWidgets: prefixWidgets,
      suffixWidgets: suffixWidgets,
    );
  }
}
