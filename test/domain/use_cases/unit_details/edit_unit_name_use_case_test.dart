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
  }) async {
    OutputUnitDetailsModel result = ObjectUtils.tryGet(
      await useCase.execute(
        InputUnitDetailsModifyModel(
          draft: UnitDetailsModel(
            unitData: UnitModel(
              name: draftUnitName,
              code: draftUnitCode,
            ),
            unitGroup: mockUnitGroup,
            argUnit: mockBaseUnit,
          ),
          saved: UnitDetailsModel(
            unitData: UnitModel(
              name: savedUnitName,
              code: savedUnitCode,
            ),
            unitGroup: mockUnitGroup,
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
      expect(result.conversionConfigEditable, true);
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
      expect(result.conversionConfigEditable, true);
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
      expect(result.conversionConfigEditable, true);
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
      expect(result.conversionConfigEditable, true);
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
      expect(result.conversionConfigEditable, true);
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
      expect(result.conversionConfigEditable, true);
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
      expect(result.conversionConfigEditable, true);
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
      expect(result.conversionConfigEditable, true);
    });
  });
}
