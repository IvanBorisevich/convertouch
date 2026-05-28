import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/init_item_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_source_item_by_params_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/replace_item_unit_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/replace_conversion_param_unit_use_case.dart';
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
  late ReplaceConversionParamUnitUseCase useCase;

  setUpAll(() {
    const ListValueRepositoryImpl listValueRepository = ListValueRepositoryImpl(
      networkRepository: MockNetworkRepository(),
    );

    const calculateDefaultValueUseCase = CalculateDefaultValueUseCase(
      dynamicValueRepository: MockDynamicValueRepository(),
      listValueRepository: listValueRepository,
    );

    useCase = const ReplaceConversionParamUnitUseCase(
      calculateSourceItemByParamsUseCase: CalculateSourceItemByParamsUseCase(
        calculateDefaultValueUseCase: calculateDefaultValueUseCase,
        initUnitListValuesUseCase: InitUnitListValuesUseCase(
          fetchListValuesUseCase: FetchListValuesUseCase(
            listValueRepository: ListValueRepositoryImpl(
              networkRepository: MockNetworkRepository(),
            ),
          ),
        ),
      ),
      replaceUnitInParamUseCase: ReplaceUnitInParamUseCase(
        calculateDefaultValueUseCase: calculateDefaultValueUseCase,
        initParamListValuesUseCase: InitParamListValuesUseCase(
          fetchListValuesUseCase: FetchListValuesUseCase(
            listValueRepository: listValueRepository,
          ),
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
        currentSrc: ConversionUnitValueModel.tuple(
            kilogram, 22 * pound.coefficient! + 45 * 2, 12),
        currentUnitValues: [
          ConversionUnitValueModel.tuple(
              kilogram, 22 * pound.coefficient! + 45 * 2, 12),
        ],
        expectedParams: ConversionParamSetValueBulkModel(
          paramSetValues: [
            ConversionParamSetValueModel(
              paramSet: barbellWeightParamSet,
              paramValues: [
                ConversionParamValueModel.tuple(
                  barWeightParam,
                  22,
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
        expectedSrc: ConversionUnitValueModel.tuple(kilogram,
            22 * pound.coefficient! + 45 * 2, 22 * pound.coefficient! + 2),
        expectedUnitValues: [
          ConversionUnitValueModel.tuple(kilogram,
              22 * pound.coefficient! + 45 * 2, 22 * pound.coefficient! + 2),
        ],
      );
    });
  });
}
