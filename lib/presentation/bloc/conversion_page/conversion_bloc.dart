import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_conversion_model.dart';
import 'package:convertouch/domain/use_cases/conversion/build_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/restore_last_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/save_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/refreshing_jobs/get_job_details_by_group_use_case.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_events.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversionBloc
    extends ConvertouchBloc<ConvertouchEvent, ConversionState> {
  final BuildConversionUseCase buildConversionUseCase;
  final SaveConversionUseCase saveConversionUseCase;
  final RestoreLastConversionUseCase restoreLastConversionUseCase;
  final GetJobDetailsByGroupUseCase getJobDetailsByGroupUseCase;

  ConversionBloc({
    required this.buildConversionUseCase,
    required this.saveConversionUseCase,
    required this.restoreLastConversionUseCase,
    required this.getJobDetailsByGroupUseCase,
  }) : super(
          const ConversionBuilt(
            conversion: OutputConversionModel(),
          ),
        ) {
    on<BuildConversion>(_onBuildConversion);
    on<RebuildConversionAfterUnitReplacement>(_onConversionItemUnitChange);
    on<ShowNewConversionAfterRefresh>(_onNewConversionShow);
    on<RemoveConversionItem>(_onRemoveConversion);
    on<RestoreLastConversion>(_onRestoreConversion);
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

      RefreshingJobModel? jobOfConversion = event.job;

      if (jobOfConversion == null) {
        final jobOfConversionResult = await getJobDetailsByGroupUseCase.execute(
          event.conversionParams.unitGroup,
        );

        if (jobOfConversionResult.isLeft) {
          emit(
            ConversionErrorState(
              exception: jobOfConversionResult.left,
              lastSuccessfulState: state,
            ),
          );
        } else {
          jobOfConversion = jobOfConversionResult.right;
        }
      }

      emit(
        ConversionBuilt(
          conversion: conversionResult.right,
          showRefreshButton:
              conversionResult.right.unitGroup?.refreshable == true &&
                  jobOfConversion != null,
          job: jobOfConversion,
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
        job: event.job,
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

  _onRestoreConversion(
    RestoreLastConversion event,
    Emitter<ConversionState> emit,
  ) async {
    var result = await restoreLastConversionUseCase.execute();

    if (result.isLeft) {
      emit(
        ConversionErrorState(
          exception: result.left,
          lastSuccessfulState: state,
        ),
      );
    } else {
      final jobOfConversion = await getJobDetailsByGroupUseCase.execute(
        result.right.unitGroup,
      );

      emit(
        ConversionBuilt(
          conversion: result.right,
          showRefreshButton: result.right.unitGroup?.refreshable == true &&
              jobOfConversion.right != null,
          job: jobOfConversion.right,
        ),
      );
    }
  }
}
