import 'package:convertouch/domain/use_cases/dynamic_data/fetch_dynamic_coefficients_use_case.dart';
import 'package:convertouch/domain/use_cases/dynamic_data/fetch_dynamic_value_use_use.dart';
import 'package:convertouch/domain/use_cases/jobs/start_job_use_case.dart';
import 'package:convertouch/domain/use_cases/jobs/stop_job_use_case.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_states.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../domain/repositories/mock/mock_dynamic_value_repository.dart';
import '../../../domain/repositories/mock/mock_network_repository.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  late Storage storage;

  const stopJobUseCase = StopJobUseCase();
  const startJobUseCase = StartJobUseCase();

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

    setUp(() {
      refreshingJobsBloc = initBloc();
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
  });
}
