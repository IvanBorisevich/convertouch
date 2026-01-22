import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/ui/model/input_box_model.dart';

class TextBoxModel extends InputBoxModel {
  final String? value;
  final String? hint;
  final String? unfocusedValue;
  final String? unfocusedHint;
  final ConvertouchValueType initialType;
  final int? maxTextLength;
  final bool textLengthCounterVisible;
  final String? invalidValueMessage;

  const TextBoxModel({
    this.value,
    this.hint,
    super.readonly,
    super.labelText,
    this.unfocusedValue,
    this.unfocusedHint,
    this.initialType = ConvertouchValueType.text,
    this.maxTextLength,
    this.textLengthCounterVisible = false,
    this.invalidValueMessage,
  });

  String get focusedText => value ?? '';

  String get focusedHintText => hint ?? '';

  String get unfocusedText => unfocusedValue ?? focusedText;

  String get unfocusedHintText => unfocusedHint ?? focusedHintText;
}
