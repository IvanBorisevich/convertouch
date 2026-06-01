import 'package:convertouch/data/repositories/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_param_set_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_param_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/init_item_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/replace_conversion_param_unit_use_case.dart';
import 'package:convertouch/domain/use_cases/list_values/fetch_list_values_use_case.dart';
import 'package:test/test.dart';

import '../../model/mock/mock_list_values_batch.dart';
import '../../model/mock/mock_param.dart';
import '../../model/mock/mock_unit.dart';
import '../../model/mock/mock_unit_group.dart';
import '../../repositories/mock/mock_dynamic_value_repository.dart';
import '../../repositories/mock/mock_network_repository.dart';
import '../../repositories/mock/mock_unit_group_repository.dart';
import 'helpers/helpers.dart';

void main() {
  late ReplaceConversionParamUnitUseCase useCase;

  setUpAll(() {
    const ListValueRepositoryImpl listValueRepository = ListValueRepositoryImpl(
      networkRepository: MockNetworkRepository(),
    );

    useCase = const ReplaceConversionParamUnitUseCase(
      calculateParamSetValueUseCase: CalculateParamSetValueUseCase(
        calculateParamValueUseValue: CalculateParamValueUseValue(
          calculateDefaultValueUseCase: CalculateDefaultValueUseCase(
            dynamicValueRepository: MockDynamicValueRepository(),
            listValueRepository: listValueRepository,
          ),
          initParamListValuesUseCase: InitParamListValuesUseCase(
            fetchListValuesUseCase: FetchListValuesUseCase(
              listValueRepository: listValueRepository,
            ),
          ),
          unitGroupRepository: MockUnitGroupRepository(),
        ),
      ),
    );
  });

  group('By coefficients', () {
    test("Should recalculate 'Bar Weight' current list value by [kg -> lb]",
        () async {
      await testCase(
        unitGroup: massGroup,
        useCase: useCase,
        delta: ReplaceConversionParamUnitDelta(
          paramId: barWeightParam.id,
          paramSetId: barWeightParam.paramSetId,
          newUnit: pound,
        ),
        currentParams: ConversionParamSetValueBulkModel(
          paramSetValues: [
            ConversionParamSetValueModel(
              paramSet: barbellWeightParamSet,
              paramValues: [
                ConversionParamValueModel.tuple(barWeightParam, 10, null,
                    unit: kilogram),
                ConversionParamValueModel.tuple(oneSideWeightParam, 45, 1,
                    unit: kilogram),
              ],
            )
          ],
          selectedIndex: 0,
        ),
        currentSrc: ConversionUnitValueModel.tuple(kilogram, 100, 12),
        currentUnitValues: [
          ConversionUnitValueModel.tuple(kilogram, 100, 12),
        ],
        expectedParams: ConversionParamSetValueBulkModel(
          paramSetValues: [
            ConversionParamSetValueModel(
              paramSet: barbellWeightParamSet,
              paramValues: [
                ConversionParamValueModel.tuple(
                  barWeightParam,
                  barWeightParamPoundListValues.items[0].valueModel,
                  null,
                  unit: pound,
                  listValues: barWeightParamPoundListValues,
                ),
                ConversionParamValueModel.tuple(oneSideWeightParam, 45, 1,
                    unit: kilogram),
              ],
            ),
          ],
          selectedIndex: 0,
        ),
        expectedSrc: ConversionUnitValueModel.tuple(
          kilogram,
          100,
          12,
        ),
        expectedUnitValues: [
          ConversionUnitValueModel.tuple(
            kilogram,
            100,
            12,
          ),
        ],
      );
    });
  });
}
