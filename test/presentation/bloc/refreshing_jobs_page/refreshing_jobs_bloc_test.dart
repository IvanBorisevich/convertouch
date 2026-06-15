import 'package:bloc_test/bloc_test.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/domain/model/job_result_model.dart';
import 'package:convertouch/domain/use_cases/dynamic_data/fetch_dynamic_coefficients_use_case.dart';
import 'package:convertouch/domain/use_cases/dynamic_data/fetch_dynamic_value_use_use.dart';
import 'package:convertouch/domain/use_cases/jobs/start_job_use_case.dart';
import 'package:convertouch/domain/use_cases/jobs/stop_job_use_case.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_events.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_states.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

import '../../../domain/repositories/mock/mock_dynamic_value_repository.dart';
import '../../../domain/repositories/mock/mock_network_repository.dart';

const _jobKey = "${GroupNames.currency}_${ParamSetNames.exchangeRate}";

class MockStorage extends Mock implements Storage {}

void main() {
  late Storage storage;

  const stopJobUseCase = StopJobUseCase();
  const startJobUseCase = StartJobUseCase(
    stopJobUseCase: stopJobUseCase,
  );

  const fetchDynamicCoefficientsUseCase = FetchDynamicCoefficientsUseCase(
    networkRepository: MockNetworkRepository(),
  );

  const fetchDynamicValueUseCase = FetchDynamicValueUseCase(
    dynamicValueRepository: MockDynamicValueRepository(),
  );

  RefreshingJobsBloc initBloc() {
    return RefreshingJobsBloc(
      startJobUseCase: startJobUseCase,
      stopJobUseCase: stopJobUseCase,
      fetchDynamicCoefficientsUseCase: fetchDynamicCoefficientsUseCase,
      fetchDynamicValueUseCase: fetchDynamicValueUseCase,
    );
  }

  setUpAll(() {
    storage = MockStorage();

    when(
      () => storage.write(any(), any<dynamic>()),
    ).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
  });

  group(RefreshingJobsBloc, () {
    late RefreshingJobsBloc refreshingJobsBloc;
    late BehaviorSubject<JobResultModel> jobStreamController;
    late DateTime completedAt;

    setUp(() {
      refreshingJobsBloc = initBloc();
      jobStreamController = BehaviorSubject();
      completedAt = DateTime.now();
    });

    tearDown(() async {
      await refreshingJobsBloc.close();
    });

    test('Initial state should be {jobs: {}}', () {
      expect(
        refreshingJobsBloc.state,
        equals(const RefreshingJobsFetched(jobs: {})),
      );
    });

    blocTest<RefreshingJobsBloc, RefreshingJobsFetched>(
      'Should emit state with initialized job stream controller '
      'on event ChangeJobInfo',
      build: () => refreshingJobsBloc,
      act: (bloc) => bloc.add(
        ChangeJobInfo(
          jobPatch: JobModel(
            progressController: jobStreamController,
          ),
          unitGroupName: GroupNames.currency,
          paramSetName: ParamSetNames.exchangeRate,
        ),
      ),
      expect: () => [
        RefreshingJobsFetched(
          jobs: {
            _jobKey: JobModel(
              cron: Cron.never,
              progressController: jobStreamController,
            )
          },
        ),
      ],
    );

    blocTest<RefreshingJobsBloc, RefreshingJobsFetched>(
      'Should emit state with initialized completedAt on event ChangeJobInfo',
      build: () => refreshingJobsBloc,
      seed: () => RefreshingJobsFetched(
        jobs: {
          _jobKey: JobModel(
            cron: Cron.never,
            progressController: jobStreamController,
          )
        },
      ),
      act: (bloc) => bloc.add(
        ChangeJobInfo(
          jobPatch: JobModel(
            progressController: null,
            completedAt: completedAt,
          ),
          unitGroupName: GroupNames.currency,
          paramSetName: ParamSetNames.exchangeRate,
        ),
      ),
      expect: () => [
        RefreshingJobsFetched(
          jobs: {
            _jobKey: JobModel(
              cron: Cron.never,
              completedAt: completedAt,
            )
          },
        ),
      ],
    );
  });
}
