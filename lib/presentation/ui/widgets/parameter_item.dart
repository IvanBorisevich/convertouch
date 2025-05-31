import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/text_box.dart';
import 'package:flutter/material.dart';

class ConvertouchParameterItem extends StatelessWidget {
  final String name;
  final bool nameVisible;
  final String? value;
  final Widget? content;
  final bool visible;
  final bool editable;
  final TextEditingController? valueChangeController;
  final void Function(String)? onValueChanged;
  final int? editableValueMaxLength;
  final bool editableValueLengthVisible;
  final double bottomMargin;
  final InputBoxColorScheme textBoxColor;

  const ConvertouchParameterItem({
    required this.name,
    this.nameVisible = true,
    this.value,
    this.content,
    this.visible = true,
    this.editable = false,
    this.valueChangeController,
    this.onValueChanged,
    this.editableValueMaxLength,
    this.editableValueLengthVisible = false,
    this.bottomMargin = 20,
    required this.textBoxColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return const SizedBox.shrink();
    }

    String? headerTitle = nameVisible ? name : null;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomMargin),
      child: editable
          ? ConvertouchTextBox(
              label: headerTitle ?? "",
              controller: valueChangeController,
              onValueChanged: onValueChanged,
              hintText: value,
              colors: textBoxColor,
              textLengthCounterVisible: editableValueLengthVisible,
              maxTextLength: editableValueMaxLength,
            )
          : SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headerTitle != null
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(
                            headerTitle,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: textBoxColor.border.regular,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  value != null
                      ? Text(
                          value!,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: textBoxColor.foreground.regular,
                          ),
                        )
                      : const SizedBox.shrink(),
                  content ?? const SizedBox.shrink(),
                ],
              ),
            ),
    );
  }
}
