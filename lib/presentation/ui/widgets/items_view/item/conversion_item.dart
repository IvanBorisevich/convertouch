import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/utils/icon_utils.dart';
import 'package:convertouch/presentation/ui/widgets/textbox.dart';
import 'package:flutter/material.dart';

class ConvertouchConversionItem extends StatefulWidget {
  final ConversionItemModel item;
  final ConvertouchValueType valueType;
  final void Function()? onTap;
  final void Function(String)? onValueChanged;
  final bool disabled;
  final ConvertouchUITheme theme;
  final ConversionItemColorScheme? customColors;
  final double spacing;

  const ConvertouchConversionItem(
    this.item, {
    required this.valueType,
    this.onTap,
    this.onValueChanged,
    this.disabled = false,
    required this.theme,
    this.customColors,
    this.spacing = 10,
    super.key,
  });

  @override
  State<ConvertouchConversionItem> createState() =>
      _ConvertouchConversionItemState();
}

class _ConvertouchConversionItemState extends State<ConvertouchConversionItem> {
  static const double _unitButtonWidth = 75;
  static const double _unitButtonHeight = 48;
  static const double _containerHeight = _unitButtonHeight;
  static const double _elementsBorderRadius = 15;

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
    var unitTextBoxColor = itemColor.textBox;

    if (_isFocused && !widget.disabled) {
      _unitValueController.text = widget.item.value.str;
    } else {
      _unitValueController.text = widget.item.value.scientific;
    }

    return Container(
      height: _containerHeight,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(_elementsBorderRadius)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ConvertouchTextBox(
              controller: _unitValueController,
              disabled: widget.disabled,
              label: widget.item.unit.name,
              hintText: _isFocused && !widget.disabled
                  ? widget.item.defaultValue.str
                  : widget.item.defaultValue.scientific,
              borderRadius: 15,
              inputType: widget.valueType,
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
                      : empty(),
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
                      : empty(),
                ],
              ),
              colors: unitTextBoxColor,
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
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                ),
                onPressed: null,
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
