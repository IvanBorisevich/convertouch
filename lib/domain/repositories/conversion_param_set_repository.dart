import 'package:convertouch/domain/model/conversion_param_set_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:either_dart/either.dart';

abstract class ConversionParamSetRepository {
  const ConversionParamSetRepository();

  Future<Either<ConvertouchException, List<ConversionParamSetModel>>> get(
    int groupId,
  );

  Future<Either<ConvertouchException, ConversionParamSetModel?>> getMandatory(
    int groupId,
  );
}
