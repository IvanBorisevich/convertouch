import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/num_range.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/utils/icon_utils.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/input_box.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/text_box.dart';
import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

enum ControlPosition {
  left,
  right;
}

class ConvertouchConversionItem<T extends ConversionItemValueModel>
    extends StatefulWidget {
  static const double _defaultSpacing = 7;

  final T item;
  final int? index;
  final void Function()? onUnitItemTap;
  final void Function(String?)? onValueChanged;
  final void Function()? onRemove;
  final bool wrapped;
  final bool isSource;
  final bool disabled;
  final bool dragDropControlVisible;
  final bool removalControlVisible;
  final bool isLast;
  final double spacing;
  final double horizontalPadding;
  final String Function(T) itemNameFunc;
  final String? Function(T) unitItemCodeFunc;
  final ConversionItemColorScheme colors;

  const ConvertouchConversionItem(
    this.item, {
    this.index,
    this.onUnitItemTap,
    this.onValueChanged,
    this.onRemove,
    this.wrapped = false,
    this.isSource = false,
    this.disabled = false,
    this.dragDropControlVisible = true,
    this.removalControlVisible = true,
    this.isLast = false,
    this.spacing = _defaultSpacing,
    this.horizontalPadding = _defaultSpacing,
    required this.itemNameFunc,
    required this.unitItemCodeFunc,
    required this.colors,
    super.key,
  });

  @override
  State<ConvertouchConversionItem<T>> createState() =>
      _ConvertouchConversionItemState<T>();
}

class _ConvertouchConversionItemState<T extends ConversionItemValueModel>
    extends State<ConvertouchConversionItem<T>> {
  static const double _unitButtonWidth = 90;
  static const double _unitButtonBorderRadius = 15;
  static const double _containerHeight = ConvertouchTextBox.defaultHeight;
  static const double _wrapContainerHeight =
      _containerHeight + ConvertouchConversionItem._defaultSpacing * 2;

  late bool _isFocused;

  @override
  void initState() {
    _isFocused = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var unitButtonColor = widget.colors.unitButton;
    var textBoxColor = widget.colors.textBox;
    var handlerColor = widget.colors.handler;
    var wrapBackgroundColor = widget.colors.wrapBackground;

    String? valueStr;
    String? defaultValueStr;

    if (_isFocused && !widget.disabled) {
      valueStr = widget.item.value?.raw;
      defaultValueStr = widget.item.defaultValue?.raw;
    } else {
      valueStr = widget.item.value?.altOrRaw;
      defaultValueStr = widget.item.defaultValue?.altOrRaw;
    }

    String itemName = widget.itemNameFunc.call(widget.item);
    String? itemCode = widget.unitItemCodeFunc.call(widget.item);

    var itemValuesRange = NumRange.closed(widget.item.min, widget.item.max);

    return Container(
      height: widget.wrapped ? _wrapContainerHeight : _containerHeight,
      padding: widget.wrapped
          ? const EdgeInsets.symmetric(
              vertical: ConvertouchConversionItem._defaultSpacing,
            )
          : null,
      decoration: BoxDecoration(
        color:
            widget.isSource ? wrapBackgroundColor.regular : Colors.transparent,
      ),
      child: Row(
        children: [
          SizedBox(width: widget.horizontalPadding),
          widget.dragDropControlVisible
              ? _wrapIntoDragListener(
                  index: widget.index,
                  child: _handler(
                    iconLogo:
                        !widget.isSource ? Icons.drag_indicator_outlined : null,
                    textLogo: widget.isSource ? '𝑥' : null,
                    handlerColor: handlerColor,
                    controlPosition: ControlPosition.left,
                  ),
                )
              : const SizedBox.shrink(),
          Expanded(
            child: ConvertouchInputBox(
              value: valueStr,
              defaultValue: defaultValueStr,
              listValues: widget.item.listValues,
              selectedListValue: widget.item.value?.toListValueModel(),
              itemUnit: widget.item.unitItem,
              readonly: widget.disabled,
              tooltipDirection:
                  widget.isLast ? TooltipDirection.up : TooltipDirection.down,
              label: itemName,
              borderRadius: 15,
              valueType: widget.item.valueType,
              invalidValueTooltipMessage: itemValuesRange.validationMessage,
              isValueValid: (value) {
                if (value == null) {
                  return true;
                }

                return itemValuesRange.contains(double.tryParse(value));
              },
              onChanged: (value) {
                if (value != '.' && value != '-') {
                  widget.onValueChanged?.call(value);
                }
              },
              onClean: () {
                widget.onValueChanged?.call(null);
              },
              onFocusSelected: () {
                setState(() {
                  _isFocused = true;
                });
              },
              onFocusLeft: () {
                setState(() {
                  _isFocused = false;
                });
              },
              suffixIcon: _suffixIcon(),
              colors: textBoxColor,
              labelPadding: widget.isSource
                  ? const EdgeInsets.symmetric(horizontal: 4)
                  : null,
            ),
          ),
          itemCode != null
              ? Container(
                  width: _unitButtonWidth,
                  height: ConvertouchTextBox.defaultHeight,
                  padding: EdgeInsets.only(left: widget.spacing),
                  child: TextButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      widget.onUnitItemTap?.call();
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        widget.isSource
                            ? unitButtonColor.background.selected
                            : unitButtonColor.background.regular,
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          side: BorderSide(
                            color: widget.isSource
                                ? unitButtonColor.border.selected
                                : unitButtonColor.border.regular,
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(_unitButtonBorderRadius),
                          ),
                        ),
                      ),
                    ),
                    child: Text(
                      itemCode,
                      style: TextStyle(
                        color: unitButtonColor.foreground.regular,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          widget.removalControlVisible
              ? _handler(
                  iconLogo: Icons.remove,
                  handlerColor: handlerColor,
                  controlPosition: ControlPosition.right,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    widget.onRemove?.call();
                  },
                )
              : const SizedBox.shrink(),
          SizedBox(width: widget.horizontalPadding),
        ],
      ),
    );
  }

  Widget _wrapIntoDragListener({
    int? index,
    required Widget child,
  }) {
    return index != null
        ? ReorderableDragStartListener(
            index: index,
            child: child,
          )
        : child;
  }

  Widget _handler({
    IconData? iconLogo,
    String? textLogo,
    required ControlPosition controlPosition,
    required ConvertouchColorScheme handlerColor,
    void Function()? onTap,
  }) {
    Color background = widget.isSource
        ? handlerColor.background.selected
        : handlerColor.background.regular;

    Color foreground = widget.isSource
        ? handlerColor.foreground.selected
        : handlerColor.foreground.regular;

    Widget? handlerLogo() {
      if (textLogo != null) {
        return Container(
          padding: const EdgeInsets.only(left: 2),
          child: Text(
            textLogo,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              height: -0.3,
              color: foreground,
            ),
          ),
        );
      }

      if (iconLogo != null) {
        return Icon(
          iconLogo,
          color: foreground,
        );
      }

      return null;
    }

    return Padding(
      padding: EdgeInsets.only(
        left: controlPosition == ControlPosition.right ? widget.spacing : 0,
        right: controlPosition == ControlPosition.left ? widget.spacing : 0,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: background,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
          ),
          child: handlerLogo(),
        ),
      ),
    );
  }

  Widget? _suffixIcon() {
    if (widget.item is ConversionUnitValueModel &&
        !(widget.item as ConversionUnitValueModel).unit.invertible) {
      return Padding(
        padding: const EdgeInsets.all(9),
        child: IconUtils.getSuffixSvgIcon(
          IconNames.oneWayConversion,
          color: widget.colors.textBox.foreground.regular,
        ),
      );
    }

    return null;
  }
}
