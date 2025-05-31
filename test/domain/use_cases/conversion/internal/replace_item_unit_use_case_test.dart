import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_item_unit_replace_model.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/replace_item_unit_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:test/test.dart';

import '../../../model/mock/mock_param.dart';
import '../../../model/mock/mock_unit.dart';
import '../../../repositories/mock/mock_dynamic_value_repository.dart';

void main() {
  late ReplaceUnitInConversionItemUseCase replaceUnitInConversionItemUseCase;
  late ReplaceUnitInParamUseCase replaceUnitInParamUseCase;

  setUp(() {
    replaceUnitInConversionItemUseCase =
        const ReplaceUnitInConversionItemUseCase(
      listValueRepository: ListValueRepositoryImpl(),
      calculateDefaultValueUseCase: CalculateDefaultValueUseCase(
        dynamicValueRepository: MockDynamicValueRepository(),
        listValueRepository: ListValueRepositoryImpl(),
      ),
    );

    replaceUnitInParamUseCase = const ReplaceUnitInParamUseCase(
      listValueRepository: ListValueRepositoryImpl(),
      calculateDefaultValueUseCase: CalculateDefaultValueUseCase(
        dynamicValueRepository: MockDynamicValueRepository(),
        listValueRepository: ListValueRepositoryImpl(),
      ),
    );
  });

  test(
      "Should replace unit in non-list conversion item, "
      "value should not be changed", () async {
    ConversionUnitValueModel unitValue = ObjectUtils.tryGet(
      await replaceUnitInConversionItemUseCase.execute(
        InputItemUnitReplaceModel(
          item: ConversionUnitValueModel.tuple(meter, 25, 1),
          newUnit: centimeter,
        ),
      ),
    );

    expect(
      unitValue,
      ConversionUnitValueModel.tuple(centimeter, 25, 1),
    );
  });

  test(
      "Should replace unit in list conversion item, "
      "list value should be changed according to "
      "the new unit's coefficient or list type", () async {
    ConversionUnitValueModel unitValue = ObjectUtils.tryGet(
      await replaceUnitInConversionItemUseCase.execute(
        InputItemUnitReplaceModel(
          item: ConversionUnitValueModel.tuple(japanClothSize, 'L', null),
          newUnit: europeanClothSize,
        ),
      ),
    );

    expect(
      unitValue,
      ConversionUnitValueModel.tuple(europeanClothSize, 34, null),
    );
  });

  test(
      "Should replace unit in non-list param item, "
      "value should not be changed", () async {
    ConversionParamValueModel paramValue = ObjectUtils.tryGet(
      await replaceUnitInParamUseCase.execute(
        InputItemUnitReplaceModel(
          item: ConversionParamValueModel.tuple(diameterParam, 10, 1,
              unit: millimeter),
          newUnit: centimeter,
        ),
      ),
    );

    expect(
      paramValue,
      ConversionParamValueModel.tuple(diameterParam, 10, 1, unit: centimeter),
    );
  });

  test(
      "Should replace unit of in list param item, "
      "list value should be changed according to "
      "the new unit's coefficient or list type", () async {
    ConversionParamValueModel paramValue = ObjectUtils.tryGet(
      await replaceUnitInParamUseCase.execute(
        InputItemUnitReplaceModel<ConversionParamValueModel>(
          item: ConversionParamValueModel.tuple(barWeightParam, 10, null,
              unit: kilogram),
          newUnit: pound,
        ),
      ),
    );

    expect(
      paramValue,
      ConversionParamValueModel.tuple(barWeightParam, 22, null, unit: pound),
    );
  });
}
