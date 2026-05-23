import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/list_value_model.dart';
import 'package:convertouch/domain/model/num_range.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_items_fetch_model.dart';
import 'package:convertouch/domain/use_cases/common/init_item_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/edit_conversion_param_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_source_item_by_params_use_case.dart';
import 'package:convertouch/domain/use_cases/list_values/fetch_list_values_use_case.dart';
import 'package:test/test.dart';

import '../../model/mock/mock_param.dart';
import '../../model/mock/mock_unit.dart';
import '../../model/mock/mock_unit_group.dart';
import '../../repositories/mock/mock_dynamic_value_repository.dart';
import '../../repositories/mock/mock_network_repository.dart';
import 'helpers/helpers.dart';

void main() {
  late EditConversionParamValueUseCase useCase;

  setUpAll(() {
    const listValueRepository = ListValueRepositoryImpl(
      networkRepository: MockNetworkRepository(),
    );

    const calculateDefaultValueUseCase = CalculateDefaultValueUseCase(
      dynamicValueRepository: MockDynamicValueRepository(),
      listValueRepository: listValueRepository,
    );

    useCase = const EditConversionParamValueUseCase(
      initParamListValuesUseCase: InitParamListValuesUseCase(
        fetchListValuesUseCase: FetchListValuesUseCase(
          listValueRepository: listValueRepository,
        ),
      ),
      calculateSourceItemByParamsUseCase: CalculateSourceItemByParamsUseCase(
        calculateDefaultValueUseCase: calculateDefaultValueUseCase,
      ),
      calculateDefaultValueUseCase: calculateDefaultValueUseCase,
    );
  });

  group('By coefficients - mass', () {
    test("Should calculate by param 'Bar Weight' list value [kg: 10 -> 20]",
        () async {
      await testCase(
        unitGroup: massGroup,
        useCase: useCase,
        delta: EditConversionParamValueDelta.raw(
          newValue: '20',
          paramId: barWeightParam.id,
          paramSetId: barbellWeightParamSet.id,
        ),
        currentParams: ConversionParamSetValueBulkModel.single(
          paramSet: barbellWeightParamSet,
          paramValues: [
            ConversionParamValueModel.tuple(barWeightParam, 10, null,
                unit: kilogram),
            ConversionParamValueModel.tuple(oneSideWeightParam, 500, 1,
                unit: kilogram),
          ],
        ),
        currentSrc: ConversionUnitValueModel.tuple(ton, 1.01, 0.012),
        currentUnitValues: [
          ConversionUnitValueModel.tuple(ton, 1.01, 0.012),
          ConversionUnitValueModel.tuple(
              pound, 1010 / pound.coefficient!, 12 / pound.coefficient!),
        ],
        expectedParams: ConversionParamSetValueBulkModel.single(
          paramSet: barbellWeightParamSet,
          paramValues: [
            ConversionParamValueModel.tuple(barWeightParam, 20, null,
                unit: kilogram),
            ConversionParamValueModel.tuple(oneSideWeightParam, 500, 1,
                unit: kilogram),
          ],
        ),
        expectedSrc: ConversionUnitValueModel.tuple(ton, 1.02, 0.022),
        expectedUnitValues: [
          ConversionUnitValueModel.tuple(ton, 1.02, 0.022),
          ConversionUnitValueModel.tuple(
              pound, 1020 / pound.coefficient!, 22 / pound.coefficient!),
        ],
      );
    });

    test("Should calculate by param 'Bar Weight' list value [lb: 22 -> 44]",
        () async {
      await testCase(
        unitGroup: massGroup,
        useCase: useCase,
        delta: EditConversionParamValueDelta.raw(
          newValue: 20 / pound.coefficient!,
          paramId: barWeightParam.id,
          paramSetId: barbellWeightParamSet.id,
        ),
        currentParams: ConversionParamSetValueBulkModel.single(
          paramSet: barbellWeightParamSet,
          paramValues: [
            ConversionParamValueModel.tuple(
                barWeightParam, 10 / pound.coefficient!, null,
                unit: pound),
            ConversionParamValueModel.tuple(oneSideWeightParam, 500, 1,
                unit: kilogram),
          ],
        ),
        currentSrc: ConversionUnitValueModel.tuple(ton, 1.01, 0.012),
        currentUnitValues: [
          ConversionUnitValueModel.tuple(ton, 1.01, 0.012),
          ConversionUnitValueModel.tuple(
              pound, 1010 / pound.coefficient!, 12 / pound.coefficient!),
        ],
        expectedParams: ConversionParamSetValueBulkModel.single(
          paramSet: barbellWeightParamSet,
          paramValues: [
            ConversionParamValueModel.tuple(
                barWeightParam, 20 / pound.coefficient!, null,
                unit: pound),
            ConversionParamValueModel.tuple(oneSideWeightParam, 500, 1,
                unit: kilogram),
          ],
        ),
        expectedSrc: ConversionUnitValueModel.tuple(ton, 1.02, 0.022),
        expectedUnitValues: [
          ConversionUnitValueModel.tuple(ton, 1.02, 0.022),
          ConversionUnitValueModel.tuple(
              pound, 1020 / pound.coefficient!, 22 / pound.coefficient!),
        ],
      );
    });

    test(
        "Should calculate by param 'One Size Weight' value "
        "[bar: 10 kg | kg: 30 -> 40]", () async {
      await testCase(
        unitGroup: massGroup,
        useCase: useCase,
        delta: EditConversionParamValueDelta.raw(
          newValue: '40',
          newDefaultValue: '1',
          paramId: oneSideWeightParam.id,
          paramSetId: barbellWeightParamSet.id,
        ),
        currentParams: ConversionParamSetValueBulkModel.single(
          paramSet: barbellWeightParamSet,
          paramValues: [
            ConversionParamValueModel.tuple(
              barWeightParam,
              10,
              null,
              unit: kilogram,
            ),
            ConversionParamValueModel.tuple(oneSideWeightParam, 30, 1,
                unit: kilogram),
          ],
        ),
        currentSrc: ConversionUnitValueModel.tuple(kilogram, 70, 12),
        currentUnitValues: [
          ConversionUnitValueModel.tuple(kilogram, 70, 12),
          ConversionUnitValueModel.tuple(
              pound, 70 / pound.coefficient!, 12 / pound.coefficient!),
        ],
        expectedParams: ConversionParamSetValueBulkModel.single(
          paramSet: barbellWeightParamSet,
          paramValues: [
            ConversionParamValueModel.tuple(
              barWeightParam,
              10,
              null,
              unit: kilogram,
              listValues: const OutputItemsFetchModel(items: [
                ListValueModel.str('10'),
                ListValueModel.str('20'),
              ], pageNum: 1, hasReachedMax: true),
            ),
            ConversionParamValueModel.tuple(oneSideWeightParam, 40, 1,
                unit: kilogram),
          ],
        ),
        expectedSrc: ConversionUnitValueModel.tuple(kilogram, 90, 12),
        expectedUnitValues: [
          ConversionUnitValueModel.tuple(kilogram, 90, 12),
          ConversionUnitValueModel.tuple(
              pound, 90 / pound.coefficient!, 12 / pound.coefficient!),
        ],
      );
    });

    test(
        "Should calculate by param 'One Size Weight' value "
        "[bar: 22 lb. | kg: 30 -> 40]", () async {
      await testCase(
        unitGroup: massGroup,
        useCase: useCase,
        delta: EditConversionParamValueDelta.raw(
          newValue: '40',
          newDefaultValue: '1',
          paramId: oneSideWeightParam.id,
          paramSetId: barbellWeightParamSet.id,
        ),
        currentParams: ConversionParamSetValueBulkModel.single(
          paramSet: barbellWeightParamSet,
          paramValues: [
            ConversionParamValueModel.tuple(barWeightParam, 22, null,
                unit: pound),
            ConversionParamValueModel.tuple(oneSideWeightParam, 30, 1,
                unit: kilogram),
          ],
        ),
        currentSrc: ConversionUnitValueModel.tuple(kilogram, 70, 12),
        currentUnitValues: [
          ConversionUnitValueModel.tuple(kilogram, 70, 12),
          ConversionUnitValueModel.tuple(
              pound, 70 / pound.coefficient!, 12 / pound.coefficient!),
        ],
        expectedParams: ConversionParamSetValueBulkModel.single(
          paramSet: barbellWeightParamSet,
          paramValues: [
            ConversionParamValueModel.tuple(
              barWeightParam,
              22,
              null,
              unit: pound,
              listValues: const OutputItemsFetchModel(items: [
                ListValueModel.str('22'),
                ListValueModel.str('44'),
              ], pageNum: 1, hasReachedMax: true),
            ),
            ConversionParamValueModel.tuple(oneSideWeightParam, 40, 1,
                unit: kilogram),
          ],
        ),
        expectedSrc: ConversionUnitValueModel.tuple(
          kilogram,
          22 * pound.coefficient! + 40 * 2,
          22 * pound.coefficient! + 1 * 2,
        ),
        expectedUnitValues: [
          ConversionUnitValueModel.tuple(
            kilogram,
            22 * pound.coefficient! + 40 * 2,
            22 * pound.coefficient! + 1 * 2,
          ),
          ConversionUnitValueModel.tuple(
              pound, 22 + 80 / pound.coefficient!, 22 + 2 / pound.coefficient!),
        ],
      );
    });
  });

  group('By formula - clothes size', () {
    test(
        "Should calculate by param 'Person' list value [Man -> Woman], "
        "should change param 'Garment' list value [empty -> default Shirt], "
        "should change param 'Height' list value [cm: empty -> default ..-156]",
        () async {
      await testCase(
        unitGroup: clothesSizeGroup,
        useCase: useCase,
        delta: EditConversionParamValueDelta.raw(
          newValue: "Woman",
          paramId: personParam.id,
          paramSetId: personParam.paramSetId,
        ),
        currentParams: ConversionParamSetValueBulkModel.single(
          paramSet: clothesSizeParamSet,
          paramValues: [
            ConversionParamValueModel.tuple(personParam, "Man", null),
            ConversionParamValueModel.tuple(garmentParam, null, null),
            ConversionParamValueModel.tuple(heightParam, null, null,
                unit: centimeter),
          ],
        ),
        currentSrc: ConversionUnitValueModel.tuple(spainClothSize, null, null),
        currentUnitValues: [
          ConversionUnitValueModel.tuple(italianClothSize, null, null),
          ConversionUnitValueModel.tuple(spainClothSize, null, null),
          ConversionUnitValueModel.tuple(germanyClothSize, null, null),
        ],
        expectedParams: ConversionParamSetValueBulkModel.single(
          paramSet: clothesSizeParamSet,
          paramValues: [
            ConversionParamValueModel.tuple(personParam, "Woman", null),
            ConversionParamValueModel.tuple(
              garmentParam,
              "Shirt",
              null,
              listValues: const OutputItemsFetchModel(items: [
                ListValueModel.str('Shirt'),
                ListValueModel.str('Trousers'),
              ], pageNum: 1, hasReachedMax: true),
            ),
            ConversionParamValueModel.tuple(
              heightParam,
              const NumRange.withRight(0, 156),
              null,
              unit: centimeter,
              listValues: OutputItemsFetchModel(items: [
                ListValueModel.range(const NumRange.withRight(0, 156)),
                ListValueModel.range(const NumRange.withRight(156, 162)),
                ListValueModel.range(const NumRange.withRight(162, 168)),
                ListValueModel.range(const NumRange.withRight(168, 174)),
                ListValueModel.range(const NumRange.withRight(174, 180)),
                ListValueModel.range(const NumRange.withRight(180, 186)),
                ListValueModel.range(
                    const NumRange.withoutBoth(186, double.infinity)),
              ], pageNum: 1, hasReachedMax: true),
            ),
          ],
        ),
        expectedSrc: ConversionUnitValueModel.tuple(spainClothSize, 34, null),
        expectedUnitValues: [
          ConversionUnitValueModel.tuple(italianClothSize, 38, null),
          ConversionUnitValueModel.tuple(spainClothSize, 34, null),
          ConversionUnitValueModel.tuple(germanyClothSize, 32, null),
        ],
      );
    });

    test(
        "Should calculate by param 'Person' list value [Man -> Woman], "
        "should change param 'Garment' list value [empty -> default Shirt], "
        "should change param 'Height' list value [m: empty -> default ..-1.56]",
        () async {
      await testCase(
        unitGroup: clothesSizeGroup,
        useCase: useCase,
        delta: EditConversionParamValueDelta.raw(
          newValue: "Woman",
          paramId: personParam.id,
          paramSetId: personParam.paramSetId,
        ),
        currentParams: ConversionParamSetValueBulkModel.single(
          paramSet: clothesSizeParamSet,
          paramValues: [
            ConversionParamValueModel.tuple(personParam, "Man", null),
            ConversionParamValueModel.tuple(garmentParam, null, null),
            ConversionParamValueModel.tuple(heightParam, null, null,
                unit: meter),
          ],
        ),
        currentSrc: ConversionUnitValueModel.tuple(spainClothSize, null, null),
        currentUnitValues: [
          ConversionUnitValueModel.tuple(italianClothSize, null, null),
          ConversionUnitValueModel.tuple(spainClothSize, null, null),
          ConversionUnitValueModel.tuple(germanyClothSize, null, null),
        ],
        expectedParams: ConversionParamSetValueBulkModel.single(
          paramSet: clothesSizeParamSet,
          paramValues: [
            ConversionParamValueModel.tuple(personParam, "Woman", null),
            ConversionParamValueModel.tuple(
              garmentParam,
              "Shirt",
              null,
              listValues: const OutputItemsFetchModel(items: [
                ListValueModel.str('Shirt'),
                ListValueModel.str('Trousers'),
              ], pageNum: 1, hasReachedMax: true),
            ),
            ConversionParamValueModel.tuple(
              heightParam,
              const NumRange.withRight(0, 1.56),
              null,
              unit: meter,
              listValues: OutputItemsFetchModel(items: [
                ListValueModel.range(const NumRange.withRight(0, 1.56)),
                ListValueModel.range(const NumRange.withRight(1.56, 1.62)),
                ListValueModel.range(const NumRange.withRight(1.62, 1.68)),
                ListValueModel.range(const NumRange.withRight(1.68, 1.74)),
                ListValueModel.range(const NumRange.withRight(1.74, 1.80)),
                ListValueModel.range(const NumRange.withRight(1.80, 1.86)),
                ListValueModel.range(
                    const NumRange.withoutBoth(1.86, double.infinity)),
              ], pageNum: 1, hasReachedMax: true),
            ),
          ],
        ),
        expectedSrc: ConversionUnitValueModel.tuple(spainClothSize, 34, null),
        expectedUnitValues: [
          ConversionUnitValueModel.tuple(italianClothSize, 38, null),
          ConversionUnitValueModel.tuple(spainClothSize, 34, null),
          ConversionUnitValueModel.tuple(germanyClothSize, 32, null),
        ],
      );
    });

    test(
        "Should calculate by param 'Person' list value [Man -> Woman]"
        "should not change param 'Garment' list value, "
        "should not change param 'Height' list value", () async {
      await testCase(
        unitGroup: clothesSizeGroup,
        useCase: useCase,
        delta: EditConversionParamValueDelta.raw(
          newValue: "Woman",
          paramId: personParam.id,
          paramSetId: personParam.paramSetId,
        ),
        currentParams: ConversionParamSetValueBulkModel.single(
          paramSet: clothesSizeParamSet,
          paramValues: [
            ConversionParamValueModel.tuple(personParam, "Man", null),
            ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
            ConversionParamValueModel.tuple(
                heightParam, const NumRange.withRight(174, 180), null,
                unit: centimeter),
          ],
        ),
        currentSrc: ConversionUnitValueModel.tuple(spainClothSize, 40, null),
        currentUnitValues: [
          ConversionUnitValueModel.tuple(italianClothSize, 48, null),
          ConversionUnitValueModel.tuple(spainClothSize, 40, null),
          ConversionUnitValueModel.tuple(germanyClothSize, 46, null),
        ],
        expectedParams: ConversionParamSetValueBulkModel.single(
          paramSet: clothesSizeParamSet,
          paramValues: [
            ConversionParamValueModel.tuple(personParam, "Woman", null),
            ConversionParamValueModel.tuple(
              garmentParam,
              "Shirt",
              null,
              listValues: const OutputItemsFetchModel(items: [
                ListValueModel.str('Shirt'),
                ListValueModel.str('Trousers'),
              ], pageNum: 1, hasReachedMax: true),
            ),
            ConversionParamValueModel.tuple(
              heightParam,
              const NumRange.withRight(174, 180),
              null,
              unit: centimeter,
              listValues: OutputItemsFetchModel(items: [
                ListValueModel.range(const NumRange.withRight(0, 156)),
                ListValueModel.range(const NumRange.withRight(156, 162)),
                ListValueModel.range(const NumRange.withRight(162, 168)),
                ListValueModel.range(const NumRange.withRight(168, 174)),
                ListValueModel.range(const NumRange.withRight(174, 180)),
                ListValueModel.range(const NumRange.withRight(180, 186)),
                ListValueModel.range(
                    const NumRange.withoutBoth(186, double.infinity)),
              ], pageNum: 1, hasReachedMax: true),
            ),
          ],
        ),
        expectedSrc: ConversionUnitValueModel.tuple(spainClothSize, 42, null),
        expectedUnitValues: [
          ConversionUnitValueModel.tuple(italianClothSize, 46, null),
          ConversionUnitValueModel.tuple(spainClothSize, 42, null),
          ConversionUnitValueModel.tuple(germanyClothSize, 40, null),
        ],
      );
    });

    test(
        "Should calculate by param 'Garment' list value [Shirt -> Trousers], "
        "should not change param 'Person' list value"
        "should not change param 'Height' (cm) list value event if it does not"
        " exists in the updated list", () async {
      await testCase(
        unitGroup: clothesSizeGroup,
        useCase: useCase,
        delta: EditConversionParamValueDelta.raw(
          newValue: "Trousers",
          paramId: garmentParam.id,
          paramSetId: garmentParam.paramSetId,
        ),
        currentParams: ConversionParamSetValueBulkModel.single(
          paramSet: clothesSizeParamSet,
          paramValues: [
            ConversionParamValueModel.tuple(personParam, "Man", null),
            ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
            ConversionParamValueModel.tuple(
                heightParam, const NumRange.withRight(174, 180), null,
                unit: centimeter),
          ],
        ),
        currentSrc: ConversionUnitValueModel.tuple(spainClothSize, 40, null),
        currentUnitValues: [
          ConversionUnitValueModel.tuple(italianClothSize, 48, null),
          ConversionUnitValueModel.tuple(spainClothSize, 40, null),
          ConversionUnitValueModel.tuple(germanyClothSize, 46, null),
        ],
        expectedParams: ConversionParamSetValueBulkModel.single(
          paramSet: clothesSizeParamSet,
          paramValues: [
            ConversionParamValueModel.tuple(
              personParam,
              "Man",
              null,
              listValues: const OutputItemsFetchModel(items: [
                ListValueModel.str('Man'),
                ListValueModel.str('Woman'),
              ], pageNum: 1, hasReachedMax: true),
            ),
            ConversionParamValueModel.tuple(garmentParam, "Trousers", null),
            ConversionParamValueModel.tuple(
              heightParam,
              const NumRange.withRight(174, 180),
              null,
              unit: centimeter,
              listValues: OutputItemsFetchModel(items: [
                ListValueModel.range(const NumRange.withRight(0, 164)),
                ListValueModel.range(const NumRange.withRight(164, 170)),
                ListValueModel.range(const NumRange.withRight(170, 176)),
                ListValueModel.range(const NumRange.withRight(176, 182)),
                ListValueModel.range(const NumRange.withRight(180, 186)),
                ListValueModel.range(const NumRange.withRight(184, 190)),
                ListValueModel.range(
                    const NumRange.withoutBoth(188, double.infinity)),
              ], pageNum: 1, hasReachedMax: true),
            ),
          ],
        ),
        expectedSrc: ConversionUnitValueModel.tuple(spainClothSize, null, null),
        expectedUnitValues: [
          ConversionUnitValueModel.tuple(italianClothSize, null, null),
          ConversionUnitValueModel.tuple(spainClothSize, null, null),
          ConversionUnitValueModel.tuple(germanyClothSize, null, null),
        ],
      );
    });

    test(
        "Should calculate by param 'Garment' list value [Shirt -> Trousers], "
        "should not change param 'Person' list value"
        "should not change param 'Height' (m) list value event if it does not"
        " exists in the updated list", () async {
      await testCase(
        unitGroup: clothesSizeGroup,
        useCase: useCase,
        delta: EditConversionParamValueDelta.raw(
          newValue: "Trousers",
          paramId: garmentParam.id,
          paramSetId: garmentParam.paramSetId,
        ),
        currentParams: ConversionParamSetValueBulkModel.single(
          paramSet: clothesSizeParamSet,
          paramValues: [
            ConversionParamValueModel.tuple(personParam, "Man", null),
            ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
            ConversionParamValueModel.tuple(
                heightParam, const NumRange.withRight(1.74, 1.8), null,
                unit: meter),
          ],
        ),
        currentSrc: ConversionUnitValueModel.tuple(spainClothSize, 40, null),
        currentUnitValues: [
          ConversionUnitValueModel.tuple(italianClothSize, 48, null),
          ConversionUnitValueModel.tuple(spainClothSize, 40, null),
          ConversionUnitValueModel.tuple(germanyClothSize, 46, null),
        ],
        expectedParams: ConversionParamSetValueBulkModel.single(
          paramSet: clothesSizeParamSet,
          paramValues: [
            ConversionParamValueModel.tuple(
              personParam,
              "Man",
              null,
              listValues: const OutputItemsFetchModel(items: [
                ListValueModel.str('Man'),
                ListValueModel.str('Woman'),
              ], pageNum: 1, hasReachedMax: true),
            ),
            ConversionParamValueModel.tuple(garmentParam, "Trousers", null),
            ConversionParamValueModel.tuple(
              heightParam,
              const NumRange.withRight(1.74, 1.8),
              null,
              unit: meter,
              listValues: OutputItemsFetchModel(items: [
                ListValueModel.range(const NumRange.withRight(0, 1.64)),
                ListValueModel.range(const NumRange.withRight(1.64, 1.7)),
                ListValueModel.range(const NumRange.withRight(1.7, 1.76)),
                ListValueModel.range(const NumRange.withRight(1.76, 1.82)),
                ListValueModel.range(const NumRange.withRight(1.8, 1.86)),
                ListValueModel.range(const NumRange.withRight(1.84, 1.9)),
                ListValueModel.range(
                    const NumRange.withoutBoth(1.88, double.infinity)),
              ], pageNum: 1, hasReachedMax: true),
            ),
          ],
        ),
        expectedSrc: ConversionUnitValueModel.tuple(spainClothSize, null, null),
        expectedUnitValues: [
          ConversionUnitValueModel.tuple(italianClothSize, null, null),
          ConversionUnitValueModel.tuple(spainClothSize, null, null),
          ConversionUnitValueModel.tuple(germanyClothSize, null, null),
        ],
      );
    });

    test(
        "Should calculate by param 'Height' list value [cm: 164-170 -> 178-184]",
        () async {
      await testCase(
        unitGroup: clothesSizeGroup,
        useCase: useCase,
        delta: EditConversionParamValueDelta.raw(
          newValue: const NumRange.withRight(178, 184),
          paramId: heightParam.id,
          paramSetId: heightParam.paramSetId,
        ),
        currentParams: ConversionParamSetValueBulkModel.single(
          paramSet: clothesSizeParamSet,
          paramValues: [
            ConversionParamValueModel.tuple(personParam, "Man", null),
            ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
            ConversionParamValueModel.tuple(
              heightParam,
              const NumRange.withRight(164, 170),
              null,
              unit: centimeter,
              listValues: OutputItemsFetchModel(items: [
                ListValueModel.range(const NumRange.withRight(0, 164)),
                ListValueModel.range(const NumRange.withRight(164, 170)),
                ListValueModel.range(const NumRange.withRight(170, 176)),
                ListValueModel.range(const NumRange.withRight(174, 180)),
                ListValueModel.range(const NumRange.withRight(178, 184)),
                ListValueModel.range(const NumRange.withRight(182, 188)),
                ListValueModel.range(const NumRange.withRight(186, 192)),
                ListValueModel.range(
                    const NumRange.withoutBoth(190, double.infinity)),
              ], pageNum: 1, hasReachedMax: true),
            ),
          ],
        ),
        currentSrc: ConversionUnitValueModel.tuple(spainClothSize, 36, null),
        currentUnitValues: [
          ConversionUnitValueModel.tuple(italianClothSize, 44, null),
          ConversionUnitValueModel.tuple(spainClothSize, 36, null),
          ConversionUnitValueModel.tuple(germanyClothSize, 42, null),
        ],
        expectedParams: ConversionParamSetValueBulkModel.single(
          paramSet: clothesSizeParamSet,
          paramValues: [
            ConversionParamValueModel.tuple(
              personParam,
              "Man",
              null,
              listValues: const OutputItemsFetchModel(items: [
                ListValueModel.str('Man'),
                ListValueModel.str('Woman'),
              ], pageNum: 1, hasReachedMax: true),
            ),
            ConversionParamValueModel.tuple(
              garmentParam,
              "Shirt",
              null,
              listValues: const OutputItemsFetchModel(items: [
                ListValueModel.str('Shirt'),
                ListValueModel.str('Trousers'),
              ], pageNum: 1, hasReachedMax: true),
            ),
            ConversionParamValueModel.tuple(
              heightParam,
              const NumRange.withRight(178, 184),
              null,
              unit: centimeter,
              listValues: OutputItemsFetchModel(items: [
                ListValueModel.range(const NumRange.withRight(0, 164)),
                ListValueModel.range(const NumRange.withRight(164, 170)),
                ListValueModel.range(const NumRange.withRight(170, 176)),
                ListValueModel.range(const NumRange.withRight(174, 180)),
                ListValueModel.range(const NumRange.withRight(178, 184)),
                ListValueModel.range(const NumRange.withRight(182, 188)),
                ListValueModel.range(const NumRange.withRight(186, 192)),
                ListValueModel.range(
                    const NumRange.withoutBoth(190, double.infinity)),
              ], pageNum: 1, hasReachedMax: true),
            ),
          ],
        ),
        expectedSrc: ConversionUnitValueModel.tuple(spainClothSize, 42, null),
        expectedUnitValues: [
          ConversionUnitValueModel.tuple(italianClothSize, 50, null),
          ConversionUnitValueModel.tuple(spainClothSize, 42, null),
          ConversionUnitValueModel.tuple(germanyClothSize, 48, null),
        ],
      );
    });

    test(
        "Should calculate by param 'Height' list value [m: 1.64-1.7 -> 1.78-1.84]",
        () async {
      await testCase(
        unitGroup: clothesSizeGroup,
        useCase: useCase,
        delta: EditConversionParamValueDelta.raw(
          newValue: const NumRange.withRight(1.78, 1.84),
          paramId: heightParam.id,
          paramSetId: heightParam.paramSetId,
        ),
        currentParams: ConversionParamSetValueBulkModel.single(
          paramSet: clothesSizeParamSet,
          paramValues: [
            ConversionParamValueModel.tuple(personParam, "Man", null),
            ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
            ConversionParamValueModel.tuple(
              heightParam,
              const NumRange.withRight(1.64, 1.7),
              null,
              unit: meter,
              listValues: OutputItemsFetchModel(items: [
                ListValueModel.range(const NumRange.withRight(0, 1.64)),
                ListValueModel.range(const NumRange.withRight(1.64, 1.7)),
                ListValueModel.range(const NumRange.withRight(1.7, 1.76)),
                ListValueModel.range(const NumRange.withRight(1.74, 1.8)),
                ListValueModel.range(const NumRange.withRight(1.78, 1.84)),
                ListValueModel.range(const NumRange.withRight(1.82, 1.88)),
                ListValueModel.range(const NumRange.withRight(1.86, 1.92)),
                ListValueModel.range(
                    const NumRange.withoutBoth(1.9, double.infinity)),
              ], pageNum: 1, hasReachedMax: true),
            ),
          ],
        ),
        currentSrc: ConversionUnitValueModel.tuple(spainClothSize, 36, null),
        currentUnitValues: [
          ConversionUnitValueModel.tuple(italianClothSize, 44, null),
          ConversionUnitValueModel.tuple(spainClothSize, 36, null),
          ConversionUnitValueModel.tuple(germanyClothSize, 42, null),
        ],
        expectedParams: ConversionParamSetValueBulkModel.single(
          paramSet: clothesSizeParamSet,
          paramValues: [
            ConversionParamValueModel.tuple(
              personParam,
              "Man",
              null,
              listValues: const OutputItemsFetchModel(items: [
                ListValueModel.str('Man'),
                ListValueModel.str('Woman'),
              ], pageNum: 1, hasReachedMax: true),
            ),
            ConversionParamValueModel.tuple(
              garmentParam,
              "Shirt",
              null,
              listValues: const OutputItemsFetchModel(items: [
                ListValueModel.str('Shirt'),
                ListValueModel.str('Trousers'),
              ], pageNum: 1, hasReachedMax: true),
            ),
            ConversionParamValueModel.tuple(
              heightParam,
              const NumRange.withRight(1.78, 1.84),
              null,
              unit: meter,
              listValues: OutputItemsFetchModel(items: [
                ListValueModel.range(const NumRange.withRight(0, 1.64)),
                ListValueModel.range(const NumRange.withRight(1.64, 1.7)),
                ListValueModel.range(const NumRange.withRight(1.7, 1.76)),
                ListValueModel.range(const NumRange.withRight(1.74, 1.8)),
                ListValueModel.range(const NumRange.withRight(1.78, 1.84)),
                ListValueModel.range(const NumRange.withRight(1.82, 1.88)),
                ListValueModel.range(const NumRange.withRight(1.86, 1.92)),
                ListValueModel.range(
                    const NumRange.withoutBoth(1.9, double.infinity)),
              ], pageNum: 1, hasReachedMax: true),
            ),
          ],
        ),
        expectedSrc: ConversionUnitValueModel.tuple(spainClothSize, 42, null),
        expectedUnitValues: [
          ConversionUnitValueModel.tuple(italianClothSize, 50, null),
          ConversionUnitValueModel.tuple(spainClothSize, 42, null),
          ConversionUnitValueModel.tuple(germanyClothSize, 48, null),
        ],
      );
    });
  });
}
