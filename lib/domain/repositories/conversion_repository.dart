import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/failure.dart';
import 'package:either_dart/either.dart';

abstract class ConversionRepository {
  const ConversionRepository();

  Future<Either<Failure, ConversionModel>> fetchLastConversion();

  Future<Either<Failure, void>> saveConversion(ConversionModel conversion);
}