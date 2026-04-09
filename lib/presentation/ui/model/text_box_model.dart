import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/ui/model/input_box_model.dart';

class TextBoxModel extends InputBoxModel {
  static const TextBoxModel empty = TextBoxModel();

  final String? value;
  final String? valueUnfocused;
  final String? hintUnfocused;
  final ConvertouchValueType valueType;
  final int? maxTextLength;
  final bool textLengthCounterVisible;

  const TextBoxModel({
    this.value,
    this.valueUnfocused,
    super.hint,
    this.hintUnfocused,
    super.readonly,
    super.labelText,
    this.valueType = ConvertouchValueType.text,
    this.maxTextLength,
    this.textLengthCounterVisible = false,
  });

  @override
  String toString() {
    return 'TextBoxModel{'
        'value: $value, '
        'valueUnfocused: $valueUnfocused, '
        'hint: $hint, '
        'hintUnfocused: $hintUnfocused, '
        'readonly: $readonly, '
        'labelText: $labelText, '
        'valueType: $valueType, '
        'maxTextLength: $maxTextLength, '
        'textLengthCounterVisible: $textLengthCounterVisible}';
  }
}
