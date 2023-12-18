import 'package:convertouch/data/dao/conversion_dao.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/repositories/conversion_repository.dart';
import 'package:either_dart/either.dart';

class ConversionRepositoryImpl extends ConversionRepository {
  final ConversionDao conversionDao;

  const ConversionRepositoryImpl(this.conversionDao);

  @override
  Future<Either<Failure, ConversionModel>> fetchLastConversion() async {
    try {
      ConversionModel conversionModel = await conversionDao.fetchConversion();
      return Right(conversionModel);
    } catch (e) {
      return Left(
        InternalFailure(
          "Error when fetching conversion properties: $e",
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> saveConversion(
    ConversionModel conversion,
  ) async {
    try {
      await conversionDao.saveConversion(conversion);
      return const Right(null);
    } catch (e) {
      return Left(
        InternalFailure("Error when saving conversion properties: $e"),
      );
    }
  }
}
