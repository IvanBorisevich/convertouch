import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_conversion_model.dart';
import 'package:convertouch/domain/repositories/conversion_repository.dart';
import 'package:convertouch/domain/use_cases/conversion/build_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class GetLastSavedConversionUseCase
    extends UseCaseNoInput<OutputConversionModel> {
  final ConversionRepository conversionRepository;
  final BuildConversionUseCase buildConversionUseCase;

  const GetLastSavedConversionUseCase({
    required this.conversionRepository,
    required this.buildConversionUseCase,
  });

  @override
  Future<Either<ConvertouchException, OutputConversionModel>> execute() async {
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
        InternalException(
          message: "Error when restoring the last conversion: $e",
        ),
      );
    }
  }
}