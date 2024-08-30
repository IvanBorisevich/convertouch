import 'package:convertouch/domain/model/use_case_model/input/input_conversion_item_removal_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_conversion_model.dart';
import 'package:convertouch/domain/use_cases/conversion/build_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/modify_conversion_input_params_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/remove_conversion_item_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_events.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_events.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversionBloc
    extends ConvertouchPersistentBloc<ConvertouchEvent, ConversionState> {
  final BuildConversionUseCase buildConversionUseCase;
  final ModifyConversionInputParamsUseCase modifyConversionInputParamsUseCase;
  final RemoveConversionItemUseCase removeConversionItemUseCase;
  final NavigationBloc navigationBloc;

  ConversionBloc({
    required this.buildConversionUseCase,
    required this.modifyConversionInputParamsUseCase,
    required this.removeConversionItemUseCase,
    required this.navigationBloc,
  }) : super(
          const ConversionBuilt(
            conversion: OutputConversionModel(),
          ),
        ) {
    on<BuildConversion>(_onBuildConversion);
    on<RebuildConversionAfterUnitReplacement>(_onConversionItemUnitChange);
    on<ShowNewConversionAfterRefresh>(_onNewConversionShowAfterRefresh);
    on<RemoveConversionItem>(_onRemoveConversionItem);
    on<GetLastSavedConversion>(_onGetLastSavedConversion);
  }

  _onBuildConversion(
    BuildConversion event,
    Emitter<ConversionState> emit,
  ) async {
    final conversionInputParamsResult =
        await modifyConversionInputParamsUseCase.execute(
      InputConversionModifyModel(
        unitGroup: event.conversionParams.unitGroup,
        sourceConversionItem: event.conversionParams.sourceConversionItem,
        targetUnits: event.conversionParams.targetUnits,
        newUnitGroup: event.modifiedUnitGroup,
        newUnit: event.modifiedUnit,
        removedUnitGroupIds: event.removedUnitGroupIds,
        removedUnitIds: event.removedUnitIds,
      ),
    );

    final params = ObjectUtils.tryGet(conversionInputParamsResult);
    await _buildConversion(params, emit);
  }

  _onConversionItemUnitChange(
    RebuildConversionAfterUnitReplacement event,
    Emitter<ConversionState> emit,
  ) async {
    final conversionInputParamsResult =
        await modifyConversionInputParamsUseCase.execute(
      InputConversionModifyModel(
        unitGroup: event.conversionParams.unitGroup,
        sourceConversionItem: event.conversionParams.sourceConversionItem,
        targetUnits: event.conversionParams.targetUnits,
        oldUnit: event.oldUnit,
        newUnit: event.newUnit,
      ),
    );

    final params = ObjectUtils.tryGet(conversionInputParamsResult);
    await _buildConversion(params, emit);

    navigationBloc.add(const NavigateBack());
  }

  _buildConversion(
    InputConversionModel params,
    Emitter<ConversionState> emit,
  ) async {
    final conversionResult = await buildConversionUseCase.execute(params);

    if (conversionResult.isLeft) {
      navigationBloc.add(
        ShowException(exception: conversionResult.left),
      );
    } else {
      emit(
        ConversionBuilt(
          conversion: conversionResult.right,
          showRefreshButton: conversionResult.right.unitGroup != null &&
              conversionResult.right.unitGroup!.refreshable &&
              conversionResult.right.targetConversionItems.isNotEmpty,
        ),
      );
    }
  }

  _onNewConversionShowAfterRefresh(
    ShowNewConversionAfterRefresh event,
    Emitter<ConversionState> emit,
  ) async {
    emit(
      ConversionBuilt(
        conversion: event.newConversion,
        showRefreshButton: event.newConversion.targetConversionItems.isNotEmpty,
      ),
    );
  }

  _onRemoveConversionItem(
    RemoveConversionItem event,
    Emitter<ConversionState> emit,
  ) async {
    ConversionBuilt prev = state as ConversionBuilt;

    emit(const ConversionInProgress());

    final conversionItemRemovalResult =
        await removeConversionItemUseCase.execute(
      InputConversionItemRemovalModel(
        id: event.id,
        conversion: prev.conversion,
      ),
    );

    final updatedOutputConversion =
        ObjectUtils.tryGet(conversionItemRemovalResult);

    emit(
      ConversionBuilt(
        conversion: updatedOutputConversion,
        showRefreshButton: prev.showRefreshButton &&
            updatedOutputConversion.targetConversionItems.isNotEmpty,
      ),
    );
  }

  _onGetLastSavedConversion(
    GetLastSavedConversion event,
    Emitter<ConversionState> emit,
  ) async {
    ConversionBuilt prev = state as ConversionBuilt;

    emit(
      ConversionBuilt(
        conversion: prev.conversion,
        showRefreshButton: prev.showRefreshButton &&
            prev.conversion.targetConversionItems.isNotEmpty,
      ),
    );
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
