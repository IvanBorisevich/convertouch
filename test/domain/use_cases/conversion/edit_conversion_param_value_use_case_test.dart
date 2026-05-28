import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/num_range.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
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
                  listValues: barWeightParamPoundListValues,
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
                  heightRangesFrom0_156To186InCm.items[0].valueModel,
                  null,
                  unit: centimeter,
                  calculated: false,
                  listValues: heightRangesFrom0_156To186InCm,
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
                  heightRangesFrom0_156To186InMeter.items[0].valueModel,
                  null,
                  unit: meter,
                  calculated: false,
                  listValues: heightRangesFrom0_156To186InMeter,
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
                  heightRangesFrom0_156To186InCm.items[4].valueModel,
                  null,
                  unit: centimeter,
                  calculated: false,
                  listValues: heightRangesFrom0_156To186InCm,
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
                  heightRangesFrom0_164To188InCm.items[0].valueModel,
                  null,
                  unit: centimeter,
                  calculated: false,
                  listValues: heightRangesFrom0_164To188InCm,
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
                  heightRangesFrom0_164To188InMeter.items[0].valueModel,
                  null,
                  unit: meter,
                  calculated: false,
                  listValues: heightRangesFrom0_164To188InMeter,
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
              heightRangesFrom0_164To190InCm.items[1].valueModel,
              null,
              unit: centimeter,
              calculated: false,
              listValues: heightRangesFrom0_164To190InCm,
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
              heightRangesFrom0_164To190InCm.items[4].valueModel,
              null,
              unit: centimeter,
              calculated: false,
              listValues: heightRangesFrom0_164To190InCm,
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
              heightRangesFrom0_164To190InMeter.items[1].valueModel,
              null,
              unit: meter,
              calculated: false,
              listValues: heightRangesFrom0_164To190InMeter,
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
              heightRangesFrom0_164To190InMeter.items[4].valueModel,
              null,
              unit: meter,
              calculated: false,
              listValues: heightRangesFrom0_164To190InMeter,
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
