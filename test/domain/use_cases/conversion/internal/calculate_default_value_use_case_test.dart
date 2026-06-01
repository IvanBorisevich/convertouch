import 'package:convertouch/data/repositories/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_default_value_calculation_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:test/test.dart';

import '../../../model/mock/mock_unit.dart';
import '../../../repositories/mock/mock_dynamic_value_repository.dart';
import '../../../repositories/mock/mock_network_repository.dart';

void main() {
  late CalculateDefaultValueUseCase useCase;

  setUp(() {
    useCase = const CalculateDefaultValueUseCase(
      dynamicValueRepository: MockDynamicValueRepository(),
      listValueRepository: ListValueRepositoryImpl(
        networkRepository: MockNetworkRepository(),
      ),
    );
  });

  test('Calculate for non-list unit', () async {
    ValueModel? result = ObjectUtils.tryGet(
      await useCase.execute(
        const InputDefaultValueCalculationModel(
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
          replacingUnit: centimeter,
        ),
      ),
    );

    expect(result, ValueModel.one);
  });
}
