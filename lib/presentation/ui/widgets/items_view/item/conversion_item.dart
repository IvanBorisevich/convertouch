import 'package:convertouch/domain/constants/settings.dart';
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
    extends StatefulWidget {
  final M model;
  final bool isLast;
  final bool draggable;
  final bool removable;
  final int? index;
  final bool isSource;
  final bool readonly;
  final void Function()? onUnitItemTap;
  final void Function(ValueModel)? onValueChanged;
  final void Function(ValueModel)? onValueFocused;
  final void Function(ListValuesFetchResult)? onRefreshTap;
  final void Function()? onItemRemoved;
  final List<Widget?> prefixWidgets;
  final List<Widget?> suffixWidgets;
  final ConversionItemColorScheme colors;
  final WidgetColorScheme dialogColors;
  final ConvertouchUITheme theme;

  const ConvertouchConversionItem({
    required this.model,
    this.isLast = false,
    this.draggable = false,
    this.removable = false,
    this.index,
    this.isSource = false,
    this.readonly = false,
    this.onUnitItemTap,
    this.onValueChanged,
    this.onValueFocused,
    this.onRefreshTap,
    this.onItemRemoved,
    this.prefixWidgets = const [],
    this.suffixWidgets = const [],
    required this.colors,
    required this.dialogColors,
    required this.theme,
    super.key,
  });

  @override
  State<ConvertouchConversionItem<M>> createState() =>
      _ConvertouchConversionItemState<M>();
}

class _ConvertouchConversionItemState<M extends ItemValueModel>
    extends State<ConvertouchConversionItem<M>> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return ConvertouchInputBox(
      key: Key(widget.model.id),
      model: widget.model,
      colors: widget.colors.inputBox,
      dialogColors: widget.dialogColors,
      theme: widget.theme,
      validators: [
        const NumSignsValidator(),
        NumInRangeValidator(widget.model.min, widget.model.max),
      ],
      floatingLabelBehavior: FloatingLabelBehavior.always,
      tooltipDirection:
          widget.isLast ? TooltipDirection.up : TooltipDirection.down,
      onValueChanged: widget.onValueChanged,
      onValueFocused: (value) {
        setState(() {
          _isFocused = true;
        });
        widget.onValueFocused?.call(value);
      },
      onValueUnfocused: (value) {
        setState(() {
          _isFocused = false;
        });
      },
      onRefreshTap: widget.onRefreshTap,
      prefixWidgets: [
        widget.draggable && widget.index != null
            ? ReorderableDragStartListener(
                index: widget.index!,
                child: Container(
                  width: _dragHandlerWidth,
                  color: Colors.transparent,
                  padding: const EdgeInsets.only(left: 3),
                  alignment: Alignment.center,
                  child: widget.isSource
                      ? Text(
                          '𝑥',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            height: -0.3,
                            color: widget.colors.prefixWidget.selected,
                          ),
                        )
                      : Icon(
                          Icons.drag_indicator_outlined,
                          color: _isFocused
                              ? widget.colors.prefixWidget.focused
                              : widget.colors.prefixWidget.regular,
                          size: 20,
                        ),
                ),
              )
            : null,
        ...widget.prefixWidgets,
      ],
      suffixWidgets: [
        ...widget.suffixWidgets,
        widget.model.unitItem != null && widget.model.unitItem!.exists
            ? GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  widget.onUnitItemTap?.call();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: _unitButtonWidth,
                  color: Colors.transparent,
                  child: Text(
                    widget.model.unitItem!.code,
                    style: TextStyle(
                      color: _isFocused
                          ? widget.colors.unitButton.focused
                          : widget.colors.unitButton.regular,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                  ),
                ),
              )
            : null,
        widget.removable
            ? GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  widget.onItemRemoved?.call();
                },
                child: Container(
                  padding: const EdgeInsets.only(right: 1),
                  width: _removalButtonWidth,
                  child: Icon(
                    Icons.remove,
                    color: widget.colors.removalIcon.regular,
                    size: 20,
                  ),
                ),
              )
            : null,
      ],
    );
  }
}
