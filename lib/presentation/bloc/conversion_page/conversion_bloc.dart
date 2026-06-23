import 'dart:developer';

import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_align_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/add_param_sets_to_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/add_units_to_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/edit_conversion_group_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/edit_conversion_param_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/edit_conversion_unit_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/edit_conversion_unit_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/get_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/align_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/remove_conversion_items_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/remove_param_sets_from_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/replace_conversion_item_unit_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/replace_conversion_param_unit_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/save_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/select_param_set_in_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/toggle_calculable_param_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/update_conversion_coefficients_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_events.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_states.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversionBloc
    extends ConvertouchPersistentBloc<ConversionEvent, ConversionBuilt> {
  final GetConversionUseCase getConversionUseCase;
  final SaveConversionUseCase saveConversionUseCase;
  final AlignConversionUseCase alignConversionUseCase;
  final AddUnitsToConversionUseCase addUnitsToConversionUseCase;
  final EditConversionGroupUseCase editConversionGroupUseCase;
  final EditConversionUnitUseCase editConversionUnitUseCase;
  final EditConversionUnitValueUseCase editConversionUnitValueUseCase;
  final UpdateConversionCoefficientsUseCase updateConversionCoefficientsUseCase;
  final RemoveConversionItemsUseCase removeConversionItemsUseCase;
  final ReplaceConversionItemUnitUseCase replaceConversionItemUnitUseCase;
  final AddParamSetsToConversionUseCase addParamSetsToConversionUseCase;
  final RemoveParamSetsFromConversionUseCase
      removeParamSetsFromConversionUseCase;
  final SelectParamSetInConversionUseCase selectParamSetInConversionUseCase;
  final EditConversionParamValueUseCase editConversionParamValueUseCase;
  final ReplaceConversionParamUnitUseCase replaceConversionParamUnitUseCase;
  final ToggleCalculableParamUseCase toggleCalculableParamUseCase;

  ConversionBloc({
    required this.getConversionUseCase,
    required this.saveConversionUseCase,
    required this.alignConversionUseCase,
    required this.addUnitsToConversionUseCase,
    required this.editConversionGroupUseCase,
    required this.editConversionUnitUseCase,
    required this.editConversionUnitValueUseCase,
    required this.updateConversionCoefficientsUseCase,
    required this.removeConversionItemsUseCase,
    required this.replaceConversionItemUnitUseCase,
    required this.addParamSetsToConversionUseCase,
    required this.removeParamSetsFromConversionUseCase,
    required this.selectParamSetInConversionUseCase,
    required this.editConversionParamValueUseCase,
    required this.replaceConversionParamUnitUseCase,
    required this.toggleCalculableParamUseCase,
  }) : super(const ConversionBuilt(conversion: ConversionModel.none)) {
    on<GetConversion>(_onGetConversion);
    on<GetOrBuildConversion>(_onGetOrBuildConversion);
    on<SaveConversion>(_onSaveConversion);
    on<CleanupConversion>(_onCleanupConversion);
    on<MoveConversionUnitValue>(_onMoveConversionUnitValue);
    on<EditConversionGroup>(_onEditConversionGroup);
    on<AddUnitsToConversion>(_onAddUnitsToConversion);
    on<EditConversionUnit>(_onEditConversionItemUnit);
    on<EditConversionUnitValue>(_onEditConversionItemValue);
    on<UpdateConversionCoefficients>(_onUpdateConversionCoefficients);
    on<RemoveConversionItems>(_onRemoveConversionItems);
    on<ReplaceConversionItemUnit>(_onReplaceConversionItemUnit);
    on<AddParamSetsToConversion>(_onAddParamSetsToConversion);
    on<RemoveSelectedParamSetFromConversion>(
        _onRemoveSelectedParamSetFromConversion);
    on<RemoveAllParamSetsFromConversion>(_onRemoveAllParamSetsFromConversion);
    on<SelectParamSetInConversion>(_onSelectParamSetInConversion);
    on<EditConversionParamValue>(_onEditConversionParamValue);
    on<ReplaceConversionParamUnit>(_onReplaceConversionParamUnit);
    on<ToggleCalculableParam>(_onToggleCalculableParam);
  }

  _onGetConversion(
    GetConversion event,
    Emitter<ConversionState> emit,
  ) async {
    emit(
      ConversionBuilt(
        conversion: event.conversion,
        rebuildUnitValues: event.rebuildUnitValues,
        rebuildParams: event.rebuildParams,
      ),
    );
  }

  _onGetOrBuildConversion(
    GetOrBuildConversion event,
    Emitter<ConversionState> emit,
  ) async {
    ConversionModel conversion;
    ConversionBuilt? prev;

    if (event.unitGroup.id != state.conversion.unitGroup.id) {
      var conversionFromDb = await getConversionUseCase.execute(
        event.unitGroup,
      );

      prev = state;

      conversion = conversionFromDb.isRight && conversionFromDb.right != null
          ? conversionFromDb.right!
          : ConversionModel.noItems(
              id: -1,
              unitGroup: event.unitGroup,
              params: null,
            );
    } else {
      conversion = state.conversion;
    }

    if (prev != null && prev.conversion.exists) {
      event.processPrevConversion?.call(prev.conversion);
    }

    log("Emit after getting conversion from storage or db");

    emit(
      ConversionBuilt(
        conversion: conversion,
        rebuildUnitValues: event.rebuildUnitValues,
        rebuildParams: event.rebuildParams,
      ),
    );

    event.processCurrentConversion?.call(conversion);

    if (conversion.params == null ||
        !conversion.params!.mandatoryParamSetExists) {
      conversion = ObjectUtils.tryGet(
        await addParamSetsToConversionUseCase.execute(
          InputConversionModifyModel<AddParamSetsDelta>(
            conversion: conversion,
            delta: const AddParamSetsDelta(),
          ),
        ),
      );

      log("Emit after mandatory param set adding");

      emit(
        ConversionBuilt(
          conversion: conversion,
          rebuildUnitValues: event.rebuildUnitValues,
          rebuildParams: event.rebuildParams,
        ),
      );
    }

    conversion = ObjectUtils.tryGet(
      await alignConversionUseCase.execute(
        InputConversionAlignModel(
          conversion: conversion,
          listValuesAsyncFetchMode: ListValuesAsyncFetchMode.viaApiOnly,
          onParamValueUpdated: (newParamValue) {
            event.onParamValueUpdated?.call(newParamValue);

            if (newParamValue.cacheApiFetchedListValues) {
              final newParamsFuture =
                  state.conversion.params?.copyWithChangedParamById(
                paramId: newParamValue.param.id,
                paramSetId: newParamValue.param.paramSetId,
                map: (paramValue, paramSetValue) async => paramValue.copyWith(
                  listValuesFetchResult: newParamValue.listValuesFetchResult,
                ),
              );

              newParamsFuture?.then((newParams) {
                final updatedConversion = state.conversion.copyWith(
                  params: newParams,
                );

                log("Emit after conversion update with a new param value");

                add(GetConversion(conversion: updatedConversion));
              });
            }
          },
        ),
      ),
    );
  }

  _onSaveConversion(
    SaveConversion event,
    Emitter<ConversionState> emit,
  ) async {
    var result = await saveConversionUseCase.execute(event.conversion);

    if (result.isLeft) {
      event.onError?.call(result.left);
    }
  }

  _onCleanupConversion(
    CleanupConversion event,
    Emitter<ConversionState> emit,
  ) async {
    var emptyConversion = ConversionModel.noItems(
      id: state.conversion.id,
      unitGroup: state.conversion.unitGroup,
      params: state.conversion.params,
    );

    if (event.keepParams) {
      emit(
        ConversionBuilt(
          conversion: emptyConversion,
          rebuildUnitValues: event.rebuildUnitValues,
          rebuildParams: false,
        ),
      );
    } else {
      final result = await removeParamSetsFromConversionUseCase.execute(
        InputConversionModifyModel<RemoveParamSetsDelta>(
          delta: const RemoveParamSetsDelta.all(),
          conversion: emptyConversion,
        ),
      );

      await _handleAndEmit(result, emit, event: event);
    }
  }

  _onMoveConversionUnitValue(
    MoveConversionUnitValue event,
    Emitter<ConversionState> emit,
  ) {
    final unitValues = state.conversion.convertedUnitValues
        .map((unitValue) => unitValue.copyWith())
        .toList();

    int oldIndex = event.oldIndex;
    int newIndex = event.newIndex;

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final item = unitValues.removeAt(oldIndex);
    unitValues.insert(newIndex, item);

    emit(
      ConversionBuilt(
        conversion: state.conversion.copyWith(
          convertedUnitValues: unitValues,
        ),
        rebuildUnitValues: event.rebuildUnitValues,
        rebuildParams: event.rebuildParams,
      ),
    );
  }

  _onEditConversionGroup(
    EditConversionGroup event,
    Emitter<ConversionState> emit,
  ) async {
    final result = await editConversionGroupUseCase.execute(
      InputConversionModifyModel<EditConversionGroupDelta>(
        delta: EditConversionGroupDelta(
          editedGroup: event.editedGroup,
        ),
        conversion: state.conversion,
      ),
    );

    await _handleAndEmit(result, emit, event: event);
  }

  _onAddUnitsToConversion(
    AddUnitsToConversion event,
    Emitter<ConversionState> emit,
  ) async {
    final result = await addUnitsToConversionUseCase.execute(
      InputConversionModifyModel<AddUnitsToConversionDelta>(
        delta: AddUnitsToConversionDelta(
          unitIds: event.unitIds,
        ),
        conversion: state.conversion,
      ),
    );

    await _handleAndEmit(result, emit, event: event);
  }

  _onEditConversionItemUnit(
    EditConversionUnit event,
    Emitter<ConversionState> emit,
  ) async {
    final result = await editConversionUnitUseCase.execute(
      InputConversionModifyModel<EditConversionUnitDelta>(
        delta: EditConversionUnitDelta(
          editedUnit: event.editedUnit,
        ),
        conversion: state.conversion,
      ),
    );

    await _handleAndEmit(result, emit, event: event);
  }

  _onEditConversionItemValue(
    EditConversionUnitValue event,
    Emitter<ConversionState> emit,
  ) async {
    final result = await editConversionUnitValueUseCase.execute(
      InputConversionModifyModel<EditConversionUnitValueDelta>(
        delta: EditConversionUnitValueDelta(
          newValue: event.newValue,
          newDefaultValue: event.newDefaultValue,
          unitId: event.unitId,
        ),
        conversion: state.conversion,
      ),
    );

    await _handleAndEmit(result, emit, event: event);
  }

  _onUpdateConversionCoefficients(
    UpdateConversionCoefficients event,
    Emitter<ConversionState> emit,
  ) async {
    final result = await updateConversionCoefficientsUseCase.execute(
      InputConversionModifyModel<UpdateConversionCoefficientsDelta>(
        delta: UpdateConversionCoefficientsDelta(
          newCoefficients: event.newCoefficients,
        ),
        conversion: state.conversion,
      ),
    );

    await _handleAndEmit(result, emit, event: event);
  }

  _onRemoveConversionItems(
    RemoveConversionItems event,
    Emitter<ConversionState> emit,
  ) async {
    final result = await removeConversionItemsUseCase.execute(
      InputConversionModifyModel<RemoveConversionItemsDelta>(
        delta: RemoveConversionItemsDelta(
          unitIds: event.unitIds,
        ),
        conversion: state.conversion,
      ),
    );

    await _handleAndEmit(result, emit, event: event);
  }

  _onReplaceConversionItemUnit(
    ReplaceConversionItemUnit event,
    Emitter<ConversionState> emit,
  ) async {
    final result = await replaceConversionItemUnitUseCase.execute(
      InputConversionModifyModel<ReplaceConversionItemUnitDelta>(
        delta: ReplaceConversionItemUnitDelta(
          newUnit: event.newUnit,
          unitId: event.oldUnitId,
          recalculationMode: event.recalculationMode,
          recalculateUnitValues:
              event.recalculationMode == RecalculationOnUnitChange.otherValues,
        ),
        conversion: state.conversion,
      ),
    );

    await _handleAndEmit(result, emit, event: event);
  }

  _onAddParamSetsToConversion(
    AddParamSetsToConversion event,
    Emitter<ConversionState> emit,
  ) async {
    final result = await addParamSetsToConversionUseCase.execute(
      InputConversionModifyModel<AddParamSetsDelta>(
        delta: AddParamSetsDelta(
          paramSetIds: event.paramSetIds,
        ),
        conversion: state.conversion,
      ),
    );

    await _handleAndEmit(result, emit, event: event);
  }

  _onRemoveSelectedParamSetFromConversion(
    RemoveSelectedParamSetFromConversion event,
    Emitter<ConversionState> emit,
  ) async {
    final result = await removeParamSetsFromConversionUseCase.execute(
      InputConversionModifyModel<RemoveParamSetsDelta>(
        delta: const RemoveParamSetsDelta.current(),
        conversion: state.conversion,
      ),
    );

    await _handleAndEmit(result, emit, event: event);
  }

  _onRemoveAllParamSetsFromConversion(
    RemoveAllParamSetsFromConversion event,
    Emitter<ConversionState> emit,
  ) async {
    final result = await removeParamSetsFromConversionUseCase.execute(
      InputConversionModifyModel<RemoveParamSetsDelta>(
        delta: const RemoveParamSetsDelta.all(),
        conversion: state.conversion,
      ),
    );

    await _handleAndEmit(result, emit, event: event);
  }

  _onSelectParamSetInConversion(
    SelectParamSetInConversion event,
    Emitter<ConversionState> emit,
  ) async {
    final result = await selectParamSetInConversionUseCase.execute(
      InputConversionModifyModel<SelectParamSetDelta>(
        delta: SelectParamSetDelta(
          newSelectedParamSetIndex: event.newSelectedParamSetIndex,
        ),
        conversion: state.conversion,
      ),
    );

    await _handleAndEmit(result, emit, event: event);
  }

  _onEditConversionParamValue(
    EditConversionParamValue event,
    Emitter<ConversionState> emit,
  ) async {
    final result = await editConversionParamValueUseCase.execute(
      InputConversionModifyModel<EditConversionParamValueDelta>(
        delta: EditConversionParamValueDelta(
          newValue: event.newValue,
          newDefaultValue: event.newDefaultValue,
          paramId: event.paramId,
          paramSetId: event.paramSetId,
        ),
        conversion: state.conversion,
      ),
    );

    await _handleAndEmit(result, emit, event: event);
  }

  _onReplaceConversionParamUnit(
    ReplaceConversionParamUnit event,
    Emitter<ConversionState> emit,
  ) async {
    final result = await replaceConversionParamUnitUseCase.execute(
      InputConversionModifyModel<ReplaceConversionParamUnitDelta>(
        delta: ReplaceConversionParamUnitDelta(
          newUnit: event.newUnit,
          paramId: event.paramId,
          paramSetId: event.paramSetId,
        ),
        conversion: state.conversion,
      ),
    );

    await _handleAndEmit(result, emit, event: event);
  }

  _onToggleCalculableParam(
    ToggleCalculableParam event,
    Emitter<ConversionState> emit,
  ) async {
    final result = await toggleCalculableParamUseCase.execute(
      InputConversionModifyModel<ToggleCalculableParamDelta>(
        delta: ToggleCalculableParamDelta(
          paramId: event.paramId,
          paramSetId: event.paramSetId,
        ),
        conversion: state.conversion,
      ),
    );

    await _handleAndEmit(result, emit, event: event);
  }

  _handleAndEmit(
    Either<ConvertouchException, ConversionModel> result,
    Emitter<ConversionState> emit, {
    required ConversionEvent event,
  }) async {
    if (result.isLeft) {
      event.onError?.call(result.left);
    } else {
      emit(
        ConversionBuilt(
          conversion: result.right,
          rebuildUnitValues: event.rebuildUnitValues,
          rebuildParams: event.rebuildParams,
        ),
      );

      event.onConversionUpdated?.call(result.right);
    }
  }

  @override
  ConversionBuilt? fromJson(Map<String, dynamic> json) {
    log("Deserializing conversion json map: $json");
    return ConversionBuilt.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(ConversionBuilt state) {
    log("Serializing conversion: $state");
    return state.toJson();
  }
}
