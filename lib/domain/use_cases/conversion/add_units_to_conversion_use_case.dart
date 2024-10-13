import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

class AddUnitsToConversionUseCase
    extends AbstractModifyConversionUseCase<AddUnitsToConversionDelta> {
  final UnitRepository unitRepository;

  const AddUnitsToConversionUseCase({
    required super.buildNewConversionUseCase,
    required this.unitRepository,
  });

  @override
  Future<Map<int, UnitModel>> modifyTargetUnits(
    Map<int, UnitModel> targetUnits,
    AddUnitsToConversionDelta delta,
  ) async {
    final newUnits = ObjectUtils.tryGet(
      await unitRepository.getByIds(delta.unitIds),
    );

    final newUnitsMap = {for (var unit in newUnits) unit.id: unit};
    return {
      ...targetUnits,
      ...newUnitsMap,
    };
  }
}
