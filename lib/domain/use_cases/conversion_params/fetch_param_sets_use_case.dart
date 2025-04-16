import 'package:convertouch/domain/model/conversion_param_set_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class FetchParamSetsUseCase
    extends UseCase<InputItemsFetchModel, List<ConversionParamSetModel>> {
  const FetchParamSetsUseCase();

  @override
  Future<Either<ConvertouchException, List<ConversionParamSetModel>>> execute(
    InputItemsFetchModel input,
  ) async {
    return const Right(
      [
        ConversionParamSetModel(
          id: 1,
          name: "Clothing Size 1",
          groupId: 10,
        ),
        ConversionParamSetModel(
          id: 1,
          name: "Clothing Size 2",
          groupId: 10,
        ),
      ]
    );
  }
}
