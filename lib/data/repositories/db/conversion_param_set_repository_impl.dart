import 'package:convertouch/data/dao/conversion_param_set_dao.dart';
import 'package:convertouch/data/translators/conversion_param_set_translator.dart';
import 'package:convertouch/domain/model/conversion_param_set_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/repositories/conversion_param_set_repository.dart';
import 'package:either_dart/either.dart';

class ConversionParamSetRepositoryImpl extends ConversionParamSetRepository {
  final ConversionParamSetDao conversionParamSetDao;

  const ConversionParamSetRepositoryImpl({
    required this.conversionParamSetDao,
  });

  @override
  Future<Either<ConvertouchException, List<ConversionParamSetModel>>> get(
    int groupId,
  ) async {
    try {
      final result = await conversionParamSetDao.get(groupId);

      return Right(
        result
            .map((entity) => ConversionParamSetTranslator.I.toModel(entity))
            .toList(),
      );
    } catch (e, stackTrace) {
      return Left(
        DatabaseException(
          message: "Error when fetching conversion param set by group id = "
              "$groupId",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<Either<ConvertouchException, ConversionParamSetModel?>> getMandatory(
    int groupId,
  ) async {
    try {
      final entity = await conversionParamSetDao.getFirstMandatory(groupId);

      if (entity == null) {
        return const Right(null);
      }

      return Right(ConversionParamSetTranslator.I.toModel(entity));
    } catch (e, stackTrace) {
      return Left(
        DatabaseException(
          message: "Error when fetching the first conversion param set",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<Either<ConvertouchException, bool>> checkIfOthersExist(
    int groupId,
  ) async {
    try {
      int? num = await conversionParamSetDao.getNumOfOptional(groupId);
      return num != null && num > 0 ? const Right(true) : const Right(false);
    } catch (e, stackTrace) {
      return Left(
        DatabaseException(
          message: "Error when checking for other param sets availability",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }
}
