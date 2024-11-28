import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/utils/icon_utils.dart';
import 'package:convertouch/presentation/ui/widgets/textbox.dart';
import 'package:flutter/material.dart';

class ConvertouchConversionItem extends StatefulWidget {
  final ConversionItemModel item;
  final int? index;
  final ConvertouchValueType inputType;
  final void Function()? onTap;
  final void Function(String)? onValueChanged;
  final void Function()? onRemove;
  final bool disabled;
  final ConversionItemColorScheme colors;

  const ConvertouchConversionItem(
    this.item, {
    this.index,
    required this.inputType,
    this.onTap,
    this.onValueChanged,
    this.onRemove,
    this.disabled = false,
    required this.colors,
    super.key,
  });

  @override
  State<ConvertouchConversionItem> createState() =>
      _ConvertouchConversionItemState();
}

class _ConvertouchConversionItemState extends State<ConvertouchConversionItem> {
  static const double _unitButtonWidth = 90;
  static const double _defaultHeight = ConvertouchTextBox.defaultHeight;
  static const double _elementsBorderRadius = 15;
  static const double _spacing = 11;

  late final TextEditingController _unitValueController;

  late bool _isFocused;

  @override
  void initState() {
    _unitValueController = TextEditingController();
    _isFocused = false;
    super.initState();
  }

  @override
  void dispose() {
    _unitValueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var itemColor = widget.colors;
    var unitButtonColor = itemColor.unitButton;
    var unitTextBoxColor = itemColor.textBox;
    var handlerColor = itemColor.handler;

    if (_isFocused && !widget.disabled) {
      _unitValueController.text = widget.item.value.str;
    } else {
      _unitValueController.text = widget.item.value.scientific;
    }

    return SizedBox(
      height: _defaultHeight,
      child: Row(
        children: [
          wrapIntoDragListener(
            index: widget.index,
            child: Container(
              padding: const EdgeInsets.only(right: 6),
              child: Icon(
                Icons.drag_indicator_outlined,
                color: handlerColor.foreground.regular,
              ),
            ),
          ),
          Expanded(
            child: ConvertouchTextBox(
              controller: _unitValueController,
              disabled: widget.disabled,
              label: widget.item.unit.name,
              hintText: _isFocused && !widget.disabled
                  ? widget.item.defaultValue.str
                  : widget.item.defaultValue.scientific,
              borderRadius: 15,
              inputType: widget.inputType,
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
                  !widget.item.unit.invertible
                      ? Padding(
                          padding: const EdgeInsets.all(9),
                          child: IconUtils.getSuffixSvgIcon(
                            IconNames.oneWayConversion,
                            color: itemColor.textBox.foreground.regular,
                          ),
                        )
                      : const SizedBox.shrink(),
                  widget.item.value.str.isNotEmpty && _isFocused
                      ? IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            color: itemColor.textBox.foreground.regular,
                            size: 17,
                          ),
                          onPressed: () {
                            widget.onValueChanged?.call("");
                            setState(() {
                              _unitValueController.clear();
                            });
                          },
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              colors: unitTextBoxColor,
            ),
          ),
          Container(
            width: _unitButtonWidth,
            height: _defaultHeight,
            padding: const EdgeInsets.only(left: _spacing),
            child: TextButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                widget.onTap?.call();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  _isFocused && !widget.disabled
                      ? unitButtonColor.background.focused
                      : unitButtonColor.background.regular,
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    side: BorderSide(
                      color: _isFocused && !widget.disabled
                          ? unitButtonColor.border.focused
                          : unitButtonColor.border.regular,
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(_elementsBorderRadius),
                    ),
                  ),
                ),
              ),
              child: Text(
                widget.item.unit.code,
                style: TextStyle(
                  color: _isFocused && !widget.disabled
                      ? unitButtonColor.foreground.focused
                      : unitButtonColor.foreground.regular,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 9, right: 1),
            child: GestureDetector(
              onTap: widget.onRemove,
              child: Icon(
                Icons.remove_circle_outline,
                color: handlerColor.foreground.regular,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget wrapIntoDragListener({
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
}
