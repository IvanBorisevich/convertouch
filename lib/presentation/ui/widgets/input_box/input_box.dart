import 'package:convertouch/presentation/bloc/common/input_validation/input_validation_bloc.dart';
import 'package:convertouch/presentation/ui/constants/input_box_constants.dart';
import 'package:convertouch/presentation/ui/model/input_box_model.dart';
import 'package:convertouch/presentation/ui/model/list_box_model.dart';
import 'package:convertouch/presentation/ui/model/text_box_model.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/list_box.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/text_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_tooltip/super_tooltip.dart';

class ConvertouchInputBox<M extends InputBoxModel> extends StatefulWidget {
  final M model;
  final FocusNode? focusNode;
  final bool autofocus;
  final TooltipDirection tooltipDirection;
  final void Function(dynamic)? onValueChanged;
  final void Function(dynamic)? onValueFocused;
  final void Function(dynamic)? onValueUnfocused;
  final void Function()? onValueCleaned;
  final BorderRadius borderRadius;
  final double borderWidth;
  final InputBoxColorScheme colors;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final List<Widget?> prefixWidgets;
  final List<Widget?> suffixWidgets;
  final EdgeInsets contentPadding;
  final EdgeInsets? labelPadding;
  final double fontSize;
  final double? letterSpacing;

  const ConvertouchInputBox({
    required this.model,
    this.focusNode,
    this.autofocus = false,
    this.tooltipDirection = TooltipDirection.down,
    this.onValueChanged,
    this.onValueFocused,
    this.onValueUnfocused,
    this.onValueCleaned,
    this.borderRadius = InputBoxConstants.defaultBorderRadius,
    this.borderWidth = 1,
    required this.colors,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixWidgets = const [],
    this.suffixWidgets = const [],
    this.contentPadding = InputBoxConstants.defaultContentPadding,
    this.labelPadding,
    this.fontSize = InputBoxConstants.defaultFontSize,
    this.letterSpacing,
    super.key,
  });

  @override
  State<ConvertouchInputBox<M>> createState() => _ConvertouchInputBoxState<M>();
}

class _ConvertouchInputBoxState<M extends InputBoxModel>
    extends State<ConvertouchInputBox<M>> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.colors.textBox.background.regular,
        borderRadius: widget.borderRadius,
        border: Border.all(
          color: _isFocused
              ? widget.colors.textBox.border.focused
              : widget.colors.textBox.border.regular,
          width: widget.borderWidth,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            ...widget.prefixWidgets.map(
              (widget) => widget != null
                  ? Row(
                      children: [
                        widget,
                        _verticalDivider(),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
            Expanded(
              child: _inputField(context),
            ),
            ...widget.suffixWidgets.map(
              (widget) => widget != null
                  ? Row(
                      children: [
                        _verticalDivider(),
                        widget,
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(BuildContext context) {
    bool prefixIconsExist =
        widget.prefixWidgets.nonNulls.isNotEmpty || widget.prefixIcon != null;
    bool suffixIconsExist =
        widget.suffixWidgets.nonNulls.isNotEmpty || widget.suffixIcon != null;

    EdgeInsetsGeometry contentPadding = EdgeInsets.only(
      top: widget.contentPadding.top,
      bottom: widget.contentPadding.bottom,
      left: prefixIconsExist ? 10 : 17,
      right: suffixIconsExist ? 10 : 17,
    );

    if (widget.model is TextBoxModel) {
      return ConvertouchTextBox(
        model: widget.model as TextBoxModel,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        tooltipDirection: widget.tooltipDirection,
        onValueChanged: widget.onValueChanged,
        onValueFocused: (value) {
          widget.onValueFocused?.call(value);
          setState(() {
            _isFocused = true;
          });
        },
        onValueUnfocused: (value) {
          widget.onValueUnfocused?.call(value);
          setState(() {
            _isFocused = false;
          });
        },
        onValueCleaned: widget.onValueCleaned,
        borderRadius: widget.borderRadius,
        borderWidth: 0,
        colors: widget.colors,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        contentPadding: contentPadding,
        labelPadding: widget.labelPadding,
        fontSize: widget.fontSize,
        letterSpacing: widget.letterSpacing,
        standalone: false,
        validationBloc: BlocProvider.of<InputValidationBloc>(context),
      );
    }

    if (widget.model is ListBoxModel) {
      return ConvertouchListBox(
        model: widget.model as ListBoxModel,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        onValueChanged: widget.onValueChanged,
        borderRadius: widget.borderRadius,
        borderWidth: widget.borderWidth,
        colors: widget.colors,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        fontSize: widget.fontSize,
        contentPadding: contentPadding,
        labelPadding: widget.labelPadding,
      );
    }

    throw Exception(
        "Cannot create input box by model of type ${widget.model.runtimeType}");
  }

  Widget _verticalDivider() {
    return VerticalDivider(
      color: _isFocused
          ? widget.colors.divider.focused
          : widget.colors.divider.regular,
      indent: 10,
      endIndent: 10,
      width: 2,
      thickness: 2,
    );
  }
}
