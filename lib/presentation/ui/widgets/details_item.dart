import 'package:convertouch/presentation/ui/model/text_box_model.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/input_box.dart';
import 'package:flutter/material.dart';

class ConvertouchDetailsItem extends StatelessWidget {
  final String name;
  final bool nameVisible;
  final String? draftValue;
  final String? savedValue;
  final Widget? content;
  final bool visible;
  final bool editable;
  final void Function(String)? onValueChanged;
  final int? editableValueMaxLength;
  final bool editableValueLengthVisible;
  final double topMargin;
  final InputBoxColorScheme inputBoxColor;

  const ConvertouchDetailsItem({
    required this.name,
    this.nameVisible = true,
    this.draftValue,
    this.savedValue,
    this.content,
    this.visible = true,
    this.editable = false,
    this.onValueChanged,
    this.editableValueMaxLength,
    this.editableValueLengthVisible = false,
    this.topMargin = 0,
    required this.inputBoxColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return const SizedBox.shrink();
    }

    String? headerTitle = nameVisible ? name : null;

    return Padding(
      padding: EdgeInsets.only(top: topMargin),
      child: editable
          ? ConvertouchInputBox(
              model: TextBoxModel(
                value: draftValue,
                valueUnfocused: draftValue,
                hint: savedValue,
                hintUnfocused: savedValue,
                labelText: headerTitle,
                maxTextLength: editableValueMaxLength,
                textLengthCounterVisible: editableValueLengthVisible,
              ),
              onValueChanged: onValueChanged,
              colors: inputBoxColor,
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headerTitle != null
                      ? Text(
                          headerTitle,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: inputBoxColor.textBox.border.regular,
                          ),
                        )
                      : const SizedBox.shrink(),
                  savedValue != null
                      ? Text(
                          savedValue!,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: inputBoxColor.textBox.foreground.regular,
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
