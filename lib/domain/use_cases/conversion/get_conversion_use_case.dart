import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/repositories/conversion_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class GetConversionUseCase extends UseCase<UnitGroupModel, ConversionModel?> {
  final ConversionRepository conversionRepository;

  const GetConversionUseCase({
    required this.conversionRepository,
  });

  @override
  Future<Either<ConvertouchException, ConversionModel?>> execute(
    UnitGroupModel input,
  ) async {
    return await conversionRepository.get(input.id);
  }
}
