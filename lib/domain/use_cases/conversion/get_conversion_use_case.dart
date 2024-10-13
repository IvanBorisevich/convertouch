import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_conversion_model.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class GetConversionUseCase
    extends UseCase<UnitGroupModel, OutputConversionModel> {
  const GetConversionUseCase();

  @override
  Future<Either<ConvertouchException, OutputConversionModel>> execute(
    UnitGroupModel input,
  ) async {
    try {
      return Right(
        OutputConversionModel.noItems(input),
      );
    } catch (e, stackTrace) {
      return Left(
        InternalException(
          message: "Error when getting the conversion from database",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }
}
