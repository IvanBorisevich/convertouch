import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/repositories/conversion_repository.dart';
import 'package:convertouch/domain/use_cases/conversion_params/create_initial_param_set_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

class GetConversionUseCase extends UseCase<UnitGroupModel, ConversionModel> {
  final ConversionRepository conversionRepository;
  final CreateInitialParamSetUseCase createInitialParamSetUseCase;

  const GetConversionUseCase({
    required this.conversionRepository,
    required this.createInitialParamSetUseCase,
  });

  @override
  Future<Either<ConvertouchException, ConversionModel>> execute(
    UnitGroupModel input,
  ) async {
    int unitGroupId = input.id;

    try {
      ConversionModel? conversion = ObjectUtils.tryGet(
        await conversionRepository.get(unitGroupId),
      );

      if (conversion == null) {
        final initialParams = ObjectUtils.tryGet(
          await createInitialParamSetUseCase.execute(unitGroupId),
        );

        return Right(
          ConversionModel.noItems(
            id: -1,
            unitGroup: input,
            params: initialParams != null
                ? ConversionParamSetValueBulkModel(
                    paramSetValues: [initialParams],
                  )
                : null,
          ),
        );
      }

      return Right(
        ConversionModel.coalesce(
          conversion,
          unitGroup: input,
        ),
      );
    } catch (e, stackTrace) {
      return Left(
        InternalException(
          message: "Error when getting a conversion from db",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }
}
