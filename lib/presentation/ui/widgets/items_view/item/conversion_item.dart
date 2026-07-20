import 'dart:developer';

import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/utils/input_validators/num_in_range_validator.dart';
import 'package:convertouch/domain/utils/input_validators/num_signs_validator.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/input_box.dart';
import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

const double _dragHandlerWidth = 35;
const double _removalButtonWidth = 35;
const double _unitButtonWidth = 76;

class ConvertouchConversionItem<M extends ItemValueModel>
    extends StatelessWidget {
  final M model;
  final String? conversionGroupName;
  final ConversionParamSetValueModel? conversionParams;
  final bool isLast;
  final bool draggable;
  final bool removable;
  final int? index;
  final bool isSource;
  final bool readonly;
  final void Function()? onUnitItemTap;
  final void Function(
    ValueModel, {
    ListValuesFetchResult? listValues,
  })? onValueChanged;
  final void Function()? onItemRemoved;
  final List<Widget?> prefixWidgets;
  final List<Widget?> suffixWidgets;
  final ConversionItemColorScheme colors;
  final WidgetColorScheme dialogColors;
  final ConvertouchUITheme theme;

  const ConvertouchConversionItem({
    required this.model,
    this.conversionGroupName,
    this.conversionParams,
    this.isLast = false,
    this.draggable = false,
    this.removable = false,
    this.index,
    this.isSource = false,
    this.readonly = false,
    this.onUnitItemTap,
    this.onValueChanged,
    this.onItemRemoved,
    this.prefixWidgets = const [],
    this.suffixWidgets = const [],
    required this.colors,
    required this.dialogColors,
    required this.theme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    log("ConversionItem build(), hash: $hashCode, "
        "item value: $model, item value: ${model.hashCode}, "
        "context hash: ${context.hashCode}");

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
      tooltipDirection: isLast ? TooltipDirection.up : TooltipDirection.down,
      onValueChanged: onValueChanged,
      prefixWidgets: [
        draggable && index != null
            ? ReorderableDragStartListener(
                index: index!,
                child: Container(
                  width: _dragHandlerWidth,
                  color: Colors.transparent,
                  padding: const EdgeInsets.only(left: 3),
                  alignment: Alignment.center,
                  child: isSource
                      ? Text(
                          '𝑥',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            height: -0.3,
                            color: colors.prefixWidget.selected,
                          ),
                        )
                      : Icon(
                          Icons.drag_indicator_outlined,
                          color: colors.prefixWidget.regular,
                          size: 20,
                        ),
                ),
              )
            : null,
        ...prefixWidgets,
      ],
      suffixWidgets: [
        ...suffixWidgets,
        model.unitItem != null && model.unitItem!.exists
            ? GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  onUnitItemTap?.call();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: _unitButtonWidth,
                  color: Colors.transparent,
                  child: Text(
                    model.unitItem!.code,
                    style: TextStyle(
                      color: colors.unitButton.regular,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                  ),
                ),
              )
            : null,
        removable
            ? GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  onItemRemoved?.call();
                },
                child: Container(
                  padding: const EdgeInsets.only(right: 1),
                  width: _removalButtonWidth,
                  child: Icon(
                    Icons.remove,
                    color: colors.removalIcon.regular,
                    size: 20,
                  ),
                ),
              )
            : null,
      ],
    );
  }
}
