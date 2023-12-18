import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/output/conversion_states.dart';
import 'package:convertouch/domain/repositories/conversion_repository.dart';
import 'package:convertouch/domain/usecases/use_case.dart';
import 'package:either_dart/either.dart';

class SaveConversionUseCase extends UseCase<ConversionBuilt, void> {
  final ConversionRepository conversionRepository;

  const SaveConversionUseCase({
    required this.conversionRepository,
  });

  @override
  Future<Either<Failure, void>> execute(ConversionBuilt input) async {
    try {
      ConversionModel conversion = ConversionModel(
        sourceUnitId: input.sourceConversionItem?.unit.id,
        sourceValue: input.sourceConversionItem?.value.strValue,
        targetUnitIds:
            input.conversionItems.map((item) => item.unit.id!).toList(),
        conversionUnitGroupId: input.unitGroup?.id,
      );

      return await conversionRepository.saveConversion(conversion);
    } catch (e) {
      return Left(
        InternalFailure("Error when restoring the last conversion: $e"),
      );
    }
  }
}
