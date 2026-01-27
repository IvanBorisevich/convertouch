import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/common/input_validation/input_validation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/input_validation/input_validation_events.dart';
import 'package:convertouch/presentation/ui/constants/input_box_constants.dart';
import 'package:convertouch/presentation/ui/model/text_box_model.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/mixin/focus_node_mixin.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/mixin/text_controller_mixin.dart';
import 'package:convertouch/presentation/ui/widgets/input_validation_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:super_tooltip/super_tooltip.dart';

class ConvertouchTextBox extends StatefulWidget {
  final TextBoxModel model;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final void Function(String?)? onValueChanged;
  final void Function(String?)? onValueFocused;
  final void Function(String?)? onValueUnfocused;
  final void Function()? onValueCleaned;
  final TooltipDirection tooltipDirection;
  final BorderRadius borderRadius;
  final double borderWidth;
  final double contentPaddingLeft;
  final double contentPaddingRight;
  final InputBoxColorScheme colors;
  final Widget? prefixIcon;
  final double prefixIconPaddingLeft;
  final double prefixIconPaddingRight;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? labelPadding;
  final double height;
  final double fontSize;
  final double? letterSpacing;
  final bool resetValidationOnNavigate;
  final InputValidationBloc? validationBloc;

  const ConvertouchTextBox({
    required this.model,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.tooltipDirection = TooltipDirection.down,
    this.onValueChanged,
    this.onValueCleaned,
    this.onValueFocused,
    this.onValueUnfocused,
    this.borderRadius = InputBoxConstants.defaultBorderRadius,
    this.borderWidth = 1,
    required this.colors,
    this.prefixIcon,
    this.prefixIconPaddingLeft = InputBoxConstants.defaultPrefixIconPaddingLeft,
    this.prefixIconPaddingRight =
        InputBoxConstants.defaultPrefixIconPaddingRight,
    this.suffixIcon,
    this.contentPaddingLeft = InputBoxConstants.defaultContentPaddingLeft,
    this.contentPaddingRight = InputBoxConstants.defaultContentPaddingRight,
    this.labelPadding,
    this.height = InputBoxConstants.defaultHeight,
    this.fontSize = InputBoxConstants.defaultFontSize,
    this.letterSpacing,
    this.resetValidationOnNavigate = true,
    this.validationBloc,
    super.key,
  });

  @override
  State createState() => _ConvertouchTextBoxState();
}

class _ConvertouchTextBoxState extends State<ConvertouchTextBox>
    with FocusNodeMixin, TextControllerMixin {
  late final FocusNode _focusNode;
  void Function()? _focusListener;

  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = initOrGetController(
      widget.controller,
      initialValue: widget.model.focusedText,
    );

    _focusNode = initOrGetFocusNode(widget.focusNode);

    if (!widget.model.readonly) {
      _focusListener = addFocusListener(
        focusNode: _focusNode,
        onFocusSelected: () {
          setState(() {});
          widget.onValueFocused?.call(_controller.text);
        },
        onFocusLeft: () {
          setState(() {});
          widget.onValueUnfocused?.call(_controller.text);
          widget.validationBloc?.add(const ResetValidation());
        },
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    disposeFocusNode(
      focusNode: _focusNode,
      listener: _focusListener,
    );

    super.dispose();
  }

  @override
  void didUpdateWidget(ConvertouchTextBox oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.model.value != oldWidget.model.value) {
      updateTextControllerValue(_controller, widget.model.focusedText);
    }
  }

  @override
  Widget build(BuildContext context) {
    RegExp? inputRegExp = inputValueTypeToRegExpMap[widget.model.initialType];

    Color borderColor;
    Color foregroundColor;
    Color hintColor;

    if (widget.model.readonly) {
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

    return InputValidationWrapper(
      focusNode: _focusNode,
      tooltipBackgroundColor: widget.colors.tooltip.background.regular,
      tooltipForegroundColor: widget.colors.tooltip.foregroundWarning.regular,
      tooltipDirection: widget.tooltipDirection,
      resetValidationOnNavigate: widget.resetValidationOnNavigate,
      child: SizedBox(
        height: widget.height,
        child: TextField(
          readOnly: widget.model.readonly,
          maxLength: widget.model.maxTextLength,
          textAlignVertical: TextAlignVertical.center,
          obscureText: false,
          autofocus: widget.autofocus,
          focusNode: _focusNode,
          controller: _controller,
          inputFormatters: inputRegExp != null
              ? [FilteringTextInputFormatter.allow(inputRegExp)]
              : null,
          keyboardType:
              inputValueTypeToKeyboardTypeMap[widget.model.initialType],
          onChanged: widget.onValueChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: widget.borderRadius,
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: widget.borderRadius,
              borderSide: widget.borderWidth > 0
                  ? BorderSide(
                      color: borderColor,
                      width: widget.borderWidth,
                    )
                  : BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: widget.borderRadius,
              borderSide: widget.borderWidth > 0
                  ? BorderSide(
                      color: borderColor,
                      width: widget.borderWidth,
                    )
                  : BorderSide.none,
            ),
            label: Container(
              padding: widget.labelPadding,
              decoration: BoxDecoration(
                color: widget.colors.background.regular,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 2,
              ),
              child: Text(
                widget.model.labelText,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.fade,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  foreground: Paint()..color = borderColor,
                ),
              ),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: _focusNode.hasFocus
                ? widget.model.hint
                : widget.model.unfocusedHint,
            hintStyle: TextStyle(
              foreground: Paint()..color = hintColor,
            ),
            contentPadding: EdgeInsets.only(
              top: widget.height / 2,
              left: widget.contentPaddingLeft,
              right: widget.contentPaddingRight,
            ),
            isDense: true,
            counterText: "",
            prefixIcon: _iconPaddingWrapper(
              icon: widget.prefixIcon,
              paddingLeft: widget.prefixIconPaddingLeft,
              paddingRight: widget.prefixIconPaddingRight,
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            suffixIcon: _iconPaddingWrapper(
              icon: widget.suffixIcon ?? _suffixCloseIcon(),
              paddingLeft: 0,
              paddingRight: 0,
            ),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            suffixIconColor: foregroundColor,
            suffixText: widget.model.textLengthCounterVisible
                ? '${_controller.text.length}/${widget.model.maxTextLength}'
                : null,
            filled: true,
            fillColor: widget.colors.background.regular,
          ),
          style: TextStyle(
            foreground: Paint()..color = foregroundColor,
            fontSize: widget.fontSize,
            fontWeight: FontWeight.w500,
            fontFamily: quicksandFontFamily,
            letterSpacing: widget.letterSpacing,
          ),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }

  Widget? _suffixCloseIcon() {
    if (_controller.text.isNotEmpty && _focusNode.hasFocus) {
      return SizedBox(
        width: 26,
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(
            Icons.close_rounded,
            color: widget.colors.foreground.regular,
            size: 17,
          ),
          onPressed: () {
            _controller.clear();
            widget.onValueCleaned?.call();
            widget.onValueChanged?.call(null);
          },
        ),
      );
    }

    return null;
  }

  Widget? _iconPaddingWrapper({
    required Widget? icon,
    required double paddingLeft,
    required double paddingRight,
  }) {
    if (icon == null) {
      return null;
    }
    return Padding(
      padding: EdgeInsets.only(
        left: paddingLeft,
        right: paddingRight,
      ),
      child: icon,
    );
  }
}
