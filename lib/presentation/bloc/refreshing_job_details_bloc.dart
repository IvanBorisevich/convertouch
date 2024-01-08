import 'package:convertouch/domain/model/input/refreshing_job_details_event.dart';
import 'package:convertouch/domain/model/output/refreshing_job_details_states.dart';
import 'package:convertouch/domain/usecases/refreshing_jobs/get_job_details_use_case.dart';
import 'package:convertouch/domain/usecases/refreshing_jobs/select_auto_refresh_cron_use_case.dart';
import 'package:convertouch/domain/usecases/refreshing_jobs/toggle_auto_refresh_mode_use_case.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RefreshingJobDetailsBloc extends ConvertouchBloc<
    RefreshingJobDetailsEvent, RefreshingJobDetailsState> {
  final GetJobDetailsUseCase getJobDetailsUseCase;
  final ToggleAutoRefreshModeUseCase toggleAutoRefreshModeUseCase;
  final SelectAutoRefreshCronUseCase selectAutoRefreshCronUseCase;

  RefreshingJobDetailsBloc({
    required this.getJobDetailsUseCase,
    required this.toggleAutoRefreshModeUseCase,
    required this.selectAutoRefreshCronUseCase,
  }) : super(const RefreshingJobDetailsInitialState()) {
    on<OpenJobDetails>(_onJobDetailsOpen);
    on<ToggleAutoRefreshMode>(_onAutoRefreshToggle);
    on<SelectAutoRefreshCron>(_onAutoRefreshCronSelect);
    on<SelectDataSource>(_onDataSourceSelect);
  }

  _onJobDetailsOpen(
    OpenJobDetails event,
    Emitter<RefreshingJobDetailsState> emit,
  ) async {
    final result = await getJobDetailsUseCase.execute(event);

    emit(
      result.fold(
          (left) => RefreshingJobDetailsErrorState(message: left.message),
          (right) => right),
    );
  }

  _onAutoRefreshToggle(
    ToggleAutoRefreshMode event,
    Emitter<RefreshingJobDetailsState> emit,
  ) async {
    final result = await toggleAutoRefreshModeUseCase.execute(event);

    emit(
      result.fold(
          (left) => RefreshingJobDetailsErrorState(message: left.message),
          (right) => right),
    );
  }

  _onAutoRefreshCronSelect(
    SelectAutoRefreshCron event,
    Emitter<RefreshingJobDetailsState> emit,
  ) async {
    final result = await selectAutoRefreshCronUseCase.execute(event);

    emit(
      result.fold(
          (left) => RefreshingJobDetailsErrorState(message: left.message),
          (right) => right),
    );
  }

  _onDataSourceSelect(
    SelectDataSource event,
    Emitter<RefreshingJobDetailsState> emit,
  ) async {}
}
