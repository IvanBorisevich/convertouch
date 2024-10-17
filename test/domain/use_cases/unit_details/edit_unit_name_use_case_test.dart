import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_rule_model.dart';
import 'package:convertouch/domain/model/unit_details_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/use_cases/unit_details/modify_unit_details_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:test/test.dart';

import '../../model/mock/mock_unit.dart';
import '../../model/mock/mock_unit_group.dart';
import '../../repositories/mock/mock_unit_repository.dart';

void main() {
  late UnitRepository unitRepository;
  late ModifyUnitDetailsUseCase useCase;

  setUpAll(() {
    unitRepository = const MockUnitRepository();
    useCase = ModifyUnitDetailsUseCase(
      unitRepository: unitRepository,
    );
  });

  Future<UnitDetailsModel> testForInput({
    required UnitGroupModel unitGroup,
    int unitId = -1,
    required String draftUnitName,
    required String draftUnitCode,
    required UnitModel savedUnitData,
    ConversionRule conversionRule = ConversionRule.none,
  }) async {
    UnitDetailsModel result = ObjectUtils.tryGet(
      await useCase.execute(
        UnitDetailsModel(
          unitGroup: unitGroup,
          draftUnitData: UnitModel(
            id: unitId,
            name: draftUnitName,
            code: draftUnitCode,
            unitGroupId: unitGroup.id,
          ),
          savedUnitData: savedUnitData,
          conversionRule: conversionRule,
        ),
      ),
    );

    return result;
  }

  group('For new details', () {
    group('In group without units', () {
      test('New unit name = empty', () async {
        final result = await testForInput(
          unitGroup: mockUnitGroupWithoutUnits,
          draftUnitName: '',
          draftUnitCode: 'code',
          savedUnitData: UnitModel.none,
        );

        expect(result.draftUnitData.name, '');
        expect(result.draftUnitData.code, 'code');
        expect(result.savedUnitData.name, '');
        expect(result.savedUnitData.code, '');
        expect(result.resultUnit.exists, false);
        expect(result.unitGroupChanged, false);
        expect(result.conversionRule.configVisible, false);
        expect(result.conversionRule.configEditable, false);
        expect(
            result.conversionRule.readOnlyDescription, baseUnitConversionRule);
      });

      test('New unit name != empty', () async {
        final result = await testForInput(
          unitGroup: mockUnitGroupWithoutUnits,
          draftUnitName: 'unitName',
          draftUnitCode: 'code',
          savedUnitData: UnitModel.none,
        );

        expect(result.draftUnitData.name, 'unitName');
        expect(result.draftUnitData.code, 'code');
        expect(result.savedUnitData.name, '');
        expect(result.savedUnitData.code, 'unitN');
        expect(result.resultUnit.exists, true);
        expect(result.unitGroupChanged, false);
        expect(result.conversionRule.configVisible, false);
        expect(result.conversionRule.configEditable, false);
        expect(
          result.conversionRule.readOnlyDescription,
          baseUnitConversionRule,
        );
      });
    });

    group('In group with units', () {
      test('New unit name = empty', () async {
        UnitModel draftUnit = UnitModel(
          name: '',
          code: 'code',
          unitGroupId: mockUnitGroupWithOneBaseUnit.id,
        );

        final result = await testForInput(
          unitGroup: mockUnitGroupWithOneBaseUnit,
          draftUnitName: draftUnit.name,
          draftUnitCode: draftUnit.code,
          savedUnitData: UnitModel.none,
          conversionRule: ConversionRule.build(
            unitGroup: mockUnitGroupWithOneBaseUnit,
            mandatoryParamsFilled: false,
            draftUnit: draftUnit,
            argUnit: mockBaseUnit,
            primaryBaseUnit: mockBaseUnit,
          ),
        );

        expect(result.draftUnitData.name, '');
        expect(result.draftUnitData.code, 'code');
        expect(result.savedUnitData.name, '');
        expect(result.savedUnitData.code, '');
        expect(result.resultUnit.exists, false);
        expect(result.unitGroupChanged, false);
        expect(result.conversionRule.configVisible, false); // name is empty
        expect(result.conversionRule.configEditable, false);
        expect(result.conversionRule.readOnlyDescription, null);
      });

      test('New unit name != empty', () async {
        UnitModel draftUnit = UnitModel(
          name: 'unitName',
          code: 'code',
          unitGroupId: mockUnitGroupWithOneBaseUnit.id,
        );

        final result = await testForInput(
          unitGroup: mockUnitGroupWithoutUnits,
          draftUnitName: draftUnit.name,
          draftUnitCode: draftUnit.code,
          savedUnitData: UnitModel.none,
          conversionRule: ConversionRule.build(
            unitGroup: mockUnitGroupWithOneBaseUnit,
            mandatoryParamsFilled: true,
            draftUnit: draftUnit,
            argUnit: mockBaseUnit,
            primaryBaseUnit: mockBaseUnit,
          ),
        );

        expect(result.draftUnitData.name, 'unitName');
        expect(result.draftUnitData.code, 'code');
        expect(result.savedUnitData.name, '');
        expect(result.savedUnitData.code, 'unitN');
        expect(result.resultUnit.exists, true);
        expect(result.unitGroupChanged, false);
        expect(result.conversionRule.configVisible, true);
        expect(result.conversionRule.configEditable, true);
        expect(result.conversionRule.readOnlyDescription, null);
      });
    });
  });

  group('For existing details', () {
    group('In group with 1 unit', () {
      test('New unit name = empty', () async {
        UnitModel draftUnit = UnitModel(
          id: mockBaseUnit.id,
          name: '',
          code: 'b1',
        );

        final result = await testForInput(
          unitGroup: mockUnitGroupWithOneBaseUnit,
          unitId: draftUnit.id,
          draftUnitName: draftUnit.name,
          draftUnitCode: draftUnit.code,
          savedUnitData: mockBaseUnit,
          conversionRule: ConversionRule.build(
            unitGroup: mockUnitGroupWithOneBaseUnit,
            mandatoryParamsFilled: true,
            draftUnit: draftUnit,
            argUnit: mockBaseUnit,
            primaryBaseUnit: mockBaseUnit,
          ),
        );

        expect(result.draftUnitData.name, '');
        expect(result.draftUnitData.code, 'b1');
        expect(result.savedUnitData.name, 'base1');
        expect(result.savedUnitData.code, 'b1');
        expect(result.resultUnit.exists, false);
        expect(result.unitGroupChanged, false);
        expect(result.conversionRule.configVisible, false);
        expect(result.conversionRule.configEditable, false);
        expect(
          result.conversionRule.readOnlyDescription,
          baseUnitConversionRule,
        );
      });

      test('New unit name != empty', () async {
        UnitModel draftUnit = UnitModel(
          id: mockBaseUnit.id,
          name: 'newName',
          code: 'b1',
        );

        final result = await testForInput(
          unitGroup: mockUnitGroupWithOneBaseUnit,
          unitId: draftUnit.id,
          draftUnitName: draftUnit.name,
          draftUnitCode: draftUnit.code,
          savedUnitData: mockBaseUnit,
          conversionRule: ConversionRule.build(
            unitGroup: mockUnitGroupWithOneBaseUnit,
            mandatoryParamsFilled: true,
            draftUnit: draftUnit,
            argUnit: mockBaseUnit,
            primaryBaseUnit: mockBaseUnit,
          ),
        );

        expect(result.draftUnitData.name, 'newName');
        expect(result.draftUnitData.code, 'b1');
        expect(result.savedUnitData.name, 'base1');
        expect(result.savedUnitData.code, 'b1');
        expect(result.resultUnit.exists, true);
        expect(result.unitGroupChanged, false);
        expect(result.conversionRule.configVisible, false);
        expect(result.conversionRule.configEditable, false);
        expect(
          result.conversionRule.readOnlyDescription,
          baseUnitConversionRule,
        );
      });
    });

    group('In group with more than 1 unit', () {
      test('New unit name = empty', () async {
        UnitModel draftUnit = UnitModel(
          id: mockBaseUnit.id,
          name: '',
          code: 'b1',
        );

        final result = await testForInput(
          unitGroup: mockUnitGroupWithMultipleBaseUnits,
          unitId: draftUnit.id,
          draftUnitName: draftUnit.name,
          draftUnitCode: draftUnit.code,
          savedUnitData: mockBaseUnit,
          conversionRule: ConversionRule.build(
            unitGroup: mockUnitGroupWithMultipleBaseUnits,
            mandatoryParamsFilled: true,
            draftUnit: draftUnit,
            argUnit: mockBaseUnit,
            primaryBaseUnit: mockBaseUnit,
            secondaryBaseUnit: mockBaseUnit2,
          ),
        );

        expect(result.draftUnitData.name, '');
        expect(result.draftUnitData.code, 'b1');
        expect(result.savedUnitData.name, 'base1');
        expect(result.savedUnitData.code, 'b1');
        expect(result.resultUnit.exists, false);
        expect(result.unitGroupChanged, false);
        expect(result.conversionRule.configVisible, true);
        expect(result.conversionRule.configEditable, true);
        expect(result.conversionRule.readOnlyDescription, null);
      });

      test('New unit name != empty', () async {
        UnitModel draftUnit = UnitModel(
          id: mockBaseUnit.id,
          name: 'newName',
          code: 'b1',
        );

        final result = await testForInput(
          unitGroup: mockUnitGroupWithMultipleBaseUnits,
          unitId: draftUnit.id,
          draftUnitName: draftUnit.name,
          draftUnitCode: draftUnit.code,
          savedUnitData: mockBaseUnit2,
          conversionRule: ConversionRule.build(
            unitGroup: mockUnitGroupWithMultipleBaseUnits,
            mandatoryParamsFilled: true,
            draftUnit: draftUnit,
            argUnit: mockBaseUnit,
            primaryBaseUnit: mockBaseUnit,
            secondaryBaseUnit: mockBaseUnit2,
          ),
        );

        expect(result.draftUnitData.name, 'newName');
        expect(result.draftUnitData.code, 'b1');
        expect(result.savedUnitData.name, 'base2');
        expect(result.savedUnitData.code, 'b2');
        expect(result.resultUnit.exists, true);
        expect(result.unitGroupChanged, false);
        expect(result.conversionRule.configVisible, true);
        expect(result.conversionRule.configEditable, true);
        expect(result.conversionRule.readOnlyDescription, null);
      });
    });
  });
}
