import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_unit_value_calculation_model.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_unit_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/init_item_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/list_values/fetch_list_values_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:test/test.dart';

import '../../../model/mock/mock_list_values_batch.dart';
import '../../../model/mock/mock_param.dart';
import '../../../model/mock/mock_unit.dart';
import '../../../repositories/mock/mock_dynamic_value_repository.dart';
import '../../../repositories/mock/mock_network_repository.dart';
import '../../../repositories/mock/mock_unit_group_repository.dart';

void main() {
  late CalculateUnitValueUseValue useCase;

  setUpAll(() {
    const listValueRepository = ListValueRepositoryImpl(
      networkRepository: MockNetworkRepository(),
    );

    useCase = const CalculateUnitValueUseValue(
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
    );
  });

  Future<void> testCase({
    required ConversionUnitValueModel currentUnitValue,
    required ConversionUnitValueModel expectedUnitValue,
    ConversionSingleUnitModifyDelta? delta,
    ConversionParamSetValueModel? paramSetValue,
    bool alignCurrentValue = true,
    bool calculateByParams = false,
    String? unitGroupName,
  }) async {
    final modifiedUnitValue = ObjectUtils.tryGet(
      await useCase.execute(
        InputUnitValueCalculationModel(
          unitValue: currentUnitValue,
          paramSetValue: paramSetValue,
          delta: delta,
          alignCurrentValue: alignCurrentValue,
          calculateByParams: calculateByParams,
          unitGroupName: unitGroupName,
        ),
      ),
    );

    expect(modifiedUnitValue.toJson(), expectedUnitValue.toJson());
  }

  group("List unit values - clothes size", () {
    group("Should init list values of item 'JP'", () {
      group("Should align selected value", () {
        test("Should preselect default list value 'S'", () async {
          final currentUnitValue = ConversionUnitValueModel.tuple(
            japanClothSize,
            null,
            null,
          );

          final expectedUnitValue = ConversionUnitValueModel.tuple(
            japanClothSize,
            japanClothesSizes.items[0].valueModel,
            null,
            listValues: japanClothesSizes,
          );

          await testCase(
            paramSetValue: ConversionParamSetValueModel.compact(
              paramSet: clothesSizeParamSet,
              paramValues: [
                (
                  personParam,
                  "Man",
                  null,
                  unit: null,
                  calculated: false,
                  listValues: null
                ),
                (
                  garmentParam,
                  "Shirt",
                  null,
                  unit: null,
                  calculated: false,
                  listValues: null
                ),
                (
                  heightParam,
                  manShirtHeightRangesFrom0_164To190InCm.items[0].valueModel,
                  null,
                  unit: centimeter,
                  calculated: false,
                  listValues: manShirtHeightRangesFrom0_164To190InCm
                ),
              ],
            ),
            currentUnitValue: currentUnitValue,
            expectedUnitValue: expectedUnitValue,
          );
        });

        test("Should leave value '3L' when it exists in the list", () async {
          final currentUnitValue = ConversionUnitValueModel.tuple(
            japanClothSize,
            '3L',
            null,
          );

          final expectedUnitValue = ConversionUnitValueModel.tuple(
            japanClothSize,
            japanClothesSizes.items[4].valueModel,
            null,
            listValues: japanClothesSizes,
          );

          await testCase(
            paramSetValue: ConversionParamSetValueModel.compact(
              paramSet: clothesSizeParamSet,
              paramValues: [
                (
                  personParam,
                  "Man",
                  null,
                  unit: null,
                  calculated: false,
                  listValues: null
                ),
                (
                  garmentParam,
                  "Shirt",
                  null,
                  unit: null,
                  calculated: false,
                  listValues: null
                ),
                (
                  heightParam,
                  manShirtHeightRangesFrom0_164To190InCm.items[0].valueModel,
                  null,
                  unit: centimeter,
                  calculated: false,
                  listValues: manShirtHeightRangesFrom0_164To190InCm
                ),
              ],
            ),
            currentUnitValue: currentUnitValue,
            expectedUnitValue: expectedUnitValue,
          );
        });

        test("Should replace unknown value 'W' with default value 'S'",
            () async {
          final currentUnitValue = ConversionUnitValueModel.tuple(
            japanClothSize,
            'W',
            null,
          );

          final expectedUnitValue = ConversionUnitValueModel.tuple(
            japanClothSize,
            japanClothesSizes.items[0].valueModel,
            null,
            listValues: japanClothesSizes,
          );

          await testCase(
            paramSetValue: ConversionParamSetValueModel.compact(
              paramSet: clothesSizeParamSet,
              paramValues: [
                (
                  personParam,
                  "Man",
                  null,
                  unit: null,
                  calculated: false,
                  listValues: null
                ),
                (
                  garmentParam,
                  "Shirt",
                  null,
                  unit: null,
                  calculated: false,
                  listValues: null
                ),
                (
                  heightParam,
                  manShirtHeightRangesFrom0_164To190InCm.items[0].valueModel,
                  null,
                  unit: centimeter,
                  calculated: false,
                  listValues: manShirtHeightRangesFrom0_164To190InCm
                ),
              ],
            ),
            currentUnitValue: currentUnitValue,
            expectedUnitValue: expectedUnitValue,
          );
        });
      });

      group("Should NOT align selected value", () {
        test(
            "Should NOT preselect default list value 'S' (align = false, params full)",
            () async {
          final currentUnitValue = ConversionUnitValueModel.tuple(
            japanClothSize,
            null,
            null,
          );

          final expectedUnitValue = ConversionUnitValueModel.tuple(
            japanClothSize,
            null,
            null,
            listValues: japanClothesSizes,
          );

          await testCase(
            alignCurrentValue: false,
            paramSetValue: ConversionParamSetValueModel.compact(
              paramSet: clothesSizeParamSet,
              paramValues: [
                (
                  personParam,
                  "Man",
                  null,
                  unit: null,
                  calculated: false,
                  listValues: null
                ),
                (
                  garmentParam,
                  "Shirt",
                  null,
                  unit: null,
                  calculated: false,
                  listValues: null
                ),
                (
                  heightParam,
                  manShirtHeightRangesFrom0_164To190InCm.items[0].valueModel,
                  null,
                  unit: centimeter,
                  calculated: false,
                  listValues: manShirtHeightRangesFrom0_164To190InCm
                ),
              ],
            ),
            currentUnitValue: currentUnitValue,
            expectedUnitValue: expectedUnitValue,
          );
        });

        test(
            "Should NOT preselect default list value 'S' (align = true, params NOT full)",
            () async {
          final currentUnitValue = ConversionUnitValueModel.tuple(
            japanClothSize,
            null,
            null,
          );

          final expectedUnitValue = ConversionUnitValueModel.tuple(
            japanClothSize,
            null,
            null,
            listValues: japanClothesSizes,
          );

          await testCase(
            paramSetValue: ConversionParamSetValueModel.compact(
              paramSet: clothesSizeParamSet,
              paramValues: [
                (
                  personParam,
                  null,
                  null,
                  unit: null,
                  calculated: false,
                  listValues: null
                ),
                (
                  garmentParam,
                  "Shirt",
                  null,
                  unit: null,
                  calculated: false,
                  listValues: null
                ),
                (
                  heightParam,
                  manShirtHeightRangesFrom0_164To190InCm.items[0].valueModel,
                  null,
                  unit: centimeter,
                  calculated: false,
                  listValues: manShirtHeightRangesFrom0_164To190InCm
                ),
              ],
            ),
            currentUnitValue: currentUnitValue,
            expectedUnitValue: expectedUnitValue,
          );
        });

        test(
            "Should NOT preselect default list value 'S' (align = false, params NOT full)",
            () async {
          final currentUnitValue = ConversionUnitValueModel.tuple(
            japanClothSize,
            null,
            null,
          );

          final expectedUnitValue = ConversionUnitValueModel.tuple(
            japanClothSize,
            null,
            null,
            listValues: japanClothesSizes,
          );

          await testCase(
            alignCurrentValue: false,
            paramSetValue: ConversionParamSetValueModel.compact(
              paramSet: clothesSizeParamSet,
              paramValues: [
                (
                  personParam,
                  null,
                  null,
                  unit: null,
                  calculated: false,
                  listValues: null
                ),
                (
                  garmentParam,
                  "Shirt",
                  null,
                  unit: null,
                  calculated: false,
                  listValues: null
                ),
                (
                  heightParam,
                  manShirtHeightRangesFrom0_164To190InCm.items[0].valueModel,
                  null,
                  unit: centimeter,
                  calculated: false,
                  listValues: manShirtHeightRangesFrom0_164To190InCm
                ),
              ],
            ),
            currentUnitValue: currentUnitValue,
            expectedUnitValue: expectedUnitValue,
          );
        });

        test("Should leave value '3L' when it exists in the list", () async {
          final currentUnitValue = ConversionUnitValueModel.tuple(
            japanClothSize,
            '3L',
            null,
          );

          final expectedUnitValue = ConversionUnitValueModel.tuple(
            japanClothSize,
            '3L',
            null,
            listValues: japanClothesSizes,
          );

          await testCase(
            alignCurrentValue: false,
            paramSetValue: ConversionParamSetValueModel.compact(
              paramSet: clothesSizeParamSet,
              paramValues: [
                (
                  personParam,
                  "Man",
                  null,
                  unit: null,
                  calculated: false,
                  listValues: null
                ),
                (
                  garmentParam,
                  "Shirt",
                  null,
                  unit: null,
                  calculated: false,
                  listValues: null
                ),
                (
                  heightParam,
                  manShirtHeightRangesFrom0_164To190InCm.items[0].valueModel,
                  null,
                  unit: centimeter,
                  calculated: false,
                  listValues: manShirtHeightRangesFrom0_164To190InCm
                ),
              ],
            ),
            currentUnitValue: currentUnitValue,
            expectedUnitValue: expectedUnitValue,
          );
        });

        test("Should leave unknown value 'W'", () async {
          final currentUnitValue = ConversionUnitValueModel.tuple(
            japanClothSize,
            'W',
            null,
          );

          final expectedUnitValue = ConversionUnitValueModel.tuple(
            japanClothSize,
            'W',
            null,
            listValues: japanClothesSizes,
          );

          await testCase(
            alignCurrentValue: false,
            paramSetValue: ConversionParamSetValueModel.compact(
              paramSet: clothesSizeParamSet,
              paramValues: [
                (
                  personParam,
                  "Man",
                  null,
                  unit: null,
                  calculated: false,
                  listValues: null
                ),
                (
                  garmentParam,
                  "Shirt",
                  null,
                  unit: null,
                  calculated: false,
                  listValues: null
                ),
                (
                  heightParam,
                  manShirtHeightRangesFrom0_164To190InCm.items[0].valueModel,
                  null,
                  unit: centimeter,
                  calculated: false,
                  listValues: manShirtHeightRangesFrom0_164To190InCm
                ),
              ],
            ),
            currentUnitValue: currentUnitValue,
            expectedUnitValue: expectedUnitValue,
          );
        });
      });
    });

    group("Change list conversion item value", () {
      test("Should change list value [JP: 'S' -> 'M']", () async {
        final currentUnitValue = ConversionUnitValueModel.tuple(
          japanClothSize,
          null,
          null,
        );

        final expectedUnitValue = ConversionUnitValueModel.tuple(
          japanClothSize,
          japanClothesSizes.items[1].valueModel,
          null,
          listValues: japanClothesSizes,
        );

        await testCase(
          delta: EditConversionUnitValueDelta.raw(
            newValue: 'M',
            unitId: japanClothSize.id,
          ),
          paramSetValue: ConversionParamSetValueModel.compact(
            paramSet: clothesSizeParamSet,
            paramValues: [
              (
                personParam,
                "Man",
                null,
                unit: null,
                calculated: false,
                listValues: null
              ),
              (
                garmentParam,
                "Shirt",
                null,
                unit: null,
                calculated: false,
                listValues: null
              ),
              (
                heightParam,
                manShirtHeightRangesFrom0_164To190InCm.items[0].valueModel,
                null,
                unit: centimeter,
                calculated: false,
                listValues: manShirtHeightRangesFrom0_164To190InCm
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
          japanClothSize,
          japanClothesSizes.items[1].valueModel,
          null,
          listValues: japanClothesSizes,
        );

        final expectedUnitValue = ConversionUnitValueModel.tuple(
          europeanClothSize,
          europeanClothesSizes.items[5].valueModel,
          null,
          listValues: europeanClothesSizes,
        );

        await testCase(
          delta: ReplaceConversionItemUnitDelta(
            newUnit: europeanClothSize,
            unitId: japanClothSize.id,
            recalculationMode: RecalculationOnUnitChange.currentValue,
          ),
          paramSetValue: ConversionParamSetValueModel.compact(
            paramSet: clothesSizeParamSet,
            paramValues: [
              (
                personParam,
                "Man",
                null,
                unit: null,
                calculated: false,
                listValues: null
              ),
              (
                garmentParam,
                "Shirt",
                null,
                unit: null,
                calculated: false,
                listValues: null
              ),
              (
                heightParam,
                manShirtHeightRangesFrom0_164To190InCm.items[1].valueModel,
                null,
                unit: centimeter,
                calculated: false,
                listValues: manShirtHeightRangesFrom0_164To190InCm
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
          japanClothSize,
          japanClothesSizes.items[1].valueModel,
          null,
          listValues: japanClothesSizes,
        );

        final expectedUnitValue = ConversionUnitValueModel.tuple(
          europeanClothSize,
          null,
          null,
          listValues: europeanClothesSizes,
        );

        await testCase(
          delta: ReplaceConversionItemUnitDelta(
            newUnit: europeanClothSize,
            unitId: japanClothSize.id,
            recalculationMode: RecalculationOnUnitChange.currentValue,
          ),
          paramSetValue: ConversionParamSetValueModel.compact(
            paramSet: clothesSizeParamSet,
            paramValues: [
              (
                personParam,
                null,
                null,
                unit: null,
                calculated: false,
                listValues: null
              ),
              (
                garmentParam,
                "Shirt",
                null,
                unit: null,
                calculated: false,
                listValues: null
              ),
              (
                heightParam,
                manShirtHeightRangesFrom0_164To190InCm.items[1].valueModel,
                null,
                unit: centimeter,
                calculated: false,
                listValues: manShirtHeightRangesFrom0_164To190InCm
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
          japanClothSize,
          null,
          null,
        );

        final expectedUnitValue = ConversionUnitValueModel.tuple(
          japanClothSize,
          japanClothesSizes.items[1].valueModel,
          null,
          listValues: japanClothesSizes,
        );

        await testCase(
          calculateByParams: true,
          unitGroupName: GroupNames.clothesSize,
          paramSetValue: ConversionParamSetValueModel.compact(
            paramSet: clothesSizeParamSet,
            paramValues: [
              (
                personParam,
                "Man",
                null,
                unit: null,
                calculated: false,
                listValues: null
              ),
              (
                garmentParam,
                "Shirt",
                null,
                unit: null,
                calculated: false,
                listValues: null
              ),
              (
                heightParam,
                manShirtHeightRangesFrom0_164To190InCm.items[1].valueModel,
                null,
                unit: centimeter,
                calculated: false,
                listValues: manShirtHeightRangesFrom0_164To190InCm
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
          japanClothSize,
          null,
          null,
        );

        final expectedUnitValue = ConversionUnitValueModel.tuple(
          japanClothSize,
          null,
          null,
          listValues: japanClothesSizes,
        );

        await testCase(
          calculateByParams: true,
          unitGroupName: GroupNames.clothesSize,
          paramSetValue: ConversionParamSetValueModel.compact(
            paramSet: clothesSizeParamSet,
            paramValues: [
              (
                personParam,
                null,
                null,
                unit: null,
                calculated: false,
                listValues: null
              ),
              (
                garmentParam,
                "Shirt",
                null,
                unit: null,
                calculated: false,
                listValues: null
              ),
              (
                heightParam,
                manShirtHeightRangesFrom0_164To190InCm.items[1].valueModel,
                null,
                unit: centimeter,
                calculated: false,
                listValues: manShirtHeightRangesFrom0_164To190InCm
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
          esRingSizes.items[1].valueModel,
          null,
          listValues: esRingSizes,
        );

        await testCase(
          calculateByParams: true,
          unitGroupName: GroupNames.ringSize,
          paramSetValue: ConversionParamSetValueModel.compact(
            paramSet: ringSizeByDiameterParamSet,
            paramValues: [
              (
                diameterParam,
                ringDiameterRangesInMm.items[2].valueModel,
                null,
                unit: millimeter,
                calculated: false,
                listValues: ringDiameterRangesInMm,
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
          esRingSizes.items[1].valueModel,
          null,
          listValues: esRingSizes,
        );

        await testCase(
          calculateByParams: true,
          unitGroupName: GroupNames.ringSize,
          paramSetValue: ConversionParamSetValueModel.compact(
            paramSet: ringSizeByDiameterParamSet,
            paramValues: [
              (
                diameterParam,
                ringDiameterRangesInMm.items[2].valueModel,
                null,
                unit: millimeter,
                calculated: false,
                listValues: ringDiameterRangesInMm,
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
          esRingSizes.items[0].valueModel,
          null,
          listValues: esRingSizes,
        );

        await testCase(
          calculateByParams: true,
          unitGroupName: GroupNames.ringSize,
          paramSetValue: ConversionParamSetValueModel.compact(
            paramSet: ringSizeByDiameterParamSet,
            paramValues: const [
              (
                diameterParam,
                null,
                null,
                unit: millimeter,
                calculated: false,
                listValues: null,
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
          esRingSizes.items[0].valueModel,
          null,
          listValues: esRingSizes,
        );

        await testCase(
          calculateByParams: true,
          unitGroupName: GroupNames.ringSize,
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
          currentUnitValue: currentUnitValue,
          expectedUnitValue: expectedUnitValue,
        );
      });
    });

    group("Should NOT calculate unit value 'kg'", () {
      test("Should NOT initially set default unit value '1'", () async {
        final currentUnitValue = ConversionUnitValueModel.tuple(
          kilogram,
          null,
          null,
        );

        final expectedUnitValue = ConversionUnitValueModel.tuple(
          kilogram,
          null,
          null,
        );

        await testCase(
          alignCurrentValue: false,
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
          currentUnitValue: currentUnitValue,
          expectedUnitValue: expectedUnitValue,
        );
      });

      test(
          "Should change non-list default value [kg: 30 -> null], "
          "should NOT replace empty default value with 1", () async {
        final currentUnitValue = ConversionUnitValueModel.tuple(
          kilogram,
          null,
          30,
        );

        final expectedUnitValue = ConversionUnitValueModel.tuple(
          kilogram,
          null,
          null,
        );

        await testCase(
          alignCurrentValue: false,
          delta: EditConversionUnitValueDelta.raw(
            newDefaultValue: null,
            unitId: kilogram.id,
          ),
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
          currentUnitValue: currentUnitValue,
          expectedUnitValue: expectedUnitValue,
        );
      });
    });
  });
}
