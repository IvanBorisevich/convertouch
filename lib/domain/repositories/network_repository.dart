import 'package:convertouch/domain/model/data_source_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/network_data_model.dart';
import 'package:either_dart/either.dart';

abstract class NetworkRepository {
  const NetworkRepository();

  Future<Either<ConvertouchException, NetworkDataModel>> getRefreshedData({
    required String unitGroupName,
    required DataSourceModel dataSource,
  });
}
