import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:either_dart/either.dart';

abstract class ConversionRepository {
  const ConversionRepository();

  Future<Either<ConvertouchException, ConversionModel>> get(int unitGroupId);

  Future<Either<ConvertouchException, void>> remove(List<int> unitGroupIds);

  Future<Either<ConvertouchException, ConversionModel>> upsert(
    ConversionModel conversion,
  );
}
