import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_value_model.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/textbox.dart';
import 'package:convertouch/presentation/ui/style/colors.dart';
import 'package:convertouch/presentation/ui/style/model/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConvertouchConversionItem extends StatefulWidget {
  final UnitValueModel item;
  final void Function()? onTap;
  final void Function(String)? onValueChanged;
  final ConvertouchUITheme theme;
  final ConvertouchConversionItemColor? customColors;

  const ConvertouchConversionItem(
    this.item, {
    this.onTap,
    this.onValueChanged,
    required this.theme,
    this.customColors,
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

  @override
  void initState() {
    super.initState();
    _isFocused = false;
  }

  @override
  Widget build(BuildContext context) {
    var itemColor = widget.customColors ?? conversionItemColors[widget.theme]!;
    var textBoxColor = itemColor.textBox;
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
                widget.onValueChanged?.call(value);
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
              customColor: textBoxColor,
              theme: widget.theme,
            ),
          ),
          const SizedBox(width: 7),
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
                        ? unitButtonColor.focused.background
                        : unitButtonColor.regular.background,
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      side: BorderSide(
                        color: _isFocused
                            ? unitButtonColor.focused.border
                            : unitButtonColor.regular.border,
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
                        ? unitButtonColor.focused.content
                        : unitButtonColor.regular.content,
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
