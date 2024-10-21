import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/repositories/conversion_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class SaveConversionUseCase extends UseCase<ConversionModel, void> {
  final ConversionRepository conversionRepository;

  const SaveConversionUseCase({
    required this.conversionRepository,
  });

  @override
  Future<Either<ConvertouchException, void>> execute(
    ConversionModel input,
  ) async {
    return await conversionRepository.merge(input);
  }
}
