import 'package:convertouch/data/repositories/list_value_repository_impl.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/num_range.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_param_set_value_calculation_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_non_list_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_param_set_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_param_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/init_item_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/dynamic_data/fetch_dynamic_value_use_use.dart';
import 'package:convertouch/domain/use_cases/list_values/fetch_list_values_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../model/mock/mock_list_values_batch.dart';
import '../../../model/mock/mock_param.dart';
import '../../../model/mock/mock_unit.dart';
import '../../../repositories/mock/mock_dynamic_value_repository.dart';
import '../../../repositories/mock/mock_unit_group_repository.dart';
import '../../../repositories/mock/mockito_mock_repository.mocks.dart';

void main() {
  late final CalculateParamSetValueUseCase useCase;
  late final MockitoNetworkRepository mockitoNetworkRepository =
      MockitoNetworkRepository();

  setUpAll(() {
    provideDummy<Either<ConvertouchException, List<ValueModel>>>(
      const Right([]),
    );

    final listValueRepository = ListValueRepositoryImpl(
      networkRepository: mockitoNetworkRepository,
    );

    useCase = CalculateParamSetValueUseCase(
      calculateParamValueUseValue: CalculateParamValueUseValue(
        calculateDefaultValueUseCase: const CalculateNonListDefaultValueUseCase(
          fetchDynamicValueUseCase: FetchDynamicValueUseCase(
            dynamicValueRepository: MockDynamicValueRepository(),
          ),
        ),
        initParamListValuesUseCase: InitParamListValuesUseCase(
          fetchListValuesUseCase: FetchListValuesUseCase(
            listValueRepository: listValueRepository,
          ),
        ),
        unitGroupRepository: const MockUnitGroupRepository(),
      ),
    );
  });

  Future<void> testCase({
    required ConversionParamSetValueModel currentParamSetValue,
    required ConversionParamSetValueModel expectedParamSetValue,
    ConversionSingleParamModifyDelta? delta,
    required bool alignCurrentValues,
    required bool enableFirstCalculableParamIfNoCalculatedEnabled,
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
          enableFirstCalculableParamIfNoCalculatedEnabled:
              enableFirstCalculableParamIfNoCalculatedEnabled,
        ),
      ),
    );

    expect(modifiedParamSetValue.toJson(), expectedParamSetValue.toJson());
  }

  group("Should initially calculate param set 'Barbell Weight'", () {
    test(
        "Should init 'Bar Weight' list values WITH preselect (alignCurrentValues = true), "
        "should recalc 'One Size Weight' by src value ("
        " - 'Bar Weight' will not be empty,"
        " - 'One Size Weight' calculated = true,"
        " - enableFirstCalculableParamIfNoCalculatedEnabled = false)",
        () async {
      final currentParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: barbellWeightParamSet,
        paramValues: const [
          (
            barWeightParam,
            null,
            null,
            unit: kilogram,
            calculated: false,
            listValuesFetchResult: null
          ),
          (
            oneSideWeightParam,
            null,
            null,
            unit: kilogram,
            calculated: true,
            listValuesFetchResult: null
          ),
        ],
      );

      final expectedParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: barbellWeightParamSet,
        paramValues: [
          (
            barWeightParam,
            barWeightParamKgListValues.items[0],
            null,
            unit: kilogram,
            calculated: false,
            listValuesFetchResult: barWeightParamKgListValues,
          ),
          (
            oneSideWeightParam,
            null,
            30,
            unit: kilogram,
            calculated: true,
            listValuesFetchResult: null
          ),
        ],
      );

      await testCase(
        srcUnitValue: ConversionUnitValueModel.tuple(kilogram, 70, 1),
        unitGroupName: GroupNames.mass,
        currentParamSetValue: currentParamSetValue,
        expectedParamSetValue: expectedParamSetValue,
        alignCurrentValues: true,
        enableFirstCalculableParamIfNoCalculatedEnabled: false,
      );
    });

    test(
        "Should init 'Bar Weight' list values WITH preselect (alignCurrentValues = true), "
        "should recalc 'One Size Weight' by src value ("
        " - 'Bar Weight' will not be empty,"
        " - 'One Size Weight' calculated = true,"
        " - enableFirstCalculableParamIfNoCalculatedEnabled = true)", () async {
      final currentParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: barbellWeightParamSet,
        paramValues: const [
          (
            barWeightParam,
            null,
            null,
            unit: kilogram,
            calculated: false,
            listValuesFetchResult: null
          ),
          (
            oneSideWeightParam,
            null,
            null,
            unit: kilogram,
            calculated: true,
            listValuesFetchResult: null
          ),
        ],
      );

      final expectedParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: barbellWeightParamSet,
        paramValues: [
          (
            barWeightParam,
            barWeightParamKgListValues.items[0],
            null,
            unit: kilogram,
            calculated: false,
            listValuesFetchResult: barWeightParamKgListValues,
          ),
          (
            oneSideWeightParam,
            null,
            30,
            unit: kilogram,
            calculated: true,
            listValuesFetchResult: null
          ),
        ],
      );

      await testCase(
        srcUnitValue: ConversionUnitValueModel.tuple(kilogram, 70, 1),
        unitGroupName: GroupNames.mass,
        currentParamSetValue: currentParamSetValue,
        expectedParamSetValue: expectedParamSetValue,
        alignCurrentValues: true,
        enableFirstCalculableParamIfNoCalculatedEnabled: true,
      );
    });

    test(
        "Should init 'Bar Weight' list values WITH preselect (alignCurrentValues = true), "
        "should NOT recalc 'One Size Weight' by src value ("
        " - 'Bar Weight' will not be empty,"
        " - 'One Size Weight' calculated = false,"
        " - enableFirstCalculableParamIfNoCalculatedEnabled = false)",
        () async {
      final currentParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: barbellWeightParamSet,
        paramValues: const [
          (
            barWeightParam,
            null,
            null,
            unit: kilogram,
            calculated: false,
            listValuesFetchResult: null
          ),
          (
            oneSideWeightParam,
            null,
            null,
            unit: kilogram,
            calculated: false,
            listValuesFetchResult: null
          ),
        ],
      );

      final expectedParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: barbellWeightParamSet,
        paramValues: [
          (
            barWeightParam,
            barWeightParamKgListValues.items[0],
            null,
            unit: kilogram,
            calculated: false,
            listValuesFetchResult: barWeightParamKgListValues,
          ),
          (
            oneSideWeightParam,
            null,
            1,
            unit: kilogram,
            calculated: false,
            listValuesFetchResult: null
          ),
        ],
      );

      await testCase(
        srcUnitValue: ConversionUnitValueModel.tuple(kilogram, 70, 1),
        unitGroupName: GroupNames.mass,
        currentParamSetValue: currentParamSetValue,
        expectedParamSetValue: expectedParamSetValue,
        alignCurrentValues: true,
        enableFirstCalculableParamIfNoCalculatedEnabled: false,
      );
    });

    test(
        "Should init 'Bar Weight' list values WITH preselect (alignCurrentValues = true), "
        "should recalc 'One Size Weight' by src value ("
        " - 'Bar Weight' will not be empty,"
        " - 'One Size Weight' will become calculated = true, because"
        "enableFirstCalculableParamIfNoCalculatedEnabled = true)", () async {
      final currentParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: barbellWeightParamSet,
        paramValues: const [
          (
            barWeightParam,
            null,
            null,
            unit: kilogram,
            calculated: false,
            listValuesFetchResult: null
          ),
          (
            oneSideWeightParam,
            null,
            null,
            unit: kilogram,
            calculated: false,
            listValuesFetchResult: null
          ),
        ],
      );

      final expectedParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: barbellWeightParamSet,
        paramValues: [
          (
            barWeightParam,
            barWeightParamKgListValues.items[0],
            null,
            unit: kilogram,
            calculated: false,
            listValuesFetchResult: barWeightParamKgListValues,
          ),
          (
            oneSideWeightParam,
            null,
            30,
            unit: kilogram,
            calculated: true,
            listValuesFetchResult: null
          ),
        ],
      );

      await testCase(
        srcUnitValue: ConversionUnitValueModel.tuple(kilogram, 70, 1),
        unitGroupName: GroupNames.mass,
        currentParamSetValue: currentParamSetValue,
        expectedParamSetValue: expectedParamSetValue,
        alignCurrentValues: true,
        enableFirstCalculableParamIfNoCalculatedEnabled: true,
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
            listValuesFetchResult: null
          ),
          (
            oneSideWeightParam,
            500,
            1,
            unit: kilogram,
            calculated: false,
            listValuesFetchResult: null
          ),
        ],
      );

      final expectedParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: barbellWeightParamSet,
        paramValues: [
          (
            barWeightParam,
            20,
            null,
            unit: kilogram,
            calculated: false,
            listValuesFetchResult: barWeightParamKgListValues,
          ),
          (
            oneSideWeightParam,
            500,
            1,
            unit: kilogram,
            calculated: false,
            listValuesFetchResult: null
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
        alignCurrentValues: true,
        enableFirstCalculableParamIfNoCalculatedEnabled: false,
      );
    });

    test("Should change 'Bar Weight' list value [lb: 22 -> 44]", () async {
      final currentParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: barbellWeightParamSet,
        paramValues: [
          (
            barWeightParam,
            barWeightParamPoundListValues.items[0],
            null,
            unit: pound,
            calculated: false,
            listValuesFetchResult: null,
          ),
          (
            oneSideWeightParam,
            500,
            1,
            unit: kilogram,
            calculated: false,
            listValuesFetchResult: null
          ),
        ],
      );

      final expectedParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: barbellWeightParamSet,
        paramValues: [
          (
            barWeightParam,
            barWeightParamPoundListValues.items[1],
            null,
            unit: pound,
            calculated: false,
            listValuesFetchResult: barWeightParamPoundListValues,
          ),
          (
            oneSideWeightParam,
            500,
            1,
            unit: kilogram,
            calculated: false,
            listValuesFetchResult: null
          ),
        ],
      );

      await testCase(
        delta: EditConversionParamValueDelta.raw(
          newValue: barWeightParamPoundListValues.items[1],
          paramId: barWeightParam.id,
          paramSetId: barbellWeightParamSet.id,
        ),
        currentParamSetValue: currentParamSetValue,
        expectedParamSetValue: expectedParamSetValue,
        alignCurrentValues: true,
        enableFirstCalculableParamIfNoCalculatedEnabled: false,
      );
    });

    test("Should change 'One Size Weight' value [kg: 30 -> 40]", () async {
      final currentParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: barbellWeightParamSet,
        paramValues: [
          (
            barWeightParam,
            10,
            null,
            unit: kilogram,
            calculated: false,
            listValuesFetchResult: barWeightParamKgListValues,
          ),
          (
            oneSideWeightParam,
            30,
            1,
            unit: kilogram,
            calculated: false,
            listValuesFetchResult: null
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
            listValuesFetchResult: barWeightParamKgListValues,
          ),
          (
            oneSideWeightParam,
            40,
            1,
            unit: kilogram,
            calculated: false,
            listValuesFetchResult: null
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
        alignCurrentValues: true,
        enableFirstCalculableParamIfNoCalculatedEnabled: false,
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
            listValuesFetchResult: null
          ),
          (
            oneSideWeightParam,
            500,
            1,
            unit: kilogram,
            calculated: false,
            listValuesFetchResult: null
          ),
        ],
      );

      final expectedParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: barbellWeightParamSet,
        paramValues: [
          (
            barWeightParam,
            barWeightParamPoundListValues.items[1],
            null,
            unit: pound,
            calculated: false,
            listValuesFetchResult: barWeightParamPoundListValues,
          ),
          (
            oneSideWeightParam,
            500,
            1,
            unit: kilogram,
            calculated: false,
            listValuesFetchResult: null
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
        alignCurrentValues: true,
        enableFirstCalculableParamIfNoCalculatedEnabled: false,
      );
    });

    test("Should change 'One Size Weight' non-list value [30 kg -> ~66.138 lb]",
        () async {
      final currentParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: barbellWeightParamSet,
        paramValues: [
          (
            barWeightParam,
            10,
            null,
            unit: kilogram,
            calculated: false,
            listValuesFetchResult: barWeightParamKgListValues,
          ),
          (
            oneSideWeightParam,
            30,
            1,
            unit: kilogram,
            calculated: false,
            listValuesFetchResult: null
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
            listValuesFetchResult: barWeightParamKgListValues,
          ),
          (
            oneSideWeightParam,
            30 / pound.coefficient!,
            1 / pound.coefficient!,
            unit: pound,
            calculated: false,
            listValuesFetchResult: null
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
        alignCurrentValues: true,
        enableFirstCalculableParamIfNoCalculatedEnabled: false,
      );
    });
  });

  group("Should initially calculate param set 'Clothes Size'", () {
    test(
        "Should init 'Person' list values and LEAVE value 'Man' (alignCurrentValues = true), "
        "should set default 'Garment' list value 'Shirt' (alignCurrentValues = true), "
        "should set default 'Height' list value [cm: ..-164] ("
        " - no src value,"
        " - 'Height' calculated = false,"
        " - enableFirstCalculableParamIfNoCalculatedEnabled = false)",
        () async {
      final currentParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: clothesSizeParamSet,
        paramValues: const [
          (
            personParam,
            "Man",
            null,
            unit: null,
            calculated: false,
            listValuesFetchResult: null,
          ),
          (
            garmentParam,
            null,
            null,
            unit: null,
            calculated: false,
            listValuesFetchResult: null
          ),
          (
            heightParam,
            null,
            null,
            unit: centimeter,
            calculated: false,
            listValuesFetchResult: null
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
            manShirtHeightRangesFrom0_164To190InCm.items[0],
            null,
            unit: centimeter,
            calculated: false,
            listValuesFetchResult: manShirtHeightRangesFrom0_164To190InCm,
          ),
        ],
      );

      await testCase(
        currentParamSetValue: currentParamSetValue,
        expectedParamSetValue: expectedParamSetValue,
        alignCurrentValues: true,
        enableFirstCalculableParamIfNoCalculatedEnabled: false,
      );
    });

    test(
        "Should init 'Person' list values and LEAVE value 'Man' (alignCurrentValues = true), "
        "should set default 'Garment' list value 'Shirt' (alignCurrentValues = true), "
        "should set default 'Height' list value [cm: ..-164] ("
        " - no src value,"
        " - 'Height' will become calculated = true, because"
        " enableFirstCalculableParamIfNoCalculatedEnabled = true)", () async {
      final currentParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: clothesSizeParamSet,
        paramValues: const [
          (
            personParam,
            "Man",
            null,
            unit: null,
            calculated: false,
            listValuesFetchResult: null,
          ),
          (
            garmentParam,
            null,
            null,
            unit: null,
            calculated: false,
            listValuesFetchResult: null
          ),
          (
            heightParam,
            null,
            null,
            unit: centimeter,
            calculated: false,
            listValuesFetchResult: null
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
            manShirtHeightRangesFrom0_164To190InCm.items[0],
            null,
            unit: centimeter,
            calculated: true,
            listValuesFetchResult: manShirtHeightRangesFrom0_164To190InCm,
          ),
        ],
      );

      await testCase(
        currentParamSetValue: currentParamSetValue,
        expectedParamSetValue: expectedParamSetValue,
        alignCurrentValues: true,
        enableFirstCalculableParamIfNoCalculatedEnabled: true,
      );
    });

    test(
        "Should init 'Person' list values and LEAVE value 'Man' (alignCurrentValues = true), "
        "should set default 'Garment' list value 'Shirt' (alignCurrentValues = true), "
        "should recalc 'Height' list value by src value IT 44 ("
        " - 'Person' is not empty,"
        " - 'Garment' is not empty,"
        " - 'Height' will become calculated = true, because"
        " enableFirstCalculableParamIfNoCalculatedEnabled = true)", () async {
      final currentParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: clothesSizeParamSet,
        paramValues: const [
          (
            personParam,
            "Man",
            null,
            unit: null,
            calculated: false,
            listValuesFetchResult: null,
          ),
          (
            garmentParam,
            null,
            null,
            unit: null,
            calculated: false,
            listValuesFetchResult: null
          ),
          (
            heightParam,
            null,
            null,
            unit: centimeter,
            calculated: false,
            listValuesFetchResult: null
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
            manShirtHeightRangesFrom0_164To190InCm.items[1],
            null,
            unit: centimeter,
            calculated: true,
            listValuesFetchResult: manShirtHeightRangesFrom0_164To190InCm,
          ),
        ],
      );

      await testCase(
        srcUnitValue:
            ConversionUnitValueModel.tuple(italianClothSize, 44, null),
        unitGroupName: GroupNames.clothesSize,
        currentParamSetValue: currentParamSetValue,
        expectedParamSetValue: expectedParamSetValue,
        alignCurrentValues: true,
        enableFirstCalculableParamIfNoCalculatedEnabled: true,
      );
    });

    test(
        "Should init 'Person' list values and LEAVE value 'Man' (alignCurrentValues = true), "
        "should set default 'Garment' list value 'Shirt' (alignCurrentValues = true), "
        "should recalc 'Height' list value by src value IT 44 ("
        " - 'Person' is not empty,"
        " - 'Garment' is not empty,"
        " - 'Height' calculated = true,"
        " - enableFirstCalculableParamIfNoCalculatedEnabled = false)",
        () async {
      final currentParamSetValue = ConversionParamSetValueModel.compact(
        paramSet: clothesSizeParamSet,
        paramValues: const [
          (
            personParam,
            "Man",
            null,
            unit: null,
            calculated: false,
            listValuesFetchResult: null,
          ),
          (
            garmentParam,
            null,
            null,
            unit: null,
            calculated: false,
            listValuesFetchResult: null
          ),
          (
            heightParam,
            null,
            null,
            unit: centimeter,
            calculated: true,
            listValuesFetchResult: null
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
            manShirtHeightRangesFrom0_164To190InCm.items[1],
            null,
            unit: centimeter,
            calculated: true,
            listValuesFetchResult: manShirtHeightRangesFrom0_164To190InCm,
          ),
        ],
      );

      await testCase(
        srcUnitValue:
            ConversionUnitValueModel.tuple(italianClothSize, 44, null),
        unitGroupName: GroupNames.clothesSize,
        currentParamSetValue: currentParamSetValue,
        expectedParamSetValue: expectedParamSetValue,
        alignCurrentValues: true,
        enableFirstCalculableParamIfNoCalculatedEnabled: false,
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
            null,
            null,
            unit: null,
            calculated: false,
            listValuesFetchResult: null
          ),
          (
            heightParam,
            null,
            null,
            unit: centimeter,
            calculated: false,
            listValuesFetchResult: null
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
            womanTrousersHeightRangesFrom0_156To186InCm.items[0],
            null,
            unit: centimeter,
            calculated: false,
            listValuesFetchResult: womanTrousersHeightRangesFrom0_156To186InCm,
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
        alignCurrentValues: true,
        enableFirstCalculableParamIfNoCalculatedEnabled: false,
      );
    });

    test(
        "Should change 'Person' list value [Man -> Woman], "
        "should recalc 'Garment' list value [empty -> Shirt], "
        "should recalc 'Height' list value [m: empty -> ..-1.56]", () async {
      final currentParamSetValue = ConversionParamSetValueModel.compact(
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
            null,
            null,
            unit: null,
            calculated: false,
            listValuesFetchResult: null
          ),
          (
            heightParam,
            null,
            null,
            unit: meter,
            calculated: false,
            listValuesFetchResult: null
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
            womanTrousersHeightRangesFrom0_156To186InMeter.items[0],
            null,
            unit: meter,
            calculated: false,
            listValuesFetchResult:
                womanTrousersHeightRangesFrom0_156To186InMeter,
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
        alignCurrentValues: true,
        enableFirstCalculableParamIfNoCalculatedEnabled: false,
      );
    });

    test(
        "Should change 'Person' list value [Man -> Woman], "
        "should leave 'Garment' = Shirt, "
        "should leave 'Height' = cm: 174-180", () async {
      final currentParamSetValue = ConversionParamSetValueModel.compact(
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
            listValuesFetchResult: null
          ),
          (
            heightParam,
            const NumRange.withRight(174, 180),
            null,
            unit: centimeter,
            calculated: false,
            listValuesFetchResult: null
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
            womanTrousersHeightRangesFrom0_156To186InCm.items[4],
            null,
            unit: centimeter,
            calculated: false,
            listValuesFetchResult: womanTrousersHeightRangesFrom0_156To186InCm,
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
        alignCurrentValues: true,
        enableFirstCalculableParamIfNoCalculatedEnabled: false,
      );
    });

    test(
        "Should leave 'Person' = Man, "
        "should change 'Garment' = [Shirt -> Trousers], "
        "should recalc 'Height' list value [cm: 174-180 -> ..-164]", () async {
      final currentParamSetValue = ConversionParamSetValueModel.compact(
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
            const NumRange.withRight(174, 180),
            null,
            unit: centimeter,
            calculated: false,
            listValuesFetchResult: null
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
            listValuesFetchResult: personParamListValues,
          ),
          (
            garmentParam,
            "Trousers",
            null,
            unit: null,
            calculated: false,
            listValuesFetchResult: garmentParamListValues,
          ),
          (
            heightParam,
            manTrousersHeightRangesFrom0_164To188InCm.items[0],
            null,
            unit: centimeter,
            calculated: false,
            listValuesFetchResult: manTrousersHeightRangesFrom0_164To188InCm,
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
        alignCurrentValues: true,
        enableFirstCalculableParamIfNoCalculatedEnabled: false,
      );
    });

    test(
        "Should leave 'Person' = Man, "
        "should change 'Garment' = [Shirt -> Trousers], "
        "should recalc 'Height' list value [m: 1.74-1.8 -> ..-1.64]", () async {
      final currentParamSetValue = ConversionParamSetValueModel.compact(
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
            const NumRange.withRight(1.74, 1.8),
            null,
            unit: meter,
            calculated: false,
            listValuesFetchResult: null
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
            listValuesFetchResult: personParamListValues,
          ),
          (
            garmentParam,
            "Trousers",
            null,
            unit: null,
            calculated: false,
            listValuesFetchResult: garmentParamListValues,
          ),
          (
            heightParam,
            manTrousersHeightRangesFrom0_164To188InMeter.items[0],
            null,
            unit: meter,
            calculated: false,
            listValuesFetchResult: manTrousersHeightRangesFrom0_164To188InMeter,
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
        alignCurrentValues: true,
        enableFirstCalculableParamIfNoCalculatedEnabled: false,
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
            manShirtHeightRangesFrom0_164To190InCm.items[1],
            null,
            unit: centimeter,
            calculated: false,
            listValuesFetchResult: manShirtHeightRangesFrom0_164To190InCm,
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
            manShirtHeightRangesFrom0_164To190InCm.items[4],
            null,
            unit: centimeter,
            calculated: false,
            listValuesFetchResult: manShirtHeightRangesFrom0_164To190InCm,
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
        alignCurrentValues: true,
        enableFirstCalculableParamIfNoCalculatedEnabled: false,
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
            listValuesFetchResult: manShirtHeightRangesFrom0_164To190InMeter,
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
            manShirtHeightRangesFrom0_164To190InMeter.items[4],
            null,
            unit: meter,
            calculated: false,
            listValuesFetchResult: manShirtHeightRangesFrom0_164To190InMeter,
          ),
        ],
      );

      await testCase(
        delta: EditConversionParamValueDelta.raw(
          newValue: manShirtHeightRangesFrom0_164To190InMeter.items[4],
          paramId: heightParam.id,
          paramSetId: heightParam.paramSetId,
        ),
        currentParamSetValue: currentParamSetValue,
        expectedParamSetValue: expectedParamSetValue,
        alignCurrentValues: true,
        enableFirstCalculableParamIfNoCalculatedEnabled: false,
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
            manShirtHeightRangesFrom0_164To190InCm.items[1],
            null,
            unit: centimeter,
            calculated: false,
            listValuesFetchResult: manShirtHeightRangesFrom0_164To190InCm,
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
            listValuesFetchResult: manShirtHeightRangesFrom0_164To190InMeter,
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
        alignCurrentValues: true,
        enableFirstCalculableParamIfNoCalculatedEnabled: false,
      );
    });
  });

  group("Should initially calculate param set 'Exchange Rate'", () {
    test("[Currency] Should init 'Source' param list values without preselect",
        () async {
      final currentParamSetValue = ConversionParamSetValueModel(
        paramSet: exchangeRateParamSet,
        paramValues: [
          ConversionParamValueModel.tuple(
            exchangeRateSourceBankParam,
            null,
            null,
          ),
        ],
      );

      final expectedParamSetValue = ConversionParamSetValueModel(
        paramSet: exchangeRateParamSet,
        paramValues: [
          ConversionParamValueModel.tuple(
            exchangeRateSourceBankParam,
            null,
            null,
            listValuesFetchResult: exchangeRateSources,
          ),
        ],
      );

      when(
        mockitoNetworkRepository.fetchListValues(
          listType: ConvertouchListType.exchangeRateSource,
          params: anyNamed('params'),
          pageSize: listValuesPageSize,
          pageNum: 0,
        ),
      ).thenAnswer(
        (_) async => const Right([
          ValueModel.rawStr('FloatRates'),
        ]),
      );

      await testCase(
        currentParamSetValue: currentParamSetValue,
        expectedParamSetValue: expectedParamSetValue,
        alignCurrentValues: true,
        enableFirstCalculableParamIfNoCalculatedEnabled: false,
      );
    });
  });
}
