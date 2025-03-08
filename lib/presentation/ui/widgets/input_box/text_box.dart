import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Map<ConvertouchValueType, TextInputType> inputValueTypeToKeyboardTypeMap =
    {
  ConvertouchValueType.text: TextInputType.text,
  ConvertouchValueType.integer: TextInputType.numberWithOptions(
    signed: true,
    decimal: false,
  ),
  ConvertouchValueType.integerPositive: TextInputType.numberWithOptions(
    signed: false,
    decimal: false,
  ),
  ConvertouchValueType.decimal: TextInputType.numberWithOptions(
    signed: true,
    decimal: true,
  ),
  ConvertouchValueType.decimalPositive: TextInputType.numberWithOptions(
    signed: false,
    decimal: true,
  ),
  ConvertouchValueType.hexadecimal: TextInputType.text,
};

final Map<ConvertouchValueType, RegExp> inputValueTypeToRegExpMap = {
  ConvertouchValueType.text: RegExp(r'(^[\S ]+$)'),
  ConvertouchValueType.integer: RegExp(r'(^[.-]?$)|(^-?\d+$)'),
  ConvertouchValueType.integerPositive: RegExp(r'(^\d+$)'),
  ConvertouchValueType.decimal: RegExp(r'(^[.-]?$)|(^-?\d+\.?\d*$)'),
  ConvertouchValueType.decimalPositive: RegExp(r'(^\d+\.?\d*$)'),
  ConvertouchValueType.hexadecimal: RegExp(r'^0[xX][\da-fA-F]+$'),
};

class ConvertouchTextBox extends StatefulWidget {
  static const double defaultHeight = 55;

  final String? text;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ConvertouchValueType valueType;
  final String label;
  final bool autofocus;
  final bool readonly;
  final void Function(String)? onChanged;
  final void Function()? onFocusSelected;
  final void Function()? onFocusLeft;
  final int? maxTextLength;
  final bool textLengthCounterVisible;
  final String? hintText;
  final double borderRadius;
  final TextBoxColorScheme colors;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry contentPadding;
  final double height;
  final double fontSize;

  const ConvertouchTextBox({
    this.text,
    this.controller,
    this.focusNode,
    this.valueType = ConvertouchValueType.text,
    this.label = "",
    this.autofocus = false,
    this.readonly = false,
    this.onChanged,
    this.onFocusSelected,
    this.onFocusLeft,
    this.maxTextLength,
    this.textLengthCounterVisible = false,
    this.hintText,
    this.borderRadius = 15,
    required this.colors,
    this.prefixIcon,
    this.suffixIcon,
    this.contentPadding = const EdgeInsets.all(17),
    this.height = defaultHeight,
    this.fontSize = 17,
    super.key,
  });

  @override
  State createState() => _ConvertouchTextBoxState();
}

class _ConvertouchTextBoxState extends State<ConvertouchTextBox> {
  int? _cursorPosition;

  late final FocusNode _focusNode;
  late final TextEditingController _controller;

  TextEditingController? _defaultController;
  FocusNode? _defaultFocusNode;

  @override
  void initState() {
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _defaultController = TextEditingController();
      _controller = _defaultController!;
    }

    if (_controller.text.isEmpty) {
      _controller.text = widget.text ?? "";
    }

    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _defaultFocusNode = FocusNode();
      _focusNode = _defaultFocusNode!;
    }

    _focusNode.addListener(_focusListener);

    super.initState();
  }

  void _focusListener() {
    if (widget.readonly) {
      return;
    }

    if (_focusNode.hasFocus) {
      widget.onFocusSelected?.call();
      _cursorPosition = null;
    } else {
      widget.onFocusLeft?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    RegExp? inputRegExp = inputValueTypeToRegExpMap[widget.valueType];

    if (_cursorPosition == null || _cursorPosition! > _controller.text.length) {
      _cursorPosition = _controller.text.length;
    }

    _controller.selection = TextSelection.collapsed(
      offset: _cursorPosition!,
    );

    Color borderColor;
    Color foregroundColor;
    Color hintColor;

    if (widget.readonly) {
      borderColor = widget.colors.border.disabled;
      foregroundColor = widget.colors.foreground.disabled;
      hintColor = widget.colors.hint.disabled;
    } else if (_focusNode.hasFocus) {
      borderColor = widget.colors.border.focused;
      foregroundColor = widget.colors.foreground.focused;
      hintColor = widget.colors.hint.focused;
    } else {
      borderColor = widget.colors.border.regular;
      foregroundColor = widget.colors.foreground.regular;
      hintColor = widget.colors.hint.regular;
    }

    return SizedBox(
      height: widget.height,
      child: TextField(
        readOnly: widget.readonly,
        maxLength: widget.maxTextLength,
        textAlignVertical: TextAlignVertical.center,
        obscureText: false,
        autofocus: widget.autofocus,
        focusNode: _focusNode,
        controller: _controller,
        inputFormatters: inputRegExp != null
            ? [FilteringTextInputFormatter.allow(inputRegExp)]
            : null,
        keyboardType: inputValueTypeToKeyboardTypeMap[widget.valueType],
        onChanged: (newValue) {
          int currentCursorPos = _controller.selection.baseOffset;
          widget.onChanged?.call(newValue);
          setState(() {
            _cursorPosition = currentCursorPos;
          });
        },
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(widget.borderRadius)),
            borderSide: BorderSide(
              color: borderColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(widget.borderRadius)),
            borderSide: BorderSide(
              color: borderColor,
            ),
          ),
          label: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width / 2,
            ),
            child: Text(
              widget.label,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.fade,
              style: TextStyle(
                fontSize: 15,
                foreground: Paint()..color = borderColor,
              ),
            ),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            foreground: Paint()..color = hintColor,
          ),
          contentPadding: widget.contentPadding,
          counterText: "",
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          suffixIconColor: foregroundColor,
          suffixText: widget.textLengthCounterVisible
              ? '${_controller.text.length}/${widget.maxTextLength}'
              : null,
          filled: true,
          fillColor: widget.colors.background.regular,
        ),
        style: TextStyle(
          foreground: Paint()..color = foregroundColor,
          fontSize: widget.fontSize,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }

  @override
  void dispose() {
    _defaultController?.dispose();
    _focusNode.removeListener(_focusListener);
    _defaultFocusNode?.dispose();
    super.dispose();
  }
}
