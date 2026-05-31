import 'dart:math';

import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/add_param_sets_to_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_param_set_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_param_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/init_item_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/list_values/fetch_list_values_use_case.dart';
import 'package:test/test.dart';

import '../../model/mock/mock_list_values_batch.dart';
import '../../model/mock/mock_param.dart';
import '../../model/mock/mock_unit.dart';
import '../../model/mock/mock_unit_group.dart';
import '../../repositories/mock/mock_conversion_param_repository.dart';
import '../../repositories/mock/mock_conversion_param_set_repository.dart';
import '../../repositories/mock/mock_dynamic_value_repository.dart';
import '../../repositories/mock/mock_network_repository.dart';
import '../../repositories/mock/mock_unit_group_repository.dart';
import 'helpers/helpers.dart';

void main() {
  late AddParamSetsToConversionUseCase useCase;

  setUpAll(() {
    const listValueRepository = ListValueRepositoryImpl(
      networkRepository: MockNetworkRepository(),
    );

    useCase = const AddParamSetsToConversionUseCase(
      conversionParamRepository: MockConversionParamRepository(),
      conversionParamSetRepository: MockConversionParamSetRepository(),
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

  group('By coefficients', () {});

  group('By formula', () {
    group("[Ring size] Add param set 'By Circumference'", () {
      test("Should auto-calculate the param 'Circumference'", () async {
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
                    circumferenceParam,
                    null,
                    14.5 * pi,
                    unit: millimeter,
                    calculated: true,
                  ),
                ],
              ),
            ],
            selectedParamSetCanBeRemoved: true,
            optionalParamSetsExist: true,
            paramSetsCanBeAdded: true,
            selectedIndex: 0,
            totalCount: 2,
          ),
        );
      });
    });

    group("[Ring size] Add param sets 'By Circumference' and 'By Diameter'",
        () {
      test("Should auto-calculate all calculable params in each of param sets",
          () async {
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
                  ConversionParamValueModel.tuple(
                    diameterParam,
                    null,
                    14.5,
                    unit: millimeter,
                    calculated: true,
                  ),
                ],
              ),
              ConversionParamSetValueModel(
                paramSet: ringSizeByCircumferenceParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(
                    circumferenceParam,
                    null,
                    14.5 * pi,
                    unit: millimeter,
                    calculated: true,
                  ),
                ],
              ),
            ],
            selectedParamSetCanBeRemoved: true,
            optionalParamSetsExist: true,
            paramSetsCanBeAdded: false,
            selectedIndex: 1,
            totalCount: 2,
          ),
        );
      });
    });

    group("[Mass] Add param set 'Barbell Weight'", () {
      test(
          "Should init list values of the param 'Bar Weight', "
          "should auto-calculate the param 'One Side Weight' value", () async {
        await testCase(
          unitGroup: massGroup,
          useCase: useCase,
          delta: AddParamSetsDelta(
            paramSetIds: [
              barbellWeightParamSet.id,
            ],
          ),
          currentParams: null,
          currentSrc: ConversionUnitValueModel.tuple(kilogram, 40, 1),
          currentUnitValues: [
            ConversionUnitValueModel.tuple(kilogram, 40, 1),
            ConversionUnitValueModel.tuple(pound, 40 / pound.coefficient!, 1),
          ],
          expectedSrc: ConversionUnitValueModel.tuple(kilogram, 40, 1),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(kilogram, 40, 1),
            ConversionUnitValueModel.tuple(
                pound, 40 / pound.coefficient!, 1 / pound.coefficient!),
          ],
          expectedParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: barbellWeightParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(
                    barWeightParam,
                    10,
                    null,
                    unit: kilogram,
                    listValues: barWeightParamKgListValues,
                  ),
                  ConversionParamValueModel.tuple(
                    oneSideWeightParam,
                    null,
                    15,
                    unit: kilogram,
                    calculated: true,
                  ),
                ],
              ),
            ],
            selectedParamSetCanBeRemoved: true,
            optionalParamSetsExist: true,
            paramSetsCanBeAdded: false,
            selectedIndex: 0,
            totalCount: 1,
          ),
        );
      });
    });
  });
}
