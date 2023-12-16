import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/ui/style/colors.dart';
import 'package:convertouch/presentation/ui/style/model/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConvertouchTextBox extends StatefulWidget {
  final String label;
  final bool autofocus;
  final void Function(String)? onChanged;
  final void Function()? onFocusSelected;
  final void Function()? onFocusLeft;
  final int? maxTextLength;
  final bool textLengthCounterVisible;
  final String? hintText;
  final double borderRadius;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final ConvertouchUITheme theme;
  final ConvertouchTextBoxColor? customColor;

  const ConvertouchTextBox({
    this.label = "",
    this.autofocus = false,
    this.onChanged,
    this.onFocusSelected,
    this.onFocusLeft,
    this.maxTextLength,
    this.textLengthCounterVisible = false,
    this.hintText,
    this.borderRadius = 8,
    this.controller,
    this.inputFormatters,
    this.keyboardType,
    required this.theme,
    this.customColor,
    super.key,
  });

  @override
  State createState() => _ConvertouchTextBoxState();
}

class _ConvertouchTextBoxState extends State<ConvertouchTextBox> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        widget.onFocusSelected?.call();
      } else {
        widget.onFocusLeft?.call();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ConvertouchTextBoxColor color =
        widget.customColor ?? textBoxColors[widget.theme]!;

    return TextField(
      maxLength: widget.maxTextLength,
      obscureText: false,
      keyboardType: widget.keyboardType,
      autofocus: widget.autofocus,
      focusNode: _focusNode,
      controller: widget.controller
        ?..selection = TextSelection.collapsed(
          offset: widget.controller?.text.length ?? 0,
        ),
      inputFormatters: widget.inputFormatters,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(widget.borderRadius)),
            borderSide: BorderSide(
              color: color.regular.border,
            )),
        focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(widget.borderRadius)),
            borderSide: BorderSide(
              color: color.focused.border,
            )),
        label: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width / 2,
          ),
          child: Text(
            widget.label,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.fade,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: TextStyle(
          color: color.regular.label,
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: color.regular.hint,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 15.0,
        ),
        counterText: "",
        suffixText: widget.textLengthCounterVisible
            ? '${widget.controller?.text.length}/${widget.maxTextLength}'
            : null,
      ),
      style: TextStyle(
        color: _focusNode.hasFocus
            ? color.focused.content
            : color.regular.content,
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.start,
    );
  }
}
