import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_conversion_model.dart';
import 'package:convertouch/domain/use_cases/conversion/build_conversion_use_case.dart';
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
  final NavigationBloc navigationBloc;

  ConversionBloc({
    required this.buildConversionUseCase,
    required this.navigationBloc,
  }) : super(
          const ConversionBuilt(
            conversion: OutputConversionModel(),
          ),
        ) {
    on<BuildConversion>(_onBuildConversion);
    on<RebuildConversionAfterUnitReplacement>(_onConversionItemUnitChange);
    on<ShowNewConversionAfterRefresh>(_onNewConversionShow);
    on<RemoveConversionItem>(_onRemoveConversion);
    on<GetLastSavedConversion>((event, emit) => emit(state));
  }

  _onBuildConversion(
    BuildConversion event,
    Emitter<ConversionState> emit,
  ) async {
    UnitGroupModel? unitGroup = event.conversionParams.unitGroup;
    ConversionItemModel? sourceConversionItem =
        event.conversionParams.sourceConversionItem;
    List<UnitModel> targetUnits = event.conversionParams.targetUnits;

    if (event.removedUnitGroupIds
        .contains(event.conversionParams.unitGroup?.id)) {
      unitGroup = null;
      sourceConversionItem = null;
      targetUnits = [];
    } else {
      if (event.modifiedUnitGroup != null &&
          event.modifiedUnitGroup!.id == event.conversionParams.unitGroup?.id) {
        unitGroup = event.modifiedUnitGroup!;
      }

      if (event.removedUnitIds.isNotEmpty) {
        targetUnits = targetUnits
            .whereNot((unit) => event.removedUnitIds.contains(unit.id))
            .toList();
      }

      if (event.modifiedUnit != null) {
        if (event.modifiedUnit!.id == sourceConversionItem?.unit.id) {
          if (event.modifiedUnit!.unitGroupId ==
              sourceConversionItem?.unit.unitGroupId) {
            sourceConversionItem = ConversionItemModel.coalesce(
              sourceConversionItem,
              unit: event.modifiedUnit!,
            );
          } else {
            sourceConversionItem = null;
          }
        }

        targetUnits = targetUnits
            .map((unit) {
              if (event.modifiedUnit!.id == unit.id) {
                if (event.modifiedUnit!.unitGroupId == unit.unitGroupId) {
                  return event.modifiedUnit!;
                } else {
                  return null;
                }
              } else {
                return unit;
              }
            })
            .whereNotNull()
            .toList();
      }
    }

    final conversionResult = await buildConversionUseCase.execute(
      InputConversionModel(
        unitGroup: unitGroup,
        sourceConversionItem: sourceConversionItem,
        targetUnits: targetUnits,
      ),
    );

    if (conversionResult.isLeft) {
      navigationBloc.add(
        ShowException(exception: conversionResult.left),
      );
    } else {
      // if (event.runtimeType != RebuildConversionOnValueChange &&
      //     conversionResult.right.emptyConversionItemsExist) {
      //   navigationBloc.add(
      //     const ShowException(
      //       exception: ConvertouchException(
      //         message: "Some dynamic values are empty. Please refresh them",
      //         severity: ExceptionSeverity.warning,
      //       ),
      //     ),
      //   );
      // }

      emit(
        ConversionBuilt(
          conversion: conversionResult.right,
          showRefreshButton: conversionResult.right.unitGroup != null &&
              conversionResult.right.unitGroup!.refreshable,
        ),
      );
    }
  }

  _onConversionItemUnitChange(
    RebuildConversionAfterUnitReplacement event,
    Emitter<ConversionState> emit,
  ) async {
    int oldUnitIndex = event.conversionParams.targetUnits
        .indexWhere((unit) => event.oldUnit.id! == unit.id!);
    event.conversionParams.targetUnits[oldUnitIndex] = event.newUnit;

    await _onBuildConversion(event, emit);

    navigationBloc.add(const NavigateBack());
  }

  _onNewConversionShow(
    ShowNewConversionAfterRefresh event,
    Emitter<ConversionState> emit,
  ) async {
    emit(
      ConversionBuilt(
        conversion: event.newConversion,
        showRefreshButton: true,
      ),
    );
  }

  _onRemoveConversion(
    RemoveConversionItem event,
    Emitter<ConversionState> emit,
  ) async {
    ConversionBuilt prev = state as ConversionBuilt;

    emit(const ConversionInProgress());

    List<ConversionItemModel> conversionItems =
        prev.conversion.targetConversionItems;
    conversionItems.removeWhere((item) => event.id == item.unit.id);

    ConversionItemModel? sourceConversionItem =
        prev.conversion.sourceConversionItem;
    if (sourceConversionItem?.unit.id == event.id) {
      sourceConversionItem = conversionItems.firstOrNull;
    }

    final outputConversion = OutputConversionModel(
      unitGroup: prev.conversion.unitGroup,
      sourceConversionItem: sourceConversionItem,
      targetConversionItems: conversionItems,
      emptyConversionItemsExist: prev.conversion.emptyConversionItemsExist,
    );

    emit(
      ConversionBuilt(
        conversion: outputConversion,
        showRefreshButton: prev.showRefreshButton,
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
