import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/repositories/list_value_repository.dart';
import 'package:either_dart/either.dart';

class ListValueRepositoryImpl implements ListValueRepository {
  const ListValueRepositoryImpl();

  @override
  Future<Either<ConvertouchException, List<ListValueModel>>> get({
    required ConvertouchListType listType,
    String? searchString,
    int pageNum = 0,
    int pageSize = 100,
  }) async {
    List<ListValueModel>? result =
        listableSets[listType]?.map((e) => ListValueModel(e)).toList();

    return Right(result ?? []);
  }
}
