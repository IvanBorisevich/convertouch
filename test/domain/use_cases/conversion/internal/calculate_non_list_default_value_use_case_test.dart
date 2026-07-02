import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_default_value_calculation_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_non_list_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/dynamic_data/fetch_dynamic_value_use_use.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:test/test.dart';

import '../../../model/mock/mock_unit.dart';
import '../../../repositories/mock/mock_dynamic_value_repository.dart';

void main() {
  late CalculateNonListDefaultValueUseCase useCase;

  setUp(() {
    useCase = const CalculateNonListDefaultValueUseCase(
      fetchDynamicValueUseCase: FetchDynamicValueUseCase(
        dynamicValueRepository: MockDynamicValueRepository(),
      ),
    );
  });

  test('Calculate for non-list unit', () async {
    ValueModel? result = ObjectUtils.tryGet(
      await useCase.execute(
        const InputDefaultValueCalculationModel(
          conversionGroupName: GroupNames.length,
          item: meter,
        ),
      ),
    );

    expect(result, ValueModel.one);
  });

  test('Calculate for replacing non-list unit', () async {
    ValueModel? result = ObjectUtils.tryGet(
      await useCase.execute(
        const InputDefaultValueCalculationModel(
          item: meter,
          conversionGroupName: GroupNames.length,
          replacingUnit: centimeter,
        ),
      ),
    );

    expect(result, ValueModel.one);
  });
}
