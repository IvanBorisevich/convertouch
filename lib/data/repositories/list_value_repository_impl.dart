import 'dart:math';

import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/list_value_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/repositories/list_value_repository.dart';
import 'package:convertouch/domain/repositories/network_repository.dart';
import 'package:convertouch/domain/utils/list_values_utils.dart';
import 'package:either_dart/either.dart';

class ListValueRepositoryImpl implements ListValueRepository {
  final NetworkRepository networkRepository;

  const ListValueRepositoryImpl({
    required this.networkRepository,
  });

  @override
  Future<Either<ConvertouchException, List<ListValueModel>>> fetch({
    required ConvertouchListType listType,
    String? searchString,
    required int pageNum,
    required int pageSize,
    UnitModel? unit,
    ConversionParamSetValueModel? params,
  }) async {
    if (listType.fetchedViaApi && params != null) {
      return await _fetchFromNetwork(
        listType: listType,
        pageNum: pageNum,
        pageSize: pageSize,
        params: params,
      );
    }

    return Right(
      _fetchLocal(
        listType: listType,
        pageNum: pageNum,
        pageSize: pageSize,
        unit: unit,
        params: params,
      ),
    );
  }

  @override
  Future<Either<ConvertouchException, bool>> belongsToList({
    required ValueModel? value,
    required ConvertouchListType listType,
    UnitModel? unit,
    ConversionParamSetValueModel? params,
  }) async {
    if (value == null) {
      return const Right(true);
    }

    bool belongs;

    if (listType.fetchedViaApi) {
      belongs = false;
    } else {
      List<ListValueModel> localListValues =
          listValuesFuncSets[listType]?.buildListValues(
                unit: unit,
                params: params,
              ) ??
              [];

      belongs = localListValues.any((v) => v.value == value.raw);
    }

    return Right(belongs);
  }

  List<ListValueModel> _fetchLocal({
    required ConvertouchListType listType,
    required int pageNum,
    required int pageSize,
    UnitModel? unit,
    ConversionParamSetValueModel? params,
  }) {
    List<ListValueModel>? localListValues =
        listValuesFuncSets[listType]?.buildListValues(
      unit: unit,
      params: params,
    );

    if (localListValues == null) {
      return const [];
    }

    int end = min((pageNum + 1) * pageSize, localListValues.length);
    return localListValues.sublist(pageNum * pageSize, end);
  }

  Future<Either<ConvertouchException, List<ListValueModel>>> _fetchFromNetwork({
    required ConvertouchListType listType,
    required int pageNum,
    required int pageSize,
    required ConversionParamSetValueModel params,
  }) async {
    return await networkRepository.fetchList(
      listType: listType,
      params: params,
      pageSize: pageSize,
      pageNum: pageNum,
    );
  }
}
