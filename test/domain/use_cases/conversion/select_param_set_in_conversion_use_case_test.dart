import 'dart:math';

import 'package:convertouch/data/repositories/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_unit_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/init_item_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/select_param_set_in_conversion_use_case.dart';
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
  late SelectParamSetInConversionUseCase useCase;

  setUpAll(() {
    const listValueRepository = ListValueRepositoryImpl(
      networkRepository: MockNetworkRepository(),
    );

    useCase = const SelectParamSetInConversionUseCase(
      calculateUnitValueUseValue: CalculateUnitValueUseValue(
        calculateDefaultValueUseCase: CalculateDefaultValueUseCase(
          dynamicValueRepository: MockDynamicValueRepository(),
          listValueRepository: listValueRepository,
        ),
        initUnitListValuesUseCase: InitUnitListValuesUseCase(
          fetchListValuesUseCase: FetchListValuesUseCase(
            listValueRepository: listValueRepository,
          ),
        ),
        unitGroupRepository: MockUnitGroupRepository(),
      ),
    );
  });

  test(
      "Should recalculate conversion on select the new param set 'By Circumference'",
      () async {
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
              ConversionParamValueModel.tuple(
                diameterParam,
                ringDiameterRangesInMm.items[0],
                null,
                unit: millimeter,
                listValues: ringDiameterRangesInMm,
              ),
            ],
          ),
          ConversionParamSetValueModel(
            paramSet: ringSizeByCircumferenceParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(
                circumferenceParam,
                ringCircumferenceRangesInMm.items[1],
                null,
                unit: millimeter,
                listValues: ringCircumferenceRangesInMm,
              ),
            ],
          ),
        ],
        selectedParamSetCanBeRemoved: true,
        optionalParamSetsExist: true,
        paramSetsCanBeAdded: false,
        selectedIndex: 0,
        totalCount: 2,
      ),
      currentSrc: ConversionUnitValueModel.tuple(
        usaRingSize,
        3,
        null,
        listValues: usaRingSizes,
      ),
      currentUnitValues: [
        ConversionUnitValueModel.tuple(
          usaRingSize,
          3,
          null,
          listValues: usaRingSizes,
        ),
        ConversionUnitValueModel.tuple(
          frRingSize,
          44,
          null,
          listValues: frRingSizes,
        ),
      ],
      expectedParams: ConversionParamSetValueBulkModel(
        paramSetValues: [
          ConversionParamSetValueModel(
            paramSet: ringSizeByDiameterParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(
                diameterParam,
                ringDiameterRangesInMm.items[0],
                null,
                unit: millimeter,
                listValues: ringDiameterRangesInMm,
              ),
            ],
          ),
          ConversionParamSetValueModel(
            paramSet: ringSizeByCircumferenceParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(
                circumferenceParam,
                ringCircumferenceRangesInMm.items[1],
                null,
                unit: millimeter,
                listValues: ringCircumferenceRangesInMm,
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
      expectedSrc: ConversionUnitValueModel.tuple(
        usaRingSize,
        3.5,
        null,
        listValues: usaRingSizes,
      ),
      expectedUnitValues: [
        ConversionUnitValueModel.tuple(
          usaRingSize,
          3.5,
          null,
          listValues: usaRingSizes,
        ),
        ConversionUnitValueModel.tuple(
          frRingSize,
          null,
          null,
          listValues: frRingSizes,
        ),
      ],
    );
  });

  test(
      "Should recalculate conversion on select the new param set 'By Circumference' "
      "by param 'Circumference' non-list value (for backward compatibility), "
      "should initialize list values of previously non-list params", () async {
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
              ConversionParamValueModel.tuple(
                diameterParam,
                ringDiameterRangesInMm.items[0],
                null,
                unit: millimeter,
                listValues: ringDiameterRangesInMm,
              ),
            ],
          ),
          ConversionParamSetValueModel(
            paramSet: ringSizeByCircumferenceParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(
                circumferenceParam,
                14.6 * pi,
                1,
                unit: millimeter,
                listValues: ringCircumferenceRangesInMm,
              ),
            ],
          ),
        ],
        selectedParamSetCanBeRemoved: true,
        optionalParamSetsExist: true,
        paramSetsCanBeAdded: false,
        selectedIndex: 0,
        totalCount: 2,
      ),
      currentSrc: ConversionUnitValueModel.tuple(
        usaRingSize,
        3,
        null,
        listValues: usaRingSizes,
      ),
      currentUnitValues: [
        ConversionUnitValueModel.tuple(
          usaRingSize,
          3,
          null,
          listValues: usaRingSizes,
        ),
        ConversionUnitValueModel.tuple(
          frRingSize,
          44,
          null,
          listValues: frRingSizes,
        ),
      ],
      expectedParams: ConversionParamSetValueBulkModel(
        paramSetValues: [
          ConversionParamSetValueModel(
            paramSet: ringSizeByDiameterParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(
                diameterParam,
                ringDiameterRangesInMm.items[0],
                null,
                unit: millimeter,
                listValues: ringDiameterRangesInMm,
              ),
            ],
          ),
          ConversionParamSetValueModel(
            paramSet: ringSizeByCircumferenceParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(
                circumferenceParam,
                14.6 * pi,
                1,
                unit: millimeter,
                listValues: ringCircumferenceRangesInMm,
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
      expectedSrc: ConversionUnitValueModel.tuple(
        usaRingSize,
        3.5,
        null,
        listValues: usaRingSizes,
      ),
      expectedUnitValues: [
        ConversionUnitValueModel.tuple(
          usaRingSize,
          3.5,
          null,
          listValues: usaRingSizes,
        ),
        ConversionUnitValueModel.tuple(
          frRingSize,
          null,
          null,
          listValues: frRingSizes,
        ),
      ],
    );
  });

  test(
      "Should leave empty conversion on select the same param set 'By Circumference'",
      () async {
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
              ConversionParamValueModel.tuple(
                diameterParam,
                ringDiameterRangesInMm.items[0],
                null,
                unit: millimeter,
                listValues: ringDiameterRangesInMm,
              )
            ],
          ),
          ConversionParamSetValueModel(
            paramSet: ringSizeByCircumferenceParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(
                circumferenceParam,
                ringCircumferenceRangesInMm.items[0],
                null,
                unit: millimeter,
                listValues: ringCircumferenceRangesInMm,
              )
            ],
          ),
        ],
        selectedParamSetCanBeRemoved: true,
        optionalParamSetsExist: true,
        paramSetsCanBeAdded: false,
        selectedIndex: 0,
        totalCount: 2,
      ),
      expectedParams: ConversionParamSetValueBulkModel(
        paramSetValues: [
          ConversionParamSetValueModel(
            paramSet: ringSizeByDiameterParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(
                diameterParam,
                ringDiameterRangesInMm.items[0],
                null,
                unit: millimeter,
                listValues: ringDiameterRangesInMm,
              )
            ],
          ),
          ConversionParamSetValueModel(
            paramSet: ringSizeByCircumferenceParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(
                circumferenceParam,
                ringCircumferenceRangesInMm.items[0],
                null,
                unit: millimeter,
                listValues: ringCircumferenceRangesInMm,
              )
            ],
          ),
        ],
        selectedParamSetCanBeRemoved: true,
        optionalParamSetsExist: true,
        paramSetsCanBeAdded: false,
        selectedIndex: 1,
        totalCount: 2,
      ),
      currentUnitValues: [],
      expectedUnitValues: [],
    );
  });
}
