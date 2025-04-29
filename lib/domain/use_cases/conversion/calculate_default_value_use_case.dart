import 'dart:developer';

import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/repositories/dynamic_value_repository.dart';
import 'package:convertouch/domain/repositories/list_value_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

class CalculateDefaultValueUseCase extends UseCase<UnitModel, String?> {
  final DynamicValueRepository dynamicValueRepository;
  final ListValueRepository listValueRepository;

  const CalculateDefaultValueUseCase({
    required this.dynamicValueRepository,
    required this.listValueRepository,
  });

  @override
  Future<Either<ConvertouchException, String?>> execute(UnitModel input) async {
    try {
      String? srcDefaultValueStr;

      var dynamicValue = ObjectUtils.tryGet(
        await dynamicValueRepository.get(input.id),
      );

      if (dynamicValue != null) {
        srcDefaultValueStr = dynamicValue.value;
      }

      if (srcDefaultValueStr == null) {
        if (input.listType != null) {
          srcDefaultValueStr = ObjectUtils.tryGet(
            await listValueRepository.getDefault(listType: input.listType!),
          )?.itemName;
        } else {
          srcDefaultValueStr = input.valueType.defaultValueStr;
        }
      }

      return Right(srcDefaultValueStr);
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
