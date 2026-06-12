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
  static const DynamicCoefficientsModel empty = DynamicCoefficientsModel({});

  final Map<int, double?> unitIdToCoefficient;

  const DynamicCoefficientsModel(this.unitIdToCoefficient);

  @override
  List<Object?> get props => [
        unitIdToCoefficient,
      ];
}
