import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_source_item_by_params_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/replace_item_unit_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/replace_conversion_param_unit_use_case.dart';
import 'package:test/test.dart';

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
      ),
      replaceUnitInParamUseCase: ReplaceUnitInParamUseCase(
        listValueRepository: listValueRepository,
        calculateDefaultValueUseCase: calculateDefaultValueUseCase,
      ),
    );
  });

  group('Change param unit in the conversion by coefficients', () {
    group('Change list parameter unit (bar weight)', () {
      test(
          'Param list value should change as well, '
          'conversion values should remain as is', () async {
        double expectedSrcValueNum = 22 * pound.coefficient! + 45 * 2;
        double expectedSrcDefaultValueNum = 22 * pound.coefficient! + 2;

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
          currentSrc:
              ConversionUnitValueModel.tuple(kilogram, expectedSrcValueNum, 12),
          currentUnitValues: [
            ConversionUnitValueModel.tuple(kilogram, expectedSrcValueNum, 12),
          ],
          expectedSrc: ConversionUnitValueModel.tuple(
              kilogram, expectedSrcValueNum, expectedSrcDefaultValueNum),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(
                kilogram, expectedSrcValueNum, expectedSrcDefaultValueNum),
          ],
          expectedParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: barbellWeightParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(barWeightParam, 22, null,
                      unit: pound),
                  ConversionParamValueModel.tuple(oneSideWeightParam, 45, 1,
                      unit: kilogram),
                ],
              ),
            ],
            selectedIndex: 0,
          ),
        );
      });
    });
  });
}
