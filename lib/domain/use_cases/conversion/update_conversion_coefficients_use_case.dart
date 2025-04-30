import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';

class UpdateConversionCoefficientsUseCase
    extends AbstractModifyConversionUseCase<UpdateConversionCoefficientsDelta> {
  const UpdateConversionCoefficientsUseCase({
    required super.convertUnitValuesUseCase,
  });

  @override
  Future<Map<int, ConversionUnitValueModel>> newConvertedUnitValues({
    required Map<int, ConversionUnitValueModel> oldConvertedUnitValues,
    required UpdateConversionCoefficientsDelta delta,
  }) async {
    oldConvertedUnitValues.updateAll(
      (key, item) => item.copyWith(
        unit: item.unit.copyWith(
          coefficient: delta.updatedUnitCoefs[item.unit.code],
        ),
      ),
    );
    return oldConvertedUnitValues;
  }
}
