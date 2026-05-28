import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/num_range.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/init_item_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/replace_item_unit_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/replace_conversion_item_unit_use_case.dart';
import 'package:convertouch/domain/use_cases/list_values/fetch_list_values_use_case.dart';
import 'package:test/test.dart';

import '../../model/mock/mock_list_values_batch.dart';
import '../../model/mock/mock_param.dart';
import '../../model/mock/mock_unit.dart';
import '../../model/mock/mock_unit_group.dart';
import '../../repositories/mock/mock_dynamic_value_repository.dart';
import '../../repositories/mock/mock_network_repository.dart';
import 'helpers/helpers.dart';

void main() {
  late ReplaceConversionItemUnitUseCase useCase;

  setUpAll(() {
    const ListValueRepositoryImpl listValueRepository = ListValueRepositoryImpl(
      networkRepository: MockNetworkRepository(),
    );

    const initUnitListValuesUseCase = InitUnitListValuesUseCase(
      fetchListValuesUseCase: FetchListValuesUseCase(
        listValueRepository: listValueRepository,
      ),
    );

    useCase = const ReplaceConversionItemUnitUseCase(
      replaceUnitInConversionItemUseCase: ReplaceUnitInConversionItemUseCase(
        calculateDefaultValueUseCase: CalculateDefaultValueUseCase(
          dynamicValueRepository: MockDynamicValueRepository(),
          listValueRepository: listValueRepository,
        ),
        initUnitListValuesUseCase: initUnitListValuesUseCase,
      ),
      initUnitListValuesUseCase: initUnitListValuesUseCase,
    );
  });

  group('By coefficients', () {
    group('Without params - length', () {
      test('Should calculate other values by [dm -> m: 10]', () async {
        await testCase(
          useCase: useCase,
          delta: ReplaceConversionItemUnitDelta(
            newUnit: meter,
            unitId: decimeter.id,
            recalculationMode: RecalculationOnUnitChange.otherValues,
          ),
          unitGroup: lengthGroup,
          currentSrc: ConversionUnitValueModel.tuple(decimeter, 10, 1),
          currentUnitValues: [
            ConversionUnitValueModel.tuple(decimeter, 10, 1),
            ConversionUnitValueModel.tuple(centimeter, 100, 10),
          ],
          expectedSrc: ConversionUnitValueModel.tuple(meter, 10, 1),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(meter, 10, 1),
            ConversionUnitValueModel.tuple(centimeter, 1000, 100),
          ],
        );
      });

      test('Should calculate other values by [dm -> m: empty, default 1]',
          () async {
        await testCase(
          useCase: useCase,
          delta: ReplaceConversionItemUnitDelta(
            newUnit: meter,
            unitId: decimeter.id,
            recalculationMode: RecalculationOnUnitChange.otherValues,
          ),
          unitGroup: lengthGroup,
          currentSrc: ConversionUnitValueModel.tuple(decimeter, null, 1),
          currentUnitValues: [
            ConversionUnitValueModel.tuple(decimeter, null, 1),
            ConversionUnitValueModel.tuple(centimeter, null, 10),
          ],
          expectedSrc: ConversionUnitValueModel.tuple(meter, null, 1),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(meter, null, 1),
            ConversionUnitValueModel.tuple(centimeter, null, 100),
          ],
        );
      });

      test('Should recalculate current value by [dm -> m: 10]', () async {
        await testCase(
          useCase: useCase,
          delta: ReplaceConversionItemUnitDelta(
            newUnit: meter,
            unitId: decimeter.id,
            recalculationMode: RecalculationOnUnitChange.currentValue,
          ),
          unitGroup: lengthGroup,
          currentSrc: ConversionUnitValueModel.tuple(decimeter, 10, 1),
          currentUnitValues: [
            ConversionUnitValueModel.tuple(decimeter, 10, 1),
            ConversionUnitValueModel.tuple(centimeter, 100, 10),
          ],
          expectedSrc: ConversionUnitValueModel.tuple(meter, 1, 0.1),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(meter, 1, 0.1),
            ConversionUnitValueModel.tuple(centimeter, 100, 10),
          ],
        );
      });

      test('Should recalculate current value by [dm -> m: empty, default 1]',
          () async {
        await testCase(
          useCase: useCase,
          delta: ReplaceConversionItemUnitDelta(
            newUnit: meter,
            unitId: decimeter.id,
            recalculationMode: RecalculationOnUnitChange.currentValue,
          ),
          unitGroup: lengthGroup,
          currentSrc: ConversionUnitValueModel.tuple(decimeter, null, 1),
          currentUnitValues: [
            ConversionUnitValueModel.tuple(decimeter, null, 1),
            ConversionUnitValueModel.tuple(centimeter, null, 10),
          ],
          expectedSrc: ConversionUnitValueModel.tuple(meter, null, 0.1),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(meter, null, 0.1),
            ConversionUnitValueModel.tuple(centimeter, null, 10),
          ],
        );
      });
    });
  });

  group('By formula', () {
    group('With params - clothes size', () {
      test(
          'Should recalculate other values by [Man, Shirt, h: cm 164-170 | EU -> US: 44], '
          'should initialize list values of the current item and other items',
          () async {
        await testCase(
          unitGroup: clothesSizeGroup,
          useCase: useCase,
          delta: ReplaceConversionItemUnitDelta(
            newUnit: usaClothSize,
            unitId: europeanClothSize.id,
            recalculationMode: RecalculationOnUnitChange.otherValues,
          ),
          currentParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: clothesSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(personParam, "Man", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(
                      heightParam, const NumRange.withRight(164, 170), null,
                      unit: centimeter),
                ],
              )
            ],
            selectedIndex: 0,
          ),
          currentSrc:
              ConversionUnitValueModel.tuple(europeanClothSize, 44, null),
          currentUnitValues: [
            ConversionUnitValueModel.tuple(europeanClothSize, 44, null),
            ConversionUnitValueModel.tuple(japanClothSize, 'M', null),
          ],
          expectedParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: clothesSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(personParam, "Man", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(
                      heightParam, const NumRange.withRight(164, 170), null,
                      unit: centimeter),
                ],
              )
            ],
            selectedIndex: 0,
          ),
          expectedSrc: ConversionUnitValueModel.tuple(
            usaClothSize,
            2,
            null,
            listValues: usaClothSizeListValues,
          ),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(
              usaClothSize,
              2,
              null,
              listValues: usaClothSizeListValues,
            ),
            ConversionUnitValueModel.tuple(
              japanClothSize,
              null,
              null,
              listValues: japanClothSizeListValues,
            ),
          ],
        );
      });

      test(
          'Should recalculate current value by [Man, Shirt, h: cm 164-170 | EU -> US: 44], '
          'should initialize list values of the current item', () async {
        await testCase(
          unitGroup: clothesSizeGroup,
          useCase: useCase,
          delta: ReplaceConversionItemUnitDelta(
            newUnit: usaClothSize,
            unitId: europeanClothSize.id,
            recalculationMode: RecalculationOnUnitChange.currentValue,
          ),
          currentParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: clothesSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(personParam, "Man", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(
                      heightParam, const NumRange.withRight(164, 170), null,
                      unit: centimeter),
                ],
              )
            ],
            selectedIndex: 0,
          ),
          currentSrc:
              ConversionUnitValueModel.tuple(europeanClothSize, 44, null),
          currentUnitValues: [
            ConversionUnitValueModel.tuple(europeanClothSize, 44, null),
            ConversionUnitValueModel.tuple(japanClothSize, 'M', null),
          ],
          expectedParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: clothesSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(personParam, "Man", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(
                      heightParam, const NumRange.withRight(164, 170), null,
                      unit: centimeter),
                ],
              )
            ],
            selectedIndex: 0,
          ),
          expectedSrc: ConversionUnitValueModel.tuple(
            usaClothSize,
            30,
            null,
            listValues: usaClothSizeListValues,
          ),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(
              usaClothSize,
              30,
              null,
              listValues: usaClothSizeListValues,
            ),
            ConversionUnitValueModel.tuple(japanClothSize, 'M', null),
          ],
        );
      });
    });
  });
}
