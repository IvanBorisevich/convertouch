import 'package:convertouch/domain/constants/refreshing_jobs.dart';
import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_conversion_model.dart';
import 'package:convertouch/domain/use_cases/conversion/build_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/get_last_saved_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/save_conversion_use_case.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_events.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversionBloc
    extends ConvertouchBloc<ConvertouchEvent, ConversionState> {
  final BuildConversionUseCase buildConversionUseCase;
  final SaveConversionUseCase saveConversionUseCase;
  final GetLastSavedConversionUseCase getLastSavedConversionUseCase;

  ConversionBloc({
    required this.buildConversionUseCase,
    required this.saveConversionUseCase,
    required this.getLastSavedConversionUseCase,
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
    final conversionResult = await buildConversionUseCase.execute(
      event.conversionParams,
    );

    if (conversionResult.isLeft) {
      emit(
        ConversionErrorState(
          exception: conversionResult.left,
          lastSuccessfulState: state,
        ),
      );
    } else {
      await saveConversionUseCase.execute(conversionResult.right);

      if (event.runtimeType != RebuildConversionOnValueChange &&
          conversionResult.right.emptyConversionItemsExist) {
        emit(
          const ConversionNotificationState(
            message: 'Some dynamic values are empty. Please refresh them',
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
      emit(
        ConversionErrorState(
          exception: result.left,
          lastSuccessfulState: state,
        ),
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
