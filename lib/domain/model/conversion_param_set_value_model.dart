import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/value_model.dart';

class ConversionParamSetValueModel extends ItemModel {
  final ConversionParamSetModel paramSet;
  final List<ConversionParamValueModel> paramValues;

  const ConversionParamSetValueModel({
    required this.paramSet,
    required this.paramValues,
  }) : super(
          itemType: ItemType.conversionParamSetValue,
        );

  const ConversionParamSetValueModel.tuple(this.paramSet, this.paramValues)
      : super(
          itemType: ItemType.conversionParamSetValue,
        );

  @override
  List<Object?> get props => [
        paramSet,
        paramValues,
      ];

  bool get hasAllValues => paramValues.every((p) => p.hasValue);

  ValueModel? getValue(String paramName) {
    var paramValue = paramValues.firstWhere((e) => e.param.name == paramName);
    return paramValue.value ?? paramValue.defaultValue;
  }

  ConversionParamValueModel? getParam(String paramName) {
    return paramValues.firstWhere((e) => e.param.name == paramName);
  }

  bool get hasMultipleCalculableParams {
    return paramValues.where((p) => p.param.calculable).length > 1;
  }

  ConversionParamSetValueModel copyWith({
    ConversionParamSetModel? paramSet,
    List<ConversionParamValueModel>? paramValues,
  }) {
    return ConversionParamSetValueModel(
      paramSet: paramSet ?? this.paramSet,
      paramValues: paramValues ?? this.paramValues,
    );
  }

  ConversionParamSetValueModel copyWithNewCalculatedParam({
    required int newCalculatedParamId,
  }) {
    List<ConversionParamValueModel> newParamValues = paramValues
        .map(
          (p) => p.copyWith(
            calculated:
                p.param.id == newCalculatedParamId ? !p.calculated : false,
          ),
        )
        .toList();

    return copyWith(
      paramValues: newParamValues,
    );
  }

  @override
  Map<String, dynamic> toJson({bool removeNulls = true}) {
    return {
      "paramSet": paramSet.toJson(),
      "paramValues": paramValues.map((value) => value.toJson()).toList(),
    };
  }

  static ConversionParamSetValueModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return ConversionParamSetValueModel(
      paramSet: ConversionParamSetModel.fromJson(json["paramSet"])!,
      paramValues: (json["paramValues"] as List)
          .map((value) => ConversionParamValueModel.fromJson(value)!)
          .toList(),
    );
  }

  @override
  String toString() {
    return 'ConversionParamSetValueModel{'
        'paramSet: $paramSet, '
        'paramValues: $paramValues}';
  }
}
