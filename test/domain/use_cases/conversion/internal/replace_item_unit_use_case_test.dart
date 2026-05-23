import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/list_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_item_unit_replace_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_items_fetch_model.dart';
import 'package:convertouch/domain/use_cases/common/init_item_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/replace_item_unit_use_case.dart';
import 'package:convertouch/domain/use_cases/list_values/fetch_list_values_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:test/test.dart';

import '../../../model/mock/mock_param.dart';
import '../../../model/mock/mock_unit.dart';
import '../../../repositories/mock/mock_dynamic_value_repository.dart';
import '../../../repositories/mock/mock_network_repository.dart';

void main() {
  late ReplaceUnitInConversionItemUseCase replaceUnitInConversionItemUseCase;
  late ReplaceUnitInParamUseCase replaceUnitInParamUseCase;

  setUp(() {
    const ListValueRepositoryImpl listValueRepository = ListValueRepositoryImpl(
      networkRepository: MockNetworkRepository(),
    );

    const FetchListValuesUseCase fetchListValuesUseCase =
        FetchListValuesUseCase(
      listValueRepository: listValueRepository,
    );

    replaceUnitInConversionItemUseCase =
        const ReplaceUnitInConversionItemUseCase(
      calculateDefaultValueUseCase: CalculateDefaultValueUseCase(
        dynamicValueRepository: MockDynamicValueRepository(),
        listValueRepository: listValueRepository,
      ),
      initUnitListValuesUseCase: InitUnitListValuesUseCase(
        fetchListValuesUseCase: fetchListValuesUseCase,
      ),
    );

    replaceUnitInParamUseCase = const ReplaceUnitInParamUseCase(
      calculateDefaultValueUseCase: CalculateDefaultValueUseCase(
        dynamicValueRepository: MockDynamicValueRepository(),
        listValueRepository: listValueRepository,
      ),
      initParamListValuesUseCase: InitParamListValuesUseCase(
        fetchListValuesUseCase: fetchListValuesUseCase,
      ),
    );
  });

  test("Should not recalculate non-list value by [m -> cm: 25]", () async {
    ConversionUnitValueModel unitValue = ObjectUtils.tryGet(
      await replaceUnitInConversionItemUseCase.execute(
        InputItemUnitReplaceModel(
          item: ConversionUnitValueModel.tuple(meter, 25, 1),
          newUnit: centimeter,
        ),
      ),
    );

    expect(
      unitValue.toJson(),
      ConversionUnitValueModel.tuple(centimeter, 25, 1).toJson(),
    );
  });

  test(
      "Should recalculate list value by [JP L -> EU 34], "
      "should init list values of new unit", () async {
    ConversionUnitValueModel unitValue = ObjectUtils.tryGet(
      await replaceUnitInConversionItemUseCase.execute(
        InputItemUnitReplaceModel(
          item: ConversionUnitValueModel.tuple(japanClothSize, 'L', null),
          newUnit: europeanClothSize,
        ),
      ),
    );

    expect(
      unitValue.toJson(),
      ConversionUnitValueModel.tuple(
        europeanClothSize,
        34,
        null,
        listValues: const OutputItemsFetchModel(items: [
          ListValueModel.str('34'),
          ListValueModel.str('36'),
          ListValueModel.str('38'),
          ListValueModel.str('40'),
          ListValueModel.str('42'),
          ListValueModel.str('44'),
          ListValueModel.str('46'),
          ListValueModel.str('48'),
          ListValueModel.str('50'),
          ListValueModel.str('52'),
          ListValueModel.str('54'),
          ListValueModel.str('56'),
        ], pageNum: 1, hasReachedMax: true),
      ).toJson(),
    );
  });

  test("Should not recalculate non-list param value by [mm -> cm]", () async {
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
      paramValue.toJson(),
      ConversionParamValueModel.tuple(diameterParam, 10, 1, unit: centimeter)
          .toJson(),
    );
  });

  test(
      "Should recalculate list param value by [kg -> lb: 10], "
      "should init list values of the same list type by new unit coefficient",
      () async {
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
      paramValue.toJson(),
      ConversionParamValueModel.tuple(
        barWeightParam,
        22,
        null,
        unit: pound,
        listValues: const OutputItemsFetchModel(items: [
          ListValueModel.str('22'),
          ListValueModel.str('44'),
        ], pageNum: 1, hasReachedMax: true),
      ).toJson(),
    );
  });
}
