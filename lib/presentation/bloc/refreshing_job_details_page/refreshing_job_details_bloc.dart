import 'package:convertouch/domain/model/usecases/input/input_auto_refresh_flag_change_model.dart';
import 'package:convertouch/domain/model/usecases/input/input_cron_change_model.dart';
import 'package:convertouch/domain/usecases/refreshing_jobs/change_job_auto_refresh_flag_use_case.dart';
import 'package:convertouch/domain/usecases/refreshing_jobs/change_job_cron_use_case.dart';
import 'package:convertouch/domain/usecases/refreshing_jobs/get_job_details_use_case.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_job_details_page/refreshing_job_details_event.dart';
import 'package:convertouch/presentation/bloc/refreshing_job_details_page/refreshing_job_details_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RefreshingJobDetailsBloc extends ConvertouchBloc<
    RefreshingJobDetailsEvent, RefreshingJobDetailsState> {
  final GetJobDetailsUseCase getJobDetailsUseCase;
  final ChangeJobAutoRefreshFlagUseCase changeJobAutoRefreshFlagUseCase;
  final ChangeJobCronUseCase changeJobCronUseCase;

  RefreshingJobDetailsBloc({
    required this.getJobDetailsUseCase,
    required this.changeJobAutoRefreshFlagUseCase,
    required this.changeJobCronUseCase,
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
    final result = await getJobDetailsUseCase.execute(event.job);

    emit(
      result.fold(
        (left) => RefreshingJobDetailsErrorState(
          message: left.message,
        ),
        (jobDetails) => RefreshingJobDetailsReady(
          job: jobDetails.job,
        ),
      ),
    );
  }

  _onAutoRefreshToggle(
    ToggleAutoRefreshMode event,
    Emitter<RefreshingJobDetailsState> emit,
  ) async {
    final result = await changeJobAutoRefreshFlagUseCase.execute(
      InputAutoRefreshFlagChangeModel(
        job: event.job,
        newFlag: event.mode,
      ),
    );

    emit(
      result.fold(
        (left) => RefreshingJobDetailsErrorState(
          message: left.message,
        ),
        (job) => RefreshingJobDetailsReady(
          job: job,
        ),
      ),
    );
  }

  _onAutoRefreshCronSelect(
    SelectAutoRefreshCron event,
    Emitter<RefreshingJobDetailsState> emit,
  ) async {
    final result = await changeJobCronUseCase.execute(
      InputCronChangeModel(
        job: event.job,
        newCron: event.newCron,
      ),
    );

    emit(
      result.fold(
        (left) => RefreshingJobDetailsErrorState(
          message: left.message,
        ),
        (job) => RefreshingJobDetailsReady(
          job: job,
        ),
      ),
    );
  }

  _onDataSourceSelect(
    SelectDataSource event,
    Emitter<RefreshingJobDetailsState> emit,
  ) async {}
}
