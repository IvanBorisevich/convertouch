import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/list_value_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:either_dart/either.dart';

abstract interface class ListValueRepository {
  const ListValueRepository();

  Future<Either<ConvertouchException, List<ListValueModel>>> fetch({
    required ConvertouchListType listType,
    String? searchString,
    required int pageNum,
    required int pageSize,
    UnitModel? unit,
    ConversionParamSetValueModel? params,
  });

  Future<Either<ConvertouchException, ListValueModel?>> getByStrValue({
    required ConvertouchListType listType,
    required String? value,
    UnitModel? unit,
  });

  Future<Either<ConvertouchException, ListValueModel?>> getDefault({
    required ConvertouchListType listType,
    UnitModel? unit,
  });

  Future<Either<ConvertouchException, bool>> belongsToList({
    required String? value,
    required ConvertouchListType listType,
    UnitModel? unit,
  });
}
