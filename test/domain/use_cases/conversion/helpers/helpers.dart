import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
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
  expect(actual.params?.toJson(), expected.params?.toJson());
  expect(actual.srcUnitValue?.toJson(), expected.srcUnitValue?.toJson());
  expect(
    actual.convertedUnitValues.sortedBy((e) => e.name).map((e) => e.toJson()),
    expected.convertedUnitValues.sortedBy((e) => e.name).map((e) => e.toJson()),
  );
}

Future<void> testCaseCompact<T extends ConversionModifyDelta>({
  required AbstractModifyConversionUseCase<T> useCase,
  required T delta,
  required UnitGroupModel unitGroup,
  (
    UnitModel,
    dynamic,
    dynamic, {
    OutputListValuesBatch? listValues,
  })? currentSrc,
  ConversionParamSetValueBulkModel? currentParams,
  required List<
          (
            UnitModel,
            dynamic,
            dynamic, {
            OutputListValuesBatch? listValues,
          })>
      currentUnitValues,
  (
    UnitModel,
    dynamic,
    dynamic, {
    OutputListValuesBatch? listValues,
  })? expectedSrc,
  ConversionParamSetValueBulkModel? expectedParams,
  required List<
          (
            UnitModel,
            dynamic,
            dynamic, {
            OutputListValuesBatch? listValues,
          })>
      expectedUnitValues,
}) async {
  await testCase(
    useCase: useCase,
    delta: delta,
    unitGroup: unitGroup,
    currentParams: currentParams,
    currentSrc: currentSrc != null
        ? ConversionUnitValueModel.tuple(
            currentSrc.$1,
            currentSrc.$2,
            currentSrc.$3,
            listValues: currentSrc.listValues,
          )
        : null,
    currentUnitValues: currentUnitValues
        .map(
          (r) => ConversionUnitValueModel.tuple(
            r.$1,
            r.$2,
            r.$3,
            listValues: r.listValues,
          ),
        )
        .toList(),
    expectedSrc: expectedSrc != null
        ? ConversionUnitValueModel.tuple(
            expectedSrc.$1,
            expectedSrc.$2,
            expectedSrc.$3,
            listValues: expectedSrc.listValues,
          )
        : null,
    expectedParams: expectedParams,
    expectedUnitValues: expectedUnitValues
        .map(
          (r) => ConversionUnitValueModel.tuple(
            r.$1,
            r.$2,
            r.$3,
            listValues: r.listValues,
          ),
        )
        .toList(),
  );
}
