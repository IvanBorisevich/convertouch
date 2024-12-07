import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_single_value_conversion_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/repositories/dynamic_value_repository.dart';
import 'package:convertouch/domain/use_cases/conversion/convert_single_value_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

class CreateConversionUseCase
    extends UseCase<InputConversionModel, ConversionModel> {
  final ConvertSingleValueUseCase convertSingleValueUseCase;
  final DynamicValueRepository dynamicValueRepository;

  const CreateConversionUseCase({
    required this.convertSingleValueUseCase,
    required this.dynamicValueRepository,
  });

  @override
  Future<Either<ConvertouchException, ConversionModel>> execute(
    InputConversionModel input,
  ) async {
    try {
      if (input.targetUnits.isEmpty) {
        return Right(
          ConversionModel.noItems(
            id: input.conversionId ?? -1,
            unitGroup: input.unitGroup,
          ),
        );
      }

      ValueModel dynamicValue = ValueModel.ofString(
        ObjectUtils.tryGet(
          await dynamicValueRepository.get(input.sourceConversionItem.unit.id),
        ).value,
      );

      ConversionItemModel srcItem = ConversionItemModel.coalesce(
        input.sourceConversionItem,
        defaultValue: dynamicValue,
      );

      List<ConversionItemModel> convertedItems = [];

      for (UnitModel tgtUnit in input.targetUnits) {
        var item = ObjectUtils.tryGet(
          await convertSingleValueUseCase.execute(
            InputSingleValueConversionModel(
              unitGroup: input.unitGroup,
              srcItem: srcItem,
              tgtUnit: tgtUnit,
            ),
          ),
        );
        convertedItems.add(item);
      }

      return Right(
        ConversionModel(
          id: input.conversionId ?? -1,
          unitGroup: input.unitGroup,
          sourceConversionItem: srcItem,
          targetConversionItems: convertedItems,
        ),
      );
    } catch (e, stackTrace) {
      return Left(
        InternalException(
          message: "Error when creating a conversion "
              "of the group ${input.unitGroup.name} "
              "for the source value ${input.sourceConversionItem.value.str} "
              "and the source unit ${input.sourceConversionItem.unit.name}",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }
}
