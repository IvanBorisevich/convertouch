import 'package:convertouch/model/entity/unit_value_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConvertouchUnitValueListItem extends StatefulWidget {
  const ConvertouchUnitValueListItem(this.item,
      {super.key, this.spacingBetweenTextAndButton = 7});

  final UnitValueModel item;
  final double spacingBetweenTextAndButton;

  @override
  State<ConvertouchUnitValueListItem> createState() =>
      _ConvertouchUnitValueListItemState();
}

class _ConvertouchUnitValueListItemState
    extends State<ConvertouchUnitValueListItem> {
  static const double _unitButtonWidth = 70;
  static const double _unitButtonHeight = 50;
  static const double _containerHeight = _unitButtonHeight;
  static const double _convertedValueTextFontSize = 17;
  static const BorderRadius _elementsBorderRadius =
      BorderRadius.all(Radius.circular(8));

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _containerHeight,
      decoration: const BoxDecoration(
        borderRadius: _elementsBorderRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextField(
              controller: TextEditingController(text: widget.item.value),
              autofocus: false,
              obscureText: false,
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                    borderRadius: _elementsBorderRadius,
                    borderSide: BorderSide(color: Color(0xFF426F99))),
                focusedBorder: const OutlineInputBorder(
                    borderRadius: _elementsBorderRadius,
                    borderSide: BorderSide(color: Color(0xFF426F99))),
                //labelText: widget.item.unit.name,
                label: Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width / 2),
                  child: Text(
                    widget.item.unit.name,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                  ),
                ),
                labelStyle: const TextStyle(
                  // overflow: TextOverflow.ellipsis,
                  color: Color(0xFF426F99),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 15.0),
              ),
              style: const TextStyle(
                color: Color(0xFF426F99),
                fontSize: _convertedValueTextFontSize,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(width: widget.spacingBetweenTextAndButton),
          SizedBox(
            width: _unitButtonWidth,
            height: _unitButtonHeight,
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xffe2eef8)),
                  shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                      side: BorderSide(
                        color: Color(0xFF426F99),
                        width: 1,
                      ),
                      borderRadius: _elementsBorderRadius))),
              child: Text(
                widget.item.unit.abbreviation,
                style: const TextStyle(
                  color: Color(0xFF426F99),
                ),
                maxLines: 1,
              ),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
