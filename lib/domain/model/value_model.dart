import 'package:convertouch/domain/utils/double_value_utils.dart';
import 'package:equatable/equatable.dart';

class ValueModel extends Equatable {
  static const ValueModel none = ValueModel(
    strValue: "",
    scientificValue: "",
  );

  static const ValueModel undefined = ValueModel(
    strValue: "-",
    scientificValue: "-",
  );

  static const ValueModel one = ValueModel(
    strValue: "1",
    scientificValue: "1",
  );

  final String strValue;
  final String scientificValue;

  const ValueModel({
    required this.strValue,
    required this.scientificValue,
  });

  ValueModel.ofDouble(double? value)
      : this(
          strValue: DoubleValueUtils.formatValue(value),
          scientificValue: DoubleValueUtils.formatValueScientific(value),
        );

  ValueModel.ofString(String? value)
      : this(
          strValue: value ?? "",
          scientificValue: DoubleValueUtils.formatValueScientific(
            double.tryParse(value ?? ""),
          ),
        );

  bool get isDefined => this != undefined;

  bool get exists => this != none;

  Map<String, dynamic> toJson() {
    return {
      "raw": strValue,
      "scientific": scientificValue,
    };
  }

  static ValueModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }

    return ValueModel(
      strValue: json["raw"],
      scientificValue: json["scientific"],
    );
  }

  @override
  List<Object> get props => [
        strValue,
      ];

  @override
  String toString() {
    return "{$strValue; sc: $scientificValue}";
  }
}
