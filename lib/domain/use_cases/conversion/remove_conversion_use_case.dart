import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_removal_model.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class RemoveConversionUseCase
    extends UseCase<InputConversionRemovalModel, void> {
  const RemoveConversionUseCase();

  @override
  Future<Either<ConvertouchException, void>> execute(
    InputConversionRemovalModel input,
  ) async {
    try {
      return const Right(null);
    } catch (e, stackTrace) {
      return Left(
        InternalException(
          message: "Error when removing a conversion",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }
}
