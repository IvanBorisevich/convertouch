import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConvertouchTextBox extends StatefulWidget {
  const ConvertouchTextBox({
    super.key,
    this.label = "",
    this.labelColor = const Color(0xFF426F99),
    this.autofocus = false,
    this.onChanged,
    this.onFocusSelected,
    this.onFocusLeft,
    this.maxTextLength,
    this.textLengthCounterVisible = false,
    this.hintText,
    this.borderColor = const Color(0xFF426F99),
    this.borderColorFocused = const Color(0xFF426F99),
    this.borderRadius = 8,
    this.textColor = const Color(0xFF426F99),
    this.controller,
    this.inputFormatters,
    this.keyboardType,
  });

  final String label;
  final Color labelColor;
  final bool autofocus;
  final void Function(String)? onChanged;
  final void Function()? onFocusSelected;
  final void Function()? onFocusLeft;
  final int? maxTextLength;
  final bool textLengthCounterVisible;
  final String? hintText;
  final Color borderColor;
  final Color borderColorFocused;
  final double borderRadius;
  final Color textColor;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

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
            borderSide: BorderSide(color: widget.borderColor)),
        focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(widget.borderRadius)),
            borderSide: BorderSide(color: widget.borderColorFocused)),
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
          color: widget.labelColor,
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
        color: widget.textColor,
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.start,
    );
  }
}
