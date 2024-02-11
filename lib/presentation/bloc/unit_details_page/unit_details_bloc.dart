import 'dart:developer';

import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_details_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/unit_details/prepare_draft_unit_details_use_case.dart';
import 'package:convertouch/domain/use_cases/unit_details/prepare_saved_unit_details_use_case.dart';
import 'package:convertouch/domain/utils/unit_utils.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_events.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// TODO: refactor

class UnitDetailsBloc
    extends ConvertouchBloc<UnitDetailsEvent, UnitDetailsState> {
  final PrepareSavedUnitDetailsUseCase prepareSavedUnitDetailsUseCase;
  final PrepareDraftUnitDetailsUseCase prepareDraftUnitDetailsUseCase;

  UnitDetailsBloc({
    required this.prepareSavedUnitDetailsUseCase,
    required this.prepareDraftUnitDetailsUseCase,
  }) : super(
          const UnitDetailsReady(
            draftDetails: UnitDetailsModel.empty,
            savedDetails: UnitDetailsModel.empty,
            editMode: false,
            conversionRuleVisible: false,
            conversionRuleEnabled: false,
          ),
        ) {
    on<GetNewUnitDetails>(_onNewUnitDetailsGet);
    on<GetExistingUnitDetails>(_onExistingUnitDetailsGet);
    on<ChangeGroupInUnitDetails>(_onUnitGroupChange);
    on<ChangeArgumentUnitInUnitDetails>(_onArgumentUnitChange);
    on<UpdateUnitNameInUnitDetails>(_onUnitNameUpdate);
    on<UpdateUnitCodeInUnitDetails>(_onUnitCodeUpdate);
    on<UpdateUnitValueInUnitDetails>(_onUnitValueUpdate);
    on<UpdateArgumentUnitValueInUnitDetails>(_onArgumentUnitValueUpdate);
  }

  _onNewUnitDetailsGet(
    GetNewUnitDetails event,
    Emitter<UnitDetailsState> emit,
  ) async {
    await _onUnitDetailsGet(
      unitGroup: event.unitGroup,
      existingUnit: null,
      emit: emit,
    );
  }

  _onExistingUnitDetailsGet(
    GetExistingUnitDetails event,
    Emitter<UnitDetailsState> emit,
  ) async {
    await _onUnitDetailsGet(
      unitGroup: event.unitGroup,
      existingUnit: event.unit,
      emit: emit,
    );
  }

  _onUnitGroupChange(
    ChangeGroupInUnitDetails event,
    Emitter<UnitDetailsState> emit,
  ) async {
    UnitDetailsReady currentState = state as UnitDetailsReady;
    UnitDetailsModel currentSavedDetails = currentState.savedDetails;
    UnitDetailsModel currentDraftDetails = currentState.draftDetails;
    bool editMode = currentState.editMode;

    UnitDetailsModel? savedDetails;

    if (!editMode) {
      final savedDetailsResult = await prepareSavedUnitDetailsUseCase.execute(
        UnitDetailsModel.coalesce(
          currentSavedDetails,
          unitGroup: event.unitGroup,
          unit: UnitModel.coalesce(
            currentSavedDetails.unit,
            code: UnitUtils.calcInitialUnitCode(
              currentDraftDetails.unit.name,
              unitCodeMaxLength: UnitDetailsModel.unitCodeMaxLength,
            ),
          ),
          argUnit: UnitModel.none,
        ),
      );

      savedDetails = await _processResult(
        savedDetailsResult,
        emit,
      );

      if (savedDetails == null) {
        return;
      }
    }

    final draftDetailsResult = await prepareDraftUnitDetailsUseCase.execute(
      UnitDetailsModel.coalesce(
        currentDraftDetails,
        unitGroup: event.unitGroup,
        argUnit: UnitModel.none,
      ),
    );

    UnitDetailsModel? draftDetails = await _processResult(
      draftDetailsResult,
      emit,
    );

    if (draftDetails == null) {
      return;
    }

    emit(
      UnitDetailsReady(
        draftDetails: draftDetails,
        savedDetails: savedDetails ?? currentSavedDetails,
        unitToBeSaved: await _buildUnitToBeSaved(
          draftDetails: draftDetails,
          savedDetails: savedDetails ?? currentSavedDetails,
          editMode: editMode,
        ),
        editMode: editMode,
        conversionRuleVisible:
            draftDetails.unitGroup?.conversionType != ConversionType.formula &&
                (!editMode && draftDetails.unit.named || editMode) &&
                draftDetails.argUnit.notEmpty,
        conversionRuleEnabled:
            draftDetails.unitGroup?.conversionType == ConversionType.static,
      ),
    );
  }

  _onArgumentUnitChange(
    ChangeArgumentUnitInUnitDetails event,
    Emitter<UnitDetailsState> emit,
  ) async {
    UnitDetailsReady currentState = state as UnitDetailsReady;
    UnitDetailsModel currentSavedDetails = currentState.savedDetails;
    UnitDetailsModel currentDraftDetails = currentState.draftDetails;
    bool editMode = currentState.editMode;

    final draftDetailsResult = await prepareDraftUnitDetailsUseCase.execute(
      UnitDetailsModel.coalesce(
        currentDraftDetails,
        argUnit: event.argumentUnit,
      ),
    );

    UnitDetailsModel? draftDetails =
        await _processResult(draftDetailsResult, emit);

    if (draftDetails == null) {
      return;
    }

    emit(
      UnitDetailsReady(
        draftDetails: draftDetails,
        savedDetails: currentSavedDetails,
        unitToBeSaved: await _buildUnitToBeSaved(
          draftDetails: draftDetails,
          savedDetails: currentSavedDetails,
          editMode: editMode,
        ),
        conversionRuleVisible: true,
        editMode: editMode,
        conversionRuleEnabled:
            draftDetails.unitGroup?.conversionType == ConversionType.static,
      ),
    );
  }

  _onUnitNameUpdate(
    UpdateUnitNameInUnitDetails event,
    Emitter<UnitDetailsState> emit,
  ) async {
    UnitDetailsReady currentState = state as UnitDetailsReady;
    UnitDetailsModel currentDraftDetails = currentState.draftDetails;
    UnitDetailsModel currentSavedDetails = currentState.savedDetails;
    bool editMode = currentState.editMode;

    UnitDetailsModel savedDetails = UnitDetailsModel.coalesce(
      currentSavedDetails,
      unit: UnitModel.coalesce(
        currentSavedDetails.unit,
        code: editMode
            ? currentSavedDetails.unit.code
            : UnitUtils.calcInitialUnitCode(
                event.newValue,
                unitCodeMaxLength: UnitDetailsModel.unitCodeMaxLength,
              ),
      ),
    );

    UnitDetailsModel draftDetails = UnitDetailsModel.coalesce(
      currentDraftDetails,
      unit: UnitModel.coalesce(
        currentDraftDetails.unit,
        name: event.newValue,
      ),
    );

    emit(
      UnitDetailsReady(
        draftDetails: draftDetails,
        savedDetails: savedDetails,
        unitToBeSaved: await _buildUnitToBeSaved(
          draftDetails: draftDetails,
          savedDetails: savedDetails,
          editMode: editMode,
        ),
        editMode: editMode,
        conversionRuleVisible:
            draftDetails.unitGroup?.conversionType != ConversionType.formula &&
                (!editMode && draftDetails.unit.named ||
                    editMode && draftDetails.unit.coefficient != 1) &&
                draftDetails.argUnit.notEmpty,
        conversionRuleEnabled:
            draftDetails.unitGroup?.conversionType == ConversionType.static,
      ),
    );
  }

  _onUnitCodeUpdate(
    UpdateUnitCodeInUnitDetails event,
    Emitter<UnitDetailsState> emit,
  ) async {
    UnitDetailsReady currentState = state as UnitDetailsReady;
    UnitDetailsModel currentSavedDetails = currentState.savedDetails;
    UnitDetailsModel currentDraftDetails = currentState.draftDetails;
    bool editMode = currentState.editMode;

    UnitDetailsModel draftDetails = UnitDetailsModel.coalesce(
      currentDraftDetails,
      unit: UnitModel.coalesce(
        currentDraftDetails.unit,
        code: event.newValue,
      ),
    );

    emit(
      UnitDetailsReady(
        draftDetails: draftDetails,
        savedDetails: currentSavedDetails,
        unitToBeSaved: await _buildUnitToBeSaved(
          draftDetails: draftDetails,
          savedDetails: currentSavedDetails,
          editMode: editMode,
        ),
        conversionRuleVisible:
            draftDetails.unitGroup?.conversionType != ConversionType.formula &&
                (!editMode && draftDetails.unit.named ||
                    editMode && draftDetails.unit.coefficient != 1) &&
                draftDetails.argUnit.notEmpty,
        editMode: editMode,
        conversionRuleEnabled:
            draftDetails.unitGroup?.conversionType == ConversionType.static,
      ),
    );
  }

  _onUnitValueUpdate(
    UpdateUnitValueInUnitDetails event,
    Emitter<UnitDetailsState> emit,
  ) async {
    UnitDetailsReady currentState = state as UnitDetailsReady;
    UnitDetailsModel currentDraftDetails = currentState.draftDetails;
    UnitDetailsModel currentSavedDetails = currentState.savedDetails;
    bool editMode = currentState.editMode;

    UnitDetailsModel draftDetails = UnitDetailsModel.coalesce(
      currentDraftDetails,
      value: ValueModel.ofString(event.newValue),
    );

    ValueModel currentUnitValue;
    if (draftDetails.value.notEmpty) {
      currentUnitValue = draftDetails.value;
    } else if (currentSavedDetails.value.notEmpty) {
      currentUnitValue = currentSavedDetails.value;
    } else {
      currentUnitValue = ValueModel.one;
    }

    ValueModel currentArgUnitValue;
    if (draftDetails.argValue.notEmpty) {
      currentArgUnitValue = draftDetails.argValue;
    } else if (currentSavedDetails.argValue.notEmpty) {
      currentArgUnitValue = currentSavedDetails.argValue;
    } else {
      currentArgUnitValue = ValueModel.one;
    }

    double newUnitCoefficient =
        await prepareDraftUnitDetailsUseCase.calculateCurrentUnitCoefficient(
      currentUnitValue: currentUnitValue,
      argUnit: draftDetails.argUnit,
      argValue: currentArgUnitValue,
    );

    draftDetails = UnitDetailsModel.coalesce(
      draftDetails,
      unit: UnitModel.coalesce(
        draftDetails.unit,
        coefficient: newUnitCoefficient,
      ),
    );

    emit(
      UnitDetailsReady(
        draftDetails: draftDetails,
        savedDetails: currentSavedDetails,
        unitToBeSaved: await _buildUnitToBeSaved(
          draftDetails: draftDetails,
          savedDetails: currentSavedDetails,
          editMode: editMode,
        ),
        conversionRuleVisible: true,
        editMode: editMode,
        conversionRuleEnabled:
            draftDetails.unitGroup?.conversionType == ConversionType.static,
      ),
    );
  }

  _onArgumentUnitValueUpdate(
    UpdateArgumentUnitValueInUnitDetails event,
    Emitter<UnitDetailsState> emit,
  ) async {
    UnitDetailsReady currentState = state as UnitDetailsReady;
    UnitDetailsModel currentDraftDetails = currentState.draftDetails;
    UnitDetailsModel currentSavedDetails = currentState.savedDetails;
    bool editMode = currentState.editMode;

    UnitDetailsModel draftDetails = UnitDetailsModel.coalesce(
      currentDraftDetails,
      argValue: ValueModel.ofString(event.newValue),
    );

    ValueModel currentUnitValue;
    if (draftDetails.value.notEmpty) {
      currentUnitValue = draftDetails.value;
    } else if (currentSavedDetails.value.notEmpty) {
      currentUnitValue = currentSavedDetails.value;
    } else {
      currentUnitValue = ValueModel.one;
    }

    ValueModel currentArgUnitValue;
    if (draftDetails.argValue.notEmpty) {
      currentArgUnitValue = draftDetails.argValue;
    } else if (currentSavedDetails.argValue.notEmpty) {
      currentArgUnitValue = currentSavedDetails.argValue;
    } else {
      currentArgUnitValue = ValueModel.one;
    }

    double newUnitCoefficient =
        await prepareDraftUnitDetailsUseCase.calculateCurrentUnitCoefficient(
      currentUnitValue: currentUnitValue,
      argUnit: draftDetails.argUnit,
      argValue: currentArgUnitValue,
    );

    draftDetails = UnitDetailsModel.coalesce(
      draftDetails,
      unit: UnitModel.coalesce(
        draftDetails.unit,
        coefficient: newUnitCoefficient,
      ),
    );

    emit(
      UnitDetailsReady(
        draftDetails: draftDetails,
        savedDetails: currentSavedDetails,
        unitToBeSaved: await _buildUnitToBeSaved(
          draftDetails: draftDetails,
          savedDetails: currentSavedDetails,
          editMode: editMode,
        ),
        conversionRuleVisible: true,
        editMode: editMode,
        conversionRuleEnabled:
            draftDetails.unitGroup?.conversionType == ConversionType.static,
      ),
    );
  }

  Future<UnitDetailsModel?> _processResult(
    final result,
    final emit,
  ) async {
    if (result.isLeft) {
      emit(
        UnitDetailsErrorState(
          exception: result.left,
          lastSuccessfulState: state,
        ),
      );
      return null;
    } else if (result.right.unitGroup?.conversionType !=
            ConversionType.formula &&
        result.right.argUnit.empty) {
      emit(
        const UnitDetailsNotificationState(
          exception: ConvertouchException(
            message: "The Base unit is going to be added. "
                "Default coefficient is 1",
            severity: ExceptionSeverity.info,
          ),
        ),
      );
    }

    return result.right;
  }

  Future<UnitModel?> _buildUnitToBeSaved({
    required UnitDetailsModel draftDetails,
    required UnitDetailsModel savedDetails,
    required bool editMode,
  }) async {
    String newUnitName = draftDetails.unit.named
        ? draftDetails.unit.name
        : savedDetails.unit.name;

    String newUnitCode;
    if (draftDetails.unit.code.isNotEmpty) {
      newUnitCode = draftDetails.unit.code;
    } else {
      newUnitCode = editMode
          ? savedDetails.unit.code
          : UnitUtils.calcInitialUnitCode(
              draftDetails.unit.name,
              unitCodeMaxLength: UnitDetailsModel.unitCodeMaxLength,
            );
    }

    bool groupsDiff = draftDetails.unitGroup != savedDetails.unitGroup;
    bool unitNameDiff = newUnitName != savedDetails.unit.name;
    bool unitCodeDiff = newUnitCode != savedDetails.unit.code;
    bool unitCoefficientDiff =
        draftDetails.unit.coefficient != savedDetails.unit.coefficient;
    bool unitSymbolDiff = draftDetails.unit.symbol != savedDetails.unit.symbol;

    log("unit name is not empty: ${newUnitName.isNotEmpty}");
    log("group is different: $groupsDiff");
    log("unit name is different: $unitNameDiff");
    log("unit code is empty: ${newUnitCode.isEmpty}, "
        "unit code is different: $unitCodeDiff");
    log("unit coefficient is different: $unitCoefficientDiff");
    log("unit symbol is different: $unitSymbolDiff");

    if (newUnitName.isNotEmpty &&
        (groupsDiff ||
            unitNameDiff ||
            unitCodeDiff ||
            unitCoefficientDiff ||
            unitSymbolDiff)) {
      return UnitModel.coalesce(
        draftDetails.unit,
        name: newUnitName,
        code: newUnitCode,
        unitGroupId: draftDetails.unitGroup!.id,
      );
    }

    return null;
  }

  _onUnitDetailsGet({
    required UnitGroupModel? unitGroup,
    required UnitModel? existingUnit,
    required Emitter<UnitDetailsState> emit,
  }) async {
    bool editMode = existingUnit != null;

    final savedDetailsResult = await prepareSavedUnitDetailsUseCase.execute(
      UnitDetailsModel(
        unitGroup: unitGroup,
        unit: existingUnit ?? UnitModel.none,
        argValue: editMode ? ValueModel.none : ValueModel.one,
      ),
    );

    UnitDetailsModel? savedDetails = await _processResult(
      savedDetailsResult,
      emit,
    );

    if (savedDetails == null) {
      return;
    }

    final draftDetailsResult = await prepareDraftUnitDetailsUseCase.execute(
      UnitDetailsModel(
        unitGroup: unitGroup,
        unit: existingUnit ?? UnitModel.none,
        argValue: editMode ? ValueModel.none : ValueModel.one,
      ),
    );

    UnitDetailsModel? draftDetails = await _processResult(
      draftDetailsResult,
      emit,
    );

    if (draftDetails == null) {
      return;
    }

    if (editMode && existingUnit.coefficient == 1) {
      emit(
        const UnitDetailsNotificationState(
          exception: ConvertouchException(
            message: "It is the Base Unit",
            severity: ExceptionSeverity.info,
          ),
        ),
      );
    }

    emit(
      UnitDetailsReady(
        draftDetails: draftDetails,
        savedDetails: savedDetails,
        editMode: editMode,
        conversionRuleVisible:
            draftDetails.unitGroup?.conversionType != ConversionType.formula &&
                (!editMode && draftDetails.unit.named ||
                    editMode && draftDetails.unit.coefficient != 1) &&
                draftDetails.argUnit.notEmpty,
        conversionRuleEnabled:
            draftDetails.unitGroup?.conversionType == ConversionType.static,
      ),
    );
  }
}
