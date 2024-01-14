import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/output/refreshing_jobs_states.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/domain/usecases/refresh_data/refresh_unit_coefficients_use_case.dart';
import 'package:convertouch/domain/usecases/refresh_data/refresh_unit_values_use_case.dart';
import 'package:convertouch/domain/usecases/use_case.dart';
import 'package:either_dart/either.dart';

class RefreshDataUseCase
    extends ReactiveUseCase<RefreshingJobModel, RefreshingJobsProgressUpdated> {
  final RefreshUnitCoefficientsUseCase refreshUnitCoefficientsUseCase;
  final RefreshUnitValuesUseCase refreshUnitValuesUseCase;

  const RefreshDataUseCase({
    required this.refreshUnitCoefficientsUseCase,
    required this.refreshUnitValuesUseCase,
  });

  @override
  Either<Failure, Stream<RefreshingJobsProgressUpdated>> execute(RefreshingJobModel input) {
    switch (input.refreshableDataPart) {
      case RefreshableDataPart.coefficient:
        return refreshUnitCoefficientsUseCase.execute(input);
      case RefreshableDataPart.value:
        return refreshUnitValuesUseCase.execute(input);
    }
  }
}
