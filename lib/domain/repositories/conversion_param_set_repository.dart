import 'package:convertouch/domain/model/conversion_param_set_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:either_dart/either.dart';

abstract class ConversionParamSetRepository {
  const ConversionParamSetRepository();

  Future<Either<ConvertouchException, List<ConversionParamSetModel>>> search({
    required int groupId,
    String? searchString,
    required int pageNum,
    required int pageSize,
  });

  Future<Either<ConvertouchException, List<ConversionParamSetModel>>> getByIds({
    required List<int> ids,
  });

  Future<Either<ConvertouchException, ConversionParamSetModel?>> getMandatory(
    int groupId,
  );

  Future<Either<ConvertouchException, int>> getCount(int groupId);
}
