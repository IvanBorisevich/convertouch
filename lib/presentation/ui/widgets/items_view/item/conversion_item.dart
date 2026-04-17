import 'package:convertouch/domain/utils/input_validators/num_in_range_validator.dart';
import 'package:convertouch/domain/utils/input_validators/num_signs_validator.dart';
import 'package:convertouch/presentation/ui/model/conversion_item_model.dart';
import 'package:convertouch/presentation/ui/model/input_box_model.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/input_box.dart';
import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

const double _dragHandlerWidth = 35;
const double _removalButtonWidth = 35;
const double _unitButtonWidth = 76;

class ConvertouchConversionItem<M extends InputBoxModel>
    extends StatefulWidget {
  final ConversionItemModel<M> model;
  final void Function()? onUnitItemTap;
  final void Function(String)? onValueChanged;
  final void Function(String)? onValueFocused;
  final void Function()? onItemRemoved;
  final List<Widget?> prefixWidgets;
  final List<Widget?> suffixWidgets;
  final ConversionItemColorScheme colors;

  const ConvertouchConversionItem(
    this.model, {
    this.onUnitItemTap,
    this.onValueChanged,
    this.onValueFocused,
    this.onItemRemoved,
    this.prefixWidgets = const [],
    this.suffixWidgets = const [],
    required this.colors,
    super.key,
  });

  @override
  State<ConvertouchConversionItem<M>> createState() =>
      _ConvertouchConversionItemState<M>();
}

class _ConvertouchConversionItemState<M extends InputBoxModel>
    extends State<ConvertouchConversionItem<M>> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return ConvertouchInputBox(
      model: widget.model.inputBoxModel,
      colors: widget.colors.inputBox,
      validators: [
        const NumSignsValidator(),
        NumInRangeValidator(widget.model.min, widget.model.max),
      ],
      tooltipDirection:
          widget.model.isLast ? TooltipDirection.up : TooltipDirection.down,
      changeValueOnFocusChanged: true,
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
      prefixWidgets: [
        widget.model.draggable && widget.model.index != null
            ? ReorderableDragStartListener(
                index: widget.model.index!,
                child: Container(
                  width: _dragHandlerWidth,
                  color: Colors.transparent,
                  padding: const EdgeInsets.only(left: 3),
                  alignment: Alignment.center,
                  child: widget.model.isSource
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
        widget.model.unit != null
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
                    widget.model.unit!.code,
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
        widget.model.removable
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
