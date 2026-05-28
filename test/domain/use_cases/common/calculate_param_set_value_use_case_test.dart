import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/num_range.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_param_set_value_calculation_model.dart';
import 'package:convertouch/domain/use_cases/common/init_item_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_param_set_value_use_case.dart';
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
  late CalculateParamSetValueUseValue useCase;

  setUpAll(() {
    const listValueRepository = ListValueRepositoryImpl(
      networkRepository: MockNetworkRepository(),
    );

    useCase = const CalculateParamSetValueUseValue(
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
    );
  });

  Future<void> testCase({
    required ConversionParamSetValueModel currentParamSetValue,
    required ConversionParamSetValueModel expectedParamSetValue,
    ConversionSingleParamModifyDelta? delta,
    bool alignCurrentValues = true,
    ConversionUnitValueModel? srcUnitValue,
    String? unitGroupName,
  }) async {
    final modifiedParamSetValue = ObjectUtils.tryGet(
      await useCase.execute(
        InputParamSetValueCalculationModel(
          paramSetValue: currentParamSetValue,
          delta: delta,
          srcUnitValue: srcUnitValue,
          unitGroupName: unitGroupName,
          alignCurrentValues: alignCurrentValues,
        ),
      ),
    );

    expect(modifiedParamSetValue.toJson(), expectedParamSetValue.toJson());
  }

  group("Should initially calculate param set 'Barbell Weight'", () {
    test(
        "Should init 'Bar Weight', "
        "should init default 'One Size Weight' "
        "(alignCurrentValues = true, calculated = false)", () async {
      final currentParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: barbellWeightParamSet,
        paramValues: const [
          (
            barWeightParam,
            null,
            null,
            unit: kilogram,
            calculated: false,
            listValues: null
          ),
          (
            oneSideWeightParam,
            null,
            null,
            unit: kilogram,
            calculated: false,
            listValues: null
          ),
        ],
      );

      final expectedParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: barbellWeightParamSet,
        paramValues: const [
          (
            barWeightParam,
            10,
            null,
            unit: kilogram,
            calculated: false,
            listValues: barWeightParamKgListValues,
          ),
          (
            oneSideWeightParam,
            null,
            1,
            unit: kilogram,
            calculated: false,
            listValues: null
          ),
        ],
      );

      await testCase(
        currentParamSetValue: currentParamSetValue,
        expectedParamSetValue: expectedParamSetValue,
      );
    });

    test(
        "Should init 'Bar Weight', "
        "should recalc 'One Size Weight' by src value"
        "(alignCurrentValues = true, calculated = true)", () async {
      final currentParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: barbellWeightParamSet,
        paramValues: const [
          (
            barWeightParam,
            null,
            null,
            unit: kilogram,
            calculated: false,
            listValues: null
          ),
          (
            oneSideWeightParam,
            null,
            null,
            unit: kilogram,
            calculated: true,
            listValues: null
          ),
        ],
      );

      final expectedParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: barbellWeightParamSet,
        paramValues: const [
          (
            barWeightParam,
            10,
            null,
            unit: kilogram,
            calculated: false,
            listValues: barWeightParamKgListValues,
          ),
          (
            oneSideWeightParam,
            null,
            30,
            unit: kilogram,
            calculated: true,
            listValues: null
          ),
        ],
      );

      await testCase(
        srcUnitValue: ConversionUnitValueModel.tuple(kilogram, 70, 1),
        unitGroupName: GroupNames.mass,
        currentParamSetValue: currentParamSetValue,
        expectedParamSetValue: expectedParamSetValue,
      );
    });

    test(
        "Should NOT init 'Bar Weight', "
        "should NOT init 'One Size Weight' "
        "(alignCurrentValues = false)", () async {
      final currentParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: barbellWeightParamSet,
        paramValues: const [
          (
            barWeightParam,
            null,
            null,
            unit: kilogram,
            calculated: false,
            listValues: null
          ),
          (
            oneSideWeightParam,
            null,
            null,
            unit: kilogram,
            calculated: false,
            listValues: null
          ),
        ],
      );

      final expectedParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: barbellWeightParamSet,
        paramValues: const [
          (
            barWeightParam,
            null,
            null,
            unit: kilogram,
            calculated: false,
            listValues: barWeightParamKgListValues,
          ),
          (
            oneSideWeightParam,
            null,
            null,
            unit: kilogram,
            calculated: false,
            listValues: null
          ),
        ],
      );

      await testCase(
        alignCurrentValues: false,
        currentParamSetValue: currentParamSetValue,
        expectedParamSetValue: expectedParamSetValue,
      );
    });
  });

  group("Should change param values in param set 'Barbell Weight'", () {
    test("Should change 'Bar Weight' list value [kg: 10 -> 20]", () async {
      final currentParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: barbellWeightParamSet,
        paramValues: const [
          (
            barWeightParam,
            10,
            null,
            unit: kilogram,
            calculated: false,
            listValues: null
          ),
          (
            oneSideWeightParam,
            500,
            1,
            unit: kilogram,
            calculated: false,
            listValues: null
          ),
        ],
      );

      final expectedParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: barbellWeightParamSet,
        paramValues: const [
          (
            barWeightParam,
            20,
            null,
            unit: kilogram,
            calculated: false,
            listValues: barWeightParamKgListValues,
          ),
          (
            oneSideWeightParam,
            500,
            1,
            unit: kilogram,
            calculated: false,
            listValues: null
          ),
        ],
      );

      await testCase(
        delta: EditConversionParamValueDelta.raw(
          newValue: 20,
          paramId: barWeightParam.id,
          paramSetId: barbellWeightParamSet.id,
        ),
        currentParamSetValue: currentParamSetValue,
        expectedParamSetValue: expectedParamSetValue,
      );
    });

    test("Should change 'Bar Weight' list value [lb: 22 -> 44]", () async {
      final currentParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: barbellWeightParamSet,
        paramValues: [
          (
            barWeightParam,
            barWeightParamPoundListValues.items[0].valueModel,
            null,
            unit: pound,
            calculated: false,
            listValues: null,
          ),
          (
            oneSideWeightParam,
            500,
            1,
            unit: kilogram,
            calculated: false,
            listValues: null
          ),
        ],
      );

      final expectedParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: barbellWeightParamSet,
        paramValues: [
          (
            barWeightParam,
            barWeightParamPoundListValues.items[1].valueModel,
            null,
            unit: pound,
            calculated: false,
            listValues: barWeightParamPoundListValues,
          ),
          (
            oneSideWeightParam,
            500,
            1,
            unit: kilogram,
            calculated: false,
            listValues: null
          ),
        ],
      );

      await testCase(
        delta: EditConversionParamValueDelta.raw(
          newValue: barWeightParamPoundListValues.items[1].valueModel,
          paramId: barWeightParam.id,
          paramSetId: barbellWeightParamSet.id,
        ),
        currentParamSetValue: currentParamSetValue,
        expectedParamSetValue: expectedParamSetValue,
      );
    });

    test("Should change 'One Size Weight' value [kg: 30 -> 40]", () async {
      final currentParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: barbellWeightParamSet,
        paramValues: const [
          (
            barWeightParam,
            10,
            null,
            unit: kilogram,
            calculated: false,
            listValues: barWeightParamKgListValues,
          ),
          (
            oneSideWeightParam,
            30,
            1,
            unit: kilogram,
            calculated: false,
            listValues: null
          ),
        ],
      );

      final expectedParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: barbellWeightParamSet,
        paramValues: const [
          (
            barWeightParam,
            10,
            null,
            unit: kilogram,
            calculated: false,
            listValues: barWeightParamKgListValues,
          ),
          (
            oneSideWeightParam,
            40,
            1,
            unit: kilogram,
            calculated: false,
            listValues: null
          ),
        ],
      );

      await testCase(
        delta: EditConversionParamValueDelta.raw(
          newValue: '40',
          newDefaultValue: '1',
          paramId: oneSideWeightParam.id,
          paramSetId: barbellWeightParamSet.id,
        ),
        currentParamSetValue: currentParamSetValue,
        expectedParamSetValue: expectedParamSetValue,
      );
    });
  });

  group("Should change param unit in param set 'Barbell Weight'", () {
    test("Should change 'Bar Weight' list value [20 kg -> 44 lb]", () async {
      final currentParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: barbellWeightParamSet,
        paramValues: const [
          (
            barWeightParam,
            20,
            null,
            unit: kilogram,
            calculated: false,
            listValues: null
          ),
          (
            oneSideWeightParam,
            500,
            1,
            unit: kilogram,
            calculated: false,
            listValues: null
          ),
        ],
      );

      final expectedParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: barbellWeightParamSet,
        paramValues: [
          (
            barWeightParam,
            barWeightParamPoundListValues.items[1].valueModel,
            null,
            unit: pound,
            calculated: false,
            listValues: barWeightParamPoundListValues,
          ),
          (
            oneSideWeightParam,
            500,
            1,
            unit: kilogram,
            calculated: false,
            listValues: null
          ),
        ],
      );

      await testCase(
        delta: ReplaceConversionParamUnitDelta(
          newUnit: pound,
          paramId: barWeightParam.id,
          paramSetId: barbellWeightParamSet.id,
        ),
        unitGroupName: GroupNames.mass,
        currentParamSetValue: currentParamSetValue,
        expectedParamSetValue: expectedParamSetValue,
      );
    });

    test("Should change 'One Size Weight' non-list value [30 kg -> ~66.138 lb]",
        () async {
      final currentParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: barbellWeightParamSet,
        paramValues: const [
          (
            barWeightParam,
            10,
            null,
            unit: kilogram,
            calculated: false,
            listValues: barWeightParamKgListValues,
          ),
          (
            oneSideWeightParam,
            30,
            1,
            unit: kilogram,
            calculated: false,
            listValues: null
          ),
        ],
      );

      final expectedParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: barbellWeightParamSet,
        paramValues: [
          (
            barWeightParam,
            10,
            null,
            unit: kilogram,
            calculated: false,
            listValues: barWeightParamKgListValues,
          ),
          (
            oneSideWeightParam,
            30 / pound.coefficient!,
            1 / pound.coefficient!,
            unit: pound,
            calculated: false,
            listValues: null
          ),
        ],
      );

      await testCase(
        delta: ReplaceConversionParamUnitDelta(
          newUnit: pound,
          paramId: oneSideWeightParam.id,
          paramSetId: barbellWeightParamSet.id,
        ),
        currentParamSetValue: currentParamSetValue,
        expectedParamSetValue: expectedParamSetValue,
      );
    });
  });

  group("Should initially calculate param set 'Clothes Size'", () {
    test(
        "Should leave 'Person' = Man, "
        "should recalc 'Garment' list value [empty -> Shirt], "
        "should recalc 'Height' list value [cm: empty -> ..-164] "
        "(alignCurrentValues = true, calculated = false)", () async {
      final currentParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: clothesSizeParamSet,
        paramValues: const [
          (
            personParam,
            "Man",
            null,
            unit: null,
            calculated: false,
            listValues: personParamListValues,
          ),
          (
            garmentParam,
            null,
            null,
            unit: null,
            calculated: false,
            listValues: null
          ),
          (
            heightParam,
            null,
            null,
            unit: centimeter,
            calculated: false,
            listValues: null
          ),
        ],
      );

      final expectedParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: clothesSizeParamSet,
        paramValues: [
          (
            personParam,
            "Man",
            null,
            unit: null,
            calculated: false,
            listValues: personParamListValues,
          ),
          (
            garmentParam,
            "Shirt",
            null,
            unit: null,
            calculated: false,
            listValues: garmentParamListValues,
          ),
          (
            heightParam,
            heightRangesFrom0_164To190InCm.items[0].valueModel,
            null,
            unit: centimeter,
            calculated: false,
            listValues: heightRangesFrom0_164To190InCm,
          ),
        ],
      );

      await testCase(
        currentParamSetValue: currentParamSetValue,
        expectedParamSetValue: expectedParamSetValue,
      );
    });

    test(
        "Should leave 'Person' = Man, "
        "should recalc 'Garment' list value [empty -> Shirt], "
        "should recalc 'Height' list value by src value IT 44 "
        "(alignCurrentValues = true, calculated = true)", () async {
      final currentParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: clothesSizeParamSet,
        paramValues: const [
          (
            personParam,
            "Man",
            null,
            unit: null,
            calculated: false,
            listValues: personParamListValues,
          ),
          (
            garmentParam,
            null,
            null,
            unit: null,
            calculated: false,
            listValues: null
          ),
          (
            heightParam,
            null,
            null,
            unit: centimeter,
            calculated: true,
            listValues: null
          ),
        ],
      );

      final expectedParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: clothesSizeParamSet,
        paramValues: [
          (
            personParam,
            "Man",
            null,
            unit: null,
            calculated: false,
            listValues: personParamListValues,
          ),
          (
            garmentParam,
            "Shirt",
            null,
            unit: null,
            calculated: false,
            listValues: garmentParamListValues,
          ),
          (
            heightParam,
            heightRangesFrom0_164To190InCm.items[1].valueModel,
            null,
            unit: centimeter,
            calculated: true,
            listValues: heightRangesFrom0_164To190InCm,
          ),
        ],
      );

      await testCase(
        srcUnitValue:
            ConversionUnitValueModel.tuple(italianClothSize, 44, null),
        unitGroupName: GroupNames.clothesSize,
        currentParamSetValue: currentParamSetValue,
        expectedParamSetValue: expectedParamSetValue,
      );
    });

    test(
        "Should leave 'Person' = Man, "
        "should NOT recalc 'Garment' list value, "
        "should NOT recalc 'Height' list value "
        "(alignCurrentValues = false)", () async {
      final currentParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: clothesSizeParamSet,
        paramValues: const [
          (
            personParam,
            "Man",
            null,
            unit: null,
            calculated: false,
            listValues: personParamListValues,
          ),
          (
            garmentParam,
            null,
            null,
            unit: null,
            calculated: false,
            listValues: null
          ),
          (
            heightParam,
            null,
            null,
            unit: centimeter,
            calculated: false,
            listValues: null
          ),
        ],
      );

      final expectedParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: clothesSizeParamSet,
        paramValues: const [
          (
            personParam,
            "Man",
            null,
            unit: null,
            calculated: false,
            listValues: personParamListValues,
          ),
          (
            garmentParam,
            null,
            null,
            unit: null,
            calculated: false,
            listValues: garmentParamListValues,
          ),
          (
            heightParam,
            null,
            null,
            unit: centimeter,
            calculated: false,
            listValues: OutputListValuesBatch.empty(),
          ),
        ],
      );

      await testCase(
        alignCurrentValues: false,
        currentParamSetValue: currentParamSetValue,
        expectedParamSetValue: expectedParamSetValue,
      );
    });
  });

  group("Should change param value in param set 'Clothes Size'", () {
    test(
        "Should change 'Person' list value [Man -> Woman], "
        "should recalc 'Garment' list value [empty -> Shirt], "
        "should recalc 'Height' list value [cm: empty -> ..-156]", () async {
      final currentParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: clothesSizeParamSet,
        paramValues: const [
          (
            personParam,
            "Man",
            null,
            unit: null,
            calculated: false,
            listValues: personParamListValues,
          ),
          (
            garmentParam,
            null,
            null,
            unit: null,
            calculated: false,
            listValues: null
          ),
          (
            heightParam,
            null,
            null,
            unit: centimeter,
            calculated: false,
            listValues: null
          ),
        ],
      );

      final expectedParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: clothesSizeParamSet,
        paramValues: [
          (
            personParam,
            "Woman",
            null,
            unit: null,
            calculated: false,
            listValues: personParamListValues,
          ),
          (
            garmentParam,
            "Shirt",
            null,
            unit: null,
            calculated: false,
            listValues: garmentParamListValues,
          ),
          (
            heightParam,
            heightRangesFrom0_156To186InCm.items[0].valueModel,
            null,
            unit: centimeter,
            calculated: false,
            listValues: heightRangesFrom0_156To186InCm,
          ),
        ],
      );

      await testCase(
        delta: EditConversionParamValueDelta.raw(
          newValue: "Woman",
          paramId: personParam.id,
          paramSetId: personParam.paramSetId,
        ),
        currentParamSetValue: currentParamSetValue,
        expectedParamSetValue: expectedParamSetValue,
      );
    });

    test(
        "Should change 'Person' list value [Man -> Woman], "
        "should recalc 'Garment' list value [empty -> Shirt], "
        "should recalc 'Height' list value [m: empty -> ..-1.56]", () async {
      final currentParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: clothesSizeParamSet,
        paramValues: const [
          (
            personParam,
            "Man",
            null,
            unit: null,
            calculated: false,
            listValues: personParamListValues,
          ),
          (
            garmentParam,
            null,
            null,
            unit: null,
            calculated: false,
            listValues: null
          ),
          (
            heightParam,
            null,
            null,
            unit: meter,
            calculated: false,
            listValues: null
          ),
        ],
      );

      final expectedParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: clothesSizeParamSet,
        paramValues: [
          (
            personParam,
            "Woman",
            null,
            unit: null,
            calculated: false,
            listValues: personParamListValues,
          ),
          (
            garmentParam,
            "Shirt",
            null,
            unit: null,
            calculated: false,
            listValues: garmentParamListValues,
          ),
          (
            heightParam,
            heightRangesFrom0_156To186InMeter.items[0].valueModel,
            null,
            unit: meter,
            calculated: false,
            listValues: heightRangesFrom0_156To186InMeter,
          ),
        ],
      );

      await testCase(
        delta: EditConversionParamValueDelta.raw(
          newValue: "Woman",
          paramId: personParam.id,
          paramSetId: personParam.paramSetId,
        ),
        currentParamSetValue: currentParamSetValue,
        expectedParamSetValue: expectedParamSetValue,
      );
    });

    test(
        "Should change 'Person' list value [Man -> Woman], "
        "should leave 'Garment' = Shirt, "
        "should leave 'Height' = cm: 174-180", () async {
      final currentParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: clothesSizeParamSet,
        paramValues: const [
          (
            personParam,
            "Man",
            null,
            unit: null,
            calculated: false,
            listValues: personParamListValues,
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
            NumRange.withRight(174, 180),
            null,
            unit: centimeter,
            calculated: false,
            listValues: null
          ),
        ],
      );

      final expectedParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: clothesSizeParamSet,
        paramValues: [
          (
            personParam,
            "Woman",
            null,
            unit: null,
            calculated: false,
            listValues: personParamListValues,
          ),
          (
            garmentParam,
            "Shirt",
            null,
            unit: null,
            calculated: false,
            listValues: garmentParamListValues,
          ),
          (
            heightParam,
            heightRangesFrom0_156To186InCm.items[4].valueModel,
            null,
            unit: centimeter,
            calculated: false,
            listValues: heightRangesFrom0_156To186InCm,
          ),
        ],
      );

      await testCase(
        delta: EditConversionParamValueDelta.raw(
          newValue: "Woman",
          paramId: personParam.id,
          paramSetId: personParam.paramSetId,
        ),
        currentParamSetValue: currentParamSetValue,
        expectedParamSetValue: expectedParamSetValue,
      );
    });

    test(
        "Should leave 'Person' = Man, "
        "should change 'Garment' = [Shirt -> Trousers], "
        "should recalc 'Height' list value [cm: 174-180 -> ..-164]", () async {
      final currentParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: clothesSizeParamSet,
        paramValues: const [
          (
            personParam,
            "Man",
            null,
            unit: null,
            calculated: false,
            listValues: personParamListValues,
          ),
          (
            garmentParam,
            "Shirt",
            null,
            unit: null,
            calculated: false,
            listValues: garmentParamListValues,
          ),
          (
            heightParam,
            NumRange.withRight(174, 180),
            null,
            unit: centimeter,
            calculated: false,
            listValues: null
          ),
        ],
      );

      final expectedParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: clothesSizeParamSet,
        paramValues: [
          (
            personParam,
            "Man",
            null,
            unit: null,
            calculated: false,
            listValues: personParamListValues,
          ),
          (
            garmentParam,
            "Trousers",
            null,
            unit: null,
            calculated: false,
            listValues: garmentParamListValues,
          ),
          (
            heightParam,
            heightRangesFrom0_164To188InCm.items[0].valueModel,
            null,
            unit: centimeter,
            calculated: false,
            listValues: heightRangesFrom0_164To188InCm,
          ),
        ],
      );

      await testCase(
        delta: EditConversionParamValueDelta.raw(
          newValue: "Trousers",
          paramId: garmentParam.id,
          paramSetId: garmentParam.paramSetId,
        ),
        currentParamSetValue: currentParamSetValue,
        expectedParamSetValue: expectedParamSetValue,
      );
    });

    test(
        "Should leave 'Person' = Man, "
        "should change 'Garment' = [Shirt -> Trousers], "
        "should recalc 'Height' list value [m: 1.74-1.8 -> ..-1.64]", () async {
      final currentParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: clothesSizeParamSet,
        paramValues: const [
          (
            personParam,
            "Man",
            null,
            unit: null,
            calculated: false,
            listValues: personParamListValues,
          ),
          (
            garmentParam,
            "Shirt",
            null,
            unit: null,
            calculated: false,
            listValues: garmentParamListValues,
          ),
          (
            heightParam,
            NumRange.withRight(1.74, 1.8),
            null,
            unit: meter,
            calculated: false,
            listValues: null
          ),
        ],
      );

      final expectedParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: clothesSizeParamSet,
        paramValues: [
          (
            personParam,
            "Man",
            null,
            unit: null,
            calculated: false,
            listValues: personParamListValues,
          ),
          (
            garmentParam,
            "Trousers",
            null,
            unit: null,
            calculated: false,
            listValues: garmentParamListValues,
          ),
          (
            heightParam,
            heightRangesFrom0_164To188InMeter.items[0].valueModel,
            null,
            unit: meter,
            calculated: false,
            listValues: heightRangesFrom0_164To188InMeter,
          ),
        ],
      );

      await testCase(
        delta: EditConversionParamValueDelta.raw(
          newValue: "Trousers",
          paramId: garmentParam.id,
          paramSetId: garmentParam.paramSetId,
        ),
        currentParamSetValue: currentParamSetValue,
        expectedParamSetValue: expectedParamSetValue,
      );
    });

    test(
        "Should leave 'Person' = Man, "
        "should leave 'Garment' = Shirt, "
        "Should change 'Height' list value [cm: 164-170 -> 178-184]", () async {
      final currentParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: clothesSizeParamSet,
        paramValues: [
          (
            personParam,
            "Man",
            null,
            unit: null,
            calculated: false,
            listValues: personParamListValues,
          ),
          (
            garmentParam,
            "Shirt",
            null,
            unit: null,
            calculated: false,
            listValues: garmentParamListValues,
          ),
          (
            heightParam,
            heightRangesFrom0_164To190InCm.items[1].valueModel,
            null,
            unit: centimeter,
            calculated: false,
            listValues: heightRangesFrom0_164To190InCm,
          ),
        ],
      );

      final expectedParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: clothesSizeParamSet,
        paramValues: [
          (
            personParam,
            "Man",
            null,
            unit: null,
            calculated: false,
            listValues: personParamListValues,
          ),
          (
            garmentParam,
            "Shirt",
            null,
            unit: null,
            calculated: false,
            listValues: garmentParamListValues,
          ),
          (
            heightParam,
            heightRangesFrom0_164To190InCm.items[4].valueModel,
            null,
            unit: centimeter,
            calculated: false,
            listValues: heightRangesFrom0_164To190InCm,
          ),
        ],
      );

      await testCase(
        delta: EditConversionParamValueDelta.raw(
          newValue: const NumRange.withRight(178, 184),
          paramId: heightParam.id,
          paramSetId: heightParam.paramSetId,
        ),
        currentParamSetValue: currentParamSetValue,
        expectedParamSetValue: expectedParamSetValue,
      );
    });

    test(
        "Should leave 'Person' = Man, "
        "should leave 'Garment' = Shirt, "
        "Should change 'Height' list value [m: 1.64-1.7 -> 1.78-1.84]",
        () async {
      final currentParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: clothesSizeParamSet,
        paramValues: [
          (
            personParam,
            "Man",
            null,
            unit: null,
            calculated: false,
            listValues: personParamListValues,
          ),
          (
            garmentParam,
            "Shirt",
            null,
            unit: null,
            calculated: false,
            listValues: garmentParamListValues,
          ),
          (
            heightParam,
            heightRangesFrom0_164To190InMeter.items[1].valueModel,
            null,
            unit: meter,
            calculated: false,
            listValues: heightRangesFrom0_164To190InMeter,
          ),
        ],
      );

      final expectedParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: clothesSizeParamSet,
        paramValues: [
          (
            personParam,
            "Man",
            null,
            unit: null,
            calculated: false,
            listValues: personParamListValues,
          ),
          (
            garmentParam,
            "Shirt",
            null,
            unit: null,
            calculated: false,
            listValues: garmentParamListValues,
          ),
          (
            heightParam,
            heightRangesFrom0_164To190InMeter.items[4].valueModel,
            null,
            unit: meter,
            calculated: false,
            listValues: heightRangesFrom0_164To190InMeter,
          ),
        ],
      );

      await testCase(
        delta: EditConversionParamValueDelta.raw(
          newValue: heightRangesFrom0_164To190InMeter.items[4].valueModel,
          paramId: heightParam.id,
          paramSetId: heightParam.paramSetId,
        ),
        currentParamSetValue: currentParamSetValue,
        expectedParamSetValue: expectedParamSetValue,
      );
    });
  });

  group("Should change param unit in param set 'Clothes Size'", () {
    test(
        "Should leave 'Person' = Man, "
        "should leave 'Garment' = Shirt, "
        "Should change 'Height' unit [cm -> m: 164-170]", () async {
      final currentParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: clothesSizeParamSet,
        paramValues: [
          (
            personParam,
            "Man",
            null,
            unit: null,
            calculated: false,
            listValues: personParamListValues,
          ),
          (
            garmentParam,
            "Shirt",
            null,
            unit: null,
            calculated: false,
            listValues: garmentParamListValues,
          ),
          (
            heightParam,
            heightRangesFrom0_164To190InCm.items[1].valueModel,
            null,
            unit: centimeter,
            calculated: false,
            listValues: heightRangesFrom0_164To190InCm,
          ),
        ],
      );

      final expectedParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: clothesSizeParamSet,
        paramValues: [
          (
            personParam,
            "Man",
            null,
            unit: null,
            calculated: false,
            listValues: personParamListValues,
          ),
          (
            garmentParam,
            "Shirt",
            null,
            unit: null,
            calculated: false,
            listValues: garmentParamListValues,
          ),
          (
            heightParam,
            heightRangesFrom0_164To190InMeter.items[1].valueModel,
            null,
            unit: meter,
            calculated: false,
            listValues: heightRangesFrom0_164To190InMeter,
          ),
        ],
      );

      await testCase(
        delta: ReplaceConversionParamUnitDelta(
          newUnit: meter,
          paramId: heightParam.id,
          paramSetId: heightParam.paramSetId,
        ),
        currentParamSetValue: currentParamSetValue,
        expectedParamSetValue: expectedParamSetValue,
      );
    });
  });
}
