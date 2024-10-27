import 'package:convertouch/domain/model/data_source_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_data_source_model.dart';
import 'package:convertouch/domain/repositories/data_source_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class GetDataSourceUseCase
    extends UseCase<InputDataSourceModel, DataSourceModel> {
  final DataSourceRepository dataSourceRepository;

  const GetDataSourceUseCase({
    required this.dataSourceRepository,
  });

  @override
  Future<Either<ConvertouchException, DataSourceModel>> execute(
    InputDataSourceModel input,
  ) {
    return dataSourceRepository.get(
      unitGroupName: input.unitGroupName,
      dataSourceName: input.dataSourceKey,
    );
  }
}
