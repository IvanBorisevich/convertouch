import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/network_data_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_data_refresh_model.dart';
import 'package:convertouch/domain/repositories/network_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class GetDynamicDataForConversionUseCase
    extends UseCase<InputDataRefreshForConversionModel, NetworkDataModel> {
  final NetworkRepository networkRepository;

  const GetDynamicDataForConversionUseCase({
    required this.networkRepository,
  });

  @override
  Future<Either<ConvertouchException, NetworkDataModel>> execute(
    InputDataRefreshForConversionModel input,
  ) async {
    return networkRepository.getRefreshedData(
        unitGroupName: input.unitGroupName,
        dataSource: input.dataSource,
    );
  }
}
