import 'package:convertouch/presentation/ui/constants/conversion_item_constants.dart';
import 'package:convertouch/presentation/ui/constants/input_box_constants.dart';
import 'package:convertouch/presentation/ui/model/conversion_item_model.dart';
import 'package:convertouch/presentation/ui/model/input_box_model.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/input_box.dart';
import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

class ConvertouchConversionItem<M extends InputBoxModel>
    extends StatefulWidget {
  final ConversionItemModel<M> model;
  final void Function()? onUnitItemTap;
  final void Function(dynamic)? onValueChanged;
  final void Function(dynamic)? onValueFocused;
  final void Function()? onItemRemoved;
  final ConversionItemColorScheme colors;

  const ConvertouchConversionItem(
    this.model, {
    this.onUnitItemTap,
    this.onValueChanged,
    this.onValueFocused,
    this.onItemRemoved,
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
      borderWidth: 0,
      colors: widget.colors.inputBox,
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
        widget.model.draggable
            ? ReorderableDragStartListener(
                index: widget.model.index,
                child: Container(
                  width: 32,
                  padding: const EdgeInsets.only(left: 3),
                  alignment: Alignment.center,
                  child: widget.model.isSource
                      ? Container(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: null,
                            child: Text(
                              '𝑥',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                height: -0.3,
                                color: widget.colors.prefixWidget.selected,
                              ),
                            ),
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
      ],
      suffixWidgets: [
        widget.model.unit != null
            ? GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  widget.onUnitItemTap?.call();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: ConversionItemConstants.defaultUnitButtonWidth,
                  decoration: const BoxDecoration(
                    borderRadius: InputBoxConstants.defaultBorderRadius,
                  ),
                  child: Text(
                    widget.model.unit?.code ?? "",
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
            ? Container(
                padding: const EdgeInsets.only(right: 1),
                width: 35,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    widget.onItemRemoved?.call();
                  },
                  icon: Icon(
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
