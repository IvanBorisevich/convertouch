import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/repositories/preferences_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class SaveSettingsUseCase extends UseCase<Map<String, dynamic>, void> {
  final PreferencesRepository preferencesRepository;

  const SaveSettingsUseCase({
    required this.preferencesRepository,
  });

  @override
  Future<Either<ConvertouchException, void>> execute(
    Map<String, dynamic> input,
  ) async {
    return await preferencesRepository.saveMap(input);
  }
}
