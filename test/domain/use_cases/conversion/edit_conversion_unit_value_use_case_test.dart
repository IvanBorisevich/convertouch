import 'package:convertouch/data/repositories/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/num_range.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/edit_conversion_unit_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_param_set_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_param_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_unit_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/init_item_list_values_use_case.dart';
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
  late EditConversionUnitValueUseCase useCase;

  setUpAll(() {
    const listValueRepository = ListValueRepositoryImpl(
      networkRepository: MockNetworkRepository(),
    );

    const initUnitListValuesUseCase = InitUnitListValuesUseCase(
      fetchListValuesUseCase: FetchListValuesUseCase(
        listValueRepository: listValueRepository,
      ),
    );

    useCase = const EditConversionUnitValueUseCase(
      calculateUnitValueUseValue: CalculateUnitValueUseValue(
        calculateDefaultValueUseCase: CalculateDefaultValueUseCase(
          dynamicValueRepository: MockDynamicValueRepository(),
          listValueRepository: listValueRepository,
        ),
        unitGroupRepository: MockUnitGroupRepository(),
        initUnitListValuesUseCase: initUnitListValuesUseCase,
      ),
      calculateParamSetValueUseCase: CalculateParamSetValueUseCase(
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
    );
  });

  group('By coefficients', () {
    group('Without params - length', () {
      test('Should calculate by [dm: 10 -> 2]', () async {
        await testCase(
          useCase: useCase,
          delta: EditConversionUnitValueDelta.raw(
            newValue: '2',
            newDefaultValue: '1',
            unitId: decimeter.id,
          ),
          unitGroup: lengthGroup,
          currentSrc: ConversionUnitValueModel.tuple(decimeter, 10, 1),
          currentParams: null,
          currentUnitValues: [
            ConversionUnitValueModel.tuple(decimeter, 10, 1),
            ConversionUnitValueModel.tuple(centimeter, 100, 10),
          ],
          expectedSrc: ConversionUnitValueModel.tuple(decimeter, 2, 1),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(decimeter, 2, 1),
            ConversionUnitValueModel.tuple(centimeter, 20, 10),
          ],
        );
      });
    });

    group('With params - mass', () {
      test(
          "Should calculate conversion and the param 'One Side Weight' "
          "by src value [kg: 60 -> 100] "
          "(calculated = true, enableFirstCalculableParamIfNoCalculatedEnabled = false)",
          () async {
        await testCase(
          unitGroup: massGroup,
          useCase: useCase,
          delta: EditConversionUnitValueDelta.raw(
            newValue: "100",
            newDefaultValue: "1",
            unitId: kilogram.id,
          ),
          currentParams: ConversionParamSetValueBulkModel.single(
            paramSet: barbellWeightParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(barWeightParam, 20, null,
                  unit: kilogram),
              ConversionParamValueModel.tuple(oneSideWeightParam, 20, 1,
                  unit: kilogram, calculated: true),
            ],
          ),
          currentSrc: ConversionUnitValueModel.tuple(kilogram, 60, 22),
          currentUnitValues: [
            ConversionUnitValueModel.tuple(kilogram, 60, 22),
            ConversionUnitValueModel.tuple(
                pound, 60 / pound.coefficient!, 22 / pound.coefficient!),
          ],
          expectedParams: ConversionParamSetValueBulkModel.single(
            paramSet: barbellWeightParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(barWeightParam, 20, null,
                  unit: kilogram),
              ConversionParamValueModel.tuple(
                oneSideWeightParam,
                null,
                40,
                unit: kilogram,
                calculated: true,
              ),
            ],
          ),
          expectedSrc: ConversionUnitValueModel.tuple(kilogram, 100, 1),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(kilogram, 100, 1),
            ConversionUnitValueModel.tuple(
                pound, 100 / pound.coefficient!, 1 / pound.coefficient!),
          ],
        );
      });

      test(
          "Should calculate conversion, but NOT the param 'One Side Weight' "
          "by src value [kg: 60 -> 100] "
          "(calculated = false, enableFirstCalculableParamIfNoCalculatedEnabled = false)",
          () async {
        await testCase(
          unitGroup: massGroup,
          useCase: useCase,
          delta: EditConversionUnitValueDelta.raw(
            newValue: "100",
            newDefaultValue: "1",
            unitId: kilogram.id,
          ),
          currentParams: ConversionParamSetValueBulkModel.single(
            paramSet: barbellWeightParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(barWeightParam, 20, null,
                  unit: kilogram),
              ConversionParamValueModel.tuple(oneSideWeightParam, 20, 1,
                  unit: kilogram),
            ],
          ),
          currentSrc: ConversionUnitValueModel.tuple(kilogram, 60, 22),
          currentUnitValues: [
            ConversionUnitValueModel.tuple(kilogram, 60, 22),
            ConversionUnitValueModel.tuple(
                pound, 60 / pound.coefficient!, 22 / pound.coefficient!),
          ],
          expectedSrc: ConversionUnitValueModel.tuple(kilogram, 100, 1),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(kilogram, 100, 1),
            ConversionUnitValueModel.tuple(
                pound, 100 / pound.coefficient!, 1 / pound.coefficient!),
          ],
          expectedParams: ConversionParamSetValueBulkModel.single(
            paramSet: barbellWeightParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(barWeightParam, 20, null,
                  unit: kilogram, listValues: barWeightParamKgListValues),
              ConversionParamValueModel.tuple(oneSideWeightParam, 20, 1,
                  unit: kilogram),
            ],
          ),
        );
      });
    });
  });

  group('By formula', () {
    group('With params - clothes size', () {
      group("'Height' calculated = false", () {
        test("Should calculate by [Man, Shirt, h: cm ..-164 | EU: empty -> 42]",
            () async {
          await testCase(
            unitGroup: clothesSizeGroup,
            useCase: useCase,
            delta: EditConversionUnitValueDelta.raw(
              newValue: '42',
              unitId: europeanClothSize.id,
            ),
            currentParams: ConversionParamSetValueBulkModel.single(
              paramSet: clothesSizeParamSet,
              paramValues: [
                ConversionParamValueModel.tuple(personParam, "Man", null),
                ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                ConversionParamValueModel.tuple(
                    heightParam, const NumRange.withRight(0, 164), null,
                    unit: centimeter),
              ],
            ),
            currentSrc: ConversionUnitValueModel.tuple(
              europeanClothSize,
              null,
              null,
              listValues: europeanClothesSizes,
            ),
            currentUnitValues: [
              ConversionUnitValueModel.tuple(
                europeanClothSize,
                null,
                null,
                listValues: europeanClothesSizes,
              ),
              ConversionUnitValueModel.tuple(
                japanClothSize,
                null,
                null,
                listValues: japanClothesSizes,
              ),
            ],
            expectedParams: ConversionParamSetValueBulkModel.single(
              paramSet: clothesSizeParamSet,
              paramValues: [
                ConversionParamValueModel.tuple(
                  personParam,
                  "Man",
                  null,
                  listValues: personParamListValues,
                ),
                ConversionParamValueModel.tuple(
                  garmentParam,
                  "Shirt",
                  null,
                  listValues: garmentParamListValues,
                ),
                ConversionParamValueModel.tuple(
                  heightParam,
                  const NumRange.withRight(0, 164),
                  null,
                  unit: centimeter,
                  listValues: manShirtHeightRangesFrom0_164To190InCm,
                ),
              ],
            ),
            expectedSrc: ConversionUnitValueModel.tuple(
              europeanClothSize,
              42,
              null,
              listValues: europeanClothesSizes,
            ),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(
                europeanClothSize,
                42,
                null,
                listValues: europeanClothesSizes,
              ),
              ConversionUnitValueModel.tuple(
                japanClothSize,
                'S',
                null,
                listValues: japanClothesSizes,
              ),
            ],
          );
        });

        test("Should calculate by [Man, Shirt, h: m ..-1.64 | EU: empty -> 42]",
            () async {
          await testCase(
            unitGroup: clothesSizeGroup,
            useCase: useCase,
            delta: EditConversionUnitValueDelta.raw(
              newValue: '42',
              unitId: europeanClothSize.id,
            ),
            currentParams: ConversionParamSetValueBulkModel.single(
              paramSet: clothesSizeParamSet,
              paramValues: [
                ConversionParamValueModel.tuple(personParam, "Man", null),
                ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                ConversionParamValueModel.tuple(
                    heightParam, const NumRange.withRight(0, 1.64), null,
                    unit: meter),
              ],
            ),
            currentSrc: ConversionUnitValueModel.tuple(
              europeanClothSize,
              null,
              null,
              listValues: europeanClothesSizes,
            ),
            currentUnitValues: [
              ConversionUnitValueModel.tuple(
                europeanClothSize,
                null,
                null,
                listValues: europeanClothesSizes,
              ),
              ConversionUnitValueModel.tuple(
                japanClothSize,
                null,
                null,
                listValues: japanClothesSizes,
              ),
            ],
            expectedParams: ConversionParamSetValueBulkModel.single(
              paramSet: clothesSizeParamSet,
              paramValues: [
                ConversionParamValueModel.tuple(
                  personParam,
                  "Man",
                  null,
                  listValues: personParamListValues,
                ),
                ConversionParamValueModel.tuple(
                  garmentParam,
                  "Shirt",
                  null,
                  listValues: garmentParamListValues,
                ),
                ConversionParamValueModel.tuple(
                  heightParam,
                  manShirtHeightRangesFrom0_164To190InMeter.items[0].valueModel,
                  null,
                  unit: meter,
                  listValues: manShirtHeightRangesFrom0_164To190InMeter,
                ),
              ],
            ),
            expectedSrc: ConversionUnitValueModel.tuple(
              europeanClothSize,
              42,
              null,
              listValues: europeanClothesSizes,
            ),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(
                europeanClothSize,
                42,
                null,
                listValues: europeanClothesSizes,
              ),
              ConversionUnitValueModel.tuple(
                japanClothSize,
                'S',
                null,
                listValues: japanClothesSizes,
              ),
            ],
          );
        });

        test(
            "Should calculate by [Woman, Trousers, h: cm 156-162 | EU: empty -> 42]",
            () async {
          await testCase(
            unitGroup: clothesSizeGroup,
            useCase: useCase,
            delta: EditConversionUnitValueDelta.raw(
              newValue: '36',
              unitId: europeanClothSize.id,
            ),
            currentParams: ConversionParamSetValueBulkModel.single(
              paramSet: clothesSizeParamSet,
              paramValues: [
                ConversionParamValueModel.tuple(personParam, "Woman", null),
                ConversionParamValueModel.tuple(garmentParam, "Trousers", null),
                ConversionParamValueModel.tuple(
                    heightParam, const NumRange.withRight(156, 162), null,
                    unit: centimeter),
              ],
            ),
            currentSrc: ConversionUnitValueModel.tuple(
              europeanClothSize,
              null,
              null,
              listValues: europeanClothesSizes,
            ),
            currentUnitValues: [
              ConversionUnitValueModel.tuple(
                europeanClothSize,
                null,
                null,
                listValues: europeanClothesSizes,
              ),
              ConversionUnitValueModel.tuple(
                japanClothSize,
                null,
                null,
                listValues: japanClothesSizes,
              ),
            ],
            expectedParams: ConversionParamSetValueBulkModel.single(
              paramSet: clothesSizeParamSet,
              paramValues: [
                ConversionParamValueModel.tuple(
                  personParam,
                  "Woman",
                  null,
                  listValues: personParamListValues,
                ),
                ConversionParamValueModel.tuple(
                  garmentParam,
                  "Trousers",
                  null,
                  listValues: garmentParamListValues,
                ),
                ConversionParamValueModel.tuple(
                  heightParam,
                  const NumRange.withRight(156, 162),
                  null,
                  unit: centimeter,
                  listValues: womanTrousersHeightRangesFrom0_156To186InCm,
                ),
              ],
            ),
            expectedSrc: ConversionUnitValueModel.tuple(
              europeanClothSize,
              36,
              null,
              listValues: europeanClothesSizes,
            ),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(
                europeanClothSize,
                36,
                null,
                listValues: europeanClothesSizes,
              ),
              ConversionUnitValueModel.tuple(
                japanClothSize,
                'M',
                null,
                listValues: japanClothesSizes,
              ),
            ],
          );
        });

        test(
            "Should calculate by [Woman, Trousers, h: m 1.56-1.62 | EU: empty -> 42]",
            () async {
          await testCase(
            unitGroup: clothesSizeGroup,
            useCase: useCase,
            delta: EditConversionUnitValueDelta.raw(
              newValue: '36',
              unitId: europeanClothSize.id,
            ),
            currentParams: ConversionParamSetValueBulkModel.single(
              paramSet: clothesSizeParamSet,
              paramValues: [
                ConversionParamValueModel.tuple(personParam, "Woman", null),
                ConversionParamValueModel.tuple(garmentParam, "Trousers", null),
                ConversionParamValueModel.tuple(
                  heightParam,
                  womanTrousersHeightRangesFrom0_156To186InMeter
                      .items[1].valueModel,
                  null,
                  unit: meter,
                ),
              ],
            ),
            currentSrc: ConversionUnitValueModel.tuple(
              europeanClothSize,
              null,
              null,
              listValues: europeanClothesSizes,
            ),
            currentUnitValues: [
              ConversionUnitValueModel.tuple(
                europeanClothSize,
                null,
                null,
                listValues: europeanClothesSizes,
              ),
              ConversionUnitValueModel.tuple(
                japanClothSize,
                null,
                null,
                listValues: japanClothesSizes,
              ),
            ],
            expectedParams: ConversionParamSetValueBulkModel.single(
              paramSet: clothesSizeParamSet,
              paramValues: [
                ConversionParamValueModel.tuple(
                  personParam,
                  "Woman",
                  null,
                  listValues: personParamListValues,
                ),
                ConversionParamValueModel.tuple(
                  garmentParam,
                  "Trousers",
                  null,
                  listValues: garmentParamListValues,
                ),
                ConversionParamValueModel.tuple(
                  heightParam,
                  womanTrousersHeightRangesFrom0_156To186InMeter
                      .items[1].valueModel,
                  null,
                  unit: meter,
                  listValues: womanTrousersHeightRangesFrom0_156To186InMeter,
                ),
              ],
            ),
            expectedSrc: ConversionUnitValueModel.tuple(
              europeanClothSize,
              36,
              null,
              listValues: europeanClothesSizes,
            ),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(
                europeanClothSize,
                36,
                null,
                listValues: europeanClothesSizes,
              ),
              ConversionUnitValueModel.tuple(
                japanClothSize,
                'M',
                null,
                listValues: japanClothesSizes,
              ),
            ],
          );
        });
      });

      group("'Height' calculated = true", () {
        test("Should calculate by [Man, Shirt, h: cm ..-164 | EU: empty -> 42]",
            () async {
          await testCase(
            unitGroup: clothesSizeGroup,
            useCase: useCase,
            delta: EditConversionUnitValueDelta.raw(
              newValue: '42',
              unitId: europeanClothSize.id,
            ),
            currentParams: ConversionParamSetValueBulkModel.single(
              paramSet: clothesSizeParamSet,
              paramValues: [
                ConversionParamValueModel.tuple(personParam, "Man", null),
                ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                ConversionParamValueModel.tuple(
                  heightParam,
                  const NumRange.withRight(0, 164),
                  null,
                  unit: centimeter,
                  calculated: true,
                ),
              ],
            ),
            currentSrc: ConversionUnitValueModel.tuple(
              europeanClothSize,
              null,
              null,
              listValues: europeanClothesSizes,
            ),
            currentUnitValues: [
              ConversionUnitValueModel.tuple(
                europeanClothSize,
                null,
                null,
                listValues: europeanClothesSizes,
              ),
              ConversionUnitValueModel.tuple(
                japanClothSize,
                null,
                null,
                listValues: japanClothesSizes,
              ),
            ],
            expectedParams: ConversionParamSetValueBulkModel.single(
              paramSet: clothesSizeParamSet,
              paramValues: [
                ConversionParamValueModel.tuple(
                  personParam,
                  "Man",
                  null,
                ),
                ConversionParamValueModel.tuple(
                  garmentParam,
                  "Shirt",
                  null,
                ),
                ConversionParamValueModel.tuple(
                  heightParam,
                  const NumRange.withRight(0, 164),
                  null,
                  unit: centimeter,
                  listValues: manShirtHeightRangesFrom0_164To190InCm,
                  calculated: true,
                ),
              ],
            ),
            expectedSrc: ConversionUnitValueModel.tuple(
              europeanClothSize,
              42,
              null,
              listValues: europeanClothesSizes,
            ),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(
                europeanClothSize,
                42,
                null,
                listValues: europeanClothesSizes,
              ),
              ConversionUnitValueModel.tuple(
                japanClothSize,
                'S',
                null,
                listValues: japanClothesSizes,
              ),
            ],
          );
        });

        test("Should calculate by [Man, Shirt, h: m ..-1.64 | EU: empty -> 42]",
            () async {
          await testCase(
            unitGroup: clothesSizeGroup,
            useCase: useCase,
            delta: EditConversionUnitValueDelta.raw(
              newValue: '42',
              unitId: europeanClothSize.id,
            ),
            currentParams: ConversionParamSetValueBulkModel.single(
              paramSet: clothesSizeParamSet,
              paramValues: [
                ConversionParamValueModel.tuple(personParam, "Man", null),
                ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                ConversionParamValueModel.tuple(
                  heightParam,
                  manShirtHeightRangesFrom0_164To190InMeter.items[0].valueModel,
                  null,
                  unit: meter,
                  calculated: true,
                ),
              ],
            ),
            currentSrc: ConversionUnitValueModel.tuple(
              europeanClothSize,
              null,
              null,
              listValues: europeanClothesSizes,
            ),
            currentUnitValues: [
              ConversionUnitValueModel.tuple(
                europeanClothSize,
                null,
                null,
                listValues: europeanClothesSizes,
              ),
              ConversionUnitValueModel.tuple(
                japanClothSize,
                null,
                null,
                listValues: japanClothesSizes,
              ),
            ],
            expectedParams: ConversionParamSetValueBulkModel.single(
              paramSet: clothesSizeParamSet,
              paramValues: [
                ConversionParamValueModel.tuple(
                  personParam,
                  "Man",
                  null,
                ),
                ConversionParamValueModel.tuple(
                  garmentParam,
                  "Shirt",
                  null,
                ),
                ConversionParamValueModel.tuple(
                  heightParam,
                  manShirtHeightRangesFrom0_164To190InMeter.items[0].valueModel,
                  null,
                  unit: meter,
                  listValues: manShirtHeightRangesFrom0_164To190InMeter,
                  calculated: true,
                ),
              ],
            ),
            expectedSrc: ConversionUnitValueModel.tuple(
              europeanClothSize,
              42,
              null,
              listValues: europeanClothesSizes,
            ),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(
                europeanClothSize,
                42,
                null,
                listValues: europeanClothesSizes,
              ),
              ConversionUnitValueModel.tuple(
                japanClothSize,
                'S',
                null,
                listValues: japanClothesSizes,
              ),
            ],
          );
        });

        test(
            "Should calculate by [Man, Shirt, h: cm ..-164 | EU: 42 -> 50], "
            "should recalculate 'Height' to cm: 178-184", () async {
          await testCase(
            unitGroup: clothesSizeGroup,
            useCase: useCase,
            delta: EditConversionUnitValueDelta.raw(
              newValue: '50',
              unitId: europeanClothSize.id,
            ),
            currentParams: ConversionParamSetValueBulkModel.single(
              paramSet: clothesSizeParamSet,
              paramValues: [
                ConversionParamValueModel.tuple(personParam, "Man", null),
                ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                ConversionParamValueModel.tuple(
                  heightParam,
                  const NumRange.withRight(0, 164),
                  null,
                  unit: centimeter,
                  calculated: true,
                ),
              ],
            ),
            currentSrc: ConversionUnitValueModel.tuple(
              europeanClothSize,
              null,
              null,
              listValues: europeanClothesSizes,
            ),
            currentUnitValues: [
              ConversionUnitValueModel.tuple(
                europeanClothSize,
                null,
                null,
                listValues: europeanClothesSizes,
              ),
              ConversionUnitValueModel.tuple(
                japanClothSize,
                null,
                null,
                listValues: japanClothesSizes,
              ),
            ],
            expectedParams: ConversionParamSetValueBulkModel.single(
              paramSet: clothesSizeParamSet,
              paramValues: [
                ConversionParamValueModel.tuple(
                  personParam,
                  "Man",
                  null,
                ),
                ConversionParamValueModel.tuple(
                  garmentParam,
                  "Shirt",
                  null,
                ),
                ConversionParamValueModel.tuple(
                  heightParam,
                  const NumRange.withRight(178, 184),
                  null,
                  unit: centimeter,
                  listValues: manShirtHeightRangesFrom0_164To190InCm,
                  calculated: true,
                ),
              ],
            ),
            expectedSrc: ConversionUnitValueModel.tuple(
              europeanClothSize,
              50,
              null,
              listValues: europeanClothesSizes,
            ),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(
                europeanClothSize,
                50,
                null,
                listValues: europeanClothesSizes,
              ),
              ConversionUnitValueModel.tuple(
                japanClothSize,
                '3L',
                null,
                listValues: japanClothesSizes,
              ),
            ],
          );
        });

        test(
            "Should calculate by [Man, Shirt, h: m ..-1.64 | EU: 42 -> 50], "
            "should recalculate 'Height' to m: 1.78-1.84", () async {
          await testCase(
            unitGroup: clothesSizeGroup,
            useCase: useCase,
            delta: EditConversionUnitValueDelta.raw(
              newValue: '50',
              unitId: europeanClothSize.id,
            ),
            currentParams: ConversionParamSetValueBulkModel.single(
              paramSet: clothesSizeParamSet,
              paramValues: [
                ConversionParamValueModel.tuple(personParam, "Man", null),
                ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                ConversionParamValueModel.tuple(
                  heightParam,
                  manShirtHeightRangesFrom0_164To190InMeter.items[0].valueModel,
                  null,
                  unit: meter,
                  calculated: true,
                ),
              ],
            ),
            currentSrc: ConversionUnitValueModel.tuple(
              europeanClothSize,
              42,
              null,
              listValues: europeanClothesSizes,
            ),
            currentUnitValues: [
              ConversionUnitValueModel.tuple(
                europeanClothSize,
                42,
                null,
                listValues: europeanClothesSizes,
              ),
              ConversionUnitValueModel.tuple(
                japanClothSize,
                'S',
                null,
                listValues: japanClothesSizes,
              ),
            ],
            expectedParams: ConversionParamSetValueBulkModel.single(
              paramSet: clothesSizeParamSet,
              paramValues: [
                ConversionParamValueModel.tuple(
                  personParam,
                  "Man",
                  null,
                ),
                ConversionParamValueModel.tuple(
                  garmentParam,
                  "Shirt",
                  null,
                ),
                ConversionParamValueModel.tuple(
                  heightParam,
                  manShirtHeightRangesFrom0_164To190InMeter.items[4].valueModel,
                  null,
                  unit: meter,
                  listValues: manShirtHeightRangesFrom0_164To190InMeter,
                  calculated: true,
                ),
              ],
            ),
            expectedSrc: ConversionUnitValueModel.tuple(
              europeanClothSize,
              50,
              null,
              listValues: europeanClothesSizes,
            ),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(
                europeanClothSize,
                50,
                null,
                listValues: europeanClothesSizes,
              ),
              ConversionUnitValueModel.tuple(
                japanClothSize,
                '3L',
                null,
                listValues: japanClothesSizes,
              ),
            ],
          );
        });

        test(
            "Should calculate by [Woman, Trousers, h: cm 156-162 | EU: empty -> 42]",
            () async {
          await testCase(
            unitGroup: clothesSizeGroup,
            useCase: useCase,
            delta: EditConversionUnitValueDelta.raw(
              newValue: '36',
              unitId: europeanClothSize.id,
            ),
            currentParams: ConversionParamSetValueBulkModel.single(
              paramSet: clothesSizeParamSet,
              paramValues: [
                ConversionParamValueModel.tuple(personParam, "Woman", null),
                ConversionParamValueModel.tuple(garmentParam, "Trousers", null),
                ConversionParamValueModel.tuple(
                  heightParam,
                  const NumRange.withRight(156, 162),
                  null,
                  unit: centimeter,
                  calculated: true,
                ),
              ],
            ),
            currentSrc: ConversionUnitValueModel.tuple(
              europeanClothSize,
              null,
              null,
              listValues: europeanClothesSizes,
            ),
            currentUnitValues: [
              ConversionUnitValueModel.tuple(
                europeanClothSize,
                null,
                null,
                listValues: europeanClothesSizes,
              ),
              ConversionUnitValueModel.tuple(
                japanClothSize,
                null,
                null,
                listValues: japanClothesSizes,
              ),
            ],
            expectedParams: ConversionParamSetValueBulkModel.single(
              paramSet: clothesSizeParamSet,
              paramValues: [
                ConversionParamValueModel.tuple(
                  personParam,
                  "Woman",
                  null,
                ),
                ConversionParamValueModel.tuple(
                  garmentParam,
                  "Trousers",
                  null,
                ),
                ConversionParamValueModel.tuple(
                  heightParam,
                  const NumRange.withRight(156, 162),
                  null,
                  unit: centimeter,
                  listValues: womanTrousersHeightRangesFrom0_156To186InCm,
                  calculated: true,
                ),
              ],
            ),
            expectedSrc: ConversionUnitValueModel.tuple(
              europeanClothSize,
              36,
              null,
              listValues: europeanClothesSizes,
            ),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(
                europeanClothSize,
                36,
                null,
                listValues: europeanClothesSizes,
              ),
              ConversionUnitValueModel.tuple(
                japanClothSize,
                'M',
                null,
                listValues: japanClothesSizes,
              ),
            ],
          );
        });

        test(
            "Should calculate by [Woman, Trousers, h: m 1.56-1.62 | EU: empty -> 42]",
            () async {
          await testCase(
            unitGroup: clothesSizeGroup,
            useCase: useCase,
            delta: EditConversionUnitValueDelta.raw(
              newValue: '36',
              unitId: europeanClothSize.id,
            ),
            currentParams: ConversionParamSetValueBulkModel.single(
              paramSet: clothesSizeParamSet,
              paramValues: [
                ConversionParamValueModel.tuple(personParam, "Woman", null),
                ConversionParamValueModel.tuple(garmentParam, "Trousers", null),
                ConversionParamValueModel.tuple(
                  heightParam,
                  womanTrousersHeightRangesFrom0_156To186InMeter
                      .items[1].valueModel,
                  null,
                  unit: meter,
                  calculated: true,
                ),
              ],
            ),
            currentSrc: ConversionUnitValueModel.tuple(
              europeanClothSize,
              null,
              null,
              listValues: europeanClothesSizes,
            ),
            currentUnitValues: [
              ConversionUnitValueModel.tuple(
                europeanClothSize,
                null,
                null,
                listValues: europeanClothesSizes,
              ),
              ConversionUnitValueModel.tuple(
                japanClothSize,
                null,
                null,
                listValues: japanClothesSizes,
              ),
            ],
            expectedParams: ConversionParamSetValueBulkModel.single(
              paramSet: clothesSizeParamSet,
              paramValues: [
                ConversionParamValueModel.tuple(
                  personParam,
                  "Woman",
                  null,
                ),
                ConversionParamValueModel.tuple(
                  garmentParam,
                  "Trousers",
                  null,
                ),
                ConversionParamValueModel.tuple(
                  heightParam,
                  womanTrousersHeightRangesFrom0_156To186InMeter
                      .items[1].valueModel,
                  null,
                  unit: meter,
                  listValues: womanTrousersHeightRangesFrom0_156To186InMeter,
                  calculated: true,
                ),
              ],
            ),
            expectedSrc: ConversionUnitValueModel.tuple(
              europeanClothSize,
              36,
              null,
              listValues: europeanClothesSizes,
            ),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(
                europeanClothSize,
                36,
                null,
                listValues: europeanClothesSizes,
              ),
              ConversionUnitValueModel.tuple(
                japanClothSize,
                'M',
                null,
                listValues: japanClothesSizes,
              ),
            ],
          );
        });
      });
    });
  });
}
