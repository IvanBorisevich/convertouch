import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_details_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_unit_details_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_unit_details_model.dart';
import 'package:convertouch/domain/use_cases/unit_details/edit_unit_name_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:test/test.dart';

import '../../model/mock/mock_unit.dart';
import '../../model/mock/mock_unit_group.dart';

void main() {
  const EditUnitNameUseCase useCase = EditUnitNameUseCase();

  Future<OutputUnitDetailsModel> testForInput({
    required String newUnitName,
    required String draftUnitName,
    required String draftUnitCode,
    required String savedUnitName,
    required String savedUnitCode,
    int unitId = 1,
    double unitCoefficient = 2,
  }) async {
    OutputUnitDetailsModel result = ObjectUtils.tryGet(
      await useCase.execute(
        InputUnitDetailsModifyModel(
          draft: UnitDetailsModel(
            unitData: UnitModel(
              id: unitId,
              name: draftUnitName,
              code: draftUnitCode,
              coefficient: unitCoefficient,
            ),
            unitGroup: mockUnitGroupWithOneBaseUnit,
            argUnit: mockBaseUnit,
          ),
          saved: UnitDetailsModel(
            unitData: UnitModel(
              id: unitId,
              name: savedUnitName,
              code: savedUnitCode,
              coefficient: unitCoefficient,
            ),
            unitGroup: mockUnitGroupWithOneBaseUnit,
            argUnit: mockBaseUnit,
          ),
          delta: newUnitName,
        ),
      ),
    );

    return result;
  }

  group('For new details', () {
    test('New unit name = empty, unit code != empty', () async {
      final result = await testForInput(
        newUnitName: "",
        draftUnitName: "name",
        draftUnitCode: "code",
        savedUnitName: "",
        savedUnitCode: "",
      );

      expect(result.draft.unitData.name, '');
      expect(result.draft.unitData.code, 'code');

      expect(result.saved.unitData.name, '');
      expect(result.saved.unitData.code, '');

      expect(result.unitToSave, null);
      expect(result.unitGroupChanged, false);

      expect(result.conversionConfigVisible, false); // name or code is empty
      expect(result.conversionConfigEditable, false);
      expect(result.conversionDescription, null);    // name or code is empty
    });

    test('New unit name != empty, unit code != empty', () async {
      final result = await testForInput(
        newUnitName: "newName",
        draftUnitName: "name",
        draftUnitCode: "code",
        savedUnitName: "",
        savedUnitCode: "",
      );

      expect(result.draft.unitData.name, 'newName');
      expect(result.draft.unitData.code, 'code');

      expect(result.saved.unitData.name, '');
      expect(result.saved.unitData.code, 'newNa');

      expect(result.unitToSave != null, true);
      expect(result.unitToSave!.name, 'newName');
      expect(result.unitToSave!.code, 'code');

      expect(result.unitGroupChanged, false);

      expect(result.conversionConfigVisible, true);
      expect(result.conversionConfigEditable, true);
      expect(result.conversionDescription, null);
    });

    test('New unit name = empty, unit code = empty', () async {
      final result = await testForInput(
        newUnitName: "",
        draftUnitName: "name",
        draftUnitCode: "",
        savedUnitName: "",
        savedUnitCode: "",
      );

      expect(result.draft.unitData.name, '');
      expect(result.draft.unitData.code, '');

      expect(result.saved.unitData.name, '');
      expect(result.saved.unitData.code, '');

      expect(result.unitToSave, null);
      expect(result.unitGroupChanged, false);

      expect(result.conversionConfigVisible, false); // name or code is empty
      expect(result.conversionConfigEditable, false);
      expect(result.conversionDescription, null);    // name or code is empty
    });

    test('New unit name != empty, unit code = empty', () async {
      final result = await testForInput(
        newUnitName: "newName",
        draftUnitName: "name",
        draftUnitCode: "",
        savedUnitName: "",
        savedUnitCode: "",
      );

      expect(result.draft.unitData.name, 'newName');
      expect(result.draft.unitData.code, '');

      expect(result.saved.unitData.name, '');
      expect(result.saved.unitData.code, 'newNa');

      expect(result.unitToSave != null, true);
      expect(result.unitToSave!.name, 'newName');
      expect(result.unitToSave!.code, 'newNa');

      expect(result.unitGroupChanged, false);

      expect(result.conversionConfigVisible, true);
      expect(result.conversionConfigEditable, true);
      expect(result.conversionDescription, null);
    });
  });

  group('For existing details', () {
    test('New unit name = empty, unit code != empty', () async {
      final result = await testForInput(
        newUnitName: "",
        draftUnitName: "name",
        draftUnitCode: "code",
        savedUnitName: "name",
        savedUnitCode: "code",
      );

      expect(result.draft.unitData.name, '');
      expect(result.draft.unitData.code, 'code');

      expect(result.saved.unitData.name, 'name');
      expect(result.saved.unitData.code, 'code');

      expect(result.unitToSave, null);
      expect(result.unitGroupChanged, false);

      expect(result.conversionConfigVisible, true);
      expect(result.conversionConfigEditable, true);
      expect(result.conversionDescription, null);
    });

    test('New unit name != empty, unit code != empty', () async {
      final result = await testForInput(
        newUnitName: "newName",
        draftUnitName: "name",
        draftUnitCode: "code",
        savedUnitName: "name",
        savedUnitCode: "code",
      );

      expect(result.draft.unitData.name, 'newName');
      expect(result.draft.unitData.code, 'code');

      expect(result.saved.unitData.name, 'name');
      expect(result.saved.unitData.code, 'code');

      expect(result.unitToSave != null, true);
      expect(result.unitToSave!.name, 'newName');
      expect(result.unitToSave!.code, 'code');

      expect(result.unitGroupChanged, false);

      expect(result.conversionConfigVisible, true);
      expect(result.conversionConfigEditable, true);
      expect(result.conversionDescription, null);
    });

    test('New unit name = empty, unit code = empty', () async {
      final result = await testForInput(
        newUnitName: "",
        draftUnitName: "name",
        draftUnitCode: "",
        savedUnitName: "name",
        savedUnitCode: "code",
      );

      expect(result.draft.unitData.name, '');
      expect(result.draft.unitData.code, '');

      expect(result.saved.unitData.name, 'name');
      expect(result.saved.unitData.code, 'code');

      expect(result.unitToSave, null);
      expect(result.unitGroupChanged, false);

      expect(result.conversionConfigVisible, true);
      expect(result.conversionConfigEditable, true);
      expect(result.conversionDescription, null);
    });

    test('New unit name != empty, unit code = empty', () async {
      final result = await testForInput(
        newUnitName: "newName",
        draftUnitName: "name",
        draftUnitCode: "",
        savedUnitName: "name",
        savedUnitCode: "code",
      );

      expect(result.draft.unitData.name, 'newName');
      expect(result.draft.unitData.code, '');

      expect(result.saved.unitData.name, 'name');
      expect(result.saved.unitData.code, 'code');

      expect(result.unitToSave != null, true);
      expect(result.unitToSave!.name, 'newName');
      expect(result.unitToSave!.code, 'code');

      expect(result.unitGroupChanged, false);

      expect(result.conversionConfigVisible, true);
      expect(result.conversionConfigEditable, true);
      expect(result.conversionDescription, null);
    });

    test('Base unit | New unit name != empty, unit code != empty', () async {
      final result = await testForInput(
        newUnitName: "newName",
        draftUnitName: "name",
        draftUnitCode: "code",
        savedUnitName: "name",
        savedUnitCode: "code",
        unitId: mockBaseUnit.id,
        unitCoefficient: 1,
      );

      expect(result.draft.unitData.name, 'newName');
      expect(result.draft.unitData.code, 'code');

      expect(result.saved.unitData.name, 'name');
      expect(result.saved.unitData.code, 'code');

      expect(result.unitToSave != null, true);
      expect(result.unitToSave!.name, 'newName');
      expect(result.unitToSave!.code, 'code');

      expect(result.unitGroupChanged, false);

      expect(result.conversionConfigVisible, false);
      expect(result.conversionConfigEditable, false);
      expect(result.conversionDescription, baseUnitConversionRule);
    });
  });
}
