import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_removal_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_conversion_model.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class RemoveConversionUseCase
    extends UseCase<InputConversionRemovalModel, OutputConversionModel> {
  const RemoveConversionUseCase();

  @override
  Future<Either<ConvertouchException, OutputConversionModel>> execute(
    InputConversionRemovalModel input,
  ) async {
    try {
      if (input.removedGroupIds
          .contains(input.currentConversion.unitGroup?.id)) {
        return const Right(OutputConversionModel.none());
      }
      return Right(input.currentConversion);
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
