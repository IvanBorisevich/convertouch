import 'dart:convert';
import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/usecases/use_case.dart';
import 'package:either_dart/either.dart';

class ImportUnitsUseCase extends UseCase<String, void> {
  final UnitRepository unitRepository;

  const ImportUnitsUseCase(this.unitRepository);

  @override
  Future<Either<Failure, void>> execute(String input) async {
    try {
      return _parseJson(input)
          .then(
            (parsedJson) => unitRepository.importFromJson(parsedJson),
          )
          .then(
            (value) => const Right(null),
          );
    } catch (e) {
      return Left(
        InternalFailure("Error during importing units json file: $e"),
      );
    }
  }

  Future<Map<String, dynamic>> _parseJson(String content) async {
    return json.decode(content);
  }
}
