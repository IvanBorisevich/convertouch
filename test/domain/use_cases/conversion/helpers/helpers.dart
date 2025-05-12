import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:test/test.dart';

Future<void> testCase<T extends ConversionModifyDelta>({
  required AbstractModifyConversionUseCase<T> useCase,
  required T delta,
  required UnitGroupModel unitGroup,
  ConversionUnitValueModel? currentSrc,
  ConversionParamSetValueBulkModel? currentParams,
  required List<ConversionUnitValueModel> currentUnitValues,
  ConversionUnitValueModel? expectedSrc,
  ConversionParamSetValueBulkModel? expectedParams,
  required List<ConversionUnitValueModel> expectedUnitValues,
  bool recalculateUnitValues = true,
}) async {
  ConversionModel actual = ObjectUtils.tryGet(
    await useCase.execute(
      InputConversionModifyModel<T>(
        conversion: ConversionModel(
          unitGroup: unitGroup,
          srcUnitValue: currentSrc,
          convertedUnitValues: currentUnitValues,
          params: currentParams,
        ),
        delta: delta,
        recalculateUnitValues: recalculateUnitValues,
      ),
    ),
  );

  ConversionModel expected = ConversionModel(
    unitGroup: unitGroup,
    srcUnitValue: expectedSrc,
    convertedUnitValues: expectedUnitValues,
    params: expectedParams,
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
