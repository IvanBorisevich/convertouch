import 'package:convertouch/presentation/bloc/common/input_validation/input_validation_bloc.dart';
import 'package:convertouch/presentation/ui/constants/input_box_constants.dart';
import 'package:convertouch/presentation/ui/model/input_box_model.dart';
import 'package:convertouch/presentation/ui/model/list_box_model.dart';
import 'package:convertouch/presentation/ui/model/text_box_model.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/list_box.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/text_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_tooltip/super_tooltip.dart';

class ConvertouchInputBox<M extends InputBoxModel> extends StatelessWidget {
  final M model;
  final FocusNode? focusNode;
  final bool autofocus;
  final TooltipDirection tooltipDirection;
  final void Function(dynamic)? onValueChanged;
  final void Function(dynamic)? onFocusSelected;
  final void Function(dynamic)? onFocusLeft;
  final double borderRadius;
  final InputBoxColorScheme colors;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry contentPadding;
  final EdgeInsetsGeometry? labelPadding;
  final double height;
  final double fontSize;
  final double? letterSpacing;

  const ConvertouchInputBox({
    required this.model,
    this.focusNode,
    this.autofocus = false,
    required this.tooltipDirection,
    this.onValueChanged,
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
  Widget build(BuildContext context) {
    if (model is TextBoxModel) {
      return ConvertouchTextBox(
        model: model as TextBoxModel,
        focusNode: focusNode,
        autofocus: autofocus,
        tooltipDirection: tooltipDirection,
        onValueChanged: onValueChanged,
        onValueFocused: onFocusSelected,
        onValueUnfocused: onFocusLeft,
        borderRadius: borderRadius,
        colors: colors,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: contentPadding,
        labelPadding: labelPadding,
        height: height,
        fontSize: fontSize,
        letterSpacing: letterSpacing,
        validationBloc: BlocProvider.of<InputValidationBloc>(context),
      );
    }

    if (model is ListBoxModel) {
      return ConvertouchListBox(
        model: model as ListBoxModel,
        focusNode: focusNode,
        autofocus: autofocus,
        onValueChanged: onValueChanged,
        borderRadius: borderRadius,
        colors: colors,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: contentPadding,
        height: height,
        fontSize: fontSize,
        labelPadding: labelPadding,
      );
    }

    throw Exception(
        "Cannot create input box by model of type ${model.runtimeType}");
  }
}
