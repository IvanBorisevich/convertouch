import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_conversion_model.dart';
import 'package:convertouch/domain/use_cases/conversion/add_units_to_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/build_new_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/edit_conversion_item_unit_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/edit_conversion_item_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/get_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/remove_conversion_items_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/replace_conversion_item_unit_use_case.dart';
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
    extends ConvertouchPersistentBloc<ConvertouchEvent, ConversionState> {
  final BuildNewConversionUseCase buildNewConversionUseCase;
  final GetConversionUseCase getConversionUseCase;
  final AddUnitsToConversionUseCase addUnitsToConversionUseCase;
  final EditConversionItemUnitUseCase editConversionItemUnitUseCase;
  final EditConversionItemValueUseCase editConversionItemValueUseCase;
  final UpdateConversionCoefficientsUseCase updateConversionCoefficientsUseCase;
  final RemoveConversionItemsUseCase removeConversionItemsUseCase;
  final ReplaceConversionItemUnitUseCase replaceConversionItemUnitUseCase;
  final NavigationBloc navigationBloc;

  ConversionBloc({
    required this.buildNewConversionUseCase,
    required this.getConversionUseCase,
    required this.addUnitsToConversionUseCase,
    required this.editConversionItemUnitUseCase,
    required this.editConversionItemValueUseCase,
    required this.updateConversionCoefficientsUseCase,
    required this.removeConversionItemsUseCase,
    required this.replaceConversionItemUnitUseCase,
    required this.navigationBloc,
  }) : super(
          const ConversionBuilt(
            conversion: OutputConversionModel(),
          ),
        ) {
    on<GetConversion>(_onGetConversion);
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
    var result = await getConversionUseCase.execute(event.unitGroup);

    if (result.isLeft) {
      navigationBloc.add(
        ShowException(exception: result.left),
      );
    } else if (result.right == OutputConversionModel.none) {
      result = await buildNewConversionUseCase.execute(
        InputConversionModel(unitGroup: event.unitGroup),
      );
    }

    await _handleAndEmit(result, emit);
  }

  _onEditConversionGroup(
    EditConversionGroup event,
    Emitter<ConversionState> emit,
  ) async {
    ConversionBuilt current = state as ConversionBuilt;

    if (current.conversion.unitGroup.id == event.editedGroup.id) {
      emit(
        ConversionBuilt(
          conversion: OutputConversionModel(
            unitGroup: event.editedGroup,
            sourceConversionItem: current.conversion.sourceConversionItem,
            targetConversionItems: current.conversion.targetConversionItems,
          ),
          showRefreshButton: current.showRefreshButton,
        ),
      );
    }
  }

  _onAddUnitsToConversion(
    AddUnitsToConversion event,
    Emitter<ConversionState> emit,
  ) async {
    ConversionBuilt current = state as ConversionBuilt;

    final result = await addUnitsToConversionUseCase.execute(
      InputConversionModifyModel<AddUnitsToConversionDelta>(
        delta: AddUnitsToConversionDelta(
          unitIds: event.unitIds,
        ),
        conversion: current.conversion,
      ),
    );

    await _handleAndEmit(result, emit);
  }

  _onEditConversionItemUnit(
    EditConversionItemUnit event,
    Emitter<ConversionState> emit,
  ) async {
    ConversionBuilt current = state as ConversionBuilt;

    final result = await editConversionItemUnitUseCase.execute(
      InputConversionModifyModel<EditConversionItemUnitDelta>(
        delta: EditConversionItemUnitDelta(
          editedUnit: event.editedUnit,
        ),
        conversion: current.conversion,
        rebuildConversion: false,
      ),
    );

    await _handleAndEmit(result, emit);
  }

  _onEditConversionItemValue(
    EditConversionItemValue event,
    Emitter<ConversionState> emit,
  ) async {
    ConversionBuilt current = state as ConversionBuilt;

    final result = await editConversionItemValueUseCase.execute(
      InputConversionModifyModel<EditConversionItemValueDelta>(
        delta: EditConversionItemValueDelta(
          newValue: event.newValue,
          newDefaultValue: event.newDefaultValue,
          unitId: event.unitId,
        ),
        conversion: current.conversion,
      ),
    );

    await _handleAndEmit(result, emit);
  }

  _onUpdateConversionCoefficients(
    UpdateConversionCoefficients event,
    Emitter<ConversionState> emit,
  ) async {
    ConversionBuilt current = state as ConversionBuilt;

    final result = await updateConversionCoefficientsUseCase.execute(
      InputConversionModifyModel<UpdateConversionCoefficientsDelta>(
        delta: UpdateConversionCoefficientsDelta(
          updatedUnitCoefs: event.updatedUnitCoefs,
        ),
        conversion: current.conversion,
      ),
    );

    await _handleAndEmit(result, emit);
  }

  _onRemoveConversionItems(
    RemoveConversionItems event,
    Emitter<ConversionState> emit,
  ) async {
    ConversionBuilt current = state as ConversionBuilt;

    emit(const ConversionInProgress());

    final result = await removeConversionItemsUseCase.execute(
      InputConversionModifyModel<RemoveConversionItemsDelta>(
        delta: RemoveConversionItemsDelta(
          unitIds: event.unitIds,
        ),
        conversion: current.conversion,
        rebuildConversion: false,
      ),
    );
    await _handleAndEmit(result, emit);
  }

  _onReplaceConversionItemUnit(
    ReplaceConversionItemUnit event,
    Emitter<ConversionState> emit,
  ) async {
    ConversionBuilt current = state as ConversionBuilt;

    final result = await replaceConversionItemUnitUseCase.execute(
      InputConversionModifyModel<ReplaceConversionItemUnitDelta>(
        delta: ReplaceConversionItemUnitDelta(
          newUnit: event.newUnit,
          oldUnitId: event.oldUnitId,
        ),
        conversion: current.conversion,
      ),
    );
    await _handleAndEmit(result, emit);
  }

  _handleAndEmit(
    Either<ConvertouchException, OutputConversionModel> result,
    Emitter<ConversionState> emit,
  ) async {
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
    }
  }

  @override
  ConversionState? fromJson(Map<String, dynamic> json) {
    return ConversionBuilt.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(ConversionState state) {
    if (state is ConversionBuilt) {
      return state.toJson();
    }
    return const {};
  }
}
