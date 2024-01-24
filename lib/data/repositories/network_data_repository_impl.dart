import 'package:convertouch/data/dao/network_dao.dart';
import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/repositories/network_data_repository.dart';
import 'package:either_dart/either.dart';

class NetworkDataRepositoryImpl extends NetworkDataRepository {
  final NetworkDao networkDao;

  const NetworkDataRepositoryImpl(this.networkDao);

  @override
  Future<Either<Failure, String>> fetch(String url) async {
    try {
      return Right(
        await networkDao.fetch(url),
      );
    } catch (e) {
      return Left(
        DatabaseFailure("Error when fetching data from network: $e"),
      );
    }
  }
}
