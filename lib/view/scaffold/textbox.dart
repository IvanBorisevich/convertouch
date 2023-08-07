import 'package:convertouch/view/style/model/textbox_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConvertouchTextBox extends StatefulWidget {
  const ConvertouchTextBox({
    super.key,
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
    required this.textBoxColors,
  });

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
  final ConvertouchTextBoxColors textBoxColors;

  @override
  State createState() => _ConvertouchTextBoxState();
}

class _ConvertouchTextBoxState extends State<ConvertouchTextBox> {
  late final String _maxTextLengthStr;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _maxTextLengthStr = widget.maxTextLength.toString();
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
    return TextField(
      maxLength: widget.maxTextLength,
      obscureText: false,
      keyboardType: widget.keyboardType,
      autofocus: widget.autofocus,
      focusNode: _focusNode,
      controller: widget.controller,
      inputFormatters: widget.inputFormatters,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(widget.borderRadius)),
            borderSide: BorderSide(
              color: widget.textBoxColors.borderColor,
            )),
        focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(widget.borderRadius)),
            borderSide: BorderSide(
              color: widget.textBoxColors.borderColorFocused,
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
          color: widget.textBoxColors.labelColor,
        ),
        hintText: widget.hintText,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 15.0,
        ),
        counterText: "",
        suffixText: widget.textLengthCounterVisible
            ? '${widget.controller?.text.length.toString()}/$_maxTextLengthStr'
            : null,
      ),
      style: TextStyle(
        color: widget.textBoxColors.textColor,
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.start,
    );
  }
}
