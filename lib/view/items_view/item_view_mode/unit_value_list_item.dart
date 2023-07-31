import 'package:convertouch/model/entity/unit_value_model.dart';
import 'package:convertouch/view/scaffold/textbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConvertouchUnitValueListItem extends StatefulWidget {
  const ConvertouchUnitValueListItem(
    this.item, {
    this.onTap,
    this.onLongPress,
    this.onValueChanged,
    this.borderColor = const Color(0xFF426F99),
    this.borderColorSelected = const Color(0xFF426F99),
    this.unitValueBackgroundColor = const Color(0x00FFFFFF),
    this.unitValueTextColor = const Color(0xFF426F99),
    this.unitButtonBackgroundColor = const Color(0xFFE2EEF8),
    this.unitButtonBackgroundColorSelected = const Color(0xFFE2EEF8),
    this.unitButtonTextColor = const Color(0xFF426F99),
    this.unitButtonTextColorSelected = const Color(0xFF223D56),
    super.key,
  });

  final UnitValueModel item;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final void Function(String)? onValueChanged;
  final Color borderColor;
  final Color borderColorSelected;
  final Color unitValueBackgroundColor;
  final Color unitValueTextColor;
  final Color unitButtonBackgroundColor;
  final Color unitButtonBackgroundColorSelected;
  final Color unitButtonTextColor;
  final Color unitButtonTextColorSelected;

  @override
  State<ConvertouchUnitValueListItem> createState() =>
      _ConvertouchUnitValueListItemState();
}

class _ConvertouchUnitValueListItemState
    extends State<ConvertouchUnitValueListItem> {
  static const double _unitButtonWidth = 70;
  static const double _unitButtonHeight = 50;
  static const double _containerHeight = _unitButtonHeight;
  static const BorderRadius _elementsBorderRadius =
      BorderRadius.all(Radius.circular(8));

  bool _isFocused = false;
  late Color _borderColor;
  late Color _unitButtonBackgroundColor;
  late Color _unitButtonTextColor;

  @override
  Widget build(BuildContext context) {
    if (_isFocused) {
      _borderColor = widget.borderColorSelected;
      _unitButtonBackgroundColor = widget.unitButtonBackgroundColorSelected;
      _unitButtonTextColor = widget.unitButtonTextColorSelected;
    } else {
      _borderColor = widget.borderColor;
      _unitButtonBackgroundColor = widget.unitButtonBackgroundColor;
      _unitButtonTextColor = widget.unitButtonTextColor;
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
              controller: TextEditingController(text: widget.item.value),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              onChanged: widget.onValueChanged,
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
              textColor: widget.unitValueTextColor,
              borderColor: widget.borderColor,
              borderColorFocused: widget.borderColorSelected,
            ),
          ),
          const SizedBox(width: 7),
          GestureDetector(
            onTap: widget.onTap,
            onLongPress: widget.onLongPress,
            child: SizedBox(
              width: _unitButtonWidth,
              height: _unitButtonHeight,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    _unitButtonBackgroundColor,
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      side: BorderSide(
                        color: _borderColor,
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
                    color: _unitButtonTextColor,
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
