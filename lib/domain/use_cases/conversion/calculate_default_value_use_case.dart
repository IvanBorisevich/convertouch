import 'dart:developer';

import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/repositories/dynamic_value_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

class CalculateDefaultValueUseCase extends UseCase<UnitModel, ValueModel?> {
  final DynamicValueRepository dynamicValueRepository;

  const CalculateDefaultValueUseCase({
    required this.dynamicValueRepository,
  });

  @override
  Future<Either<ConvertouchException, ValueModel?>> execute(
    UnitModel input,
  ) async {
    try {
      var dynamicValue = ObjectUtils.tryGet(
        await dynamicValueRepository.get(input.id),
      );

      String? srcDefaultValueStr = dynamicValue != null
          ? dynamicValue.value
          : input.valueType.defaultValueStr;

      return Right(ValueModel.any(srcDefaultValueStr));
    } catch (e, stackTrace) {
      log("Error when calculating a source default value: $e");
      return Left(
        InternalException(
          message: "Error when calculating a source default value "
              "for the unit ${input.name}",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }
}
