import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/repositories/preferences_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class GetSettingsUseCase extends UseCase<List<String>, Map<String, dynamic>> {
  final PreferencesRepository preferencesRepository;

  const GetSettingsUseCase({
    required this.preferencesRepository,
  });

  @override
  Future<Either<ConvertouchException, Map<String, dynamic>>> execute(
    List<String> input,
  ) async {
    return await preferencesRepository.getMap(input);
  }
}
