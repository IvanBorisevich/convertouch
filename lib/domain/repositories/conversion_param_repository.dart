import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:either_dart/either.dart';

abstract class ConversionParamRepository {
  const ConversionParamRepository();

  Future<Either<ConvertouchException, List<ConversionParamModel>>> get(
    int setId,
  );
}
