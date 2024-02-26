import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/keyboard/model/keyboard_models.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/textbox.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:flutter/material.dart';

class ConvertouchConversionItem extends StatefulWidget {
  final ConversionItemModel item;
  final void Function()? onTap;
  final void Function(String)? onValueChanged;
  final bool disabled;
  final ConvertouchUITheme theme;
  final ConversionItemColorScheme? customColors;
  final double spacing;

  const ConvertouchConversionItem(
    this.item, {
    this.onTap,
    this.onValueChanged,
    this.disabled = false,
    required this.theme,
    this.customColors,
    this.spacing = 11,
    super.key,
  });

  @override
  State<ConvertouchConversionItem> createState() =>
      _ConvertouchConversionItemState();
}

class _ConvertouchConversionItemState extends State<ConvertouchConversionItem> {
  static const double _unitButtonWidth = 70;
  static const double _unitButtonHeight = 50;
  static const double _containerHeight = _unitButtonHeight;
  static const BorderRadius _elementsBorderRadius =
      BorderRadius.all(Radius.circular(8));

  late final TextEditingController _unitValueController;

  late bool _isFocused;

  @override
  void initState() {
    _unitValueController = TextEditingController();
    _isFocused = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var itemColor = widget.customColors ?? conversionItemColors[widget.theme]!;
    var unitButtonColor = itemColor.unitButton;

    if (_isFocused) {
      _unitValueController.text = widget.item.value.strValue;
    } else {
      _unitValueController.text =
          widget.item.value.scientificValue ?? widget.item.value.strValue;
    }

    return Container(
      height: _containerHeight,
      decoration: const BoxDecoration(
        borderRadius: _elementsBorderRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ConvertouchTextBox(
              controller: _unitValueController,
              disabled: widget.disabled,
              label: widget.item.unit.name,
              hintText: _isFocused
                  ? widget.item.defaultValue.strValue
                  : widget.item.defaultValue.scientificValue,
              inputFormatters: [
                decimalNegativeNumbersFormatter,
              ],
              textInputType: decimalNegativeNumbersType,
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
              theme: widget.theme,
            ),
          ),
          SizedBox(width: widget.spacing),
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              widget.onTap?.call();
            },
            child: SizedBox(
              width: _unitButtonWidth,
              height: _unitButtonHeight,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    _isFocused
                        ? unitButtonColor.background.focused
                        : unitButtonColor.background.regular,
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      side: BorderSide(
                        color: _isFocused
                            ? unitButtonColor.border.focused
                            : unitButtonColor.border.regular,
                        width: 1,
                      ),
                      borderRadius: _elementsBorderRadius,
                    ),
                  ),
                ),
                onPressed: null,
                child: Text(
                  widget.item.unit.code,
                  style: TextStyle(
                    color: _isFocused
                        ? unitButtonColor.foreground.focused
                        : unitButtonColor.foreground.regular,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _unitValueController.dispose();
    super.dispose();
  }
}
