import 'package:collection/collection.dart';
import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/convert_unit_values_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/replace_conversion_param_unit_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:test/test.dart';

import '../../model/mock/mock_param.dart';
import '../../model/mock/mock_unit.dart';
import '../../model/mock/mock_unit_group.dart';
import '../../repositories/mock/mock_dynamic_value_repository.dart';

void main() {
  late ReplaceConversionParamUnitUseCase useCase;

  setUp(() {
    useCase = const ReplaceConversionParamUnitUseCase(
      convertUnitValuesUseCase: ConvertUnitValuesUseCase(),
      calculateDefaultValueUseCase: CalculateDefaultValueUseCase(
        dynamicValueRepository: MockDynamicValueRepository(),
        listValueRepository: ListValueRepositoryImpl(),
      ),
      listValueRepository: ListValueRepositoryImpl(),
    );
  });

  Future<void> testCase({
    required UnitGroupModel unitGroup,
    required ConversionUnitValueModel src,
    required UnitModel newUnit,
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
        InputConversionModifyModel<ReplaceConversionParamUnitDelta>(
          conversion: ConversionModel(
            unitGroup: unitGroup,
            srcUnitValue: src,
            convertedUnitValues: currentUnitValues,
            params: params,
          ),
          delta: ReplaceConversionParamUnitDelta(
            newUnit: newUnit,
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
    required UnitModel newUnit,
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
      newUnit: newUnit,
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

  group('Change param unit in the conversion by formula', () {
    group('Change non-list parameter unit (height)', () {
      test('New height param value is acceptable', () async {
        await testCaseWithClothingSizeParams(
          src: ConversionUnitValueModel.tuple(europeanSize, 34, null),
          gender: "Male",
          garment: "Shirt",
          height: 1.7,
          defaultHeight: 1,
          newUnit: meter,
          paramId: heightParam.id,
          paramSetId: heightParam.paramSetId,
          currentUnitValues: [
            ConversionUnitValueModel.tuple(europeanSize, 34, null),
            ConversionUnitValueModel.tuple(japanSize, null, null),
          ],
          expectedSrc: ConversionUnitValueModel.tuple(europeanSize, 34, null),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(europeanSize, 34, null),
            ConversionUnitValueModel.tuple(japanSize, 7, null),
          ],
          expectedParamValues: [
            ConversionParamValueModel.tuple(genderParam, "Male", null),
            ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
            ConversionParamValueModel.tuple(heightParam, 1.7, 1, unit: meter),
          ],
        );
      });

      test('New height param value is not acceptable', () async {
        await testCaseWithClothingSizeParams(
          src: ConversionUnitValueModel.tuple(europeanSize, 34, null),
          gender: "Male",
          garment: "Shirt",
          height: 1.9,
          defaultHeight: 1,
          newUnit: meter,
          paramId: heightParam.id,
          paramSetId: heightParam.paramSetId,
          currentUnitValues: [
            ConversionUnitValueModel.tuple(europeanSize, 34, null),
            ConversionUnitValueModel.tuple(japanSize, null, null),
          ],
          expectedSrc: ConversionUnitValueModel.tuple(europeanSize, 34, null),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(europeanSize, 34, null),
            ConversionUnitValueModel.tuple(japanSize, null, null),
          ],
          expectedParamValues: [
            ConversionParamValueModel.tuple(genderParam, "Male", null),
            ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
            ConversionParamValueModel.tuple(heightParam, 1.9, 1, unit: meter),
          ],
        );
      });

      test('New height default param value is not empty', () async {
        await testCaseWithClothingSizeParams(
          src: ConversionUnitValueModel.tuple(europeanSize, 32, null),
          gender: "Male",
          garment: "Shirt",
          height: null,
          defaultHeight: 1,
          newUnit: meter,
          paramId: heightParam.id,
          paramSetId: heightParam.paramSetId,
          currentUnitValues: [
            ConversionUnitValueModel.tuple(europeanSize, 32, null),
            ConversionUnitValueModel.tuple(japanSize, null, null),
          ],
          expectedSrc: ConversionUnitValueModel.tuple(europeanSize, 32, null),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(europeanSize, 32, null),
            ConversionUnitValueModel.tuple(japanSize, 3, null),
          ],
          expectedParamValues: [
            ConversionParamValueModel.tuple(genderParam, "Male", null),
            ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
            ConversionParamValueModel.tuple(heightParam, null, 1, unit: meter),
          ],
        );
      });

      test(
        '''
        New height param values are empty 
        (preset value will be used for calculation)
        ''',
        () async {
          await testCaseWithClothingSizeParams(
            src: ConversionUnitValueModel.tuple(europeanSize, 32, null),
            gender: "Male",
            garment: "Shirt",
            height: null,
            defaultHeight: null,
            newUnit: meter,
            paramId: heightParam.id,
            paramSetId: heightParam.paramSetId,
            currentUnitValues: [
              ConversionUnitValueModel.tuple(europeanSize, 32, null),
              ConversionUnitValueModel.tuple(japanSize, 3, null),
            ],
            expectedSrc: ConversionUnitValueModel.tuple(europeanSize, 32, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanSize, 32, null),
              ConversionUnitValueModel.tuple(japanSize, 3, null),
            ],
            expectedParamValues: [
              ConversionParamValueModel.tuple(genderParam, "Male", null),
              ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
              ConversionParamValueModel.tuple(heightParam, null, 1,
                  unit: meter),
            ],
          );
        },
      );
    });
  });
}
