import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:either_dart/either.dart';

abstract interface class ListValueRepository {
  const ListValueRepository();

  Future<Either<ConvertouchException, List<ListValueModel>>> search({
    required ConvertouchListType listType,
    String? searchString,
    required int pageNum,
    required int pageSize,
    double? coefficient,
  });

  Future<Either<ConvertouchException, ListValueModel?>> getByStrValue({
    required ConvertouchListType listType,
    required String? value,
    double? coefficient,
  });

  Future<Either<ConvertouchException, ListValueModel?>> getDefault({
    required ConvertouchListType listType,
    double? coefficient,
  });

  Future<Either<ConvertouchException, bool>> belongsToList({
    required String? value,
    required ConvertouchListType listType,
    double? coefficient,
  });
}
