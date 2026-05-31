import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/conversion_param_set_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/repositories/conversion_param_set_repository.dart';
import 'package:either_dart/src/either.dart';

import '../../model/mock/mock_param.dart';
import '../../model/mock/mock_unit_group.dart';

final _groupParamSets = {
  clothesSizeGroup.id: [
    clothesSizeParamSet,
  ],
  ringSizeGroup.id: [
    ringSizeByDiameterParamSet,
    ringSizeByCircumferenceParamSet,
  ],
  massGroup.id: [
    barbellWeightParamSet,
  ],
  currencyGroup.id: [
    exchangeRateParamSet,
  ]
};

final _mockParamSetsList = _groupParamSets.values.flattenedToList;

final _groupMandatoryParamSets = {
  clothesSizeGroup.id: clothesSizeParamSet,
  currencyGroup.id: exchangeRateParamSet,
};

class MockConversionParamSetRepository extends ConversionParamSetRepository {
  const MockConversionParamSetRepository();

  @override
  Future<Either<ConvertouchException, List<ConversionParamSetModel>>> getByIds({
    required List<int> ids,
  }) async {
    Map<int, ConversionParamSetModel> mockParamSetsMap = {
      for (var paramSet in _mockParamSetsList) paramSet.id: paramSet
    };

    return Right(
      ids.map((id) => mockParamSetsMap[id]!).toList(),
    );
  }

  @override
  Future<Either<ConvertouchException, int>> getCount(int groupId) async {
    return Right(_groupParamSets[groupId]?.length ?? 0);
  }

  @override
  Future<Either<ConvertouchException, ConversionParamSetModel?>> getMandatory(
    int groupId,
  ) async {
    return Right(_groupMandatoryParamSets[groupId]);
  }

  @override
  Future<Either<ConvertouchException, List<ConversionParamSetModel>>> search({
    required int groupId,
    String? searchString,
    required int pageNum,
    required int pageSize,
  }) async {
    return Right(_mockParamSetsList);
  }
}
