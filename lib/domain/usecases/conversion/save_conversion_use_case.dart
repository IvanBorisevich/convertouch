import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/usecases/input/input_conversion_model.dart';
import 'package:convertouch/domain/model/usecases/output/output_conversion_model.dart';
import 'package:convertouch/domain/repositories/conversion_repository.dart';
import 'package:convertouch/domain/usecases/use_case.dart';
import 'package:either_dart/either.dart';

class SaveConversionUseCase extends UseCase<OutputConversionModel, void> {
  final ConversionRepository conversionRepository;

  const SaveConversionUseCase({
    required this.conversionRepository,
  });

  @override
  Future<Either<Failure, void>> execute(OutputConversionModel input) async {
    try {
      InputConversionModel conversionToBeSaved = InputConversionModel(
        unitGroup: input.unitGroup,
        sourceConversionItem: input.sourceConversionItem,
        targetUnits:
            input.targetConversionItems.map((item) => item.unit).toList(),
      );

      return await conversionRepository.saveConversion(conversionToBeSaved);
    } catch (e) {
      return Left(
        InternalFailure("Error when saving the current conversion: $e"),
      );
    }
  }
}
