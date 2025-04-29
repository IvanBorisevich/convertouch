import 'dart:developer';

import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/add_param_sets_to_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/add_units_to_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/edit_conversion_group_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/edit_conversion_item_unit_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/edit_conversion_item_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/edit_conversion_param_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/get_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/remove_conversion_items_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/remove_param_sets_from_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/replace_conversion_item_unit_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/replace_conversion_param_unit_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/save_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/select_param_set_in_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/update_conversion_coefficients_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_events.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_events.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_states.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversionBloc
    extends ConvertouchPersistentBloc<ConvertouchEvent, ConversionBuilt> {
  final GetConversionUseCase getConversionUseCase;
  final SaveConversionUseCase saveConversionUseCase;
  final AddUnitsToConversionUseCase addUnitsToConversionUseCase;
  final EditConversionGroupUseCase editConversionGroupUseCase;
  final EditConversionItemUnitUseCase editConversionItemUnitUseCase;
  final EditConversionItemValueUseCase editConversionItemValueUseCase;
  final UpdateConversionCoefficientsUseCase updateConversionCoefficientsUseCase;
  final RemoveConversionItemsUseCase removeConversionItemsUseCase;
  final ReplaceConversionItemUnitUseCase replaceConversionItemUnitUseCase;
  final AddParamSetsToConversionUseCase addParamSetsToConversionUseCase;
  final RemoveParamSetsFromConversionUseCase
      removeParamSetsFromConversionUseCase;
  final SelectParamSetInConversionUseCase selectParamSetInConversionUseCase;
  final EditConversionParamValueUseCase editConversionParamValueUseCase;
  final ReplaceConversionParamUnitUseCase replaceConversionParamUnitUseCase;
  final NavigationBloc navigationBloc;

  ConversionBloc({
    required this.getConversionUseCase,
    required this.saveConversionUseCase,
    required this.addUnitsToConversionUseCase,
    required this.editConversionGroupUseCase,
    required this.editConversionItemUnitUseCase,
    required this.editConversionItemValueUseCase,
    required this.updateConversionCoefficientsUseCase,
    required this.removeConversionItemsUseCase,
    required this.replaceConversionItemUnitUseCase,
    required this.addParamSetsToConversionUseCase,
    required this.removeParamSetsFromConversionUseCase,
    required this.selectParamSetInConversionUseCase,
    required this.editConversionParamValueUseCase,
    required this.replaceConversionParamUnitUseCase,
    required this.navigationBloc,
  }) : super(
          const ConversionBuilt(
            conversion: ConversionModel.none,
          ),
        ) {
    on<GetConversion>(_onGetConversion);
    on<SaveConversion>(_onSaveConversion);
    on<ClearConversion>(_onClearConversion);
    on<EditConversionGroup>(_onEditConversionGroup);
    on<AddUnitsToConversion>(_onAddUnitsToConversion);
    on<EditConversionItemUnit>(_onEditConversionItemUnit);
    on<EditConversionItemValue>(_onEditConversionItemValue);
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
  }

  _onGetConversion(
    GetConversion event,
    Emitter<ConversionState> emit,
  ) async {
    if (event.unitGroup.id != state.conversion.unitGroup.id) {
      var result = await getConversionUseCase.execute(event.unitGroup);

      ConversionBuilt prev = state;
      log("Prev conversion state: $prev");

      if (result.isLeft) {
        navigationBloc.add(
          ShowException(exception: result.left),
        );
      } else {
        ConversionModel conversion = result.right ??
            ObjectUtils.tryGet(
              await addParamSetsToConversionUseCase.execute(
                InputConversionModifyModel<AddParamSetsDelta>(
                  conversion: ConversionModel.noItems(
                    id: -1,
                    unitGroup: event.unitGroup,
                    params: null,
                  ),
                  delta: const AddParamSetsDelta(
                    initial: true,
                  ),
                ),
              ),
            );

        emit(
          ConversionBuilt(
            conversion: conversion,
            showRefreshButton: event.unitGroup.refreshable &&
                conversion.convertedUnitValues.isNotEmpty,
          ),
        );

        if (prev.conversion.exists) {
          event.processPrevConversion?.call(prev.conversion);
        }
      }
    } else {
      emit(state);
    }

    event.onComplete?.call();
  }

  _onSaveConversion(
    SaveConversion event,
    Emitter<ConversionState> emit,
  ) async {
    log("Save conversion to db: ${event.conversion}");
    var result = await saveConversionUseCase.execute(event.conversion);

    if (result.isLeft) {
      navigationBloc.add(
        ShowException(exception: result.left),
      );
    }
  }

  _onClearConversion(
    ClearConversion event,
    Emitter<ConversionState> emit,
  ) {
    emit(
      ConversionBuilt(
        conversion: ConversionModel.noItems(
          id: state.conversion.id,
          unitGroup: state.conversion.unitGroup,
          params: state.conversion.params,
        ),
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
        recalculateUnitValues: false,
      ),
    );

    await _handleAndEmit(result, emit);
    event.onComplete?.call();
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

    await _handleAndEmit(result, emit);
  }

  _onEditConversionItemUnit(
    EditConversionItemUnit event,
    Emitter<ConversionState> emit,
  ) async {
    final result = await editConversionItemUnitUseCase.execute(
      InputConversionModifyModel<EditConversionItemUnitDelta>(
        delta: EditConversionItemUnitDelta(
          editedUnit: event.editedUnit,
        ),
        conversion: state.conversion,
      ),
    );

    await _handleAndEmit(result, emit);
  }

  _onEditConversionItemValue(
    EditConversionItemValue event,
    Emitter<ConversionState> emit,
  ) async {
    final result = await editConversionItemValueUseCase.execute(
      InputConversionModifyModel<EditConversionItemValueDelta>(
        delta: EditConversionItemValueDelta(
          newValue: event.newValue,
          newDefaultValue: event.newDefaultValue,
          unitId: event.unitId,
        ),
        conversion: state.conversion,
      ),
    );

    await _handleAndEmit(result, emit);
  }

  _onUpdateConversionCoefficients(
    UpdateConversionCoefficients event,
    Emitter<ConversionState> emit,
  ) async {
    final result = await updateConversionCoefficientsUseCase.execute(
      InputConversionModifyModel<UpdateConversionCoefficientsDelta>(
        delta: UpdateConversionCoefficientsDelta(
          updatedUnitCoefs: event.updatedUnitCoefs,
        ),
        conversion: state.conversion,
      ),
    );

    await _handleAndEmit(result, emit);
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
        recalculateUnitValues: false,
      ),
    );
    await _handleAndEmit(result, emit);
  }

  _onReplaceConversionItemUnit(
    ReplaceConversionItemUnit event,
    Emitter<ConversionState> emit,
  ) async {
    final result = await replaceConversionItemUnitUseCase.execute(
      InputConversionModifyModel<ReplaceConversionItemUnitDelta>(
        delta: ReplaceConversionItemUnitDelta(
          newUnit: event.newUnit,
          oldUnitId: event.oldUnitId,
        ),
        conversion: state.conversion,
      ),
    );
    await _handleAndEmit(result, emit);
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
    await _handleAndEmit(result, emit);
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
    await _handleAndEmit(result, emit);
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
    await _handleAndEmit(result, emit);
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
    await _handleAndEmit(result, emit);
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
    await _handleAndEmit(result, emit);
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
    await _handleAndEmit(result, emit);
  }

  _handleAndEmit(
    Either<ConvertouchException, ConversionModel> result,
    Emitter<ConversionState> emit, {
    void Function()? onSuccess,
  }) async {
    if (result.isLeft) {
      navigationBloc.add(
        ShowException(exception: result.left),
      );
    } else {
      emit(
        ConversionBuilt(
          conversion: result.right,
          showRefreshButton: result.right.unitGroup.refreshable &&
              result.right.convertedUnitValues.isNotEmpty,
        ),
      );
      onSuccess?.call();
    }
  }

  @override
  ConversionBuilt? fromJson(Map<String, dynamic> json) {
    log("Serialized conversion json map: $json");
    return ConversionBuilt.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(ConversionBuilt state) {
    return state.toJson();
  }
}
