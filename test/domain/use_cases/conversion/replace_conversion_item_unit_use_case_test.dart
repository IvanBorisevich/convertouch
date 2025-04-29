import 'package:collection/collection.dart';
import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/convert_single_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/convert_unit_values_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/replace_conversion_item_unit_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:test/test.dart';

import '../../model/mock/mock_param.dart';
import '../../model/mock/mock_unit.dart';
import '../../model/mock/mock_unit_group.dart';
import '../../repositories/mock/mock_dynamic_value_repository.dart';

void main() {
  late ReplaceConversionItemUnitUseCase useCase;

  setUp(() {
    useCase = const ReplaceConversionItemUnitUseCase(
      convertUnitValuesUseCase: ConvertUnitValuesUseCase(
        convertSingleValueUseCase: ConvertSingleValueUseCase(),
      ),
      calculateDefaultValueUseCase: CalculateDefaultValueUseCase(
        dynamicValueRepository: MockDynamicValueRepository(),
        listValueRepository: ListValueRepositoryImpl(),
      ),
    );
  });

  Future<void> testCase({
    required UnitGroupModel unitGroup,
    required ConversionUnitValueModel src,
    required UnitModel newUnit,
    required int oldUnitId,
    required List<ConversionUnitValueModel> currentUnitValues,
    required List<ConversionUnitValueModel> expectedUnitValues,
    required ConversionUnitValueModel? expectedSrc,
    required ConversionParamSetValueBulkModel? params,
  }) async {
    ConversionModel actual = ObjectUtils.tryGet(
      await useCase.execute(
        InputConversionModifyModel<ReplaceConversionItemUnitDelta>(
          conversion: ConversionModel(
            unitGroup: unitGroup,
            srcUnitValue: src,
            convertedUnitValues: currentUnitValues,
            params: params,
          ),
          delta: ReplaceConversionItemUnitDelta(
            newUnit: newUnit,
            oldUnitId: oldUnitId,
          ),
        ),
      ),
    );

    ConversionModel expected = ConversionModel(
      unitGroup: unitGroup,
      srcUnitValue: expectedSrc,
      convertedUnitValues: expectedUnitValues,
      params: params,
    );

    expect(actual.id, expected.id);
    expect(actual.name, expected.name);
    expect(actual.unitGroup, expected.unitGroup);
    expect(actual.srcUnitValue, expected.srcUnitValue);
    expect(actual.params, expected.params);
    expect(
      actual.convertedUnitValues.sortedBy((e) => e.name),
      expected.convertedUnitValues.sortedBy((e) => e.name),
    );
  }

  Future<void> testCaseWithClothingSizeParams({
    required String? gender,
    required String? garment,
    required double? height,
    required double? defaultHeight,
    required ConversionUnitValueModel src,
    required UnitModel newUnit,
    required int oldUnitId,
    required List<ConversionUnitValueModel> currentUnitValues,
    required List<ConversionUnitValueModel> expectedUnitValues,
    required ConversionUnitValueModel? expectedSrc,
  }) async {
    await testCase(
      unitGroup: clothingSizeGroup,
      src: src,
      newUnit: newUnit,
      oldUnitId: oldUnitId,
      currentUnitValues: currentUnitValues,
      expectedUnitValues: expectedUnitValues,
      expectedSrc: expectedSrc,
      params: ConversionParamSetValueBulkModel(
        paramSetValues: [
          ConversionParamSetValueModel(
            paramSet: clothingSizeParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(genderParam, gender, null),
              ConversionParamValueModel.tuple(garmentParam, garment, null),
              ConversionParamValueModel.tuple(
                heightParam,
                height,
                defaultHeight,
                unit: centimeter,
              ),
            ],
          ),
        ],
      ),
    );
  }

  group('Change unit in the conversion by coefficients', () {
    group('Without params', () {
      test('Source value is not empty', () async {
        await testCase(
          unitGroup: lengthGroup,
          src: ConversionUnitValueModel.tuple(decimeter, 10, 1),
          params: null,
          oldUnitId: decimeter.id,
          newUnit: meter,
          currentUnitValues: [
            ConversionUnitValueModel.tuple(decimeter, 10, 1),
            ConversionUnitValueModel.tuple(centimeter, 100, 10),
          ],
          expectedSrc: ConversionUnitValueModel.tuple(meter, 10, 1),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(meter, 10, 1),
            ConversionUnitValueModel.tuple(centimeter, 1000, 100),
          ],
        );
      });

      test('Source default value is not empty', () async {
        await testCase(
          unitGroup: lengthGroup,
          src: ConversionUnitValueModel.tuple(decimeter, null, 1),
          params: null,
          oldUnitId: decimeter.id,
          newUnit: meter,
          currentUnitValues: [
            ConversionUnitValueModel.tuple(decimeter, null, 1),
            ConversionUnitValueModel.tuple(centimeter, null, 10),
          ],
          expectedSrc: ConversionUnitValueModel.tuple(meter, null, 1),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(meter, null, 1),
            ConversionUnitValueModel.tuple(centimeter, null, 100),
          ],
        );
      });

      test('Both source values are empty', () async {
        await testCase(
          unitGroup: lengthGroup,
          src: ConversionUnitValueModel.tuple(decimeter, null, null),
          params: null,
          oldUnitId: decimeter.id,
          newUnit: meter,
          currentUnitValues: [
            ConversionUnitValueModel.tuple(decimeter, null, null),
            ConversionUnitValueModel.tuple(centimeter, null, null),
          ],
          expectedSrc: ConversionUnitValueModel.tuple(meter, null, 1),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(meter, null, 1),
            ConversionUnitValueModel.tuple(centimeter, null, 100),
          ],
        );
      });
    });
  });

  group('Change unit in the conversion by formula', () {

    group('With params', () {

      group('All param values are set', () {
        test('Source value is not empty', () async {
          await testCaseWithClothingSizeParams(
            src: ConversionUnitValueModel.tuple(europeanSize, 32, null),
            gender: "Male",
            garment: "Shirt",
            height: 160,
            defaultHeight: 1,
            oldUnitId: europeanSize.id,
            newUnit: usaSize,
            currentUnitValues: [
              ConversionUnitValueModel.tuple(europeanSize, 32, null),
              ConversionUnitValueModel.tuple(japanSize, 3, null),
            ],
            expectedSrc: ConversionUnitValueModel.tuple(usaSize, 32, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(usaSize, 32, null),
              ConversionUnitValueModel.tuple(japanSize, null, null),
            ],
          );
        });
      });

      group('All param values are set (default param value is set)', () {
        test('Source value is not empty', () async {
          await testCaseWithClothingSizeParams(
            src: ConversionUnitValueModel.tuple(europeanSize, 32, null),
            gender: "Male",
            garment: "Shirt",
            height: null,
            defaultHeight: 1,
            oldUnitId: europeanSize.id,
            newUnit: usaSize,
            currentUnitValues: [
              ConversionUnitValueModel.tuple(europeanSize, 32, null),
              ConversionUnitValueModel.tuple(japanSize, 3, null),
            ],
            expectedSrc: ConversionUnitValueModel.tuple(usaSize, 32, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(usaSize, 32, null),
              ConversionUnitValueModel.tuple(japanSize, null, null),
            ],
          );
        });
      });

      group('Some param values are not set', () {
        test('Source value is not empty', () async {
          await testCaseWithClothingSizeParams(
            src: ConversionUnitValueModel.tuple(europeanSize, 32, null),
            gender: null,
            garment: "Shirt",
            height: null,
            defaultHeight: 1,
            oldUnitId: europeanSize.id,
            newUnit: usaSize,
            currentUnitValues: [
              ConversionUnitValueModel.tuple(europeanSize, null, null),
              ConversionUnitValueModel.tuple(japanSize, null, null),
            ],
            expectedSrc: ConversionUnitValueModel.tuple(usaSize, null, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(usaSize, null, null),
              ConversionUnitValueModel.tuple(japanSize, null, null),
            ],
          );
        });

        test('Source value is empty', () async {
          await testCaseWithClothingSizeParams(
            src: ConversionUnitValueModel.tuple(europeanSize, null, null),
            gender: null,
            garment: "Shirt",
            height: null,
            defaultHeight: 1,
            oldUnitId: europeanSize.id,
            newUnit: usaSize,
            currentUnitValues: [
              ConversionUnitValueModel.tuple(europeanSize, null, null),
              ConversionUnitValueModel.tuple(japanSize, null, null),
            ],
            expectedSrc: ConversionUnitValueModel.tuple(usaSize, null, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(usaSize, null, null),
              ConversionUnitValueModel.tuple(japanSize, null, null),
            ],
          );
        });
      });
    });
  });
}
