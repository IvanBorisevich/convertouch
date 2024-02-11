import 'package:convertouch/domain/utils/number_value_utils.dart';
import 'package:equatable/equatable.dart';

class ValueModel extends Equatable {
  static const ValueModel none = ValueModel(
    strValue: "",
    scientificValue: "",
  );

  static const ValueModel one = ValueModel(
    strValue: "1",
    scientificValue: "1",
  );

  final String strValue;
  final String? scientificValue;

  const ValueModel({
    required this.strValue,
    required this.scientificValue,
  });

  ValueModel.ofDouble(double? value)
      : this(
          strValue: NumberValueUtils.formatValue(value),
          scientificValue:
              NumberValueUtils.formatValueInScientificNotation(value),
        );

  ValueModel.ofString(String? value)
      : this(
          strValue: value ?? "",
          scientificValue: NumberValueUtils.formatValueInScientificNotation(
            double.tryParse(value ?? ""),
          ),
        );

  bool get empty => strValue.isEmpty;

  bool get notEmpty => strValue.isNotEmpty;

  @override
  List<Object> get props => [
        strValue,
      ];

  @override
  String toString() {
    return "{$strValue - $scientificValue}";
  }
}
