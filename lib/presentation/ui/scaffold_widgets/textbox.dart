import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/keyboard/keyboard_wrappers.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/keyboard/model/keyboard_models.dart';
import 'package:convertouch/presentation/ui/style/color/color_set.dart';
import 'package:convertouch/presentation/ui/style/color/color_state_variation.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConvertouchTextBox extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueNotifier<String?>? notifier;
  final bool useCustomKeyboard;
  final KeyboardType customKeyboardType;
  final RegExp? customInputFormatter;
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
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? textInputType;
  final ConvertouchUITheme theme;
  final ColorStateVariation<TextBoxColorSet>? customColor;

  const ConvertouchTextBox({
    required this.controller,
    this.focusNode,
    this.notifier,
    this.useCustomKeyboard = false,
    this.customKeyboardType = KeyboardType.numeric,
    this.customInputFormatter,
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
    this.inputFormatters,
    this.textInputType,
    required this.theme,
    this.customColor,
    super.key,
  });

  @override
  State createState() => _ConvertouchTextBoxState();
}

class _ConvertouchTextBoxState extends State<ConvertouchTextBox> {
  late final ColorStateVariation<TextBoxColorSet> _color;
  late final FocusNode _focusNode;

  FocusNode? _defaultFocusNode;
  ValueNotifier<String?>? _notifier;
  ValueNotifier<String?>? _defaultNotifier;

  @override
  void initState() {
    _color = widget.customColor ?? textBoxColors[widget.theme]!;

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
    if (_focusNode.hasFocus) {
      widget.onFocusSelected?.call();
    } else {
      widget.onFocusLeft?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (widget.useCustomKeyboard) {
            return Container(
              padding: const EdgeInsetsDirectional.fromSTEB(7, 5, 7, 0),
              child: KeyboardActionsWrapper(
                keyboardType: widget.customKeyboardType,
                inputFormatter: widget.customInputFormatter,
                controller: widget.controller,
                focusNode: _focusNode,
                notifier: _notifier!,
                child: _textBox(
                  needToSetFocusNode: false,
                  textInputType: TextInputType.none,
                ),
              ),
            );
          } else {
            return _textBox(
              textInputType: widget.textInputType,
              onChanged: widget.onChanged,
            );
          }
        },
      ),
    );
  }

  Widget _textBox({
    bool needToSetFocusNode = true,
    TextInputType? textInputType,
    void Function(String)? onChanged,
  }) {
    return TextField(
      readOnly: widget.disabled,
      maxLength: widget.maxTextLength,
      obscureText: false,
      keyboardType: textInputType,
      autofocus: widget.autofocus,
      focusNode: needToSetFocusNode ? _focusNode : null,
      controller: widget.controller
        ..selection = TextSelection.collapsed(
          offset: widget.controller.text.length,
        ),
      inputFormatters: widget.inputFormatters,
      onChanged: onChanged,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
          borderSide: BorderSide(
            color: _color.regular.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
          borderSide: BorderSide(
            color: _color.focused?.border ?? noColor,
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
          color: _focusNode.hasFocus
              ? _color.focused?.label
              : _color.regular.label,
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: _color.regular.hint,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 15.0,
        ),
        counterText: "",
        suffixText: widget.textLengthCounterVisible
            ? '${widget.controller.text.length}/${widget.maxTextLength}'
            : null,
      ),
      style: TextStyle(
        color: _focusNode.hasFocus
            ? _color.focused?.foreground
            : _color.regular.foreground,
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.start,
    );
  }

  @override
  void dispose() {
    _focusNode.removeListener(_focusListener);
    _defaultFocusNode?.dispose();
    _notifier?.removeListener(_customKeyboardValueChangeListener);
    _notifier?.dispose();
    super.dispose();
  }
}
