import 'package:convertouch/domain/model/unit_details_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_unit_details_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_unit_details_model.dart';
import 'package:convertouch/domain/use_cases/unit_details/edit_unit_code_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:test/test.dart';

import '../../model/mock/mock_unit.dart';
import '../../model/mock/mock_unit_group.dart';

void main() {
  const EditUnitCodeUseCase useCase = EditUnitCodeUseCase();

  Future<OutputUnitDetailsModel> testForInput({
    required String newUnitCode,
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
            unitGroup: mockUnitGroupWithOneBaseUnit,
            argUnit: mockBaseUnit,
          ),
          saved: UnitDetailsModel(
            unitData: UnitModel(
              name: savedUnitName,
              code: savedUnitCode,
            ),
            unitGroup: mockUnitGroupWithOneBaseUnit,
            argUnit: mockBaseUnit,
          ),
          delta: newUnitCode,
        ),
      ),
    );

    return result;
  }

  group('For new details', () {
    test('New unit code = empty, unit name != empty', () async {
      final result = await testForInput(
        newUnitCode: "",
        draftUnitName: "unitName",
        draftUnitCode: "unitCode",
        savedUnitName: "",
        savedUnitCode: "",
      );

      expect(result.draft.unitData.name, 'unitName');
      expect(result.draft.unitData.code, '');

      expect(result.saved.unitData.name, '');
      expect(result.saved.unitData.code, 'unitN');

      expect(result.unitToSave != null, true);
      expect(result.unitToSave!.name, 'unitName');
      expect(result.unitToSave!.code, 'unitN');

      expect(result.unitGroupChanged, false);
      expect(result.conversionConfigEditable, true);
    });

    test('New unit code != empty, unit name != empty', () async {
      final result = await testForInput(
        newUnitCode: "newCode",
        draftUnitName: "unitName",
        draftUnitCode: "unitCode",
        savedUnitName: "",
        savedUnitCode: "",
      );

      expect(result.draft.unitData.name, 'unitName');
      expect(result.draft.unitData.code, 'newCode');

      expect(result.saved.unitData.name, '');
      expect(result.saved.unitData.code, 'unitN');

      expect(result.unitToSave != null, true);
      expect(result.unitToSave!.name, 'unitName');
      expect(result.unitToSave!.code, 'newCode');

      expect(result.unitGroupChanged, false);
      expect(result.conversionConfigEditable, true);
    });

    test('New unit code = empty, unit name = empty', () async {
      final result = await testForInput(
        newUnitCode: "",
        draftUnitName: "",
        draftUnitCode: "unitCode",
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
      expect(result.conversionDescription, null); // name or code is empty
    });

    test('New unit code != empty, unit name = empty', () async {
      final result = await testForInput(
        newUnitCode: "newCode",
        draftUnitName: "",
        draftUnitCode: "unitCode",
        savedUnitName: "",
        savedUnitCode: "",
      );

      expect(result.draft.unitData.name, '');
      expect(result.draft.unitData.code, 'newCode');

      expect(result.saved.unitData.name, '');
      expect(result.saved.unitData.code, '');

      expect(result.unitToSave, null);
      expect(result.unitGroupChanged, false);

      expect(result.conversionConfigVisible, false); // name or code is empty
      expect(result.conversionConfigEditable, false);
      expect(result.conversionDescription, null); // name or code is empty
    });
  });

  group('For existing details', () {
    test('New unit code = empty, unit name != empty', () async {
      final result = await testForInput(
        newUnitCode: "",
        draftUnitName: "unitName",
        draftUnitCode: "unitCode",
        savedUnitName: "unitName",
        savedUnitCode: "unitCode",
      );

      expect(result.draft.unitData.name, 'unitName');
      expect(result.draft.unitData.code, '');

      expect(result.saved.unitData.name, 'unitName');
      expect(result.saved.unitData.code, 'unitCode');

      expect(result.unitToSave, null);
      expect(result.unitGroupChanged, false);

      expect(result.conversionConfigEditable, true);
      expect(result.conversionConfigEditable, true);
      expect(result.conversionDescription, null);
    });

    test('New unit code != empty, unit name != empty', () async {
      final result = await testForInput(
        newUnitCode: "newCode",
        draftUnitName: "unitName",
        draftUnitCode: "unitCode",
        savedUnitName: "unitName",
        savedUnitCode: "unitCode",
      );

      expect(result.draft.unitData.name, 'unitName');
      expect(result.draft.unitData.code, 'newCode');

      expect(result.saved.unitData.name, 'unitName');
      expect(result.saved.unitData.code, 'unitCode');

      expect(result.unitToSave != null, true);
      expect(result.unitToSave!.name, 'unitName');
      expect(result.unitToSave!.code, 'newCode');

      expect(result.unitGroupChanged, false);

      expect(result.conversionConfigEditable, true);
      expect(result.conversionConfigEditable, true);
      expect(result.conversionDescription, null);
    });

    test('New unit code = empty, unit name = empty', () async {
      final result = await testForInput(
        newUnitCode: "",
        draftUnitName: "",
        draftUnitCode: "unitCode",
        savedUnitName: "unitName",
        savedUnitCode: "unitCode",
      );

      expect(result.draft.unitData.name, '');
      expect(result.draft.unitData.code, '');

      expect(result.saved.unitData.name, 'unitName');
      expect(result.saved.unitData.code, 'unitCode');

      expect(result.unitToSave, null);
      expect(result.unitGroupChanged, false);

      expect(result.conversionConfigEditable, true);
      expect(result.conversionConfigEditable, true);
      expect(result.conversionDescription, null);
    });

    test('New unit code != empty, unit name = empty', () async {
      final result = await testForInput(
        newUnitCode: "newCode",
        draftUnitName: "",
        draftUnitCode: "unitCode",
        savedUnitName: "unitName",
        savedUnitCode: "unitCode",
      );

      expect(result.draft.unitData.name, '');
      expect(result.draft.unitData.code, 'newCode');

      expect(result.saved.unitData.name, 'unitName');
      expect(result.saved.unitData.code, 'unitCode');

      expect(result.unitToSave != null, true);
      expect(result.unitToSave!.name, 'unitName');
      expect(result.unitToSave!.code, 'newCode');

      expect(result.unitGroupChanged, false);

      expect(result.conversionConfigEditable, true);
      expect(result.conversionConfigEditable, true);
      expect(result.conversionDescription, null);
    });
  });
}
