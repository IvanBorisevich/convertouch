import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/utils/icon_utils.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/input_box.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/text_box.dart';
import 'package:flutter/material.dart';

class ConvertouchConversionItem<T extends ConversionItemValueModel>
    extends StatefulWidget {
  final T item;
  final int? index;
  final void Function()? onTap;
  final void Function(String?)? onValueChanged;
  final void Function()? onRemove;
  final bool isSource;
  final bool disabled;
  final bool controlsVisible;
  final String Function(T) itemNameFunc;
  final String? Function(T) unitItemCodeFunc;
  final ConversionItemColorScheme colors;

  const ConvertouchConversionItem(
    this.item, {
    this.index,
    this.onTap,
    this.onValueChanged,
    this.onRemove,
    this.isSource = false,
    this.disabled = false,
    this.controlsVisible = true,
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
  static const double _containerPadding = 7;
  static const double _containerHeight =
      ConvertouchTextBox.defaultHeight + _containerPadding * 2;

  late bool _isFocused;

  @override
  void initState() {
    _isFocused = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var itemColor = widget.colors;
    var unitButtonColor = itemColor.unitButton;
    var unitTextBoxColor = itemColor.textBox;
    var handlerColor = itemColor.handler;
    var highlightBackgroundColor = itemColor.highlightBackground;

    String? valueStr;
    String? defaultValueStr;

    if (_isFocused && !widget.disabled) {
      valueStr = widget.item.value?.raw;
      defaultValueStr = widget.item.defaultValue?.raw;
    } else {
      valueStr = widget.item.value?.alt;
      defaultValueStr = widget.item.defaultValue?.alt;
    }

    String itemName = widget.itemNameFunc.call(widget.item);
    String? itemCode = widget.unitItemCodeFunc.call(widget.item);

    return Container(
      height: _containerHeight,
      padding: const EdgeInsets.symmetric(vertical: _containerPadding),
      decoration: BoxDecoration(
        color: widget.isSource
            ? highlightBackgroundColor.regular
            : Colors.transparent,
      ),
      child: Row(
        children: [
          widget.controlsVisible
              ? _wrapIntoDragListener(
                  index: widget.index,
                  child: _handler(
                    iconLogo:
                        !widget.isSource ? Icons.drag_indicator_outlined : null,
                    textLogo: widget.isSource ? '𝑥' : null,
                    handlerColor: handlerColor,
                  ),
                )
              : const SizedBox.shrink(),
          Expanded(
            child: ConvertouchInputBox(
              value: valueStr,
              defaultValue: defaultValueStr,
              readonly: widget.disabled,
              label: itemName,
              borderRadius: 15,
              valueType: widget.item.valueType,
              listType: widget.item.listType,
              onChanged: (value) {
                if (value != '.' && value != '-') {
                  widget.onValueChanged?.call(value);
                }
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
              suffixIcon: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.item is ConversionUnitValueModel &&
                          !(widget.item as ConversionUnitValueModel)
                              .unit
                              .invertible
                      ? Padding(
                          padding: const EdgeInsets.all(9),
                          child: IconUtils.getSuffixSvgIcon(
                            IconNames.oneWayConversion,
                            color: itemColor.textBox.foreground.regular,
                          ),
                        )
                      : const SizedBox.shrink(),
                  widget.item.value != null && _isFocused
                      ? IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            color: itemColor.textBox.foreground.regular,
                            size: 17,
                          ),
                          onPressed: () {
                            widget.onValueChanged?.call(null);
                          },
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              colors: unitTextBoxColor,
            ),
          ),
          itemCode != null
              ? Container(
                  width: _unitButtonWidth,
                  height: ConvertouchTextBox.defaultHeight,
                  padding: const EdgeInsets.only(left: 7),
                  child: TextButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      widget.onTap?.call();
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        unitButtonColor.background.regular,
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          side: BorderSide(
                            color: unitButtonColor.border.regular,
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
          widget.controlsVisible
              ? _handler(
                  iconLogo: Icons.remove,
                  handlerColor: handlerColor,
                  onTap: widget.onRemove,
                )
              : const SizedBox.shrink(),
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
    required ConvertouchColorScheme handlerColor,
    void Function()? onTap,
  }) {
    Color background = widget.isSource
        ? handlerColor.background.selected
        : handlerColor.background.regular;

    Color foreground = widget.isSource
        ? handlerColor.foreground.selected
        : handlerColor.foreground.regular;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
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
          child: textLogo != null
              ? Container(
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
                )
              : (iconLogo != null
                  ? Icon(
                      iconLogo,
                      color: foreground,
                    )
                  : null),
        ),
      ),
    );
  }
}
