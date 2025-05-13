import 'dart:math';

import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/convert_unit_values_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/select_param_set_in_conversion_use_case.dart';
import 'package:test/test.dart';

import '../../model/mock/mock_param.dart';
import '../../model/mock/mock_unit.dart';
import '../../model/mock/mock_unit_group.dart';
import '../../repositories/mock/mock_dynamic_value_repository.dart';
import 'helpers/helpers.dart';

void main() {
  late SelectParamSetInConversionUseCase useCase;

  setUp(() {
    useCase = const SelectParamSetInConversionUseCase(
      convertUnitValuesUseCase: ConvertUnitValuesUseCase(),
      listValueRepository: ListValueRepositoryImpl(),
      calculateDefaultValueUseCase: CalculateDefaultValueUseCase(
        dynamicValueRepository: MockDynamicValueRepository(),
      ),
    );
  });

  test('Conversion has unit values (should be changed)', () async {
    await testCase(
      unitGroup: ringSizeGroup,
      useCase: useCase,
      delta: const SelectParamSetDelta(
        newSelectedParamSetIndex: 1,
      ),
      currentParams: ConversionParamSetValueBulkModel(
        paramSetValues: [
          ConversionParamSetValueModel(
            paramSet: ringSizeByDiameterParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(diameterParam, 14, 1,
                  unit: millimeter)
            ],
          ),
          ConversionParamSetValueModel(
            paramSet: ringSizeByCircumferenceParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(circumferenceParam, 14.5 * pi, 1,
                  unit: millimeter)
            ],
          ),
        ],
        selectedParamSetCanBeRemoved: true,
        paramSetsCanBeRemovedInBulk: true,
        paramSetsCanBeAdded: false,
        selectedIndex: 0,
        totalCount: 2,
      ),
      currentSrc: ConversionUnitValueModel.tuple(usaRingSize, 3, null),
      currentUnitValues: [
        ConversionUnitValueModel.tuple(usaRingSize, 3, null),
        ConversionUnitValueModel.tuple(frRingSize, 44, null),
      ],
      expectedSrc: ConversionUnitValueModel.tuple(usaRingSize, 3.5, null),
      expectedUnitValues: [
        ConversionUnitValueModel.tuple(usaRingSize, 3.5, null),
        ConversionUnitValueModel.tuple(frRingSize, null, null),
      ],
      expectedParams: ConversionParamSetValueBulkModel(
        paramSetValues: [
          ConversionParamSetValueModel(
            paramSet: ringSizeByDiameterParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(diameterParam, 14, 1,
                  unit: millimeter),
            ],
          ),
          ConversionParamSetValueModel(
            paramSet: ringSizeByCircumferenceParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(circumferenceParam, 14.5 * pi, 1,
                  unit: millimeter),
            ],
          ),
        ],
        selectedParamSetCanBeRemoved: true,
        paramSetsCanBeRemovedInBulk: true,
        paramSetsCanBeAdded: false,
        selectedIndex: 1,
        totalCount: 2,
      ),
    );
  });

  test('Conversion does not have unit values', () async {
    await testCase(
      unitGroup: ringSizeGroup,
      useCase: useCase,
      delta: const SelectParamSetDelta(
        newSelectedParamSetIndex: 1,
      ),
      currentParams: ConversionParamSetValueBulkModel(
        paramSetValues: [
          ConversionParamSetValueModel(
            paramSet: ringSizeByDiameterParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(diameterParam, 14, 1,
                  unit: millimeter)
            ],
          ),
          ConversionParamSetValueModel(
            paramSet: ringSizeByCircumferenceParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(circumferenceParam, 14.5 * pi, 1,
                  unit: millimeter)
            ],
          ),
        ],
        selectedParamSetCanBeRemoved: true,
        paramSetsCanBeRemovedInBulk: true,
        paramSetsCanBeAdded: false,
        selectedIndex: 0,
        totalCount: 2,
      ),
      currentUnitValues: [],
      expectedUnitValues: [],
      expectedParams: ConversionParamSetValueBulkModel(
        paramSetValues: [
          ConversionParamSetValueModel(
            paramSet: ringSizeByDiameterParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(diameterParam, 14, 1,
                  unit: millimeter),
            ],
          ),
          ConversionParamSetValueModel(
            paramSet: ringSizeByCircumferenceParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(circumferenceParam, 14.5 * pi, 1,
                  unit: millimeter),
            ],
          ),
        ],
        selectedParamSetCanBeRemoved: true,
        paramSetsCanBeRemovedInBulk: true,
        paramSetsCanBeAdded: false,
        selectedIndex: 1,
        totalCount: 2,
      ),
    );
  });
}
