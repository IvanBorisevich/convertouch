import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/repositories/conversion_param_repository.dart';
import 'package:either_dart/src/either.dart';

import '../../model/mock/mock_param.dart';

final _paramsOfSet = {
  clothesSizeParamSet.id: [
    personParam,
    garmentParam,
    heightParam,
  ],
  ringSizeByDiameterParamSet.id: [
    diameterParam,
  ],
  ringSizeByCircumferenceParamSet.id: [
    circumferenceParam,
  ],
  barbellWeightParamSet.id: [
    barWeightParam,
    oneSideWeightParam,
  ]
};

class MockConversionParamRepository extends ConversionParamRepository {
  const MockConversionParamRepository();

  @override
  Future<Either<ConvertouchException, List<ConversionParamModel>>> getBySetId(
    int setId,
  ) async {
    return Right(_paramsOfSet[setId] ?? []);
  }

  @override
  Future<Either<ConvertouchException, ConversionParamModel?>> get(
      int paramId) async {
    return Right(
      _paramsOfSet.values
          .expand((e) => e)
          .firstWhereOrNull((p) => p.id == paramId),
    );
  }
}
