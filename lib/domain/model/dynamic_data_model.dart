import 'package:convertouch/domain/model/list_value_model.dart';
import 'package:equatable/equatable.dart';

abstract class DynamicDataModel extends Equatable {
  const DynamicDataModel();
}

class DynamicValueModel extends DynamicDataModel {
  final int unitId;
  final String? value;

  const DynamicValueModel({
    required this.unitId,
    this.value,
  });

  @override
  List<Object?> get props => [
        unitId,
        value,
      ];
}

class DynamicCoefficientsModel extends DynamicDataModel {
  final Map<int, double?> unitIdToCoefficient;

  const DynamicCoefficientsModel(this.unitIdToCoefficient);

  @override
  List<Object?> get props => [
        unitIdToCoefficient,
      ];
}

class DynamicListValuesModel extends DynamicDataModel {
  final List<ListValueModel> listValues;

  const DynamicListValuesModel(this.listValues);

  @override
  List<Object?> get props => [
        listValues,
      ];
}
