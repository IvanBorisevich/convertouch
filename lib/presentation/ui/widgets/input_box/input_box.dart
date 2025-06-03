import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/bloc/common/items_list/dropdown_bloc.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/list_box.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/text_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchInputBox extends StatefulWidget {
  final String? value;
  final String? defaultValue;
  final List<ListValueModel> listValues;
  final ListValueModel? selectedListValue;
  final UnitModel? itemUnit;
  final FocusNode? focusNode;
  final ConvertouchValueType valueType;
  final ConvertouchListType? listType;
  final String label;
  final bool autofocus;
  final bool readonly;
  final void Function(String?)? onChanged;
  final void Function()? onClean;
  final void Function()? onFocusSelected;
  final void Function()? onFocusLeft;
  final int? maxTextLength;
  final bool textLengthCounterVisible;
  final double borderRadius;
  final InputBoxColorScheme colors;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry contentPadding;
  final EdgeInsetsGeometry? labelPadding;
  final double height;
  final double fontSize;

  const ConvertouchInputBox({
    this.value,
    this.defaultValue,
    this.itemUnit,
    this.focusNode,
    this.valueType = ConvertouchValueType.text,
    this.listType,
    this.label = "",
    this.autofocus = false,
    this.readonly = false,
    this.onChanged,
    this.onClean,
    this.onFocusSelected,
    this.onFocusLeft,
    this.maxTextLength,
    this.textLengthCounterVisible = false,
    this.borderRadius = 15,
    required this.colors,
    this.prefixIcon,
    this.suffixIcon,
    this.contentPadding = const EdgeInsets.all(17),
    this.labelPadding,
    this.height = ConvertouchTextBox.defaultHeight,
    this.fontSize = 17,
    super.key,
  })  : listValues = const [],
        selectedListValue = null;

  @override
  State<ConvertouchInputBox> createState() => _ConvertouchInputBoxState();
}

class _ConvertouchInputBoxState extends State<ConvertouchInputBox> {
  @override
  Widget build(BuildContext context) {
    if (widget.listType != null) {
      return BlocProvider(
        create: (_) => DropdownBloc(
          getListValuesUseCase: di.locator(),
          selectListValueUseCase: di.locator(),
        ),
        child: ConvertouchListBox(
          values: widget.listValues,
          selectedValue: widget.selectedListValue,
          focusNode: widget.focusNode,
          label: widget.label,
          autofocus: widget.autofocus,
          disabled: widget.readonly,
          onChanged: widget.onChanged,
          onFocusSelected: widget.onFocusSelected,
          onFocusLeft: widget.onFocusLeft,
          borderRadius: widget.borderRadius,
          colors: widget.colors,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          height: widget.height,
          fontSize: widget.fontSize,
          labelPadding: widget.labelPadding,
        ),
      );
    }

    return ConvertouchTextBox(
      text: widget.value,
      focusNode: widget.focusNode,
      valueType: widget.valueType,
      hintText: widget.defaultValue,
      label: widget.label,
      autofocus: widget.autofocus,
      readonly: widget.readonly,
      onValueChanged: widget.onChanged,
      onValueClean: widget.onClean,
      onFocusSelected: widget.onFocusSelected,
      onFocusLeft: widget.onFocusLeft,
      maxTextLength: widget.maxTextLength,
      textLengthCounterVisible: widget.textLengthCounterVisible,
      borderRadius: widget.borderRadius,
      colors: widget.colors,
      prefixIcon: widget.prefixIcon,
      suffixIcon: widget.suffixIcon,
      contentPadding: widget.contentPadding,
      labelPadding: widget.labelPadding,
      height: widget.height,
      fontSize: widget.fontSize,
    );
  }
}
