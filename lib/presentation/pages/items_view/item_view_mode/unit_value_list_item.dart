import 'package:convertouch/domain/entities/unit_value_entity.dart';
import 'package:convertouch/presentation/pages/scaffold/textbox.dart';
import 'package:convertouch/presentation/pages/style/model/conversion_item_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConvertouchUnitValueListItem extends StatefulWidget {
  const ConvertouchUnitValueListItem(
    this.item, {
    this.onTap,
    this.onLongPress,
    this.onValueChanged,
    required this.itemColors,
    super.key,
  });

  final UnitValueEntity item;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final void Function(String)? onValueChanged;
  final ConvertouchConversionItemColors itemColors;

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
    var itemColors = widget.itemColors;
    if (_isFocused) {
      _borderColor = itemColors.textBoxColors.borderColorFocused;
      _unitButtonBackgroundColor = itemColors.unitButtonBackgroundColorSelected;
      _unitButtonTextColor = itemColors.unitButtonTextColorSelected;
    } else {
      _borderColor = itemColors.textBoxColors.borderColor;
      _unitButtonBackgroundColor = itemColors.unitButtonBackgroundColor;
      _unitButtonTextColor = itemColors.unitButtonTextColor;
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
              textBoxColors: itemColors.textBoxColors,
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
