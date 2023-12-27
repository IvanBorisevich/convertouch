import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/refreshable_value_model.dart';
import 'package:either_dart/either.dart';

abstract class RefreshableValueRepository {
  const RefreshableValueRepository();

  Future<Either<Failure, RefreshableValueModel?>> get(int unitId);
}