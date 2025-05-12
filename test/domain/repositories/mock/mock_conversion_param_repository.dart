import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/repositories/conversion_param_repository.dart';
import 'package:either_dart/src/either.dart';

import '../../model/mock/mock_param.dart';

final _paramsOfSet = {
  clothingSizeParamSet.id: [
    genderParam,
    garmentParam,
    heightParam,
  ],
  ringSizeByDiameterParamSet.id: [
    diameterParam,
  ],
  ringSizeByCircumferenceParamSet.id: [
    circumferenceParam,
  ],
};

class MockConversionParamRepository extends ConversionParamRepository {
  const MockConversionParamRepository();

  @override
  Future<Either<ConvertouchException, List<ConversionParamModel>>> get(
    int setId,
  ) async {
    return Right(_paramsOfSet[setId] ?? []);
  }
}
