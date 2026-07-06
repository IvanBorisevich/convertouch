import 'package:convertouch/data/repositories/list_value_repository_impl.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/settings.dart';
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

void main() {
  late CalculateUnitValueUseValue useCase;

  setUpAll(() {
    const listValueRepository = ListValueRepositoryImpl(
      networkRepository: MockNetworkRepository(),
    );

    useCase = const CalculateUnitValueUseValue(
      calculateDefaultValueUseCase: CalculateNonListDefaultValueUseCase(
        fetchDynamicValueUseCase: FetchDynamicValueUseCase(
          dynamicValueRepository: MockDynamicValueRepository(),
        ),
      ),
      fetchListValuesUseCase: FetchListValuesUseCase(
        listValueRepository: listValueRepository,
      ),
    );
  });

  Future<void> testCase({
    required ConversionUnitValueModel currentUnitValue,
    required ConversionUnitValueModel expectedUnitValue,
    ConversionUnitValuesModifyDelta? delta,
    ConversionParamSetValueModel? paramSetValue,
    bool calculateByParams = false,
    required UnitGroupModel conversionGroup,
  }) async {
    final modifiedUnitValue = ObjectUtils.tryGet(
      await useCase.execute(
        InputUnitValueCalculationModel(
          itemValue: currentUnitValue,
          paramSetValue: paramSetValue,
          delta: delta,
          calculateByParams: calculateByParams,
          conversionGroup: conversionGroup,
        ),
      ),
    );

    expect(
      modifiedUnitValue.toJson(),
      expectedUnitValue.toJson(),
    );
  }

  group("List unit values - clothes size", () {
    group("Should init list values of item 'JP'", () {
      test(
          "Should / shouldn't preselect default list value 'S' "
          "(depends on the param 'preselected' of the list type)", () async {
        final currentUnitValue = ConversionUnitValueModel.tuple(
          jpClothesSize,
          null,
          null,
        );

        final expectedUnitValue = ConversionUnitValueModel.tuple(
          jpClothesSize,
          ConvertouchListType.clothesSizeJp.preselected
              ? japanClothesSizes.items[0]
              : null,
          null,
          listValuesFetchResult: japanClothesSizes,
        );

        await testCase(
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
                listValuesFetchResult: null
              ),
              (
                garmentParam,
                "Shirt",
                null,
                unit: null,
                calculated: false,
                listValuesFetchResult: null
              ),
              (
                heightParam,
                manShirtHeightRangesFrom0_164To190InCm.items[0],
                null,
                unit: centimeter,
                calculated: false,
                listValuesFetchResult: manShirtHeightRangesFrom0_164To190InCm
              ),
            ],
          ),
          currentUnitValue: currentUnitValue,
          expectedUnitValue: expectedUnitValue,
        );
      });

      test("Should leave value '3L' when it exists in the list", () async {
        final currentUnitValue = ConversionUnitValueModel.tuple(
          jpClothesSize,
          '3L',
          null,
        );

        final expectedUnitValue = ConversionUnitValueModel.tuple(
          jpClothesSize,
          japanClothesSizes.items[4],
          null,
          listValuesFetchResult: japanClothesSizes,
        );

        await testCase(
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
                listValuesFetchResult: null
              ),
              (
                garmentParam,
                "Shirt",
                null,
                unit: null,
                calculated: false,
                listValuesFetchResult: null
              ),
              (
                heightParam,
                manShirtHeightRangesFrom0_164To190InCm.items[0],
                null,
                unit: centimeter,
                calculated: false,
                listValuesFetchResult: manShirtHeightRangesFrom0_164To190InCm
              ),
            ],
          ),
          currentUnitValue: currentUnitValue,
          expectedUnitValue: expectedUnitValue,
        );
      });

      test(
          "Should / shouldn't replace unknown value 'W' with default value 'S' "
          "(depends on the param 'preselected' of the list type)", () async {
        final currentUnitValue = ConversionUnitValueModel.tuple(
          jpClothesSize,
          'W',
          null,
        );

        final expectedUnitValue = ConversionUnitValueModel.tuple(
          jpClothesSize,
          ConvertouchListType.clothesSizeJp.preselected
              ? japanClothesSizes.items[0]
              : 'W',
          null,
          listValuesFetchResult: japanClothesSizes,
        );

        await testCase(
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
                listValuesFetchResult: null
              ),
              (
                garmentParam,
                "Shirt",
                null,
                unit: null,
                calculated: false,
                listValuesFetchResult: null
              ),
              (
                heightParam,
                manShirtHeightRangesFrom0_164To190InCm.items[0],
                null,
                unit: centimeter,
                calculated: false,
                listValuesFetchResult: manShirtHeightRangesFrom0_164To190InCm
              ),
            ],
          ),
          currentUnitValue: currentUnitValue,
          expectedUnitValue: expectedUnitValue,
        );
      });
    });

    group("Change list conversion item value", () {
      test("Should change list value [JP: 'S' -> 'M']", () async {
        final currentUnitValue = ConversionUnitValueModel.tuple(
          jpClothesSize,
          null,
          null,
        );

        final expectedUnitValue = ConversionUnitValueModel.tuple(
          jpClothesSize,
          japanClothesSizes.items[1],
          null,
          listValuesFetchResult: japanClothesSizes,
        );

        await testCase(
          delta: EditConversionUnitValueDelta.raw(
            newValue: 'M',
            unitId: jpClothesSize.id,
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
                listValuesFetchResult: null
              ),
              (
                garmentParam,
                "Shirt",
                null,
                unit: null,
                calculated: false,
                listValuesFetchResult: null
              ),
              (
                heightParam,
                manShirtHeightRangesFrom0_164To190InCm.items[0],
                null,
                unit: centimeter,
                calculated: false,
                listValuesFetchResult: manShirtHeightRangesFrom0_164To190InCm
              ),
            ],
          ),
          currentUnitValue: currentUnitValue,
          expectedUnitValue: expectedUnitValue,
        );
      });
    });

    group('Replace list conversion item unit', () {
      test("Should change list value ['M' JP -> 44 EU]", () async {
        final currentUnitValue = ConversionUnitValueModel.tuple(
          jpClothesSize,
          japanClothesSizes.items[1],
          null,
          listValuesFetchResult: japanClothesSizes,
        );

        final expectedUnitValue = ConversionUnitValueModel.tuple(
          euClothesSize,
          europeanClothesSizes.items[5],
          null,
          listValuesFetchResult: europeanClothesSizes,
        );

        await testCase(
          delta: ReplaceConversionItemUnitDelta(
            newUnit: euClothesSize,
            unitId: jpClothesSize.id,
            recalculationMode: RecalculationOnUnitChange.currentValue,
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
                listValuesFetchResult: null
              ),
              (
                garmentParam,
                "Shirt",
                null,
                unit: null,
                calculated: false,
                listValuesFetchResult: null
              ),
              (
                heightParam,
                manShirtHeightRangesFrom0_164To190InCm.items[1],
                null,
                unit: centimeter,
                calculated: false,
                listValuesFetchResult: manShirtHeightRangesFrom0_164To190InCm
              ),
            ],
          ),
          currentUnitValue: currentUnitValue,
          expectedUnitValue: expectedUnitValue,
        );
      });

      test("Should change list value ['M' JP -> null EU] (params NOT full)",
          () async {
        final currentUnitValue = ConversionUnitValueModel.tuple(
          jpClothesSize,
          japanClothesSizes.items[1],
          null,
          listValuesFetchResult: japanClothesSizes,
        );

        final expectedUnitValue = ConversionUnitValueModel.tuple(
          euClothesSize,
          null,
          null,
          listValuesFetchResult: europeanClothesSizes,
        );

        await testCase(
          delta: ReplaceConversionItemUnitDelta(
            newUnit: euClothesSize,
            unitId: jpClothesSize.id,
            recalculationMode: RecalculationOnUnitChange.currentValue,
          ),
          conversionGroup: clothesSizeGroup,
          paramSetValue: ConversionParamSetValueModel.compact(
            paramSet: clothesSizeParamSet,
            paramValues: [
              (
                personParam,
                null,
                null,
                unit: null,
                calculated: false,
                listValuesFetchResult: null
              ),
              (
                garmentParam,
                "Shirt",
                null,
                unit: null,
                calculated: false,
                listValuesFetchResult: null
              ),
              (
                heightParam,
                manShirtHeightRangesFrom0_164To190InCm.items[1],
                null,
                unit: centimeter,
                calculated: false,
                listValuesFetchResult: manShirtHeightRangesFrom0_164To190InCm
              ),
            ],
          ),
          currentUnitValue: currentUnitValue,
          expectedUnitValue: expectedUnitValue,
        );
      });
    });

    group('Should calculate list value by params', () {
      test(
          "Should calculate list value 'M' JP (clothes size, mandatory params full)",
          () async {
        final currentUnitValue = ConversionUnitValueModel.tuple(
          jpClothesSize,
          null,
          null,
        );

        final expectedUnitValue = ConversionUnitValueModel.tuple(
          jpClothesSize,
          japanClothesSizes.items[1],
          null,
          listValuesFetchResult: japanClothesSizes,
        );

        await testCase(
          calculateByParams: true,
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
                listValuesFetchResult: null
              ),
              (
                garmentParam,
                "Shirt",
                null,
                unit: null,
                calculated: false,
                listValuesFetchResult: null
              ),
              (
                heightParam,
                manShirtHeightRangesFrom0_164To190InCm.items[1],
                null,
                unit: centimeter,
                calculated: false,
                listValuesFetchResult: manShirtHeightRangesFrom0_164To190InCm
              ),
            ],
          ),
          currentUnitValue: currentUnitValue,
          expectedUnitValue: expectedUnitValue,
        );
      });

      test(
          "Should calculate list value <empty> JP (clothes size, mandatory params NOT full)",
          () async {
        final currentUnitValue = ConversionUnitValueModel.tuple(
          jpClothesSize,
          null,
          null,
        );

        final expectedUnitValue = ConversionUnitValueModel.tuple(
          jpClothesSize,
          null,
          null,
          listValuesFetchResult: japanClothesSizes,
        );

        await testCase(
          calculateByParams: true,
          conversionGroup: clothesSizeGroup,
          paramSetValue: ConversionParamSetValueModel.compact(
            paramSet: clothesSizeParamSet,
            paramValues: [
              (
                personParam,
                null,
                null,
                unit: null,
                calculated: false,
                listValuesFetchResult: null
              ),
              (
                garmentParam,
                "Shirt",
                null,
                unit: null,
                calculated: false,
                listValuesFetchResult: null
              ),
              (
                heightParam,
                manShirtHeightRangesFrom0_164To190InCm.items[1],
                null,
                unit: centimeter,
                calculated: false,
                listValuesFetchResult: manShirtHeightRangesFrom0_164To190InCm
              ),
            ],
          ),
          currentUnitValue: currentUnitValue,
          expectedUnitValue: expectedUnitValue,
        );
      });

      test(
          "Should calculate list value 6.5 ES (ring size, optional params full, "
          "main value provided)", () async {
        final currentUnitValue = ConversionUnitValueModel.tuple(
          esRingSize,
          null,
          null,
        );

        final expectedUnitValue = ConversionUnitValueModel.tuple(
          esRingSize,
          esRingSizes.items[1],
          null,
          listValuesFetchResult: esRingSizes,
        );

        await testCase(
          calculateByParams: true,
          conversionGroup: ringSizeGroup,
          paramSetValue: ConversionParamSetValueModel.compact(
            paramSet: ringSizeByDiameterParamSet,
            paramValues: [
              (
                diameterParam,
                ringDiameterRangesInMm.items[2],
                null,
                unit: millimeter,
                calculated: false,
                listValuesFetchResult: ringDiameterRangesInMm,
              ),
            ],
          ),
          currentUnitValue: currentUnitValue,
          expectedUnitValue: expectedUnitValue,
        );
      });

      test(
          "Should calculate list value 6.5 ES (ring size, optional params full, "
          "default value provided)", () async {
        final currentUnitValue = ConversionUnitValueModel.tuple(
          esRingSize,
          null,
          null,
        );

        final expectedUnitValue = ConversionUnitValueModel.tuple(
          esRingSize,
          esRingSizes.items[1],
          null,
          listValuesFetchResult: esRingSizes,
        );

        await testCase(
          calculateByParams: true,
          conversionGroup: ringSizeGroup,
          paramSetValue: ConversionParamSetValueModel.compact(
            paramSet: ringSizeByDiameterParamSet,
            paramValues: [
              (
                diameterParam,
                ringDiameterRangesInMm.items[2],
                null,
                unit: millimeter,
                calculated: false,
                listValuesFetchResult: ringDiameterRangesInMm,
              ),
            ],
          ),
          currentUnitValue: currentUnitValue,
          expectedUnitValue: expectedUnitValue,
        );
      });

      test(
          "Should calculate default list value 4 ES (ring size, optional params NOT full)",
          () async {
        final currentUnitValue = ConversionUnitValueModel.tuple(
          esRingSize,
          null,
          null,
        );

        final expectedUnitValue = ConversionUnitValueModel.tuple(
          esRingSize,
          esRingSizes.items[0],
          null,
          listValuesFetchResult: esRingSizes,
        );

        await testCase(
          calculateByParams: true,
          conversionGroup: ringSizeGroup,
          paramSetValue: ConversionParamSetValueModel.compact(
            paramSet: ringSizeByDiameterParamSet,
            paramValues: const [
              (
                diameterParam,
                null,
                null,
                unit: millimeter,
                calculated: false,
                listValuesFetchResult: null,
              ),
            ],
          ),
          currentUnitValue: currentUnitValue,
          expectedUnitValue: expectedUnitValue,
        );
      });

      test(
          "Should calculate default list value 4 ES (ring size, optional params absent)",
          () async {
        final currentUnitValue = ConversionUnitValueModel.tuple(
          esRingSize,
          null,
          null,
        );

        final expectedUnitValue = ConversionUnitValueModel.tuple(
          esRingSize,
          esRingSizes.items[0],
          null,
          listValuesFetchResult: esRingSizes,
        );

        await testCase(
          calculateByParams: true,
          conversionGroup: ringSizeGroup,
          currentUnitValue: currentUnitValue,
          expectedUnitValue: expectedUnitValue,
        );
      });
    });
  });

  group("Non-list unit values - mass", () {
    group("Should calculate unit value 'kg'", () {
      test("Should initially set default unit value '1'", () async {
        final currentUnitValue = ConversionUnitValueModel.tuple(
          kilogram,
          null,
          null,
        );

        final expectedUnitValue = ConversionUnitValueModel.tuple(
          kilogram,
          null,
          '1',
        );

        await testCase(
          conversionGroup: massGroup,
          currentUnitValue: currentUnitValue,
          expectedUnitValue: expectedUnitValue,
        );
      });
    });

    group("Edit non-list conversion item value", () {
      test(
          "Should change non-list main value [kg: 30 -> 45], "
          "should replace empty default value with 1", () async {
        final currentUnitValue = ConversionUnitValueModel.tuple(
          kilogram,
          30,
          null,
        );

        final expectedUnitValue = ConversionUnitValueModel.tuple(
          kilogram,
          45,
          1,
        );

        await testCase(
          delta: EditConversionUnitValueDelta.raw(
            newValue: 45,
            unitId: kilogram.id,
          ),
          conversionGroup: massGroup,
          currentUnitValue: currentUnitValue,
          expectedUnitValue: expectedUnitValue,
        );
      });

      test("Should change non-list main value [kg: 30 -> <empty>]", () async {
        final currentUnitValue = ConversionUnitValueModel.tuple(
          kilogram,
          30,
          null,
        );

        final expectedUnitValue = ConversionUnitValueModel.tuple(
          kilogram,
          null,
          1,
        );

        await testCase(
          delta: EditConversionUnitValueDelta.raw(
            newValue: null,
            unitId: kilogram.id,
          ),
          conversionGroup: massGroup,
          currentUnitValue: currentUnitValue,
          expectedUnitValue: expectedUnitValue,
        );
      });

      test("Should change non-list default value [kg: 30 -> 45]", () async {
        final currentUnitValue = ConversionUnitValueModel.tuple(
          kilogram,
          null,
          30,
        );

        final expectedUnitValue = ConversionUnitValueModel.tuple(
          kilogram,
          null,
          45,
        );

        await testCase(
          delta: EditConversionUnitValueDelta.raw(
            newDefaultValue: 45,
            unitId: kilogram.id,
          ),
          conversionGroup: massGroup,
          currentUnitValue: currentUnitValue,
          expectedUnitValue: expectedUnitValue,
        );
      });

      test(
          "Should change non-list default value [kg: 30 -> 1], "
          "should replace empty default value with 1", () async {
        final currentUnitValue = ConversionUnitValueModel.tuple(
          kilogram,
          null,
          30,
        );

        final expectedUnitValue = ConversionUnitValueModel.tuple(
          kilogram,
          null,
          1,
        );

        await testCase(
          delta: EditConversionUnitValueDelta.raw(
            newDefaultValue: null,
            unitId: kilogram.id,
          ),
          conversionGroup: massGroup,
          currentUnitValue: currentUnitValue,
          expectedUnitValue: expectedUnitValue,
        );
      });
    });

    group('Replace non-list conversion item unit', () {
      test("Should change non-list unit main value [30 kg -> ~66 lb]",
          () async {
        final currentUnitValue = ConversionUnitValueModel.tuple(
          kilogram,
          30,
          null,
        );

        final expectedUnitValue = ConversionUnitValueModel.tuple(
          pound,
          30 / pound.coefficient!,
          1,
        );

        await testCase(
          delta: ReplaceConversionItemUnitDelta(
            newUnit: pound,
            unitId: kilogram.id,
            recalculationMode: RecalculationOnUnitChange.currentValue,
          ),
          conversionGroup: massGroup,
          currentUnitValue: currentUnitValue,
          expectedUnitValue: expectedUnitValue,
        );
      });

      test("Should change non-list unit default value [1 kg -> ~2.3 lb]",
          () async {
        final currentUnitValue = ConversionUnitValueModel.tuple(
          kilogram,
          null,
          1,
        );

        final expectedUnitValue = ConversionUnitValueModel.tuple(
          pound,
          null,
          1 / pound.coefficient!,
        );

        await testCase(
          delta: ReplaceConversionItemUnitDelta(
            newUnit: pound,
            unitId: kilogram.id,
            recalculationMode: RecalculationOnUnitChange.currentValue,
          ),
          conversionGroup: massGroup,
          currentUnitValue: currentUnitValue,
          expectedUnitValue: expectedUnitValue,
        );
      });

      test("Should NOT change non-list unit main value [30 kg -> 30 lb]",
          () async {
        final currentUnitValue = ConversionUnitValueModel.tuple(
          kilogram,
          30,
          null,
        );

        final expectedUnitValue = ConversionUnitValueModel.tuple(
          pound,
          30,
          1,
        );

        await testCase(
          delta: ReplaceConversionItemUnitDelta(
            newUnit: pound,
            unitId: kilogram.id,
            recalculationMode: RecalculationOnUnitChange.otherValues,
          ),
          conversionGroup: massGroup,
          currentUnitValue: currentUnitValue,
          expectedUnitValue: expectedUnitValue,
        );
      });

      test("Should NOT change non-list unit default value [1 kg -> ~2.3 lb]",
          () async {
        final currentUnitValue = ConversionUnitValueModel.tuple(
          kilogram,
          null,
          2,
        );

        final expectedUnitValue = ConversionUnitValueModel.tuple(
          pound,
          null,
          2,
        );

        await testCase(
          delta: ReplaceConversionItemUnitDelta(
            newUnit: pound,
            unitId: kilogram.id,
            recalculationMode: RecalculationOnUnitChange.otherValues,
          ),
          conversionGroup: massGroup,
          currentUnitValue: currentUnitValue,
          expectedUnitValue: expectedUnitValue,
        );
      });
    });
  });
}
