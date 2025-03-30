import 'package:convertouch/data/dao/conversion_param_dao.dart';
import 'package:convertouch/data/translators/conversion_param_translator.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/repositories/conversion_param_repository.dart';
import 'package:either_dart/either.dart';

abstract class ConversionParamRepositoryImpl extends ConversionParamRepository {
  final ConversionParamDao conversionParamDao;

  const ConversionParamRepositoryImpl({
    required this.conversionParamDao,
  });

  @override
  Future<Either<ConvertouchException, List<ConversionParamModel>>> get(
    int setId,
  ) async {
    try {
      final result = await conversionParamDao.get(setId);

      return Right(
        result
            .map((entity) => ConversionParamTranslator.I.toModel(entity))
            .toList(),
      );
    } catch (e, stackTrace) {
      return Left(
        DatabaseException(
          message: "Error when fetching conversion params by set id = "
              "$setId",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }
}
