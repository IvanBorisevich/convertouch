import 'package:convertouch/data/repositories/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/num_range.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/edit_conversion_param_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_item_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_non_list_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_param_set_value_use_case.dart';
import 'package:convertouch/domain/use_cases/dynamic_data/fetch_dynamic_value_use_use.dart';
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

    const calculateDefaultValueUseCase = CalculateNonListDefaultValueUseCase(
      fetchDynamicValueUseCase: FetchDynamicValueUseCase(
        dynamicValueRepository: MockDynamicValueRepository(),
      ),
    );

    useCase = const EditConversionParamValueUseCase(
      calculateParamSetValueUseCase: CalculateParamSetValueUseCase(
        calculateParamValueUseValue: CalculateParamValueUseValue(
          calculateDefaultValueUseCase: calculateDefaultValueUseCase,
          fetchListValuesUseCase: FetchListValuesUseCase(
            listValueRepository: listValueRepository,
          ),
          unitGroupRepository: MockUnitGroupRepository(),
        ),
      ),
      calculateUnitValueUseValue: CalculateUnitValueUseValue(
        calculateDefaultValueUseCase: calculateDefaultValueUseCase,
        fetchListValuesUseCase: FetchListValuesUseCase(
          listValueRepository: listValueRepository,
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
            newValue: 20,
            paramId: barWeightParam.id,
            paramSetId: barbellWeightParamSet.id,
          ),
          currentParams: ConversionParamSetValueBulkModel.singleCompact(
            paramSet: barbellWeightParamSet,
            paramValues: [
              (
                barWeightParam,
                10,
                null,
                unit: kilogram,
                calculated: false,
                listValuesFetchResult: barWeightParamKgListValues
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
          ),
          currentSrc: (ton, 1.01, 0.012, listValuesFetchResult: null),
          currentUnitValues: [
            (ton, 1.01, 0.012, listValuesFetchResult: null),
            (
              pound,
              1010 / pound.coefficient!,
              12 / pound.coefficient!,
              listValuesFetchResult: null
            ),
          ],
          expectedParams: ConversionParamSetValueBulkModel.singleCompact(
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
          ),
          expectedSrc: (ton, 1.02, 0.022, listValuesFetchResult: null),
          expectedUnitValues: [
            (ton, 1.02, 0.022, listValuesFetchResult: null),
            (
              pound,
              1020 / pound.coefficient!,
              22 / pound.coefficient!,
              listValuesFetchResult: null
            ),
          ],
        );
      });

      test("Should change param 'Bar Weight' [lb: 22 -> 44]", () async {
        await testCaseCompact(
          unitGroup: massGroup,
          useCase: useCase,
          delta: EditConversionParamValueDelta.raw(
            newValue: barWeightParamPoundListValues.items[1],
            paramId: barWeightParam.id,
            paramSetId: barbellWeightParamSet.id,
          ),
          currentParams: ConversionParamSetValueBulkModel.singleCompact(
            paramSet: barbellWeightParamSet,
            paramValues: [
              (
                barWeightParam,
                22,
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
          ),
          currentSrc: (ton, 1.01, 0.012, listValuesFetchResult: null),
          currentUnitValues: [
            (ton, 1.01, 0.012, listValuesFetchResult: null),
            (
              pound,
              1010 / pound.coefficient!,
              12 / pound.coefficient!,
              listValuesFetchResult: null
            ),
          ],
          expectedParams: ConversionParamSetValueBulkModel.singleCompact(
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
          ),
          expectedSrc: (ton, 1.02, 0.022, listValuesFetchResult: null),
          expectedUnitValues: [
            (ton, 1.02, 0.022, listValuesFetchResult: null),
            (
              pound,
              1020 / pound.coefficient!,
              22 / pound.coefficient!,
              listValuesFetchResult: null
            ),
          ],
        );
      });
    });

    group("Should recalculate conversion by changed param 'One Size Weight'",
        () {
      group("Should change 'One Size Weight' value [kg: 30 -> 40]", () {
        test("Should recalc conversion for 'Bar Weight' = 10 kg", () async {
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
            ),
            currentSrc: (kilogram, 70, 12, listValuesFetchResult: null),
            currentUnitValues: [
              (kilogram, 70, 12, listValuesFetchResult: null),
              (
                pound,
                70 / pound.coefficient!,
                12 / pound.coefficient!,
                listValuesFetchResult: null
              ),
            ],
            expectedParams: ConversionParamSetValueBulkModel.singleCompact(
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
            ),
            expectedSrc: (kilogram, 90, 12, listValuesFetchResult: null),
            expectedUnitValues: [
              (kilogram, 90, 12, listValuesFetchResult: null),
              (
                pound,
                90 / pound.coefficient!,
                12 / pound.coefficient!,
                listValuesFetchResult: null
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
                  barWeightParamPoundListValues.items[0],
                  null,
                  unit: pound,
                  calculated: false,
                  listValuesFetchResult: barWeightParamPoundListValues,
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
            ),
            currentSrc: (kilogram, 70, 12, listValuesFetchResult: null),
            currentUnitValues: [
              (kilogram, 70, 12, listValuesFetchResult: null),
              (
                pound,
                70 / pound.coefficient!,
                12 / pound.coefficient!,
                listValuesFetchResult: null
              ),
            ],
            expectedParams: ConversionParamSetValueBulkModel.singleCompact(
              paramSet: barbellWeightParamSet,
              paramValues: [
                (
                  barWeightParam,
                  barWeightParamPoundListValues.items[0],
                  null,
                  unit: pound,
                  calculated: false,
                  listValuesFetchResult: barWeightParamPoundListValues,
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
            ),
            expectedSrc: (kilogram, 90, 12, listValuesFetchResult: null),
            expectedUnitValues: [
              (kilogram, 90, 12, listValuesFetchResult: null),
              (
                pound,
                90 / pound.coefficient!,
                12 / pound.coefficient!,
                listValuesFetchResult: null
              ),
            ],
          );
        });
      });
    });
  });

  group('By formula - clothes size', () {
    group("Should change 'Person' list value [Man -> Woman]", () {
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
              paramValues: [
                (
                  personParam,
                  "Man",
                  null,
                  unit: null,
                  calculated: false,
                  listValuesFetchResult: personParamListValues
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
            ),
            currentSrc: (
              esClothesSize,
              null,
              null,
              listValuesFetchResult: esClothesSizes,
            ),
            currentUnitValues: [
              (
                itClothesSize,
                null,
                null,
                listValuesFetchResult: itClothesSizes,
              ),
              (
                esClothesSize,
                null,
                null,
                listValuesFetchResult: esClothesSizes,
              ),
              (
                deClothesSize,
                null,
                null,
                listValuesFetchResult: deClothesSizes,
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
                  listValuesFetchResult:
                      womanTrousersHeightRangesFrom0_156To186InCm,
                ),
              ],
            ),
            expectedSrc: (
              esClothesSize,
              34,
              null,
              listValuesFetchResult: esClothesSizes,
            ),
            expectedUnitValues: [
              (itClothesSize, 38, null, listValuesFetchResult: itClothesSizes),
              (
                esClothesSize,
                34,
                null,
                listValuesFetchResult: esClothesSizes,
              ),
              (deClothesSize, 32, null, listValuesFetchResult: deClothesSizes),
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
            ),
            currentSrc: (
              esClothesSize,
              null,
              null,
              listValuesFetchResult: esClothesSizes,
            ),
            currentUnitValues: [
              (
                itClothesSize,
                null,
                null,
                listValuesFetchResult: itClothesSizes,
              ),
              (
                esClothesSize,
                null,
                null,
                listValuesFetchResult: esClothesSizes,
              ),
              (
                deClothesSize,
                null,
                null,
                listValuesFetchResult: deClothesSizes,
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
            ),
            expectedSrc: (
              esClothesSize,
              34,
              null,
              listValuesFetchResult: esClothesSizes
            ),
            expectedUnitValues: [
              (
                itClothesSize,
                38,
                null,
                listValuesFetchResult: itClothesSizes,
              ),
              (
                esClothesSize,
                34,
                null,
                listValuesFetchResult: esClothesSizes,
              ),
              (
                deClothesSize,
                32,
                null,
                listValuesFetchResult: deClothesSizes,
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
            ),
            currentSrc: (
              esClothesSize,
              40,
              null,
              listValuesFetchResult: esClothesSizes,
            ),
            currentUnitValues: [
              (
                itClothesSize,
                48,
                null,
                listValuesFetchResult: itClothesSizes,
              ),
              (
                esClothesSize,
                40,
                null,
                listValuesFetchResult: esClothesSizes,
              ),
              (
                deClothesSize,
                46,
                null,
                listValuesFetchResult: deClothesSizes,
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
                  listValuesFetchResult:
                      womanTrousersHeightRangesFrom0_156To186InCm,
                ),
              ],
            ),
            expectedSrc: (
              esClothesSize,
              42,
              null,
              listValuesFetchResult: esClothesSizes,
            ),
            expectedUnitValues: [
              (itClothesSize, 46, null, listValuesFetchResult: itClothesSizes),
              (esClothesSize, 42, null, listValuesFetchResult: esClothesSizes),
              (deClothesSize, 40, null, listValuesFetchResult: deClothesSizes),
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
            ),
            currentSrc: (
              esClothesSize,
              40,
              null,
              listValuesFetchResult: esClothesSizes,
            ),
            currentUnitValues: [
              (itClothesSize, 48, null, listValuesFetchResult: itClothesSizes),
              (esClothesSize, 40, null, listValuesFetchResult: esClothesSizes),
              (deClothesSize, 46, null, listValuesFetchResult: deClothesSizes),
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
                  listValuesFetchResult:
                      manTrousersHeightRangesFrom0_164To188InCm,
                ),
              ],
            ),
            expectedSrc: (
              esClothesSize,
              36,
              null,
              listValuesFetchResult: esClothesSizes
            ),
            expectedUnitValues: [
              (itClothesSize, 44, null, listValuesFetchResult: itClothesSizes),
              (esClothesSize, 36, null, listValuesFetchResult: esClothesSizes),
              (deClothesSize, 44, null, listValuesFetchResult: deClothesSizes),
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
            ),
            currentSrc: (
              esClothesSize,
              40,
              null,
              listValuesFetchResult: esClothesSizes,
            ),
            currentUnitValues: [
              (itClothesSize, 48, null, listValuesFetchResult: itClothesSizes),
              (esClothesSize, 40, null, listValuesFetchResult: esClothesSizes),
              (deClothesSize, 46, null, listValuesFetchResult: deClothesSizes),
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
                  listValuesFetchResult:
                      manTrousersHeightRangesFrom0_164To188InMeter,
                ),
              ],
            ),
            expectedSrc: (
              esClothesSize,
              36,
              null,
              listValuesFetchResult: esClothesSizes
            ),
            expectedUnitValues: [
              (itClothesSize, 44, null, listValuesFetchResult: itClothesSizes),
              (esClothesSize, 36, null, listValuesFetchResult: esClothesSizes),
              (deClothesSize, 44, null, listValuesFetchResult: deClothesSizes),
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
        ),
        currentSrc: (
          esClothesSize,
          36,
          null,
          listValuesFetchResult: esClothesSizes,
        ),
        currentUnitValues: [
          (itClothesSize, 44, null, listValuesFetchResult: itClothesSizes),
          (esClothesSize, 36, null, listValuesFetchResult: esClothesSizes),
          (deClothesSize, 42, null, listValuesFetchResult: deClothesSizes),
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
        ),
        expectedSrc: (
          esClothesSize,
          42,
          null,
          listValuesFetchResult: esClothesSizes
        ),
        expectedUnitValues: [
          (itClothesSize, 50, null, listValuesFetchResult: itClothesSizes),
          (esClothesSize, 42, null, listValuesFetchResult: esClothesSizes),
          (deClothesSize, 48, null, listValuesFetchResult: deClothesSizes),
        ],
      );
    });

    test("Should calculate by 'Height' list value [m: 1.64-1.7 -> 1.78-1.84]",
        () async {
      await testCaseCompact(
        unitGroup: clothesSizeGroup,
        useCase: useCase,
        delta: EditConversionParamValueDelta.raw(
          newValue: manShirtHeightRangesFrom0_164To190InMeter.items[4],
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
        ),
        currentSrc: (
          esClothesSize,
          36,
          null,
          listValuesFetchResult: esClothesSizes
        ),
        currentUnitValues: [
          (itClothesSize, 44, null, listValuesFetchResult: itClothesSizes),
          (esClothesSize, 36, null, listValuesFetchResult: esClothesSizes),
          (deClothesSize, 42, null, listValuesFetchResult: deClothesSizes),
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
        ),
        expectedSrc: (
          esClothesSize,
          42,
          null,
          listValuesFetchResult: esClothesSizes
        ),
        expectedUnitValues: [
          (itClothesSize, 50, null, listValuesFetchResult: itClothesSizes),
          (esClothesSize, 42, null, listValuesFetchResult: esClothesSizes),
          (deClothesSize, 48, null, listValuesFetchResult: deClothesSizes),
        ],
      );
    });
  });
}
