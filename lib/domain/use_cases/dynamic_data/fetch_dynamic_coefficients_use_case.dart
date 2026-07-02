import 'package:convertouch/domain/model/dynamic_data_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_dynamic_data_fetch_model.dart';
import 'package:convertouch/domain/repositories/network_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class FetchDynamicCoefficientsUseCase extends UseCase<
    InputDynamicCoefficientsFetchModel, DynamicCoefficientsModel?> {
  final NetworkRepository networkRepository;

  const FetchDynamicCoefficientsUseCase({
    required this.networkRepository,
  });

  @override
  Future<Either<ConvertouchException, DynamicCoefficientsModel?>> execute(
    InputDynamicCoefficientsFetchModel input,
  ) async {
    return await networkRepository.fetchCoefficients(
      conversionGroupName: input.groupName,
      params: input.params,
    );
  }
}
