import 'package:convertouch/data/repositories/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_item_value_calculation_model.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_item_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_non_list_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/dynamic_data/fetch_dynamic_value_use_use.dart';
import 'package:convertouch/domain/use_cases/list_values/fetch_list_values_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:test/test.dart';

import '../../../model/mock/mock_list_values_batch.dart';
import '../../../model/mock/mock_param.dart';
import '../../../model/mock/mock_unit.dart';
import '../../../model/mock/mock_unit_group.dart';
import '../../../repositories/mock/mock_dynamic_value_repository.dart';
import '../../../repositories/mock/mock_network_repository.dart';
import '../../../repositories/mock/mock_unit_group_repository.dart';

void main() {
  late CalculateParamValueUseValue useCase;

  setUpAll(() {
    const listValueRepository = ListValueRepositoryImpl(
      networkRepository: MockNetworkRepository(),
    );

    useCase = const CalculateParamValueUseValue(
      calculateDefaultValueUseCase: CalculateNonListDefaultValueUseCase(
        fetchDynamicValueUseCase: FetchDynamicValueUseCase(
          dynamicValueRepository: MockDynamicValueRepository(),
        ),
      ),
      fetchListValuesUseCase: FetchListValuesUseCase(
        listValueRepository: listValueRepository,
      ),
      unitGroupRepository: MockUnitGroupRepository(),
    );
  });

  Future<void> testCase({
    required ConversionParamValueModel currentParamValue,
    required ConversionParamValueModel expectedParamValue,
    ConversionParamsModifyDelta? delta,
    required ConversionParamSetValueModel paramSetValue,
    ConversionUnitValueModel? srcUnitValue,
    required UnitGroupModel conversionGroup,
  }) async {
    final modifiedParamValue = ObjectUtils.tryGet(
      await useCase.execute(
        InputParamValueCalculationModel(
          itemValue: currentParamValue,
          paramSetValue: paramSetValue,
          delta: delta,
          srcUnitValue: srcUnitValue,
          conversionGroup: conversionGroup,
        ),
      ),
    );

    expect(
      modifiedParamValue.toJson(saveListValues: true),
      expectedParamValue.toJson(saveListValues: true),
    );
  }

  group("List params", () {
    group("Should init list values of param 'Bar Weight' kg", () {
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
          listValuesFetchResult: barWeightParamKgListValues,
        );

        await testCase(
          conversionGroup: massGroup,
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
          listValuesFetchResult: barWeightParamKgListValues,
        );

        await testCase(
          conversionGroup: massGroup,
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
          listValuesFetchResult: barWeightParamKgListValues,
        );

        await testCase(
          conversionGroup: massGroup,
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

    group("Change param list value", () {
      test("Should change param 'Bar Weight' [kg: 10 -> 20]", () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          barWeightParam,
          10,
          null,
          unit: kilogram,
          listValuesFetchResult: barWeightParamKgListValues,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          barWeightParam,
          20,
          null,
          unit: kilogram,
          listValuesFetchResult: barWeightParamKgListValues,
        );

        await testCase(
          delta: EditConversionParamValueDelta.raw(
            newValue: 20,
            paramId: barWeightParam.id,
            paramSetId: barbellWeightParamSet.id,
          ),
          conversionGroup: massGroup,
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
          barWeightParamPoundListValues.items[0],
          null,
          unit: pound,
          listValuesFetchResult: barWeightParamPoundListValues,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          barWeightParam,
          barWeightParamPoundListValues.items[1],
          null,
          unit: pound,
          listValuesFetchResult: barWeightParamPoundListValues,
        );

        await testCase(
          delta: EditConversionParamValueDelta.raw(
            newValue: barWeightParamPoundListValues.items[1],
            paramId: barWeightParam.id,
            paramSetId: barbellWeightParamSet.id,
          ),
          conversionGroup: massGroup,
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

      test("Should change param 'Height' [m: 1.64-1.7 -> 1.78-1.84]", () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          heightParam,
          manShirtHeightRangesFrom0_164To190InMeter.items[0],
          null,
          unit: meter,
          calculated: false,
          listValuesFetchResult: manShirtHeightRangesFrom0_164To190InMeter,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          heightParam,
          manShirtHeightRangesFrom0_164To190InMeter.items[4],
          null,
          unit: meter,
          calculated: false,
          listValuesFetchResult: manShirtHeightRangesFrom0_164To190InMeter,
        );

        await testCase(
          delta: EditConversionParamValueDelta.raw(
            newValue: manShirtHeightRangesFrom0_164To190InMeter.items[4],
            paramId: heightParam.id,
            paramSetId: heightParam.paramSetId,
          ),
          conversionGroup: clothesSizeGroup,
          paramSetValue: ConversionParamSetValueModel.compact(
            paramSet: clothesSizeParamSet,
            paramValues: [
              (
                personParam,
                "Man",
                null,
                unit: null,
                calculated: false,
                listValuesFetchResult: personParamListValues,
              ),
              (
                garmentParam,
                "Shirt",
                null,
                unit: null,
                calculated: false,
                listValuesFetchResult: garmentParamListValues,
              ),
              (
                heightParam,
                manShirtHeightRangesFrom0_164To190InMeter.items[1],
                null,
                unit: meter,
                calculated: false,
                listValuesFetchResult:
                    manShirtHeightRangesFrom0_164To190InMeter,
              ),
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });
    });

    group("Calculate param value by src value", () {
      test(
          "Should NOT calculate param 'Height' [cm: 162-168 -> 162-168] "
          "in empty conversion (i. e. src value does not exist)", () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          heightParam,
          womanShirtHeightRangesFrom0_156To186InCm.items[2],
          null,
          unit: centimeter,
          calculated: true,
          listValuesFetchResult: womanShirtHeightRangesFrom0_156To186InCm,
        );

        final expectedParamValue = currentParamValue;

        await testCase(
          conversionGroup: clothesSizeGroup,
          paramSetValue: ConversionParamSetValueModel.compact(
            paramSet: clothesSizeParamSet,
            paramValues: [
              (
                personParam,
                "Woman",
                null,
                unit: null,
                calculated: false,
                listValuesFetchResult: personParamListValues,
              ),
              (
                garmentParam,
                "Shirt",
                null,
                unit: null,
                calculated: false,
                listValuesFetchResult: garmentParamListValues,
              ),
              (
                heightParam,
                womanShirtHeightRangesFrom0_156To186InCm.items[2],
                null,
                unit: meter,
                calculated: false,
                listValuesFetchResult: womanShirtHeightRangesFrom0_156To186InCm,
              ),
            ],
          ),
          currentParamValue: currentParamValue,
          expectedParamValue: expectedParamValue,
        );
      });
    });

    group('Replace list param unit', () {
      test("Should change param 'Bar Weight' unit [20 kg -> 44 lb]", () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          barWeightParam,
          20,
          null,
          unit: kilogram,
          listValuesFetchResult: barWeightParamKgListValues,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          barWeightParam,
          barWeightParamPoundListValues.items[1],
          null,
          unit: pound,
          listValuesFetchResult: barWeightParamPoundListValues,
        );

        await testCase(
          delta: ReplaceConversionParamUnitDelta(
            newUnit: pound,
            paramId: barWeightParam.id,
            paramSetId: barbellWeightParamSet.id,
          ),
          conversionGroup: massGroup,
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
          conversionGroup: massGroup,
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
          "Should leave default value of param 'One Side Weight' kg (calculated = false)",
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
          conversionGroup: massGroup,
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
          "Should calculate value of param 'One Side Weight' kg by src value (calculated = true)",
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
          conversionGroup: massGroup,
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
          "Should calculate value of param 'One Side Weight' kg by src value (calculated = true)",
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
          conversionGroup: massGroup,
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
          "Should init default value of param 'One Side Weight' kg (calculated = false)",
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
          conversionGroup: massGroup,
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
          "Should calculate default value of param 'One Side Weight' kg "
          "in empty conversion (i. e. src value does not exist) (calculated = true)",
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
          1,
          unit: kilogram,
          calculated: true,
        );

        await testCase(
          conversionGroup: massGroup,
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
          "Should keep current main value of param 'One Side Weight' kg "
              "in empty conversion (i. e. src value does not exist) (calculated = true)",
              () async {
            final currentParamValue = ConversionParamValueModel.tuple(
              oneSideWeightParam,
              20,
              null,
              unit: kilogram,
              calculated: true,
            );

            final expectedParamValue = ConversionParamValueModel.tuple(
              oneSideWeightParam,
              20,
              null,
              unit: kilogram,
              calculated: true,
            );

            await testCase(
              conversionGroup: massGroup,
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
          conversionGroup: massGroup,
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

    group("Change non-list param value", () {
      test(
          "Should change non-list param 'One Side Weight' main value [kg: 30 -> 45], "
          "should replace empty default value with 1", () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          oneSideWeightParam,
          30,
          null,
          unit: kilogram,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          oneSideWeightParam,
          45,
          1,
          unit: kilogram,
        );

        await testCase(
          delta: EditConversionParamValueDelta.raw(
            newValue: 45,
            paramId: oneSideWeightParam.id,
            paramSetId: oneSideWeightParam.paramSetId,
          ),
          conversionGroup: massGroup,
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
          "Should change non-list param 'One Side Weight' main value [kg: 30 -> <empty>]",
          () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          oneSideWeightParam,
          30,
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
          delta: EditConversionParamValueDelta.raw(
            newValue: null,
            paramId: oneSideWeightParam.id,
            paramSetId: oneSideWeightParam.paramSetId,
          ),
          conversionGroup: massGroup,
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
          "Should change non-list param 'One Side Weight' default value [kg: 2 -> 4]",
          () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          oneSideWeightParam,
          null,
          2,
          unit: kilogram,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          oneSideWeightParam,
          null,
          4,
          unit: kilogram,
        );

        await testCase(
          delta: EditConversionParamValueDelta.raw(
            newDefaultValue: 4,
            paramId: oneSideWeightParam.id,
            paramSetId: oneSideWeightParam.paramSetId,
          ),
          conversionGroup: massGroup,
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
          "Should change non-list param 'One Side Weight' default value [kg: 2 -> <empty>], "
          "should replace empty default value with 1", () async {
        final currentParamValue = ConversionParamValueModel.tuple(
          oneSideWeightParam,
          null,
          2,
          unit: kilogram,
        );

        final expectedParamValue = ConversionParamValueModel.tuple(
          oneSideWeightParam,
          null,
          1,
          unit: kilogram,
        );

        await testCase(
          delta: EditConversionParamValueDelta.raw(
            newDefaultValue: null,
            paramId: oneSideWeightParam.id,
            paramSetId: oneSideWeightParam.paramSetId,
          ),
          conversionGroup: massGroup,
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
        test("Should change param 'One Side Weight' default value", () async {
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
            15 / pound.coefficient!,
            unit: pound,
            calculated: true,
          );

          await testCase(
            delta: ReplaceConversionParamUnitDelta(
              newUnit: pound,
              paramId: oneSideWeightParam.id,
              paramSetId: oneSideWeightParam.paramSetId,
            ),
            conversionGroup: massGroup,
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

        test("Should NOT change param 'One Side Weight' main value", () async {
          final currentParamValue = ConversionParamValueModel.tuple(
            oneSideWeightParam,
            12,
            null,
            unit: kilogram,
            calculated: true,
          );

          final expectedParamValue = ConversionParamValueModel.tuple(
            oneSideWeightParam,
            12 / pound.coefficient!,
            null,
            unit: pound,
            calculated: true,
          );

          await testCase(
            delta: ReplaceConversionParamUnitDelta(
              newUnit: pound,
              paramId: oneSideWeightParam.id,
              paramSetId: oneSideWeightParam.paramSetId,
            ),
            conversionGroup: massGroup,
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
