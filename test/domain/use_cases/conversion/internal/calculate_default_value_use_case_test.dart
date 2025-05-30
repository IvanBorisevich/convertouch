import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_default_value_calculation_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:test/test.dart';

import '../../../model/mock/mock_param.dart';
import '../../../model/mock/mock_unit.dart';
import '../../../repositories/mock/mock_dynamic_value_repository.dart';

void main() {
  late CalculateDefaultValueUseCase useCase;

  setUp(() {
    useCase = const CalculateDefaultValueUseCase(
      dynamicValueRepository: MockDynamicValueRepository(),
      listValueRepository: ListValueRepositoryImpl(),
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

  test('Calculate for list unit', () async {
    ValueModel? result = ObjectUtils.tryGet(
      await useCase.execute(
        const InputDefaultValueCalculationModel(
          item: japanClothSize,
        ),
      ),
    );

    expect(result, ValueModel.any('S'));
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

  test('Calculate for replacing list unit', () async {
    ValueModel? result = ObjectUtils.tryGet(
      await useCase.execute(
        const InputDefaultValueCalculationModel(
          item: japanClothSize,
          replacingUnit: italianClothSize,
        ),
      ),
    );

    expect(result, ValueModel.any(38));
  });

  test('Calculate for non-list param by its default unit', () async {
    ValueModel? result = ObjectUtils.tryGet(
      await useCase.execute(
        const InputDefaultValueCalculationModel(
          item: heightParam,
        ),
      ),
    );

    expect(result, ValueModel.one);
  });

  test('Calculate for non-list param by explicit param unit', () async {
    ValueModel? result = ObjectUtils.tryGet(
      await useCase.execute(
        const InputDefaultValueCalculationModel(
          item: heightParam,
          currentParamUnit: centimeter,
        ),
      ),
    );

    expect(result, ValueModel.one);
  });

  test('Calculate for list param without unit without preselection', () async {
    ValueModel? result = ObjectUtils.tryGet(
      await useCase.execute(
        const InputDefaultValueCalculationModel(
          item: personParam,
        ),
      ),
    );

    expect(result, null);
  });

  test('Calculate for list param without unit with preselection', () async {});

  test('Calculate for list param with unit without preselection', () async {});

  test('Calculate for list param with unit with preselection', () async {
    ValueModel? result = ObjectUtils.tryGet(
      await useCase.execute(
        const InputDefaultValueCalculationModel(
          item: barWeightParam,
        ),
      ),
    );

    expect(result, ValueModel.any(10));
  });

  test('Calculate for replacing unit in non-list param', () async {
    ValueModel? result = ObjectUtils.tryGet(
      await useCase.execute(
        const InputDefaultValueCalculationModel(
          item: heightParam,
          currentParamUnit: meter,
          replacingUnit: centimeter,
        ),
      ),
    );

    expect(result, ValueModel.one);
  });

  test('Calculate for replacing unit in list param', () async {
    ValueModel? result = ObjectUtils.tryGet(
      await useCase.execute(
        const InputDefaultValueCalculationModel(
          item: barWeightParam,
          currentParamUnit: kilogram,
          replacingUnit: pound,
        ),
      ),
    );

    expect(result, ValueModel.any(22));
  });
}
