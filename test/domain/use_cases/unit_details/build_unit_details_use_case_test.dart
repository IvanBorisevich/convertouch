import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_details_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_unit_details_build_model.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/use_cases/unit_details/build_unit_details_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:test/test.dart';

import '../../model/mock/mock_unit.dart';
import '../../model/mock/mock_unit_group.dart';
import '../../repositories/mock/mock_unit_repository.dart';

void main() {
  late UnitRepository unitRepository;
  late BuildUnitDetailsUseCase useCase;

  setUpAll(() {
    unitRepository = const MockUnitRepository();
    useCase = BuildUnitDetailsUseCase(
      unitRepository: unitRepository,
    );
  });

  group('For a new unit', () {
    test('In a group without units', () async {
      UnitDetailsModel result = ObjectUtils.tryGet(
        await useCase.execute(
          const InputUnitDetailsBuildModel(
            unitGroup: mockUnitGroupWithoutUnits,
          ),
        ),
      );

      expect(result.editMode, true);
      expect(result.resultUnit.exists, false);
      expect(result.unitGroupChanged, false);
      expect(result.conversionRule.configVisible, false);
      expect(result.conversionRule.configEditable, false);
      expect(result.conversionRule.readOnlyDescription, baseUnitConversionRule);
    });

    test('In a group with units', () async {
      UnitDetailsModel result = ObjectUtils.tryGet(
        await useCase.execute(
          const InputUnitDetailsBuildModel(
            unitGroup: mockUnitGroupWithOneBaseUnit,
          ),
        ),
      );

      expect(result.editMode, true);
      expect(result.resultUnit.exists, false);
      expect(result.unitGroupChanged, false);
      expect(
          result.conversionRule.configVisible, false); // name or code is empty
      expect(result.conversionRule.configEditable, false);
      expect(result.conversionRule.readOnlyDescription, null);
    });
  });

  group('For an existing unit', () {
    group('For a custom unit (edit mode)', () {
      test('For a custom non-base unit', () async {
        UnitDetailsModel result = ObjectUtils.tryGet(
          await useCase.execute(
            const InputExistingUnitDetailsBuildModel(
              unit: mockUnit,
              unitGroup: mockUnitGroupWithOneBaseUnit,
            ),
          ),
        );

        expect(result.editMode, true);
        expect(result.resultUnit.exists, false);
        expect(result.unitGroupChanged, false);
        expect(result.conversionRule.configVisible, true);
        expect(result.conversionRule.configEditable, true);
        expect(result.conversionRule.readOnlyDescription, null);
      });

      test('For a custom base unit (no other base units)', () async {
        UnitDetailsModel result = ObjectUtils.tryGet(
          await useCase.execute(
            const InputExistingUnitDetailsBuildModel(
              unit: mockBaseUnit,
              unitGroup: mockUnitGroupWithOneBaseUnit,
            ),
          ),
        );

        expect(result.editMode, true);
        expect(result.resultUnit.exists, false);
        expect(result.unitGroupChanged, false);
        expect(result.conversionRule.configVisible, false);
        expect(result.conversionRule.configEditable, false);
        expect(
            result.conversionRule.readOnlyDescription, baseUnitConversionRule);
      });

      test('For a custom base unit 1 (with other base units)', () async {
        UnitDetailsModel result = ObjectUtils.tryGet(
          await useCase.execute(
            const InputExistingUnitDetailsBuildModel(
              unit: mockBaseUnit,
              unitGroup: mockUnitGroupWithMultipleBaseUnits,
            ),
          ),
        );

        expect(result.editMode, true);
        expect(result.resultUnit.exists, false);
        expect(result.unitGroupChanged, false);
        expect(result.conversionRule.configVisible, true);
        expect(result.conversionRule.configEditable, true);
        expect(result.conversionRule.readOnlyDescription, null);
      });

      test('For a custom base unit 2 (with other base units)', () async {
        UnitDetailsModel result = ObjectUtils.tryGet(
          await useCase.execute(
            const InputExistingUnitDetailsBuildModel(
              unit: mockBaseUnit2,
              unitGroup: mockUnitGroupWithMultipleBaseUnits,
            ),
          ),
        );

        expect(result.editMode, true);
        expect(result.resultUnit.exists, false);
        expect(result.unitGroupChanged, false);
        expect(result.conversionRule.configVisible, true);
        expect(result.conversionRule.configEditable, true);
        expect(result.conversionRule.readOnlyDescription, null);
      });
    });

    group('For read-only mode (oob unit)', () {
      test('For a non-base unit', () async {
        UnitDetailsModel result = ObjectUtils.tryGet(
          await useCase.execute(
            const InputExistingUnitDetailsBuildModel(
              unit: mockOobUnit,
              unitGroup: mockUnitGroupWithOneBaseUnit,
            ),
          ),
        );

        expect(result.editMode, false);
        expect(result.resultUnit.exists, false);
        expect(result.unitGroupChanged, false);
        expect(result.conversionRule.configVisible, false);
        expect(result.conversionRule.configEditable, false);
        expect(result.conversionRule.readOnlyDescription, "1 n1o = 2 b1");
      });

      test('For a base unit (no other base units)', () async {
        UnitDetailsModel result = ObjectUtils.tryGet(
          await useCase.execute(
            const InputExistingUnitDetailsBuildModel(
              unit: mockOobBaseUnit,
              unitGroup: mockUnitGroupWithOneBaseUnitOob,
            ),
          ),
        );

        expect(result.editMode, false);
        expect(result.resultUnit.exists, false);
        expect(result.unitGroupChanged, false);
        expect(result.conversionRule.configVisible, false);
        expect(result.conversionRule.configEditable, false);
        expect(
            result.conversionRule.readOnlyDescription, baseUnitConversionRule);
      });

      test('For a base unit 1 (with other base units)', () async {
        UnitDetailsModel result = ObjectUtils.tryGet(
          await useCase.execute(
            const InputExistingUnitDetailsBuildModel(
              unit: mockOobBaseUnit,
              unitGroup: mockUnitGroupWithMultipleBaseUnitsOob,
            ),
          ),
        );

        expect(result.editMode, false);
        expect(result.resultUnit.exists, false);
        expect(result.unitGroupChanged, false);
        expect(result.conversionRule.configVisible, false);
        expect(result.conversionRule.configEditable, false);
        expect(result.conversionRule.readOnlyDescription, "1 b1o = 1 b2o");
      });

      test('For a base unit 2 (with other base units)', () async {
        UnitDetailsModel result = ObjectUtils.tryGet(
          await useCase.execute(
            const InputExistingUnitDetailsBuildModel(
              unit: mockOobBaseUnit2,
              unitGroup: mockUnitGroupWithMultipleBaseUnits,
            ),
          ),
        );

        expect(result.editMode, false);
        expect(result.resultUnit.exists, false);
        expect(result.unitGroupChanged, false);
        expect(result.conversionRule.configVisible, false);
        expect(result.conversionRule.configEditable, false);
        expect(result.conversionRule.readOnlyDescription, "1 b2o = 1 b1");
      });
    });
  });
}
