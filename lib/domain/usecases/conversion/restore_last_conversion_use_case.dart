import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/usecases/output/output_conversion_model.dart';
import 'package:convertouch/domain/repositories/conversion_repository.dart';
import 'package:convertouch/domain/usecases/conversion/build_conversion_use_case.dart';
import 'package:convertouch/domain/usecases/use_case.dart';
import 'package:either_dart/either.dart';

class RestoreLastConversionUseCase
    extends UseCaseNoInput<OutputConversionModel> {
  final ConversionRepository conversionRepository;
  final BuildConversionUseCase buildConversionUseCase;

  const RestoreLastConversionUseCase({
    required this.conversionRepository,
    required this.buildConversionUseCase,
  });

  @override
  Future<Either<Failure, OutputConversionModel>> execute() async {
    try {
      var lastConversionResult = await conversionRepository.getLastConversion();

      if (lastConversionResult.isLeft) {
        return Left(lastConversionResult.left);
      }

      if (lastConversionResult.right == null) {
        return const Right(
          OutputConversionModel(),
        );
      }

      return await buildConversionUseCase.execute(lastConversionResult.right!);
    } catch (e) {
      return Left(
        InternalFailure("Error when restoring the last conversion: $e"),
      );
    }
  }
}
