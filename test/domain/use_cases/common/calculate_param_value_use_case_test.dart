import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_param_value_calculation_model.dart';
import 'package:convertouch/domain/use_cases/common/init_item_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_param_value_use_case.dart';
import 'package:convertouch/domain/use_cases/list_values/fetch_list_values_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:test/test.dart';

import '../../model/mock/mock_list_values_batch.dart';
import '../../model/mock/mock_param.dart';
import '../../model/mock/mock_unit.dart';
import '../../repositories/mock/mock_dynamic_value_repository.dart';
import '../../repositories/mock/mock_network_repository.dart';
import '../../repositories/mock/mock_unit_group_repository.dart';

void main() {
  late CalculateParamValueUseValue useCase;

  setUpAll(() {
    const listValueRepository = ListValueRepositoryImpl(
      networkRepository: MockNetworkRepository(),
    );

    useCase = const CalculateParamValueUseValue(
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
    );
  });

  Future<void> testCase({
    required ConversionParamValueModel currentParamValue,
    required ConversionParamValueModel expectedParamValue,
    ConversionSingleParamModifyDelta? delta,
    required ConversionParamSetValueModel paramSetValue,
    bool alignCurrentValue = true,
    ConversionUnitValueModel? srcUnitValue,
    String? unitGroupName,
  }) async {
    final modifiedParamValue = ObjectUtils.tryGet(
      await useCase.execute(
        InputParamValueCalculationModel(
          paramValue: currentParamValue,
          paramSetValue: paramSetValue,
          delta: delta,
          alignCurrentValue: alignCurrentValue,
          srcUnitValue: srcUnitValue,
          unitGroupName: unitGroupName,
        ),
      ),
    );

    expect(modifiedParamValue.toJson(), expectedParamValue.toJson());
  }

  group("List params", () {
    group("Should init list values of param 'Bar Weight' kg", () {
      group("Should align selected value", () {
        test("Should preselect default list value 10", () async {
          final currentParamValue = ConversionParamValueModel.tuple(
            barWeightParam,
            null,
            null,
            unit: kilogram,
          );

          final expectedParamValue = ConversionParamValueModel.tuple(
            barWeightParam,
            10,
            null,
            unit: kilogram,
            listValues: barWeightParamKgListValues,
          );

          await testCase(
            paramSetValue: ConversionParamSetValueModel(
              paramSet: barbellWeightParamSet,
              paramValues: [
                currentParamValue,
                ConversionParamValueModel.tuple(oneSideWeightParam, 30, 1,
                    unit: kilogram),
              ],
            ),
            currentParamValue: currentParamValue,
            expectedParamValue: expectedParamValue,
          );
        });

        test("Should leave value 20 when it exists in the list", () async {
          final currentParamValue = ConversionParamValueModel.tuple(
            barWeightParam,
            20,
            null,
            unit: kilogram,
          );

          final expectedParamValue = ConversionParamValueModel.tuple(
            barWeightParam,
            20,
            null,
            unit: kilogram,
            listValues: barWeightParamKgListValues,
          );

          await testCase(
            paramSetValue: ConversionParamSetValueModel(
              paramSet: barbellWeightParamSet,
              paramValues: [
                currentParamValue,
                ConversionParamValueModel.tuple(oneSideWeightParam, 30, 1,
                    unit: kilogram),
              ],
            ),
            currentParamValue: currentParamValue,
            expectedParamValue: expectedParamValue,
          );
        });

        test("Should replace unknown value 15 with default value 10", () async {
          final currentParamValue = ConversionParamValueModel.tuple(
            barWeightParam,
            15,
            null,
            unit: kilogram,
          );

          final expectedParamValue = ConversionParamValueModel.tuple(
            barWeightParam,
            10,
            null,
            unit: kilogram,
            listValues: barWeightParamKgListValues,
          );

          await testCase(
            paramSetValue: ConversionParamSetValueModel(
              paramSet: barbellWeightParamSet,
              paramValues: [
                currentParamValue,
                ConversionParamValueModel.tuple(oneSideWeightParam, 30, 1,
                    unit: kilogram),
              ],
            ),
            currentParamValue: currentParamValue,
            expectedParamValue: expectedParamValue,
          );
        });
      });

      group("Should NOT align selected value", () {
        test("Should NOT preselect default value 10 when no value selected",
            () async {
          final currentParamValue = ConversionParamValueModel.tuple(
            barWeightParam,
            null,
            null,
            unit: kilogram,
          );

          final expectedParamValue = ConversionParamValueModel.tuple(
            barWeightParam,
            null,
            null,
            unit: kilogram,
            listValues: barWeightParamKgListValues,
          );

          await testCase(
            alignCurrentValue: false,
            paramSetValue: ConversionParamSetValueModel(
              paramSet: barbellWeightParamSet,
              paramValues: [
                currentParamValue,
                ConversionParamValueModel.tuple(oneSideWeightParam, 30, 1,
                    unit: kilogram),
              ],
            ),
            currentParamValue: currentParamValue,
            expectedParamValue: expectedParamValue,
          );
        });

        test("Should leave value 20 when it exists in the list", () async {
          final currentParamValue = ConversionParamValueModel.tuple(
            barWeightParam,
            20,
            null,
            unit: kilogram,
          );

          final expectedParamValue = ConversionParamValueModel.tuple(
            barWeightParam,
            20,
            null,
            unit: kilogram,
            listValues: barWeightParamKgListValues,
          );

          await testCase(
            alignCurrentValue: false,
            paramSetValue: ConversionParamSetValueModel(
              paramSet: barbellWeightParamSet,
              paramValues: [
                currentParamValue,
                ConversionParamValueModel.tuple(oneSideWeightParam, 30, 1,
                    unit: kilogram),
              ],
            ),
            currentParamValue: currentParamValue,
            expectedParamValue: expectedParamValue,
          );
        });

        test("Should NOT replace unknown value 15", () async {
          final currentParamValue = ConversionParamValueModel.tuple(
            barWeightParam,
            15,
            null,
            unit: kilogram,
          );

          final expectedParamValue = ConversionParamValueModel.tuple(
            barWeightParam,
            15,
            null,
            unit: kilogram,
            listValues: barWeightParamKgListValues,
          );

          await testCase(
            alignCurrentValue: false,
            paramSetValue: ConversionParamSetValueModel(
              paramSet: barbellWeightParamSet,
              paramValues: [
                currentParamValue,
                ConversionParamValueModel.tuple(oneSideWeightParam, 30, 1,
                    unit: kilogram),
              ],
            ),
            currentParamValue: currentParamValue,
            expectedParamValue: expectedParamValue,
          );
        });
      });
    });

    group("Change param list value", () {
      test("Should change param 'Bar Weight' [kg: 10 -> 20]", () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          barWeightParam,
          10,
          null,
          unit: kilogram,
          listValues: barWeightParamKgListValues,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          barWeightParam,
          20,
          null,
          unit: kilogram,
          listValues: barWeightParamKgListValues,
        );

        await testCase(
          delta: EditConversionParamValueDelta.raw(
            newValue: 20,
            paramId: barWeightParam.id,
            paramSetId: barbellWeightParamSet.id,
          ),
          paramSetValue: ConversionParamSetValueModel(
            paramSet: barbellWeightParamSet,
            paramValues: [
              currentParamValue,
              ConversionParamValueModel.tuple(oneSideWeightParam, 30, 1,
                  unit: kilogram),
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });

      test("Should change param 'Bar Weight' [lb: 22 -> 44]", () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          barWeightParam,
          22,
          null,
          unit: pound,
          listValues: barWeightParamLbListValues,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          barWeightParam,
          44,
          null,
          unit: pound,
          listValues: barWeightParamLbListValues,
        );

        await testCase(
          delta: EditConversionParamValueDelta.raw(
            newValue: 44,
            paramId: barWeightParam.id,
            paramSetId: barbellWeightParamSet.id,
          ),
          paramSetValue: ConversionParamSetValueModel(
            paramSet: barbellWeightParamSet,
            paramValues: [
              currentParamValue,
              ConversionParamValueModel.tuple(oneSideWeightParam, 30, 1,
                  unit: kilogram),
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });
    });

    group('Replace list param unit', () {
      test("Should change param 'Bar Weight' unit [kg -> lb: 10]", () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          barWeightParam,
          10,
          null,
          unit: kilogram,
          listValues: barWeightParamKgListValues,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          barWeightParam,
          22,
          null,
          unit: pound,
          listValues: barWeightParamLbListValues,
        );

        await testCase(
          delta: ReplaceConversionParamUnitDelta(
            newUnit: pound,
            paramId: barWeightParam.id,
            paramSetId: barbellWeightParamSet.id,
          ),
          paramSetValue: ConversionParamSetValueModel(
            paramSet: barbellWeightParamSet,
            paramValues: [
              currentParamValue,
              ConversionParamValueModel.tuple(oneSideWeightParam, 30, 1,
                  unit: kilogram),
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });
    });
  });

  group("Non-list params", () {
    group("Should calculate value of param 'One Side Weight' kg", () {
      test(
          "Should initially calculate default value of param 'One Side Weight' kg (calculated = false)",
          () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          oneSideWeightParam,
          null,
          null,
          unit: kilogram,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          oneSideWeightParam,
          null,
          1,
          unit: kilogram,
        );

        await testCase(
          paramSetValue: ConversionParamSetValueModel(
            paramSet: barbellWeightParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(
                barWeightParam,
                null,
                null,
                unit: kilogram,
              ),
              currentParamValue,
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });

      test(
          "Should recalculate default value of param 'One Side Weight' kg (calculated = false)",
          () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          oneSideWeightParam,
          null,
          20,
          unit: kilogram,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          oneSideWeightParam,
          null,
          1,
          unit: kilogram,
        );

        await testCase(
          paramSetValue: ConversionParamSetValueModel(
            paramSet: barbellWeightParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(
                barWeightParam,
                null,
                null,
                unit: kilogram,
              ),
              currentParamValue,
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });

      test(
          "Should calculate value of param 'One Side Weight' kg by src value (calculated = true, alignCurrentValue = true)",
          () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          oneSideWeightParam,
          null,
          null,
          unit: kilogram,
          calculated: true,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          oneSideWeightParam,
          null,
          25,
          unit: kilogram,
          calculated: true,
        );

        await testCase(
          srcUnitValue: ConversionUnitValueModel.tuple(kilogram, 60, 1),
          unitGroupName: GroupNames.mass,
          paramSetValue: ConversionParamSetValueModel(
            paramSet: barbellWeightParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(
                barWeightParam,
                10,
                null,
                unit: kilogram,
              ),
              currentParamValue,
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });

      test(
          "Should calculate value of param 'One Side Weight' kg by src value (calculated = true, alignCurrentValue = false)",
          () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          oneSideWeightParam,
          null,
          null,
          unit: kilogram,
          calculated: true,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          oneSideWeightParam,
          null,
          25,
          unit: kilogram,
          calculated: true,
        );

        await testCase(
          alignCurrentValue: false,
          srcUnitValue: ConversionUnitValueModel.tuple(kilogram, 60, 1),
          unitGroupName: GroupNames.mass,
          paramSetValue: ConversionParamSetValueModel(
            paramSet: barbellWeightParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(
                barWeightParam,
                10,
                null,
                unit: kilogram,
              ),
              currentParamValue,
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });

      test(
          "Should recalculate default value of param 'One Side Weight' kg"
          " since it should NOT calculate by empty src value (calculated = true), ",
          () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          oneSideWeightParam,
          null,
          20,
          unit: kilogram,
          calculated: true,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          oneSideWeightParam,
          null,
          1,
          unit: kilogram,
          calculated: true,
        );

        await testCase(
          paramSetValue: ConversionParamSetValueModel(
            paramSet: barbellWeightParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(
                barWeightParam,
                null,
                null,
                unit: kilogram,
              ),
              currentParamValue,
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });
    });

    group("Should NOT calculate value of param 'One Side Weight' kg", () {
      test(
          "Should NOT initially calculate default value of param 'One Side Weight' kg (calculated = false)",
          () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          oneSideWeightParam,
          null,
          null,
          unit: kilogram,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          oneSideWeightParam,
          null,
          null,
          unit: kilogram,
        );

        await testCase(
          alignCurrentValue: false,
          paramSetValue: ConversionParamSetValueModel(
            paramSet: barbellWeightParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(
                barWeightParam,
                null,
                null,
                unit: kilogram,
              ),
              currentParamValue,
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });

      test(
          "Should NOT recalculate default value of param 'One Side Weight' kg (calculated = false)",
          () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          oneSideWeightParam,
          null,
          20,
          unit: kilogram,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          oneSideWeightParam,
          null,
          20,
          unit: kilogram,
        );

        await testCase(
          alignCurrentValue: false,
          paramSetValue: ConversionParamSetValueModel(
            paramSet: barbellWeightParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(
                barWeightParam,
                null,
                null,
                unit: kilogram,
              ),
              currentParamValue,
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });

      test(
          "Should NOT recalculate default value of param 'One Side Weight' kg"
          " since it should NOT calculate by empty src value (calculated = true), ",
          () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          oneSideWeightParam,
          null,
          20,
          unit: kilogram,
          calculated: true,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          oneSideWeightParam,
          null,
          20,
          unit: kilogram,
          calculated: true,
        );

        await testCase(
          alignCurrentValue: false,
          paramSetValue: ConversionParamSetValueModel(
            paramSet: barbellWeightParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(
                barWeightParam,
                null,
                null,
                unit: kilogram,
              ),
              currentParamValue,
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });
    });

    group('Replace non-list param unit', () {
      group("Should change param 'One Side Weight' unit [kg -> lb: 15]", () {
        test(
            "Should NOT change param 'One Side Weight' default value (alignCurrentValue = false)",
            () async {
          final currentParamValue = ConversionParamValueModel.tuple(
            oneSideWeightParam,
            null,
            15,
            unit: kilogram,
            calculated: true,
          );

          final expectedParamValue = ConversionParamValueModel.tuple(
            oneSideWeightParam,
            null,
            15,
            unit: pound,
            calculated: true,
          );

          await testCase(
            alignCurrentValue: false,
            delta: ReplaceConversionParamUnitDelta(
              newUnit: pound,
              paramId: oneSideWeightParam.id,
              paramSetId: oneSideWeightParam.paramSetId,
            ),
            paramSetValue: ConversionParamSetValueModel(
              paramSet: barbellWeightParamSet,
              paramValues: [
                ConversionParamValueModel.tuple(
                  barWeightParam,
                  null,
                  null,
                  unit: kilogram,
                ),
                currentParamValue,
              ],
            ),
            currentParamValue: currentParamValue,
            expectedParamValue: expectedParamValue,
          );
        });

        test(
            "Should change param 'One Side Weight' default value (alignCurrentValue = true)",
            () async {
          final currentParamValue = ConversionParamValueModel.tuple(
            oneSideWeightParam,
            null,
            15,
            unit: kilogram,
            calculated: true,
          );

          final expectedParamValue = ConversionParamValueModel.tuple(
            oneSideWeightParam,
            null,
            1,
            unit: pound,
            calculated: true,
          );

          await testCase(
            delta: ReplaceConversionParamUnitDelta(
              newUnit: pound,
              paramId: oneSideWeightParam.id,
              paramSetId: oneSideWeightParam.paramSetId,
            ),
            paramSetValue: ConversionParamSetValueModel(
              paramSet: barbellWeightParamSet,
              paramValues: [
                ConversionParamValueModel.tuple(
                  barWeightParam,
                  null,
                  null,
                  unit: kilogram,
                ),
                currentParamValue,
              ],
            ),
            currentParamValue: currentParamValue,
            expectedParamValue: expectedParamValue,
          );
        });

        test(
            "Should NOT change param 'One Side Weight' value (alignCurrentValue = false)",
            () async {
          final currentParamValue = ConversionParamValueModel.tuple(
            oneSideWeightParam,
            12,
            null,
            unit: kilogram,
            calculated: true,
          );

          final expectedParamValue = ConversionParamValueModel.tuple(
            oneSideWeightParam,
            12,
            null,
            unit: pound,
            calculated: true,
          );

          await testCase(
            alignCurrentValue: false,
            delta: ReplaceConversionParamUnitDelta(
              newUnit: pound,
              paramId: oneSideWeightParam.id,
              paramSetId: oneSideWeightParam.paramSetId,
            ),
            paramSetValue: ConversionParamSetValueModel(
              paramSet: barbellWeightParamSet,
              paramValues: [
                ConversionParamValueModel.tuple(
                  barWeightParam,
                  null,
                  null,
                  unit: kilogram,
                ),
                currentParamValue,
              ],
            ),
            currentParamValue: currentParamValue,
            expectedParamValue: expectedParamValue,
          );
        });

        test(
            "Should NOT change param 'One Side Weight' value (alignCurrentValue = true)",
            () async {
          final currentParamValue = ConversionParamValueModel.tuple(
            oneSideWeightParam,
            12,
            null,
            unit: kilogram,
            calculated: true,
          );

          final expectedParamValue = ConversionParamValueModel.tuple(
            oneSideWeightParam,
            12,
            1,
            unit: pound,
            calculated: true,
          );

          await testCase(
            delta: ReplaceConversionParamUnitDelta(
              newUnit: pound,
              paramId: oneSideWeightParam.id,
              paramSetId: oneSideWeightParam.paramSetId,
            ),
            paramSetValue: ConversionParamSetValueModel(
              paramSet: barbellWeightParamSet,
              paramValues: [
                ConversionParamValueModel.tuple(
                  barWeightParam,
                  null,
                  null,
                  unit: kilogram,
                ),
                currentParamValue,
              ],
            ),
            currentParamValue: currentParamValue,
            expectedParamValue: expectedParamValue,
          );
        });
      });
    });
  });
}
