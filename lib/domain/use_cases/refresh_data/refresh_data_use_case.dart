import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_job_result_model.dart';
import 'package:convertouch/domain/use_cases/refresh_data/refresh_unit_coefficients_use_case.dart';
import 'package:convertouch/domain/use_cases/refresh_data/refresh_unit_values_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class RefreshDataUseCase
    extends ReactiveUseCase<RefreshingJobModel, OutputJobResultModel> {
  final RefreshUnitCoefficientsUseCase refreshUnitCoefficientsUseCase;
  final RefreshUnitValuesUseCase refreshUnitValuesUseCase;

  const RefreshDataUseCase({
    required this.refreshUnitCoefficientsUseCase,
    required this.refreshUnitValuesUseCase,
  });

  @override
  Either<Failure, Stream<OutputJobResultModel>> execute(
    RefreshingJobModel input,
  ) {
    switch (input.refreshableDataPart) {
      case RefreshableDataPart.coefficient:
        return refreshUnitCoefficientsUseCase.execute(input);
      case RefreshableDataPart.value:
        return refreshUnitValuesUseCase.execute(input);
    }
  }
}
