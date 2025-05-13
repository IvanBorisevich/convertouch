import 'dart:math';

import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/add_param_sets_to_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/convert_unit_values_use_case.dart';
import 'package:test/test.dart';

import '../../model/mock/mock_param.dart';
import '../../model/mock/mock_unit.dart';
import '../../model/mock/mock_unit_group.dart';
import '../../repositories/mock/mock_conversion_param_repository.dart';
import '../../repositories/mock/mock_conversion_param_set_repository.dart';
import '../../repositories/mock/mock_dynamic_value_repository.dart';
import 'helpers/helpers.dart';

void main() {
  late AddParamSetsToConversionUseCase useCase;

  setUp(() {
    useCase = const AddParamSetsToConversionUseCase(
      convertUnitValuesUseCase: ConvertUnitValuesUseCase(),
      conversionParamRepository: MockConversionParamRepository(),
      conversionParamSetRepository: MockConversionParamSetRepository(),
      listValueRepository: ListValueRepositoryImpl(),
      calculateDefaultValueUseCase: CalculateDefaultValueUseCase(
        dynamicValueRepository: MockDynamicValueRepository(),
      ),
    );
  });

  test('Add a mandatory param set', () async {
    await testCase(
      unitGroup: clothingSizeGroup,
      useCase: useCase,
      delta: const AddParamSetsDelta(),
      currentUnitValues: [],
      expectedUnitValues: [],
      expectedParams: ConversionParamSetValueBulkModel(
        paramSetValues: [
          ConversionParamSetValueModel(
            paramSet: clothingSizeParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(genderParam, null, null),
              ConversionParamValueModel.tuple(garmentParam, null, null),
              ConversionParamValueModel.tuple(heightParam, null, 1,
                  unit: centimeter),
            ],
          ),
        ],
        mandatoryParamSetExists: true,
        totalCount: 1,
      ),
    );
  });

  group('Add an optional param set (should be recalculated by src value)', () {
    group('Conversion has params', () {
      test('Conversion has unit values (should not be changed)', () async {
        await testCase(
          unitGroup: ringSizeGroup,
          useCase: useCase,
          delta: AddParamSetsDelta(
            paramSetIds: [
              ringSizeByCircumferenceParamSet.id,
            ],
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
            ],
            selectedParamSetCanBeRemoved: true,
            paramSetsCanBeRemovedInBulk: true,
            paramSetsCanBeAdded: true,
            selectedIndex: 0,
            totalCount: 2,
          ),
          currentSrc: ConversionUnitValueModel.tuple(usaRingSize, 3, null),
          currentUnitValues: [
            ConversionUnitValueModel.tuple(usaRingSize, 3, null),
            ConversionUnitValueModel.tuple(frRingSize, 44, null),
          ],
          expectedSrc: ConversionUnitValueModel.tuple(usaRingSize, 3, null),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(usaRingSize, 3, null),
            ConversionUnitValueModel.tuple(frRingSize, 44, null),
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
                  ConversionParamValueModel.tuple(
                      circumferenceParam, 14 * pi, 1,
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

      test('Conversion has no unit values', () async {
        await testCase(
          unitGroup: ringSizeGroup,
          useCase: useCase,
          delta: AddParamSetsDelta(
            paramSetIds: [
              ringSizeByCircumferenceParamSet.id,
            ],
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
            ],
            selectedParamSetCanBeRemoved: true,
            paramSetsCanBeRemovedInBulk: true,
            paramSetsCanBeAdded: true,
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
                  ConversionParamValueModel.tuple(circumferenceParam, null, 1,
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
    });

    group('Conversion has no params', () {
      test('Conversion has unit values (should not be changed)', () async {
        await testCase(
          unitGroup: ringSizeGroup,
          useCase: useCase,
          delta: AddParamSetsDelta(
            paramSetIds: [
              ringSizeByCircumferenceParamSet.id,
            ],
          ),
          currentParams: null,
          currentSrc: ConversionUnitValueModel.tuple(usaRingSize, 3, null),
          currentUnitValues: [
            ConversionUnitValueModel.tuple(usaRingSize, 3, null),
            ConversionUnitValueModel.tuple(frRingSize, 44, null),
          ],
          expectedSrc: ConversionUnitValueModel.tuple(usaRingSize, 3, null),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(usaRingSize, 3, null),
            ConversionUnitValueModel.tuple(frRingSize, 44, null),
          ],
          expectedParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: ringSizeByCircumferenceParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(
                      circumferenceParam, 14 * pi, 1,
                      unit: millimeter),
                ],
              ),
            ],
            selectedParamSetCanBeRemoved: true,
            paramSetsCanBeRemovedInBulk: true,
            paramSetsCanBeAdded: true,
            selectedIndex: 0,
            totalCount: 2,
          ),
        );
      });

      test('Conversion has no unit values', () async {
        await testCase(
          unitGroup: ringSizeGroup,
          useCase: useCase,
          delta: AddParamSetsDelta(
            paramSetIds: [
              ringSizeByDiameterParamSet.id,
              ringSizeByCircumferenceParamSet.id,
            ],
          ),
          currentParams: null,
          currentUnitValues: [],
          expectedUnitValues: [],
          expectedParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: ringSizeByDiameterParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(diameterParam, null, 1,
                      unit: millimeter),
                ],
              ),
              ConversionParamSetValueModel(
                paramSet: ringSizeByCircumferenceParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(circumferenceParam, null, 1,
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
    });
  });
}
