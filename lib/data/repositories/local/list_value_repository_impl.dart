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
  }) async {
    List<ListValueModel>? result =
        listableSets[listType]?.map((e) => ListValueModel(e)).toList();

    return Right(result ?? []);
  }

  @override
  Future<Either<ConvertouchException, ListValueModel?>> getDefault({
    required ConvertouchListType listType,
  }) async {
    String? rawValue = listableSets[listType]?.firstOrNull;
    return rawValue != null
        ? Right(ListValueModel(rawValue))
        : const Right(null);
  }

  @override
  Future<Either<ConvertouchException, bool>> belongsToList({
    required String? value,
    required ConvertouchListType listType,
  }) async {
    if (value == null) {
      return const Right(true);
    }
    return Right(listableSets[listType]?.contains(value) ?? false);
  }
}
