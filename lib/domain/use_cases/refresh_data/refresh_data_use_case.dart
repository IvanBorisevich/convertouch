import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/refreshable_value_model.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/repositories/network_data_repository.dart';
import 'package:convertouch/domain/repositories/refreshable_value_repository.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:convertouch/domain/utils/response_transformers/response_transformer.dart';
import 'package:either_dart/either.dart';

class RefreshDataUseCase<T> extends UseCase<RefreshingJobModel, List<T>> {
  final NetworkDataRepository networkDataRepository;
  final RefreshableValueRepository refreshableValueRepository;
  final UnitRepository unitRepository;

  const RefreshDataUseCase({
    required this.networkDataRepository,
    required this.refreshableValueRepository,
    required this.unitRepository,
  });

  @override
  Future<Either<Failure, List<T>>> execute(RefreshingJobModel input) async {
    try {
      if (input.selectedDataSource == null) {
        throw Exception("No data source found for the job id = ${input.id}");
      }

      int unitGroupId = input.unitGroup.id!;
      final response = ObjectUtils.tryGet(
          await networkDataRepository.fetch(input.selectedDataSource!.url));
      final String transformerName =
          input.selectedDataSource!.responseTransformerClassName;

      switch (input.refreshableDataPart) {
        case RefreshableDataPart.coefficient:
          final coefficients = await refreshUnitCoefficients(
            response,
            transformerName,
            unitGroupId,
          );
          return Right(coefficients as List<T>);
        case RefreshableDataPart.value:
          final values = await refreshUnitValues(
            response,
            transformerName,
            unitGroupId,
          );
          return Right(values as List<T>);
      }
    } catch (e, stacktrace) {
      return Left(
        InternalFailure("Error when refreshing data: $e,\n$stacktrace"),
      );
    }
  }

  Future<List<UnitModel>> refreshUnitCoefficients(
    String response,
    String transformerName,
    int unitGroupId,
  ) async {
    Map<String, double?> codeToCoefficient =
        ResponseTransformer.getInstance<UnitCoefficientsResponseTransformer>(
      transformerName,
    ).transform(response);

    return ObjectUtils.tryGet(
      await unitRepository.updateCoefficientsByCodes(
        unitGroupId,
        codeToCoefficient,
      ),
    );
  }

  Future<List<RefreshableValueModel>> refreshUnitValues(
    String response,
    String transformerName,
    int unitGroupId,
  ) async {
    Map<String, String?> codeToValue =
        ResponseTransformer.getInstance<UnitValuesResponseTransformer>(
      transformerName,
    ).transform(response);
    return ObjectUtils.tryGet(
      await refreshableValueRepository.updateValuesByCodes(
        unitGroupId,
        codeToValue,
      ),
    );
  }
}
