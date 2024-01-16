import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/usecases/input/input_conversion_model.dart';
import 'package:either_dart/either.dart';

abstract class ConversionRepository {
  const ConversionRepository();

  Future<Either<Failure, InputConversionModel?>> getLastConversion();

  Future<Either<Failure, void>> saveConversion(InputConversionModel conversion);
}
