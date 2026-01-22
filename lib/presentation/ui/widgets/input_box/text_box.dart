import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_states.dart';
import 'package:convertouch/presentation/ui/constants/input_box_constants.dart';
import 'package:convertouch/presentation/ui/model/text_box_model.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/mixin/focus_node_mixin.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/mixin/text_controller_mixin.dart';
import 'package:convertouch/presentation/ui/widgets/tooltip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_tooltip/super_tooltip.dart';

class ConvertouchTextBox extends StatefulWidget {
  final TextBoxModel model;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool Function(String?)? isValueValid;
  final void Function(String?)? onValueChanged;
  final void Function()? onValueCleaned;
  final void Function()? onFocusSelected;
  final void Function()? onFocusLeft;
  final TooltipDirection tooltipDirection;
  final double borderRadius;
  final InputBoxColorScheme colors;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry contentPadding;
  final EdgeInsetsGeometry? labelPadding;
  final double height;
  final double fontSize;
  final double? letterSpacing;

  const ConvertouchTextBox({
    required this.model,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.isValueValid,
    this.tooltipDirection = TooltipDirection.down,
    this.onValueChanged,
    this.onValueCleaned,
    this.onFocusSelected,
    this.onFocusLeft,
    this.borderRadius = InputBoxConstants.defaultBorderRadius,
    required this.colors,
    this.prefixIcon,
    this.suffixIcon,
    this.contentPadding = InputBoxConstants.defaultContentPadding,
    this.labelPadding,
    this.height = InputBoxConstants.defaultHeight,
    this.fontSize = InputBoxConstants.defaultFontSize,
    this.letterSpacing,
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
  late final SuperTooltipController _tooltipController;

  @override
  void initState() {
    _tooltipController = SuperTooltipController();

    _controller = initOrGetController(
      widget.controller,
      initialValue: widget.model.focusedText,
    );

    _focusNode = initOrGetFocusNode(widget.focusNode);

    if (!widget.model.readonly) {
      _focusListener = addFocusListener(
        focusNode: _focusNode,
        onFocusSelected: () async {
          widget.onFocusSelected?.call();
          await _isValid(_controller.text);
        },
        onFocusLeft: () async {
          widget.onFocusLeft?.call();
          await _tooltipController.hideTooltip();
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
      focusListener: _focusListener,
    );
    _tooltipController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ConvertouchTextBox oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.model.value != oldWidget.model.value && _focusNode.hasFocus) {
      updateTextControllerValue(_controller, widget.model.focusedText);
    }

    if (widget.model.unfocusedValue != oldWidget.model.unfocusedValue &&
        !_focusNode.hasFocus) {
      updateTextControllerValue(_controller, widget.model.unfocusedText);
    }
  }

  Future<bool> _isValid(String newValue) async {
    bool isValid = widget.isValueValid?.call(newValue) ?? true;
    if (!isValid) {
      await _tooltipController.showTooltip();
    } else if (_tooltipController.isVisible) {
      await _tooltipController.hideTooltip();
    }

    return isValid;
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

    return BlocListener<NavigationBloc, NavigationState>(
      listener: (_, navigationState) {
        if (_tooltipController.isVisible) {
          FocusScope.of(context).unfocus();
        }
      },
      child: ConvertouchTooltip(
        text: widget.model.invalidValueMessage,
        controller: _tooltipController,
        tooltipDirection: widget.tooltipDirection,
        colors: widget.colors.tooltip,
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
            onChanged: (newValue) async {
              if (await _isValid(newValue)) {
                widget.onValueChanged?.call(newValue);
              }
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
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
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
              contentPadding: widget.contentPadding,
              counterText: "",
              prefixIcon: widget.prefixIcon,
              suffixIcon: _suffixIcon(),
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
      ),
    );
  }

  Widget? _suffixIcon() {
    if (widget.suffixIcon != null) {
      return widget.suffixIcon;
    }

    if (_controller.text.isNotEmpty && _focusNode.hasFocus) {
      return IconButton(
        icon: Icon(
          Icons.close_rounded,
          color: widget.colors.foreground.regular,
          size: 17,
        ),
        onPressed: () async {
          _controller.clear();
          widget.onValueCleaned?.call();
          await _tooltipController.hideTooltip();
        },
      );
    }

    return null;
  }
}
