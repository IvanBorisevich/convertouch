import 'package:collection/collection.dart';
import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/convert_single_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/convert_unit_values_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/edit_conversion_param_value_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:test/test.dart';

import '../../model/mock/mock_param.dart';
import '../../model/mock/mock_unit.dart';
import '../../model/mock/mock_unit_group.dart';
import '../../repositories/mock/mock_dynamic_value_repository.dart';

void main() {
  late EditConversionParamValueUseCase useCase;

  setUp(() {
    useCase = const EditConversionParamValueUseCase(
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
    required String? newParamValue,
    required String? newParamDefaultValue,
    required int paramId,
    required int paramSetId,
    required List<ConversionUnitValueModel> currentUnitValues,
    required List<ConversionUnitValueModel> expectedUnitValues,
    required List<ConversionParamValueModel> expectedParamValues,
    required ConversionUnitValueModel? expectedSrc,
    required ConversionParamSetValueBulkModel? params,
  }) async {
    ConversionModel actual = ObjectUtils.tryGet(
      await useCase.execute(
        InputConversionModifyModel<EditConversionParamValueDelta>(
          conversion: ConversionModel(
            unitGroup: unitGroup,
            srcUnitValue: src,
            convertedUnitValues: currentUnitValues,
            params: params,
          ),
          delta: EditConversionParamValueDelta(
            newValue: newParamValue,
            newDefaultValue: newParamDefaultValue,
            paramId: paramId,
            paramSetId: paramSetId,
          ),
        ),
      ),
    );

    ConversionModel expected = ConversionModel(
      unitGroup: unitGroup,
      srcUnitValue: expectedSrc,
      convertedUnitValues: expectedUnitValues,
      params: ConversionParamSetValueBulkModel(
        paramSetValues: [
          ConversionParamSetValueModel(
            paramSet: clothingSizeParamSet,
            paramValues: expectedParamValues,
          ),
        ],
      ),
    );

    expect(actual.id, expected.id);
    expect(actual.name, expected.name);
    expect(actual.unitGroup, expected.unitGroup);
    expect(actual.srcUnitValue, expected.srcUnitValue);
    expect(actual.params?.toJson(), expected.params?.toJson());
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
    required String? newParamValue,
    required String? newParamDefaultValue,
    required int paramId,
    required int paramSetId,
    required List<ConversionUnitValueModel> currentUnitValues,
    required List<ConversionUnitValueModel> expectedUnitValues,
    required List<ConversionParamValueModel> expectedParamValues,
    required ConversionUnitValueModel? expectedSrc,
  }) async {
    await testCase(
      unitGroup: clothingSizeGroup,
      src: src,
      newParamValue: newParamValue,
      newParamDefaultValue: newParamDefaultValue,
      paramId: paramId,
      paramSetId: paramSetId,
      currentUnitValues: currentUnitValues,
      expectedUnitValues: expectedUnitValues,
      expectedParamValues: expectedParamValues,
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

  group('Change value in the conversion by formula', () {
    var currentUnitValues = [
      ConversionUnitValueModel.tuple(europeanSize, 32, null),
      ConversionUnitValueModel.tuple(japanSize, 3, null),
    ];

    group('Change non-list parameter value (height)', () {
      group('New height param value is not empty', () {
        test('New height param value is acceptable', () async {
          await testCaseWithClothingSizeParams(
            src: ConversionUnitValueModel.tuple(europeanSize, 32, null),
            gender: "Male",
            garment: "Shirt",
            height: 160,
            defaultHeight: 1,
            newParamValue: "150",
            newParamDefaultValue: null,
            paramId: heightParam.id,
            paramSetId: heightParam.paramSetId,
            currentUnitValues: currentUnitValues,
            expectedSrc: ConversionUnitValueModel.tuple(europeanSize, 32, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanSize, 32, null),
              ConversionUnitValueModel.tuple(japanSize, 3, null),
            ],
            expectedParamValues: [
              ConversionParamValueModel.tuple(genderParam, "Male", null),
              ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
              ConversionParamValueModel.tuple(heightParam, 150, 1,
                  unit: centimeter),
            ],
          );
        });

        test('New height param value is not acceptable', () async {
          await testCaseWithClothingSizeParams(
            src: ConversionUnitValueModel.tuple(europeanSize, 32, null),
            gender: "Male",
            garment: "Shirt",
            height: 140,
            defaultHeight: 1,
            newParamValue: "170",
            newParamDefaultValue: null,
            paramId: heightParam.id,
            paramSetId: heightParam.paramSetId,
            currentUnitValues: currentUnitValues,
            expectedSrc: ConversionUnitValueModel.tuple(europeanSize, 32, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanSize, 32, null),
              ConversionUnitValueModel.tuple(japanSize, null, null),
            ],
            expectedParamValues: [
              ConversionParamValueModel.tuple(genderParam, "Male", null),
              ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
              ConversionParamValueModel.tuple(heightParam, 170, 1,
                  unit: centimeter),
            ],
          );
        });

        test('Both new values are not empty', () async {
          await testCaseWithClothingSizeParams(
            src: ConversionUnitValueModel.tuple(europeanSize, 30, null),
            gender: "Male",
            garment: "Shirt",
            height: 150,
            defaultHeight: 1,
            newParamValue: "180",
            newParamDefaultValue: "140",
            paramId: heightParam.id,
            paramSetId: heightParam.paramSetId,
            currentUnitValues: currentUnitValues,
            expectedSrc: ConversionUnitValueModel.tuple(europeanSize, 30, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanSize, 30, null),
              ConversionUnitValueModel.tuple(japanSize, null, null),
            ],
            expectedParamValues: [
              ConversionParamValueModel.tuple(genderParam, "Male", null),
              ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
              ConversionParamValueModel.tuple(heightParam, 180, 140,
                  unit: centimeter),
            ],
          );
        });
      });

      group('New height param value is empty', () {
        test(
          '''
          New value is empty | new default value is not empty 
          (for list param should be ignored)
          ''',
          () async {
            await testCaseWithClothingSizeParams(
              src: ConversionUnitValueModel.tuple(europeanSize, 32, null),
              gender: "Male",
              garment: "Shirt",
              height: 150,
              defaultHeight: 1,
              newParamValue: null,
              newParamDefaultValue: "160",
              paramId: heightParam.id,
              paramSetId: heightParam.paramSetId,
              currentUnitValues: currentUnitValues,
              expectedSrc:
                  ConversionUnitValueModel.tuple(europeanSize, 32, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(europeanSize, 32, null),
                ConversionUnitValueModel.tuple(japanSize, 3, null),
              ],
              expectedParamValues: [
                ConversionParamValueModel.tuple(genderParam, "Male", null),
                ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                ConversionParamValueModel.tuple(heightParam, null, 160,
                    unit: centimeter),
              ],
            );
          },
        );
      });
    });

    group('Change list parameter value (garment)', () {
      group('New garment param value is empty', () {
        test(
          'New value is empty',
              () async {
            await testCaseWithClothingSizeParams(
              src: ConversionUnitValueModel.tuple(europeanSize, 32, null),
              gender: "Male",
              garment: "Shirt",
              height: 150,
              defaultHeight: 1,
              newParamValue: null,
              newParamDefaultValue: null,
              paramId: garmentParam.id,
              paramSetId: garmentParam.paramSetId,
              currentUnitValues: currentUnitValues,
              expectedSrc:
              ConversionUnitValueModel.tuple(europeanSize, 32, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(europeanSize, 32, null),
                ConversionUnitValueModel.tuple(japanSize, null, null),
              ],
              expectedParamValues: [
                ConversionParamValueModel.tuple(genderParam, "Male", null),
                ConversionParamValueModel.tuple(garmentParam, null, null),
                ConversionParamValueModel.tuple(heightParam, 150, 1,
                    unit: centimeter),
              ],
            );
          },
        );

        test(
          '''
          New value is empty | new default value is not empty 
          (for list param should be ignored)
          ''',
          () async {
            await testCaseWithClothingSizeParams(
              src: ConversionUnitValueModel.tuple(europeanSize, 32, null),
              gender: "Male",
              garment: "Shirt",
              height: 150,
              defaultHeight: 1,
              newParamValue: null,
              newParamDefaultValue: "Any",
              paramId: garmentParam.id,
              paramSetId: garmentParam.paramSetId,
              currentUnitValues: currentUnitValues,
              expectedSrc:
                  ConversionUnitValueModel.tuple(europeanSize, 32, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(europeanSize, 32, null),
                ConversionUnitValueModel.tuple(japanSize, null, null),
              ],
              expectedParamValues: [
                ConversionParamValueModel.tuple(genderParam, "Male", null),
                ConversionParamValueModel.tuple(garmentParam, null, null),
                ConversionParamValueModel.tuple(heightParam, 150, 1,
                    unit: centimeter),
              ],
            );
          },
        );
      });
    });
  });
}
