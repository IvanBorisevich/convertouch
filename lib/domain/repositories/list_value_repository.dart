import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:either_dart/either.dart';

abstract interface class ListValueRepository {
  const ListValueRepository();

  Future<Either<ConvertouchException, List<ValueModel>>> fetch({
    required ConvertouchListType listType,
    required String? searchString,
    required int pageNum,
    required int pageSize,
    required UnitModel? unit,
    required ConversionParamSetValueModel? params,
  });

  Future<Either<ConvertouchException, bool>> belongsToList({
    required ValueModel? value,
    required ConvertouchListType listType,
    required UnitModel? unit,
    required ConversionParamSetValueModel? params,
  });
}
