import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_unit_details_build_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_unit_details_model.dart';
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

  setUp(() {
    unitRepository = const MockUnitRepository();
    useCase = BuildUnitDetailsUseCase(
      unitRepository: unitRepository,
    );
  });


  group('For new unit', () {
    test('Editable mode enabled', () async {
      OutputUnitDetailsModel result = ObjectUtils.tryGet(
        await useCase.execute(
          const InputUnitDetailsBuildModel(
            unitGroup: mockUnitGroup,
          ),
        ),
      );

      expect(result.editMode, true);
      expect(result.unitToSave == null, true);
      expect(result.unitGroupChanged, false);
      expect(result.conversionDescription, null);
      expect(result.conversionConfigEditable, true);
    });
  });

  group('For existing unit', () {
    test('Editable mode, non-base unit', () async {
      OutputUnitDetailsModel result = ObjectUtils.tryGet(
        await useCase.execute(
          const InputExistingUnitDetailsBuildModel(
            unit: mockUnit,
            unitGroup: mockUnitGroup,
          ),
        ),
      );

      expect(result.editMode, true);
      expect(result.unitToSave != null, false);
      expect(result.unitGroupChanged, false);
      expect(result.conversionDescription, "1 code = 3 code2");
      expect(result.conversionConfigEditable, true);
    });

    test('Editable mode, base unit', () async {
      OutputUnitDetailsModel result = ObjectUtils.tryGet(
        await useCase.execute(
          const InputExistingUnitDetailsBuildModel(
            unit: mockBaseUnit,
            unitGroup: mockUnitGroup,
          ),
        ),
      );

      expect(result.editMode, true);
      expect(result.unitToSave == null, true);
      expect(result.unitGroupChanged, false);
      expect(result.conversionDescription, baseUnitConversionRule);
      expect(result.conversionConfigEditable, false);
    });

    test('Read-only mode, non-base unit', () async {
      OutputUnitDetailsModel result = ObjectUtils.tryGet(
        await useCase.execute(
          const InputExistingUnitDetailsBuildModel(
            unit: mockOobUnit,
            unitGroup: mockUnitGroup,
          ),
        ),
      );

      expect(result.editMode, false);
      expect(result.unitToSave == null, true);
      expect(result.unitGroupChanged, false);
      expect(result.conversionDescription, "1 code3 = 2 code2");
      expect(result.conversionConfigEditable, false);
    });

    test('Read-only mode, base unit (no other base units)', () async {
      OutputUnitDetailsModel result = ObjectUtils.tryGet(
        await useCase.execute(
          const InputExistingUnitDetailsBuildModel(
            unit: mockOobBaseUnit2,
            unitGroup: mockUnitGroup,
          ),
        ),
      );

      expect(result.editMode, false);
      expect(result.unitToSave == null, true);
      expect(result.unitGroupChanged, false);
      expect(result.conversionDescription, baseUnitConversionRule);
      expect(result.conversionConfigEditable, false);
    });

    test('Read-only mode, base unit (with other base units)', () async {
      OutputUnitDetailsModel result = ObjectUtils.tryGet(
        await useCase.execute(
          const InputExistingUnitDetailsBuildModel(
            unit: mockOobBaseUnit,
            unitGroup: mockUnitGroup,
          ),
        ),
      );

      expect(result.editMode, false);
      expect(result.unitToSave == null, true);
      expect(result.unitGroupChanged, false);
      expect(result.conversionDescription, "1 code4 = 1 code2");
      expect(result.conversionConfigEditable, false);
    });
  });
}
