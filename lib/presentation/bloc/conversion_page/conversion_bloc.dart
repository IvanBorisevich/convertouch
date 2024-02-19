import 'package:collection/collection.dart';
import 'package:convertouch/domain/constants/refreshing_jobs.dart';
import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_conversion_model.dart';
import 'package:convertouch/domain/use_cases/conversion/build_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/get_last_saved_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/save_conversion_use_case.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_events.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_events.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversionBloc
    extends ConvertouchBloc<ConvertouchEvent, ConversionState> {
  final BuildConversionUseCase buildConversionUseCase;
  final SaveConversionUseCase saveConversionUseCase;
  final GetLastSavedConversionUseCase getLastSavedConversionUseCase;
  final NavigationBloc navigationBloc;

  ConversionBloc({
    required this.buildConversionUseCase,
    required this.saveConversionUseCase,
    required this.getLastSavedConversionUseCase,
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
    on<GetLastSavedConversion>(_onLastSavedConversionGet);
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
      await saveConversionUseCase.execute(conversionResult.right);

      if (event.runtimeType != RebuildConversionOnValueChange &&
          conversionResult.right.emptyConversionItemsExist) {
        navigationBloc.add(
          const ShowException(
            exception: ConvertouchException(
              message: "Some dynamic values are empty. Please refresh them",
              severity: ExceptionSeverity.warning,
            ),
          ),
        );
      }

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
    List<ConversionItemModel> conversionItems = event.conversionItems;
    conversionItems.removeWhere((item) => event.itemUnitId == item.unit.id);

    final outputConversion = OutputConversionModel(
      unitGroup: event.unitGroupInConversion,
      sourceConversionItem: conversionItems.firstOrNull,
      targetConversionItems: conversionItems,
    );

    await saveConversionUseCase.execute(outputConversion);

    emit(
      ConversionBuilt(
        conversion: outputConversion,
      ),
    );
  }

  _onLastSavedConversionGet(
    GetLastSavedConversion event,
    Emitter<ConversionState> emit,
  ) async {
    var result = await getLastSavedConversionUseCase.execute();

    if (result.isLeft) {
      navigationBloc.add(
        ShowException(exception: result.left),
      );
    } else {
      RefreshingJobModel? jobOfConversion = RefreshingJobModel.fromJson(
          refreshingJobsMap[result.right.unitGroup?.name]);

      emit(
        ConversionBuilt(
          conversion: result.right,
          showRefreshButton: result.right.unitGroup?.refreshable == true &&
              jobOfConversion != null,
        ),
      );
    }
  }
}
