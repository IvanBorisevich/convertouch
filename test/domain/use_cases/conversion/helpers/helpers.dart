import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:test/test.dart';

import '../../../model/mock/mock_param.dart';
import '../../../model/mock/mock_unit.dart';
import '../../../model/mock/mock_unit_group.dart';

Future<void> testCase<T extends ConversionModifyDelta>({
  required AbstractModifyConversionUseCase<T> useCase,
  required T delta,
  required UnitGroupModel unitGroup,
  required ConversionUnitValueModel? src,
  required List<ConversionUnitValueModel> currentUnitValues,
  required List<ConversionUnitValueModel> expectedUnitValues,
  required ConversionUnitValueModel? expectedSrc,
  required ConversionParamSetValueBulkModel? params,
}) async {
  ConversionModel actual = ObjectUtils.tryGet(
    await useCase.execute(
      InputConversionModifyModel<T>(
        conversion: ConversionModel(
          unitGroup: unitGroup,
          srcUnitValue: src,
          convertedUnitValues: currentUnitValues,
          params: params,
        ),
        delta: delta,
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

Future<void> testCaseWithClothingSizeParams<T extends ConversionModifyDelta>({
  required AbstractModifyConversionUseCase<T> useCase,
  required T delta,
  required String? gender,
  required String? garment,
  required double? height,
  required double? defaultHeight,
  required ConversionUnitValueModel? src,
  required List<ConversionUnitValueModel> currentUnitValues,
  required List<ConversionUnitValueModel> expectedUnitValues,
  required ConversionUnitValueModel? expectedSrc,
}) async {
  await testCase(
    useCase: useCase,
    delta: delta,
    unitGroup: clothingSizeGroup,
    src: src,
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

Future<void> testCaseWithRingSizeParams<T extends ConversionModifyDelta>({
  required AbstractModifyConversionUseCase<T> useCase,
  required T delta,
  required double? diameter,
  required double? defaultDiameter,
  required bool calculated,
  required ConversionUnitValueModel? src,
  required List<ConversionUnitValueModel> currentUnitValues,
  required List<ConversionUnitValueModel> expectedUnitValues,
  required ConversionUnitValueModel? expectedSrc,
}) async {
  await testCase(
    useCase: useCase,
    delta: delta,
    unitGroup: ringSizeGroup,
    src: src,
    currentUnitValues: currentUnitValues,
    expectedUnitValues: expectedUnitValues,
    expectedSrc: expectedSrc,
    params: ConversionParamSetValueBulkModel(
      paramSetValues: [
        ConversionParamSetValueModel(
          paramSet: ringSizeByDiameterParamSet,
          paramValues: [
            ConversionParamValueModel.tuple(
              diameterParam,
              diameter,
              defaultDiameter,
              unit: millimeter,
              calculated: calculated,
            ),
          ],
        ),
      ],
    ),
  );
}
