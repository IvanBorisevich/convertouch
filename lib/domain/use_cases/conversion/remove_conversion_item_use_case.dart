import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_item_removal_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_conversion_model.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class RemoveConversionItemUseCase
    extends UseCase<InputConversionItemRemovalModel, OutputConversionModel> {
  @override
  Future<Either<ConvertouchException, OutputConversionModel>> execute(
    InputConversionItemRemovalModel input,
  ) async {
    try {
      List<ConversionItemModel> conversionItems =
          input.conversion.targetConversionItems;
      conversionItems.removeWhere((item) => input.id == item.unit.id);

      ConversionItemModel? sourceConversionItem =
          input.conversion.sourceConversionItem;
      if (sourceConversionItem?.unit.id == input.id) {
        sourceConversionItem = conversionItems.firstOrNull;
      }

      return Right(
        OutputConversionModel(
          unitGroup: input.conversion.unitGroup,
          sourceConversionItem: sourceConversionItem,
          targetConversionItems: conversionItems,
          emptyConversionItemsExist: input.conversion.emptyConversionItemsExist,
        ),
      );
    } catch (e) {
      return Left(
        InternalException(
          message: "Error when modifying input conversion params",
          stackTrace: null,
          dateTime: DateTime.now(),
        ),
      );
    }
  }
}
