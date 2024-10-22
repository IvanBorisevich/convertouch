import 'dart:developer';

import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/add_units_to_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/edit_conversion_item_unit_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/edit_conversion_item_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/get_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/remove_conversion_items_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/replace_conversion_item_unit_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/save_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/update_conversion_coefficients_use_case.dart';
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
  final EditConversionItemUnitUseCase editConversionItemUnitUseCase;
  final EditConversionItemValueUseCase editConversionItemValueUseCase;
  final UpdateConversionCoefficientsUseCase updateConversionCoefficientsUseCase;
  final RemoveConversionItemsUseCase removeConversionItemsUseCase;
  final ReplaceConversionItemUnitUseCase replaceConversionItemUnitUseCase;
  final NavigationBloc navigationBloc;

  ConversionBloc({
    required this.getConversionUseCase,
    required this.saveConversionUseCase,
    required this.addUnitsToConversionUseCase,
    required this.editConversionItemUnitUseCase,
    required this.editConversionItemValueUseCase,
    required this.updateConversionCoefficientsUseCase,
    required this.removeConversionItemsUseCase,
    required this.replaceConversionItemUnitUseCase,
    required this.navigationBloc,
  }) : super(
          const ConversionBuilt(
            conversion: ConversionModel.none,
          ),
        ) {
    on<GetConversion>(_onGetConversion);
    on<SaveConversion>(_onSaveConversion);
    on<EditConversionGroup>(_onEditConversionGroup);
    on<AddUnitsToConversion>(_onAddUnitsToConversion);
    on<EditConversionItemUnit>(_onEditConversionItemUnit);
    on<EditConversionItemValue>(_onEditConversionItemValue);
    on<UpdateConversionCoefficients>(_onUpdateConversionCoefficients);
    on<RemoveConversionItems>(_onRemoveConversionItems);
    on<ReplaceConversionItemUnit>(_onReplaceConversionItemUnit);
  }

  _onGetConversion(
    GetConversion event,
    Emitter<ConversionState> emit,
  ) async {
    if (event.unitGroup.id != state.conversion.unitGroup.id) {
      var result = await getConversionUseCase.execute(event.unitGroup.id);

      if (result.isRight && !result.right.exists) {
        log("No conversion found in db by group id = ${event.unitGroup.id}");
        result = Right(ConversionModel.noItems(event.unitGroup));
      }

      ConversionBuilt prev = state;
      await _handleAndEmit(result, emit, onSuccess: () {
        if (prev.conversion.exists) {
          log("Processing previous conversion state of the group "
              "'${prev.conversion.unitGroup.name}'");
          event.processPrevConversion?.call(prev.conversion);
        } else {
          log("No previous conversion");
        }
      });
    } else {
      log("Get existing conversion state from cache");
      emit(state);
    }
  }

  _onSaveConversion(
    SaveConversion event,
    Emitter<ConversionState> emit,
  ) async {
    var result = await saveConversionUseCase.execute(event.conversion);

    if (result.isLeft) {
      navigationBloc.add(
        ShowException(exception: result.left),
      );
    }
  }

  _onEditConversionGroup(
    EditConversionGroup event,
    Emitter<ConversionState> emit,
  ) async {
    if (state.conversion.unitGroup.id == event.editedGroup.id) {
      emit(
        ConversionBuilt(
          conversion: ConversionModel(
            unitGroup: event.editedGroup,
            sourceConversionItem: state.conversion.sourceConversionItem,
            targetConversionItems: state.conversion.targetConversionItems,
          ),
          showRefreshButton: state.showRefreshButton,
        ),
      );
    }

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
        rebuildConversion: false,
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
              result.right.targetConversionItems.isNotEmpty,
        ),
      );
      onSuccess?.call();
    }
  }

  @override
  ConversionBuilt? fromJson(Map<String, dynamic> json) {
    return ConversionBuilt.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(ConversionBuilt state) {
    return state.toJson();
  }
}
