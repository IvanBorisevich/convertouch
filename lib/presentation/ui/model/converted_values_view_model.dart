import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:equatable/equatable.dart';

class ConvertedValuesViewModel extends Equatable {
  final List<ConversionUnitValueModel> convertedValues;
  final int? sourceUnitId;
  final UnitGroupModel unitGroup;

  const ConvertedValuesViewModel({
    required this.convertedValues,
    this.sourceUnitId,
    required this.unitGroup,
  });

  @override
  List<Object?> get props => [
        convertedValues,
        sourceUnitId,
        unitGroup,
      ];
}
