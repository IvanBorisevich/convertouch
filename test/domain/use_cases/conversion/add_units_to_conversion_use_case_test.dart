import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/num_range.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/common/init_item_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/add_units_to_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_source_item_by_params_use_case.dart';
import 'package:convertouch/domain/use_cases/list_values/fetch_list_values_use_case.dart';
import 'package:test/test.dart';

import '../../model/mock/mock_list_values_batch.dart';
import '../../model/mock/mock_param.dart';
import '../../model/mock/mock_unit.dart';
import '../../model/mock/mock_unit_group.dart';
import '../../repositories/mock/mock_dynamic_value_repository.dart';
import '../../repositories/mock/mock_network_repository.dart';
import '../../repositories/mock/mock_unit_repository.dart';
import 'helpers/helpers.dart';

void main() {
  late AddUnitsToConversionUseCase useCase;

  setUpAll(() {
    const listValueRepository = ListValueRepositoryImpl(
      networkRepository: MockNetworkRepository(),
    );

    const initUnitListValuesUseCase = InitUnitListValuesUseCase(
    fetchListValuesUseCase: FetchListValuesUseCase(
    listValueRepository: listValueRepository,
    ),
    );

    useCase = const AddUnitsToConversionUseCase(
      calculateSourceItemByParamsUseCase: CalculateSourceItemByParamsUseCase(
        calculateDefaultValueUseCase: CalculateDefaultValueUseCase(
          dynamicValueRepository: MockDynamicValueRepository(),
          listValueRepository: listValueRepository,
        ),
        initUnitListValuesUseCase: initUnitListValuesUseCase,
      ),
      unitRepository: MockUnitRepository(),
      initUnitListValuesUseCase: initUnitListValuesUseCase,
    );
  });

  group('By coefficients', () {
    group('Without params', () {
      test('Should calculate default values for units: cm, km, dm', () async {
        await testCase(
          useCase: useCase,
          delta: AddUnitsToConversionDelta(
            unitIds: [
              centimeter.id,
              kilometer.id,
              decimeter.id,
            ],
          ),
          unitGroup: lengthGroup,
          currentSrc: null,
          expectedSrc: ConversionUnitValueModel.tuple(centimeter, null, 1),
          currentUnitValues: [],
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(centimeter, null, 1),
            ConversionUnitValueModel.tuple(kilometer, null, 0.00001),
            ConversionUnitValueModel.tuple(decimeter, null, 0.1),
          ],
        );
      });

      test('Should calculate values and default values for units: cm, km, dm',
          () async {
        await testCase(
          useCase: useCase,
          delta: AddUnitsToConversionDelta(
            unitIds: [
              centimeter.id,
              kilometer.id,
            ],
          ),
          unitGroup: lengthGroup,
          currentSrc: ConversionUnitValueModel.tuple(decimeter, 10, 1),
          currentUnitValues: [
            ConversionUnitValueModel.tuple(decimeter, 10, 1),
          ],
          expectedSrc: ConversionUnitValueModel.tuple(decimeter, 10, 1),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(centimeter, 100, 10),
            ConversionUnitValueModel.tuple(kilometer, 0.001, 0.0001),
            ConversionUnitValueModel.tuple(decimeter, 10, 1),
          ],
        );
      });
    });
  });

  group('By formula', () {
    group('With params', () {
      test(
          'Should calculate list values for [Man, Shirt, h: cm ..-164 | IT, JP], '
          'should init list values', () async {
        await testCase(
          unitGroup: clothesSizeGroup,
          useCase: useCase,
          delta: AddUnitsToConversionDelta(
            unitIds: [
              japanClothSize.id,
              italianClothSize.id,
            ],
          ),
          currentParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: clothesSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(personParam, "Man", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(
                      heightParam, const NumRange.withRight(0, 164), null,
                      unit: centimeter),
                ],
              )
            ],
            selectedIndex: 0,
          ),
          currentUnitValues: [],
          expectedParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: clothesSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(personParam, "Man", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(
                      heightParam, const NumRange.withRight(0, 164), null,
                      unit: centimeter),
                ],
              )
            ],
            selectedIndex: 0,
          ),
          expectedSrc: ConversionUnitValueModel.tuple(
            japanClothSize,
            'S',
            null,
            listValues: japanClothSizeListValues,
          ),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(
              japanClothSize,
              'S',
              null,
              listValues: japanClothSizeListValues,
            ),
            ConversionUnitValueModel.tuple(
              italianClothSize,
              42,
              null,
              listValues: italianClothesSizeListValues,
            ),
          ],
        );
      });
    });
  });
}
