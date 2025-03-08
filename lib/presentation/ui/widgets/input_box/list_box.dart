import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/input_dialog/list_input_dialog_content.dart';
import 'package:flutter/material.dart';

class ConvertouchListBox extends StatefulWidget {
  static const double defaultHeight = 55;

  final ValueModel? value;
  final FocusNode? focusNode;
  final ConvertouchValueType valueType;
  final String label;
  final bool autofocus;
  final bool readonly;
  final void Function(String)? onChanged;
  final void Function()? onFocusSelected;
  final void Function()? onFocusLeft;
  final double borderRadius;
  final TextBoxColorScheme colors;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry contentPadding;
  final double height;
  final double fontSize;

  const ConvertouchListBox({
    this.value,
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
    this.height = defaultHeight,
    this.fontSize = 17,
    super.key,
  });

  @override
  State<ConvertouchListBox> createState() => _ConvertouchListBoxState();
}

class _ConvertouchListBoxState extends State<ConvertouchListBox> {
  late final FocusNode _focusNode;
  FocusNode? _defaultFocusNode;

  @override
  void initState() {
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

      if (widget.valueType.isList) {
        showDialog(
          context: context,
          builder: (context) {
            return ListInputDialogContent(
              values: widget.valueType.listValues(),
            );
          },
        );
      }
    } else {
      widget.onFocusLeft?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
