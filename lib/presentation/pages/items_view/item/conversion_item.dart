import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_value_model.dart';
import 'package:convertouch/domain/utils/unit_value_util.dart';
import 'package:convertouch/presentation/pages/scaffold/textbox.dart';
import 'package:convertouch/presentation/pages/style/colors.dart';
import 'package:convertouch/presentation/pages/style/model/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConvertouchConversionItem extends StatefulWidget {
  final UnitValueModel item;
  final void Function()? onTap;
  final void Function(String)? onValueChanged;
  final ConvertouchConversionItemColor? color;

  const ConvertouchConversionItem(
    this.item, {
    this.onTap,
    this.onValueChanged,
    this.color,
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

  final _unitValueController = TextEditingController();

  late bool _isFocused;

  late ConvertouchTextBoxColor _textBoxColor;
  late ConvertouchMenuItemColor _unitButtonColor;
  late String _rawUnitValue;

  @override
  void initState() {
    super.initState();
    _isFocused = false;
    _rawUnitValue = formatValue(widget.item.value);
  }

  @override
  Widget build(BuildContext context) {
    var itemColor =
        widget.color ?? conversionItemColor[ConvertouchUITheme.light]!;
    _textBoxColor = itemColor.textBox;
    _unitButtonColor = itemColor.unitButton;

    if (!_isFocused) {
      _rawUnitValue = formatValue(widget.item.value);
      _unitValueController.text = formatValueInScientificNotation(
        widget.item.value,
      );
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
              label: widget.item.unit.name,
              controller: _unitValueController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)')),
              ],
              keyboardType: const TextInputType.numberWithOptions(
                signed: false,
                decimal: true,
              ),
              onChanged: (value) {
                _rawUnitValue = value;
                widget.onValueChanged?.call(value);
              },
              onFocusSelected: () {
                setState(() {
                  _isFocused = true;
                  _unitValueController.text = _rawUnitValue;
                });
              },
              onFocusLeft: () {
                setState(() {
                  _isFocused = false;
                });
              },
              customColor: _textBoxColor,
            ),
          ),
          const SizedBox(width: 7),
          GestureDetector(
            onTap: widget.onTap,
            child: SizedBox(
              width: _unitButtonWidth,
              height: _unitButtonHeight,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    _isFocused
                        ? _unitButtonColor.focused.background
                        : _unitButtonColor.regular.background,
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      side: BorderSide(
                        color: _isFocused
                            ? _unitButtonColor.focused.border
                            : _unitButtonColor.regular.border,
                        width: 1,
                      ),
                      borderRadius: _elementsBorderRadius,
                    ),
                  ),
                ),
                onPressed: null,
                child: Text(
                  widget.item.unit.abbreviation,
                  style: TextStyle(
                    color: _isFocused
                        ? _unitButtonColor.focused.content
                        : _unitButtonColor.regular.content,
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
}
