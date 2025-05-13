import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/repositories/list_value_repository.dart';
import 'package:either_dart/either.dart';

class ListValueRepositoryImpl implements ListValueRepository {
  const ListValueRepositoryImpl();

  @override
  Future<Either<ConvertouchException, List<ListValueModel>>> search({
    required ConvertouchListType listType,
    String? searchString,
    int pageNum = 0,
    int pageSize = 100,
    double? coefficient,
  }) async {
    List<ListValueModel>? result = listableSets[listType]
        ?.call(c: coefficient)
        .map((e) => ListValueModel(e))
        .toList();

    return Right(result ?? []);
  }

  @override
  Future<Either<ConvertouchException, ListValueModel?>> getDefault({
    required ConvertouchListType listType,
    double? coefficient,
  }) async {
    String? rawValue = listType.preselected
        ? listableSets[listType]?.call(c: coefficient).firstOrNull
        : null;
    return rawValue != null
        ? Right(ListValueModel(rawValue))
        : const Right(null);
  }

  @override
  Future<Either<ConvertouchException, bool>> belongsToList({
    required String? value,
    required ConvertouchListType listType,
    double? coefficient,
  }) async {
    if (value == null) {
      return const Right(true);
    }
    return Right(
        listableSets[listType]?.call(c: coefficient).contains(value) ?? false);
  }
}
