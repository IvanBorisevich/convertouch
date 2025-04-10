import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_param_set_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_single_value_conversion_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/repositories/dynamic_value_repository.dart';
import 'package:convertouch/domain/use_cases/conversion/convert_single_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/create_conversion_param_set_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

class CreateConversionUseCase
    extends UseCase<InputConversionModel, ConversionModel> {
  final ConvertSingleValueUseCase convertSingleValueUseCase;
  final DynamicValueRepository dynamicValueRepository;
  final CreateConversionParamSetUseCase createConversionParamSetUseCase;

  const CreateConversionUseCase({
    required this.convertSingleValueUseCase,
    required this.dynamicValueRepository,
    required this.createConversionParamSetUseCase,
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

      ConversionUnitValueModel srcItem = await _initSrcUnitValue(
        input.sourceUnitValue,
      );

      ConversionParamSetValueModel? paramSetValue = ObjectUtils.tryGet(
        await createConversionParamSetUseCase.execute(
          InputParamSetValuesCreateModel(
            groupId: input.unitGroup.id,
          ),
        ),
      );

      List<ConversionUnitValueModel> convertedItems = [];

      for (UnitModel tgtUnit in input.targetUnits) {
        var item = ObjectUtils.tryGet(
          await convertSingleValueUseCase.execute(
            InputSingleValueConversionModel(
              unitGroup: input.unitGroup,
              srcItem: srcItem,
              tgtUnit: tgtUnit,
              paramSetValue: paramSetValue,
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
          conversionUnitValues: convertedItems,
          paramSetValue: paramSetValue,
        ),
      );
    } catch (e, stackTrace) {
      return Left(
        InternalException(
          message: "Error when creating a conversion "
              "of the group ${input.unitGroup.name} "
              "for the source value ${input.sourceUnitValue.value.raw} "
              "and the source unit ${input.sourceUnitValue.unit.name}",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }

  Future<ConversionUnitValueModel> _initSrcUnitValue(
    ConversionUnitValueModel srcItem,
  ) async {
    String? srcDefaultValueStr;

    var dynamicValue = ObjectUtils.tryGet(
      await dynamicValueRepository.get(srcItem.unit.id),
    );

    if (dynamicValue != null) {
      srcDefaultValueStr = dynamicValue.value;
    }

    srcDefaultValueStr ??= srcItem.unit.valueType.defaultValueStr;

    return ConversionUnitValueModel.coalesce(
      srcItem,
      defaultValue: ValueModel.str(
        srcDefaultValueStr ?? srcItem.defaultValue.raw,
      ),
    );
  }
}
