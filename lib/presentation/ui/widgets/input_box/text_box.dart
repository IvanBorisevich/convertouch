import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/common/input_validation/input_validation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/input_validation/input_validation_events.dart';
import 'package:convertouch/presentation/ui/constants/input_box_constants.dart';
import 'package:convertouch/presentation/ui/model/text_box_model.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
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
  final InputBoxColorScheme colors;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry contentPadding;
  final EdgeInsetsGeometry? labelPadding;
  final double fontSize;
  final double? letterSpacing;
  final bool resetValidationOnNavigate;
  final InputValidationBloc? validationBloc;

  const ConvertouchTextBox({
    this.model = TextBoxModel.empty,
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
    this.suffixIcon,
    this.contentPadding = InputBoxConstants.defaultContentPadding,
    this.labelPadding,
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
  static const double textHeightCoefficient = 1.2;

  final ValueNotifier<bool> _closeIconVisibilityNotifier =
      ValueNotifier<bool>(false);

  late final FocusNode _focusNode;
  late final TextEditingController _controller;

  void Function()? _focusListener;
  void Function()? _textValueListener;

  late String _hint;

  @override
  void initState() {
    _hint = widget.model.hintUnfocused;

    _controller = initOrGetController(
      widget.controller,
      initialValue:
          widget.autofocus ? widget.model.value : widget.model.valueUnfocused,
    );

    _focusNode = initOrGetFocusNode(widget.focusNode);

    if (!widget.model.readonly) {
      _focusListener = addFocusListener(
        focusNode: _focusNode,
        onFocusSelected: () {
          widget.onValueFocused?.call(_controller.text);
          _closeIconVisibilityNotifier.value = _controller.text.isNotEmpty;
          updateTextControllerValue(_controller, widget.model.value);
          setState(() {
            _hint = widget.model.hint;
          });
        },
        onFocusLeft: () {
          widget.onValueUnfocused?.call(_controller.text);
          widget.validationBloc?.add(const ResetValidation());
          _closeIconVisibilityNotifier.value = false;
          updateTextControllerValue(_controller, widget.model.valueUnfocused);
          setState(() {
            _hint = widget.model.hintUnfocused;
          });
        },
      );

      _textValueListener = addTextValueListener(
        controller: _controller,
        onValueChange: (value) {
          _closeIconVisibilityNotifier.value =
              _focusNode.hasFocus && value != null && value.isNotEmpty;
        },
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      disposeTextController(
        controller: _controller,
        listener: _textValueListener,
      );
    }

    if (widget.focusNode == null) {
      disposeFocusNode(
        focusNode: _focusNode,
        listener: _focusListener,
      );
    }

    _closeIconVisibilityNotifier.dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(ConvertouchTextBox oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_focusNode.hasFocus && widget.model.value != oldWidget.model.value) {
      updateTextControllerValue(_controller, widget.model.value);
    } else if (!_focusNode.hasFocus &&
        widget.model.valueUnfocused != oldWidget.model.valueUnfocused) {
      updateTextControllerValue(_controller, widget.model.valueUnfocused);
    }
  }

  @override
  Widget build(BuildContext context) {
    RegExp? inputRegExp = inputValueTypeToRegExpMap[widget.model.valueType];

    Color foregroundColor;
    Color hintColor;
    Color labelColor;

    if (widget.model.readonly) {
      foregroundColor = widget.colors.textBox.foreground.disabled;
      hintColor = widget.colors.textBox.hint.disabled;
      labelColor = widget.colors.textBox.label.disabled;
    } else if (_focusNode.hasFocus) {
      foregroundColor = widget.colors.textBox.foreground.focused;
      hintColor = widget.colors.textBox.hint.focused;
      labelColor = widget.colors.textBox.label.focused;
    } else {
      foregroundColor = widget.colors.textBox.foreground.regular;
      hintColor = widget.colors.textBox.hint.regular;
      labelColor = widget.colors.textBox.label.regular;
    }

    return InputValidationWrapper(
      focusNode: _focusNode,
      tooltipBackgroundColor: widget.colors.textBox.tooltip.background.regular,
      tooltipForegroundColor: widget.colors.textBox.tooltip.foreground.warning,
      tooltipDirection: widget.tooltipDirection,
      resetValidationOnNavigate: widget.resetValidationOnNavigate,
      child: GestureDetector(
        onTap: () {
          _focusNode.requestFocus();
        },
        child: Container(
          padding: widget.contentPadding,
          alignment: Alignment.center,
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
                inputValueTypeToKeyboardTypeMap[widget.model.valueType],
            onChanged: widget.onValueChanged,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: widget.borderRadius,
                borderSide: BorderSide.none,
              ),
              label: Container(
                padding: widget.labelPadding,
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
                    fontWeight: FontWeight.w600,
                    foreground: Paint()..color = labelColor,
                  ),
                ),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              alignLabelWithHint: true,
              hintText: _hint,
              hintStyle: TextStyle(
                foreground: Paint()..color = hintColor,
              ),
              isDense: true,
              counterText: "",
              contentPadding: const EdgeInsets.symmetric(vertical: 7),
              prefixIcon: widget.prefixIcon,
              prefixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
              suffixIcon: widget.suffixIcon ?? _suffixCloseIcon(),
              suffixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
              suffixIconColor: foregroundColor,
              suffixText: widget.model.textLengthCounterVisible
                  ? '${_controller.text.length}/${widget.model.maxTextLength}'
                  : null,
              filled: true,
              fillColor: widget.colors.textBox.background.regular,
              constraints: BoxConstraints(
                maxHeight: widget.fontSize * textHeightCoefficient +
                    widget.contentPadding.vertical,
              ),
            ),
            style: TextStyle(
              foreground: Paint()..color = foregroundColor,
              fontSize: widget.fontSize,
              fontWeight: FontWeight.w500,
              fontFamily: quicksandFontFamily,
              letterSpacing: widget.letterSpacing,
              height: textHeightCoefficient,
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ),
    );
  }

  Widget? _suffixCloseIcon() {
    return ValueListenableBuilder(
      valueListenable: _closeIconVisibilityNotifier,
      builder: (_, visible, child) {
        if (!visible) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          width: 26,
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.close_rounded,
              color: widget.colors.textBox.foreground.regular,
              size: 17,
            ),
            onPressed: () {
              _controller.clear();
              widget.onValueCleaned?.call();
              widget.onValueChanged?.call(null);
              _closeIconVisibilityNotifier.value = false;
            },
          ),
        );
      },
    );
  }
}
