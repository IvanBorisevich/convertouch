import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/utils/input_validators/num_in_range_validator.dart';
import 'package:convertouch/domain/utils/input_validators/num_signs_validator.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/input_box.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/input_box_icon_model.dart';
import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

const double _unitButtonWidth = 76;
const double _removalButtonWidth = 25;

class ConvertouchConversionItem<M extends ItemValueModel>
    extends StatelessWidget {
  final M model;
  final String? conversionGroupName;
  final ConversionParamSetValueModel? conversionParams;
  final TooltipDirection tooltipDirection;
  final bool readonly;
  final bool removable;
  final void Function(
    ValueModel?, {
    ListValuesFetchResult? listValues,
  })? onValueChanged;
  final void Function()? onUnitItemTap;
  final void Function()? onItemRemoved;
  final List<InputBoxIconModel> prefixIcons;
  final List<InputBoxIconModel> suffixIcons;
  final ConversionItemColorScheme colors;
  final WidgetColorScheme dialogColors;
  final ConvertouchUITheme theme;

  const ConvertouchConversionItem({
    required this.model,
    this.conversionGroupName,
    this.conversionParams,
    this.tooltipDirection = TooltipDirection.down,
    this.readonly = false,
    this.removable = false,
    this.onValueChanged,
    this.onUnitItemTap,
    this.onItemRemoved,
    this.prefixIcons = const [],
    this.suffixIcons = const [],
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
      iconsModel: InputBoxIconsWrapperModel(
        prefixIconsModels: prefixIcons,
        suffixIconsModels: [
          ...suffixIcons,
          InputBoxIconModel.iconWithDivider(
            width: _unitButtonWidth,
            visible: model.unitItem != null && model.unitItem!.exists,
            onTap: () {
              FocusScope.of(context).unfocus();
              onUnitItemTap?.call();
            },
            builder: () => Text(
              model.unitItem!.code,
              style: TextStyle(
                color: colors.unitButton.regular,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
            ),
          ),
          InputBoxIconModel.iconWithDivider(
            width: _removalButtonWidth,
            visible: removable,
            onTap: () {
              FocusScope.of(context).unfocus();
              onItemRemoved?.call();
            },
            builder: () => Icon(
              Icons.remove,
              color: colors.removalIcon.regular,
              size: 20,
            ),
          ),
        ],
        iconSpacing: 5,
        innermostSpacing: 10,
        outermostSpacingWithIcons: 7,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      tooltipDirection: tooltipDirection,
      onValueChanged: onValueChanged,
    );
  }
}
