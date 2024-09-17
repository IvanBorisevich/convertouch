import 'dart:developer';

import 'package:convertouch/domain/model/data_source_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/domain/model/network_data_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_data_refresh_model.dart';
import 'package:convertouch/domain/repositories/data_source_repository.dart';
import 'package:convertouch/domain/repositories/job_repository.dart';
import 'package:convertouch/domain/use_cases/dynamic_data/get_dynamic_data_for_conversion.dart';
import 'package:convertouch/domain/use_cases/jobs/start_job_use_case.dart';
import 'package:convertouch/domain/use_cases/jobs/stop_job_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_events.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_events.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_events.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RefreshingJobsBloc
    extends ConvertouchPersistentBloc<ConvertouchEvent, RefreshingJobsState> {
  final StartJobUseCase startJobUseCase;
  final StopJobUseCase stopJobUseCase;
  final GetDynamicDataForConversionUseCase getDynamicDataForConversionUseCase;
  final DataSourceRepository dataSourceRepository;
  final JobRepository jobRepository;
  final ConversionBloc conversionBloc;
  final NavigationBloc navigationBloc;

  RefreshingJobsBloc({
    required this.startJobUseCase,
    required this.stopJobUseCase,
    required this.getDynamicDataForConversionUseCase,
    required this.dataSourceRepository,
    required this.jobRepository,
    required this.conversionBloc,
    required this.navigationBloc,
  }) : super(const RefreshingJobsFetched(jobs: {}, currentDataSources: {})) {
    on<FetchRefreshingJobs>(_onJobsFetch);
    on<StartRefreshingJobForConversion>(_onStartRefreshingJobForConversion);
    on<StopRefreshingJobForConversion>(_onStopRefreshingJobForConversion);
  }

  _onJobsFetch(
    FetchRefreshingJobs event,
    Emitter<RefreshingJobsState> emit,
  ) async {
    Map<String, JobModel> jobs = await _getAllJobs();
    Map<String, String> currentDataSources = await _getCurrentDataSources();

    emit(
      RefreshingJobsFetched(
        jobs: jobs,
        currentDataSources: currentDataSources,
      ),
    );
  }

  _onStartRefreshingJobForConversion(
    StartRefreshingJobForConversion event,
    Emitter<RefreshingJobsState> emit,
  ) async {
    Map<String, JobModel> jobs = await _getAllJobs();
    Map<String, String> currentDataSources = await _getCurrentDataSources();
    JobModel job = jobs[event.unitGroupName]!;

    DataSourceModel dataSource = ObjectUtils.tryGet(
      await dataSourceRepository.getSelected(event.unitGroupName),
    );

    final inputParamsForRefresh = InputDataRefreshForConversionModel(
      unitGroupName: event.unitGroupName,
      dataSource: dataSource,
    );

    final startedJobResult = await startJobUseCase.execute(
      JobModel<NetworkDataModel>.coalesce(
        job,
        jobFunc: () async {
          NetworkDataModel networkData = ObjectUtils.tryGet(
            await getDynamicDataForConversionUseCase.execute(
              inputParamsForRefresh,
            ),
          );
          return networkData;
        },
        onComplete: (networkData) {
          if (networkData == null) {
            return;
          }

          if (networkData.dynamicCoefficients != null) {
            conversionBloc.add(
              UpdateConversionCoefficients(
                updatedUnitCoefs: networkData.dynamicCoefficients!,
              ),
            );
          }

          if (networkData.dynamicValue != null) {
            conversionBloc.add(
              EditConversionItemValue(
                newValue: null,
                newDefaultValue: networkData.dynamicValue!.value,
                unitId: networkData.dynamicValue!.unitId,
              ),
            );
          }
        },
      ),
    );

    if (startedJobResult.isLeft) {
      navigationBloc.add(
        ShowException(
          exception: startedJobResult.left,
        ),
      );
    } else {
      if (startedJobResult.right.alreadyRunning) {
        navigationBloc.add(
          ShowException(
            exception: InternalException(
              message: "Job '${job.name}' is running at the moment",
              severity: ExceptionSeverity.info,
              stackTrace: null,
              dateTime: DateTime.now(),
            ),
          ),
        );
      } else {
        jobs.update(
          event.unitGroupName,
          (value) => startedJobResult.right,
        );
      }
    }

    emit(
      RefreshingJobsFetched(
        jobs: jobs,
        currentDataSources: currentDataSources,
      ),
    );
  }

  _onStopRefreshingJobForConversion(
    StopRefreshingJobForConversion event,
    Emitter<RefreshingJobsState> emit,
  ) async {
    Map<String, JobModel> jobs = await _getAllJobs();
    Map<String, String> currentDataSources = await _getCurrentDataSources();

    final stoppedJobResult = await stopJobUseCase.execute(
      jobs[event.unitGroupName]!,
    );

    if (stoppedJobResult.isLeft) {
      navigationBloc.add(
        ShowException(
          exception: stoppedJobResult.left,
        ),
      );
    } else {
      jobs.update(event.unitGroupName, (value) => stoppedJobResult.right);
    }

    emit(
      RefreshingJobsFetched(
        jobs: jobs,
        currentDataSources: currentDataSources,
      ),
    );
  }

  Future<Map<String, JobModel>> _getAllJobs() async {
    Map<String, JobModel> jobs = {};

    if (state is RefreshingJobsFetched) {
      jobs = (state as RefreshingJobsFetched).jobs;
    }

    if (jobs.isEmpty) {
      log("Jobs map first initialization");
      jobs = ObjectUtils.tryGet(await jobRepository.getAll());
    }

    return jobs;
  }

  Future<Map<String, String>> _getCurrentDataSources() async {
    Map<String, String> currentDataSources = {};

    if (state is RefreshingJobsFetched) {
      currentDataSources = (state as RefreshingJobsFetched).currentDataSources;
    }

    if (currentDataSources.isEmpty) {
      log("Data sources map first initialization");
      currentDataSources =
          ObjectUtils.tryGet(await dataSourceRepository.getAllSelected());
    }

    return currentDataSources;
  }

  @override
  RefreshingJobsState? fromJson(Map<String, dynamic> json) {
    return RefreshingJobsFetched.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(RefreshingJobsState state) {
    if (state is RefreshingJobsFetched) {
      return state.toJson();
    }
    return const {};
  }
}
