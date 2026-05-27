import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/list_value_model.dart';
import 'package:convertouch/domain/model/num_range.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_items_fetch_model.dart';
import 'package:convertouch/domain/use_cases/common/init_item_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/edit_conversion_param_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_param_set_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_param_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_source_item_by_params_use_case.dart';
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
      calculateParamSetValueUseValue: CalculateParamSetValueUseValue(
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
      calculateSourceItemByParamsUseCase: CalculateSourceItemByParamsUseCase(
        calculateDefaultValueUseCase: calculateDefaultValueUseCase,
        initUnitListValuesUseCase: InitUnitListValuesUseCase(
          fetchListValuesUseCase: FetchListValuesUseCase(
            listValueRepository: listValueRepository,
          ),
        ),
      ),
    );
  });

  group('By coefficients - mass', () {
    group("Should recalculate conversion by changed param 'Bar Weight'", () {
      test("Should change param 'Bar Weight' [kg: 10 -> 20]", () async {
        await testCaseCompact(
          unitGroup: massGroup,
          useCase: useCase,
          delta: EditConversionParamValueDelta.raw(
            newValue: '20',
            paramId: barWeightParam.id,
            paramSetId: barbellWeightParamSet.id,
          ),
          currentParams: ConversionParamSetValueBulkModel.singleCompact(
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
          ),
          currentSrc: (ton, 1.01, 0.012, listValues: null),
          currentUnitValues: [
            (ton, 1.01, 0.012, listValues: null),
            (
              pound,
              1010 / pound.coefficient!,
              12 / pound.coefficient!,
              listValues: null
            ),
          ],
          expectedParams: ConversionParamSetValueBulkModel.singleCompact(
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
          ),
          expectedSrc: (ton, 1.02, 0.022, listValues: null),
          expectedUnitValues: [
            (ton, 1.02, 0.022, listValues: null),
            (
              pound,
              1020 / pound.coefficient!,
              22 / pound.coefficient!,
              listValues: null
            ),
          ],
        );
      });

      test("Should change param 'Bar Weight' [lb: 22 -> 44]", () async {
        await testCaseCompact(
          unitGroup: massGroup,
          useCase: useCase,
          delta: EditConversionParamValueDelta.raw(
            newValue: 44,
            paramId: barWeightParam.id,
            paramSetId: barbellWeightParamSet.id,
          ),
          currentParams: ConversionParamSetValueBulkModel.singleCompact(
            paramSet: barbellWeightParamSet,
            paramValues: const [
              (
                barWeightParam,
                22,
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
          ),
          currentSrc: (ton, 1.01, 0.012, listValues: null),
          currentUnitValues: [
            (ton, 1.01, 0.012, listValues: null),
            (
              pound,
              1010 / pound.coefficient!,
              12 / pound.coefficient!,
              listValues: null
            ),
          ],
          expectedParams: ConversionParamSetValueBulkModel.singleCompact(
            paramSet: barbellWeightParamSet,
            paramValues: const [
              (
                barWeightParam,
                44,
                null,
                unit: pound,
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
          ),
          expectedSrc: (ton, 1.02, 0.022, listValues: null),
          expectedUnitValues: [
            (ton, 1.02, 0.022, listValues: null),
            (
              pound,
              1020 / pound.coefficient!,
              22 / pound.coefficient!,
              listValues: null
            ),
          ],
        );
      });
    });

    group("Should recalculate conversion by changed param 'One Size Weight'",
        () {
      group("Should change 'One Size Weight' value [kg: 30 -> 40]", () {
        test("Should recalc for 'Bar Weight' = 10 kg", () async {
          await testCaseCompact(
            unitGroup: massGroup,
            useCase: useCase,
            delta: EditConversionParamValueDelta.raw(
              newValue: '40',
              newDefaultValue: '1',
              paramId: oneSideWeightParam.id,
              paramSetId: barbellWeightParamSet.id,
            ),
            currentParams: ConversionParamSetValueBulkModel.singleCompact(
              paramSet: barbellWeightParamSet,
              paramValues: const [
                (
                  barWeightParam,
                  10,
                  null,
                  unit: kilogram,
                  calculated: false,
                  listValues: null,
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
            ),
            currentSrc: (kilogram, 70, 12, listValues: null),
            currentUnitValues: [
              (kilogram, 70, 12, listValues: null),
              (
                pound,
                70 / pound.coefficient!,
                12 / pound.coefficient!,
                listValues: null
              ),
            ],
            expectedParams: ConversionParamSetValueBulkModel.singleCompact(
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
            ),
            expectedSrc: (kilogram, 90, 12, listValues: null),
            expectedUnitValues: [
              (kilogram, 90, 12, listValues: null),
              (
                pound,
                90 / pound.coefficient!,
                12 / pound.coefficient!,
                listValues: null
              ),
            ],
          );
        });

        test("Should recalc for 'Bar Weight' = 22 lb", () async {
          await testCaseCompact(
            unitGroup: massGroup,
            useCase: useCase,
            delta: EditConversionParamValueDelta.raw(
              newValue: '40',
              newDefaultValue: '1',
              paramId: oneSideWeightParam.id,
              paramSetId: barbellWeightParamSet.id,
            ),
            currentParams: ConversionParamSetValueBulkModel.singleCompact(
              paramSet: barbellWeightParamSet,
              paramValues: [
                (
                  barWeightParam,
                  10 / pound.coefficient!,
                  null,
                  unit: pound,
                  calculated: false,
                  listValues: null
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
            ),
            currentSrc: (kilogram, 70, 12, listValues: null),
            currentUnitValues: [
              (kilogram, 70, 12, listValues: null),
              (
                pound,
                70 / pound.coefficient!,
                12 / pound.coefficient!,
                listValues: null
              ),
            ],
            expectedParams: ConversionParamSetValueBulkModel.singleCompact(
              paramSet: barbellWeightParamSet,
              paramValues: [
                (
                  barWeightParam,
                  10 / pound.coefficient!,
                  null,
                  unit: pound,
                  calculated: false,
                  listValues: barWeightParamLbListValues,
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
            ),
            expectedSrc: (
              kilogram,
              22 * pound.coefficient! + 40 * 2,
              22 * pound.coefficient! + 1 * 2,
              listValues: null
            ),
            expectedUnitValues: [
              (
                kilogram,
                22 * pound.coefficient! + 40 * 2,
                22 * pound.coefficient! + 1 * 2,
                listValues: null
              ),
              (
                pound,
                22 + 80 / pound.coefficient!,
                22 + 2 / pound.coefficient!,
                listValues: null
              ),
            ],
          );
        });
      });
    });
  });

  group('By formula - clothes size', () {
    group("Should calculate by 'Person' list value [Man -> Woman]", () {
      group("Should recalc 'Garment' list value [empty -> default Shirt]", () {
        test("Should recalc 'Height' list value [cm: empty -> default ..-156]",
            () async {
          await testCaseCompact(
            unitGroup: clothesSizeGroup,
            useCase: useCase,
            delta: EditConversionParamValueDelta.raw(
              newValue: "Woman",
              paramId: personParam.id,
              paramSetId: personParam.paramSetId,
            ),
            currentParams: ConversionParamSetValueBulkModel.singleCompact(
              paramSet: clothesSizeParamSet,
              paramValues: const [
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
            ),
            currentSrc: (
              spainClothSize,
              null,
              null,
              listValues: spainClothSizeListValues,
            ),
            currentUnitValues: [
              (
                italianClothSize,
                null,
                null,
                listValues: italianClothesSizeListValues,
              ),
              (
                spainClothSize,
                null,
                null,
                listValues: spainClothSizeListValues,
              ),
              (
                germanyClothSize,
                null,
                null,
                listValues: germanyClothesSizeListValues,
              ),
            ],
            expectedParams: ConversionParamSetValueBulkModel.singleCompact(
              paramSet: clothesSizeParamSet,
              paramValues: [
                (
                  personParam,
                  "Woman",
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
                  listValues: garmentParamListValues,
                ),
                (
                  heightParam,
                  const NumRange.withRight(0, 156),
                  null,
                  unit: centimeter,
                  calculated: false,
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
            expectedSrc: (
              spainClothSize,
              34,
              null,
              listValues: spainClothSizeListValues,
            ),
            expectedUnitValues: [
              (
                italianClothSize,
                38,
                null,
                listValues: italianClothesSizeListValues
              ),
              (
                spainClothSize,
                34,
                null,
                listValues: spainClothSizeListValues,
              ),
              (
                germanyClothSize,
                32,
                null,
                listValues: germanyClothesSizeListValues
              ),
            ],
          );
        });

        test("Should recalc 'Height' list value [m: empty -> default ..-1.56]",
            () async {
          await testCaseCompact(
            unitGroup: clothesSizeGroup,
            useCase: useCase,
            delta: EditConversionParamValueDelta.raw(
              newValue: "Woman",
              paramId: personParam.id,
              paramSetId: personParam.paramSetId,
            ),
            currentParams: ConversionParamSetValueBulkModel.singleCompact(
              paramSet: clothesSizeParamSet,
              paramValues: const [
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
            ),
            currentSrc: (
              spainClothSize,
              null,
              null,
              listValues: spainClothSizeListValues,
            ),
            currentUnitValues: [
              (
                italianClothSize,
                null,
                null,
                listValues: italianClothesSizeListValues,
              ),
              (
                spainClothSize,
                null,
                null,
                listValues: spainClothSizeListValues,
              ),
              (
                germanyClothSize,
                null,
                null,
                listValues: germanyClothesSizeListValues,
              ),
            ],
            expectedParams: ConversionParamSetValueBulkModel.singleCompact(
              paramSet: clothesSizeParamSet,
              paramValues: [
                (
                  personParam,
                  "Woman",
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
                  listValues: garmentParamListValues,
                ),
                (
                  heightParam,
                  const NumRange.withRight(0, 1.56),
                  null,
                  unit: meter,
                  calculated: false,
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
            expectedSrc: (
              spainClothSize,
              34,
              null,
              listValues: spainClothSizeListValues
            ),
            expectedUnitValues: [
              (
                italianClothSize,
                38,
                null,
                listValues: italianClothesSizeListValues,
              ),
              (
                spainClothSize,
                34,
                null,
                listValues: spainClothSizeListValues,
              ),
              (
                germanyClothSize,
                32,
                null,
                listValues: germanyClothesSizeListValues,
              ),
            ],
          );
        });
      });

      group("Should leave 'Garment' list value 'Shirt'", () {
        test("Should leave as is recalc param 'Height' list value", () async {
          await testCaseCompact(
            unitGroup: clothesSizeGroup,
            useCase: useCase,
            delta: EditConversionParamValueDelta.raw(
              newValue: "Woman",
              paramId: personParam.id,
              paramSetId: personParam.paramSetId,
            ),
            currentParams: ConversionParamSetValueBulkModel.singleCompact(
              paramSet: clothesSizeParamSet,
              paramValues: const [
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
                  NumRange.withRight(174, 180),
                  null,
                  unit: centimeter,
                  calculated: false,
                  listValues: null
                ),
              ],
            ),
            currentSrc: (
              spainClothSize,
              40,
              null,
              listValues: spainClothSizeListValues,
            ),
            currentUnitValues: [
              (
                italianClothSize,
                48,
                null,
                listValues: italianClothesSizeListValues,
              ),
              (
                spainClothSize,
                40,
                null,
                listValues: spainClothSizeListValues,
              ),
              (
                germanyClothSize,
                46,
                null,
                listValues: germanyClothesSizeListValues,
              ),
            ],
            expectedParams: ConversionParamSetValueBulkModel.singleCompact(
              paramSet: clothesSizeParamSet,
              paramValues: [
                (
                  personParam,
                  "Woman",
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
                  listValues: garmentParamListValues,
                ),
                (
                  heightParam,
                  const NumRange.withRight(174, 180),
                  null,
                  unit: centimeter,
                  calculated: false,
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
            expectedSrc: (
              spainClothSize,
              42,
              null,
              listValues: spainClothSizeListValues,
            ),
            expectedUnitValues: [
              (
                italianClothSize,
                46,
                null,
                listValues: italianClothesSizeListValues
              ),
              (spainClothSize, 42, null, listValues: spainClothSizeListValues),
              (
                germanyClothSize,
                40,
                null,
                listValues: germanyClothesSizeListValues
              ),
            ],
          );
        });
      });
    });

    group("Should calculate by 'Garment' list value [Shirt -> Trousers]", () {
      group("Should leave 'Person' list value 'Man'", () {
        test(
            "Should recalc param 'Height' list value [cm: 174-180 -> default ..-164]",
            () async {
          await testCaseCompact(
            unitGroup: clothesSizeGroup,
            useCase: useCase,
            delta: EditConversionParamValueDelta.raw(
              newValue: "Trousers",
              paramId: garmentParam.id,
              paramSetId: garmentParam.paramSetId,
            ),
            currentParams: ConversionParamSetValueBulkModel.singleCompact(
              paramSet: clothesSizeParamSet,
              paramValues: const [
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
                  NumRange.withRight(174, 180),
                  null,
                  unit: centimeter,
                  calculated: false,
                  listValues: null
                ),
              ],
            ),
            currentSrc: (
              spainClothSize,
              40,
              null,
              listValues: spainClothSizeListValues,
            ),
            currentUnitValues: [
              (
                italianClothSize,
                48,
                null,
                listValues: italianClothesSizeListValues
              ),
              (spainClothSize, 40, null, listValues: spainClothSizeListValues),
              (
                germanyClothSize,
                46,
                null,
                listValues: germanyClothesSizeListValues
              ),
            ],
            expectedParams: ConversionParamSetValueBulkModel.singleCompact(
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
                  listValues: null
                ),
                (
                  heightParam,
                  const NumRange.withRight(0, 164),
                  null,
                  unit: centimeter,
                  calculated: false,
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
            expectedSrc: (
              spainClothSize,
              36,
              null,
              listValues: spainClothSizeListValues
            ),
            expectedUnitValues: [
              (
                italianClothSize,
                44,
                null,
                listValues: italianClothesSizeListValues
              ),
              (spainClothSize, 36, null, listValues: spainClothSizeListValues),
              (
                germanyClothSize,
                44,
                null,
                listValues: germanyClothesSizeListValues
              ),
            ],
          );
        });

        test(
            "Should recalc param 'Height' list value [m: 1.74-1.8 -> default ..-1.64]",
            () async {
          await testCaseCompact(
            unitGroup: clothesSizeGroup,
            useCase: useCase,
            delta: EditConversionParamValueDelta.raw(
              newValue: "Trousers",
              paramId: garmentParam.id,
              paramSetId: garmentParam.paramSetId,
            ),
            currentParams: ConversionParamSetValueBulkModel.singleCompact(
              paramSet: clothesSizeParamSet,
              paramValues: const [
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
                  NumRange.withRight(1.74, 1.8),
                  null,
                  unit: meter,
                  calculated: false,
                  listValues: null
                ),
              ],
            ),
            currentSrc: (
              spainClothSize,
              40,
              null,
              listValues: spainClothSizeListValues,
            ),
            currentUnitValues: [
              (
                italianClothSize,
                48,
                null,
                listValues: italianClothesSizeListValues
              ),
              (spainClothSize, 40, null, listValues: spainClothSizeListValues),
              (
                germanyClothSize,
                46,
                null,
                listValues: germanyClothesSizeListValues
              ),
            ],
            expectedParams: ConversionParamSetValueBulkModel.singleCompact(
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
                  listValues: null
                ),
                (
                  heightParam,
                  const NumRange.withRight(0, 1.64),
                  null,
                  unit: meter,
                  calculated: false,
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
            expectedSrc: (
              spainClothSize,
              36,
              null,
              listValues: spainClothSizeListValues
            ),
            expectedUnitValues: [
              (
                italianClothSize,
                44,
                null,
                listValues: italianClothesSizeListValues
              ),
              (spainClothSize, 36, null, listValues: spainClothSizeListValues),
              (
                germanyClothSize,
                44,
                null,
                listValues: germanyClothesSizeListValues
              ),
            ],
          );
        });
      });
    });

    test("Should calculate by 'Height' list value [cm: 164-170 -> 178-184]",
        () async {
      await testCaseCompact(
        unitGroup: clothesSizeGroup,
        useCase: useCase,
        delta: EditConversionParamValueDelta.raw(
          newValue: const NumRange.withRight(178, 184),
          paramId: heightParam.id,
          paramSetId: heightParam.paramSetId,
        ),
        currentParams: ConversionParamSetValueBulkModel.singleCompact(
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
              const NumRange.withRight(164, 170),
              null,
              unit: centimeter,
              calculated: false,
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
        currentSrc: (
          spainClothSize,
          36,
          null,
          listValues: spainClothSizeListValues,
        ),
        currentUnitValues: [
          (
            italianClothSize,
            44,
            null,
            listValues: italianClothesSizeListValues
          ),
          (spainClothSize, 36, null, listValues: spainClothSizeListValues),
          (
            germanyClothSize,
            42,
            null,
            listValues: germanyClothesSizeListValues
          ),
        ],
        expectedParams: ConversionParamSetValueBulkModel.singleCompact(
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
              const NumRange.withRight(178, 184),
              null,
              unit: centimeter,
              calculated: false,
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
        expectedSrc: (
          spainClothSize,
          42,
          null,
          listValues: spainClothSizeListValues
        ),
        expectedUnitValues: [
          (
            italianClothSize,
            50,
            null,
            listValues: italianClothesSizeListValues
          ),
          (spainClothSize, 42, null, listValues: spainClothSizeListValues),
          (
            germanyClothSize,
            48,
            null,
            listValues: germanyClothesSizeListValues
          ),
        ],
      );
    });

    test("Should calculate by 'Height' list value [m: 1.64-1.7 -> 1.78-1.84]",
        () async {
      await testCaseCompact(
        unitGroup: clothesSizeGroup,
        useCase: useCase,
        delta: EditConversionParamValueDelta.raw(
          newValue: const NumRange.withRight(1.78, 1.84),
          paramId: heightParam.id,
          paramSetId: heightParam.paramSetId,
        ),
        currentParams: ConversionParamSetValueBulkModel.singleCompact(
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
              const NumRange.withRight(1.64, 1.7),
              null,
              unit: meter,
              calculated: false,
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
        currentSrc: (
          spainClothSize,
          36,
          null,
          listValues: spainClothSizeListValues
        ),
        currentUnitValues: [
          (
            italianClothSize,
            44,
            null,
            listValues: italianClothesSizeListValues
          ),
          (spainClothSize, 36, null, listValues: spainClothSizeListValues),
          (
            germanyClothSize,
            42,
            null,
            listValues: germanyClothesSizeListValues
          ),
        ],
        expectedParams: ConversionParamSetValueBulkModel.singleCompact(
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
              const NumRange.withRight(1.78, 1.84),
              null,
              unit: meter,
              calculated: false,
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
        expectedSrc: (
          spainClothSize,
          42,
          null,
          listValues: spainClothSizeListValues
        ),
        expectedUnitValues: [
          (
            italianClothSize,
            50,
            null,
            listValues: italianClothesSizeListValues
          ),
          (spainClothSize, 42, null, listValues: spainClothSizeListValues),
          (
            germanyClothSize,
            48,
            null,
            listValues: germanyClothesSizeListValues
          ),
        ],
      );
    });
  });
}
