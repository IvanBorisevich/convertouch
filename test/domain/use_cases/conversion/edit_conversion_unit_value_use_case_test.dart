import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/num_range.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/edit_conversion_unit_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_default_value_use_case.dart';
import 'package:test/test.dart';

import '../../model/mock/mock_param.dart';
import '../../model/mock/mock_unit.dart';
import '../../model/mock/mock_unit_group.dart';
import '../../repositories/mock/mock_dynamic_value_repository.dart';
import '../../repositories/mock/mock_network_repository.dart';
import 'helpers/helpers.dart';

void main() {
  late EditConversionUnitValueUseCase useCase;

  setUpAll(() {
    useCase = const EditConversionUnitValueUseCase(
      calculateDefaultValueUseCase: CalculateDefaultValueUseCase(
        dynamicValueRepository: MockDynamicValueRepository(),
        listValueRepository: ListValueRepositoryImpl(
          networkRepository: MockNetworkRepository(),
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
      group("With active calculable param 'One Side Weight'", () {
        test('Should calculate conversion and the param by [kg: 60 -> 100]',
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
                ConversionParamValueModel.tuple(oneSideWeightParam, 40, null,
                    unit: kilogram, calculated: true),
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
      });

      group("With inactive calculable param 'One Side Weight'", () {
        test('Should calculate conversion by [kg: 60 -> 100]', () async {
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
                    unit: kilogram),
                ConversionParamValueModel.tuple(oneSideWeightParam, 20, 1,
                    unit: kilogram),
              ],
            ),
          );
        });
      });
    });
  });

  group('By formula', () {
    group('With params - clothes size', () {
      test('Should calculate by [Man, Shirt, h: cm ..-164 | EU: empty -> 42]',
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
          currentSrc:
              ConversionUnitValueModel.tuple(europeanClothSize, null, null),
          currentUnitValues: [
            ConversionUnitValueModel.tuple(europeanClothSize, null, null),
            ConversionUnitValueModel.tuple(japanClothSize, null, null),
          ],
          expectedParams: ConversionParamSetValueBulkModel.single(
            paramSet: clothesSizeParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(personParam, "Man", null),
              ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
              ConversionParamValueModel.tuple(
                  heightParam, const NumRange.withRight(0, 164), null,
                  unit: centimeter),
            ],
          ),
          expectedSrc:
              ConversionUnitValueModel.tuple(europeanClothSize, 42, null),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(europeanClothSize, 42, null),
            ConversionUnitValueModel.tuple(japanClothSize, 'S', null),
          ],
        );
      });

      test('Should calculate by [Man, Shirt, h: m ..-1.64 | EU: empty -> 42]',
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
          currentSrc:
              ConversionUnitValueModel.tuple(europeanClothSize, null, null),
          currentUnitValues: [
            ConversionUnitValueModel.tuple(europeanClothSize, null, null),
            ConversionUnitValueModel.tuple(japanClothSize, null, null),
          ],
          expectedParams: ConversionParamSetValueBulkModel.single(
            paramSet: clothesSizeParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(personParam, "Man", null),
              ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
              ConversionParamValueModel.tuple(
                  heightParam, const NumRange.withRight(0, 1.64), null,
                  unit: meter),
            ],
          ),
          expectedSrc:
              ConversionUnitValueModel.tuple(europeanClothSize, 42, null),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(europeanClothSize, 42, null),
            ConversionUnitValueModel.tuple(japanClothSize, 'S', null),
          ],
        );
      });

      test(
          'Should calculate by [Woman, Trousers, h: cm 156-162 | EU: empty -> 42]',
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
          currentSrc:
              ConversionUnitValueModel.tuple(europeanClothSize, null, null),
          currentUnitValues: [
            ConversionUnitValueModel.tuple(europeanClothSize, null, null),
            ConversionUnitValueModel.tuple(japanClothSize, null, null),
          ],
          expectedParams: ConversionParamSetValueBulkModel.single(
            paramSet: clothesSizeParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(personParam, "Woman", null),
              ConversionParamValueModel.tuple(garmentParam, "Trousers", null),
              ConversionParamValueModel.tuple(
                  heightParam, const NumRange.withRight(156, 162), null,
                  unit: centimeter),
            ],
          ),
          expectedSrc:
              ConversionUnitValueModel.tuple(europeanClothSize, 36, null),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(europeanClothSize, 36, null),
            ConversionUnitValueModel.tuple(japanClothSize, 'M', null),
          ],
        );
      });

      test(
          'Should calculate by [Woman, Trousers, h: m 1.56-1.62 | EU: empty -> 42]',
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
                  heightParam, const NumRange.withRight(1.56, 1.62), null,
                  unit: meter),
            ],
          ),
          currentSrc:
              ConversionUnitValueModel.tuple(europeanClothSize, null, null),
          currentUnitValues: [
            ConversionUnitValueModel.tuple(europeanClothSize, null, null),
            ConversionUnitValueModel.tuple(japanClothSize, null, null),
          ],
          expectedParams: ConversionParamSetValueBulkModel.single(
            paramSet: clothesSizeParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(personParam, "Woman", null),
              ConversionParamValueModel.tuple(garmentParam, "Trousers", null),
              ConversionParamValueModel.tuple(
                  heightParam, const NumRange.withRight(1.56, 1.62), null,
                  unit: meter),
            ],
          ),
          expectedSrc:
              ConversionUnitValueModel.tuple(europeanClothSize, 36, null),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(europeanClothSize, 36, null),
            ConversionUnitValueModel.tuple(japanClothSize, 'M', null),
          ],
        );
      });
    });
  });
}
