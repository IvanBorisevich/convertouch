import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:either_dart/either.dart';

abstract class ConversionRepository {
  const ConversionRepository();

  Future<Either<ConvertouchException, InputConversionModel?>> getLastConversion();

  Future<Either<ConvertouchException, void>> saveConversion(InputConversionModel conversion);
}
