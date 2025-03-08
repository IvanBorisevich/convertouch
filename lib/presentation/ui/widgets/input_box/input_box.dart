import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/list_box.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/text_box.dart';
import 'package:flutter/material.dart';

class ConvertouchInputBox extends StatefulWidget {
  final ValueModel? value;
  final TextEditingController? textController;
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

  ConvertouchInputBox.text({
    this.value,
    this.textController,
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
    this.height = ConvertouchTextBox.defaultHeight,
    this.fontSize = 17,
    super.key,
  }) : assert(
          !valueType.isList,
          'Value type in text box cannot be list',
        );

  const ConvertouchInputBox.list({
    ValueModel? listValue,
    this.focusNode,
    required this.valueType,
    this.label = "",
    this.autofocus = false,
    this.readonly = false,
    this.onChanged,
    this.onFocusSelected,
    this.onFocusLeft,
    this.borderRadius = 15,
    required this.colors,
    this.prefixIcon,
    this.suffixIcon,
    this.contentPadding = const EdgeInsets.all(17),
    this.height = ConvertouchListBox.defaultHeight,
    this.fontSize = 17,
    super.key,
  })  : value = listValue,
        textController = null,
        hintText = null,
        maxTextLength = null,
        textLengthCounterVisible = false;

  @override
  State<ConvertouchInputBox> createState() => _ConvertouchInputBoxState();
}

class _ConvertouchInputBoxState extends State<ConvertouchInputBox> {
  @override
  Widget build(BuildContext context) {
    if (widget.valueType.isList) {
      return ConvertouchListBox(
        value: widget.value,
        focusNode: widget.focusNode,
        valueType: widget.valueType,
        label: widget.label,
        autofocus: widget.autofocus,
        readonly: widget.readonly,
        onChanged: widget.onChanged,
        onFocusSelected: widget.onFocusSelected,
        onFocusLeft: widget.onFocusLeft,
        borderRadius: widget.borderRadius,
        colors: widget.colors,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        contentPadding: widget.contentPadding,
        height: widget.height,
        fontSize: widget.fontSize,
      );
    }

    return ConvertouchTextBox(
      text: widget.value?.raw,
      controller: widget.textController,
      focusNode: widget.focusNode,
      valueType: widget.valueType,
      label: widget.label,
      autofocus: widget.autofocus,
      readonly: widget.readonly,
      onChanged: widget.onChanged,
      onFocusSelected: widget.onFocusSelected,
      onFocusLeft: widget.onFocusLeft,
      maxTextLength: widget.maxTextLength,
      textLengthCounterVisible: widget.textLengthCounterVisible,
      hintText: widget.hintText,
      borderRadius: widget.borderRadius,
      colors: widget.colors,
      prefixIcon: widget.prefixIcon,
      suffixIcon: widget.suffixIcon,
      contentPadding: widget.contentPadding,
      height: widget.height,
      fontSize: widget.fontSize,
    );
  }
}
