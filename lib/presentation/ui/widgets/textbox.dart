import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/widgets/keyboard/keyboard_wrappers.dart';
import 'package:convertouch/presentation/ui/widgets/keyboard/model/keyboard_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConvertouchTextBox extends StatefulWidget {
  final TextEditingController? controller;
  final String? text;
  final FocusNode? focusNode;
  final ValueNotifier<String?>? notifier;
  final ConvertouchValueType inputType;
  final bool useCustomKeyboard;
  final double height;
  final String label;
  final bool autofocus;
  final bool disabled;
  final void Function(String)? onChanged;
  final void Function()? onFocusSelected;
  final void Function()? onFocusLeft;
  final int? maxTextLength;
  final bool textLengthCounterVisible;
  final String? hintText;
  final double borderRadius;
  final ConvertouchUITheme theme;
  final TextBoxColorScheme? customColor;

  const ConvertouchTextBox({
    this.controller,
    this.text,
    this.focusNode,
    this.notifier,
    this.useCustomKeyboard = false,
    this.inputType = ConvertouchValueType.text,
    this.height = 70,
    this.label = "",
    this.autofocus = false,
    this.disabled = false,
    this.onChanged,
    this.onFocusSelected,
    this.onFocusLeft,
    this.maxTextLength,
    this.textLengthCounterVisible = false,
    this.hintText,
    this.borderRadius = 8,
    required this.theme,
    this.customColor,
    super.key,
  });

  @override
  State createState() => _ConvertouchTextBoxState();
}

class _ConvertouchTextBoxState extends State<ConvertouchTextBox> {
  late TextBoxColorScheme _color;
  int? _cursorPosition;

  late final FocusNode _focusNode;
  late final TextEditingController _controller;

  TextEditingController? _defaultController;
  FocusNode? _defaultFocusNode;
  ValueNotifier<String?>? _notifier;
  ValueNotifier<String?>? _defaultNotifier;

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

    if (widget.useCustomKeyboard) {
      if (widget.notifier != null) {
        _notifier = widget.notifier!;
      } else {
        _defaultNotifier = ValueNotifier<String?>(null);
        _notifier = _defaultNotifier!;
      }

      _notifier!.addListener(_customKeyboardValueChangeListener);
    }

    super.initState();
  }

  void _customKeyboardValueChangeListener() {
    if (_notifier!.value != null) {
      widget.onChanged?.call(_notifier!.value!);
    }
  }

  void _focusListener() {
    if (widget.disabled) {
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
    _controller.selection = TextSelection.collapsed(
      offset: _cursorPosition ?? _controller.text.length,
    );

    _color = widget.customColor ?? unitTextBoxColors[widget.theme]!;

    Color borderColor;
    Color foregroundColor;
    Color hintColor;

    if (widget.disabled) {
      borderColor = _color.border.disabled;
      foregroundColor = _color.foreground.disabled;
      hintColor = _color.hint.disabled;
    } else if (_focusNode.hasFocus) {
      borderColor = _color.border.focused;
      foregroundColor = _color.foreground.focused;
      hintColor = _color.hint.focused;
    } else {
      borderColor = _color.border.regular;
      foregroundColor = _color.foreground.regular;
      hintColor = _color.hint.regular;
    }

    return SizedBox(
      height: widget.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (widget.useCustomKeyboard) {
            return Container(
              padding: const EdgeInsetsDirectional.fromSTEB(7, 5, 7, 0),
              child: KeyboardActionsWrapper(
                inputType: widget.inputType,
                controller: _controller,
                focusNode: _focusNode,
                notifier: _notifier!,
                child: _textBox(
                  needToSetFocusNode: false,
                  inputType: widget.inputType,
                  borderColor: borderColor,
                  foregroundColor: foregroundColor,
                  hintColor: hintColor,
                ),
              ),
            );
          } else {
            return _textBox(
              inputType: widget.inputType,
              onChanged: widget.onChanged,
              borderColor: borderColor,
              foregroundColor: foregroundColor,
              hintColor: hintColor,
            );
          }
        },
      ),
    );
  }

  Widget _textBox({
    bool needToSetFocusNode = true,
    required ConvertouchValueType inputType,
    required Color borderColor,
    required Color foregroundColor,
    required Color hintColor,
    void Function(String)? onChanged,
  }) {
    RegExp? inputRegExp = inputValueTypeToRegExpMap[inputType];

    return TextField(
      readOnly: widget.disabled,
      maxLength: widget.maxTextLength,
      obscureText: false,
      keyboardType: inputValueTypeToKeyboardTypeMap[inputType],
      autofocus: widget.autofocus,
      focusNode: needToSetFocusNode ? _focusNode : null,
      controller: _controller,
      inputFormatters: inputRegExp != null
          ? [FilteringTextInputFormatter.allow(inputRegExp)]
          : null,
      onChanged: (newValue) {
        int currentCursorPos = _controller.selection.baseOffset;
        onChanged?.call(newValue);
        setState(() {
          _cursorPosition = currentCursorPos;
        });
      },
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
          borderSide: BorderSide(
            color: borderColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
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
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: TextStyle(
          color: borderColor,
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: hintColor,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 15.0,
        ),
        counterText: "",
        suffixText: widget.textLengthCounterVisible
            ? '${_controller.text.length}/${widget.maxTextLength}'
            : null,
      ),
      style: TextStyle(
        color: foregroundColor,
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.start,
    );
  }

  @override
  void dispose() {
    _defaultController?.dispose();
    _focusNode.removeListener(_focusListener);
    _defaultFocusNode?.dispose();
    _notifier?.removeListener(_customKeyboardValueChangeListener);
    _notifier?.dispose();
    super.dispose();
  }
}
