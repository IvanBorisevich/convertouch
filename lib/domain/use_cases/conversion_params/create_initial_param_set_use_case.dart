import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/repositories/conversion_param_repository.dart';
import 'package:convertouch/domain/repositories/conversion_param_set_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

class CreateInitialParamSetUseCase
    extends UseCase<int, ConversionParamSetValueModel?> {
  final ConversionParamSetRepository conversionParamSetRepository;
  final ConversionParamRepository conversionParamRepository;

  const CreateInitialParamSetUseCase({
    required this.conversionParamSetRepository,
    required this.conversionParamRepository,
  });

  @override
  Future<Either<ConvertouchException, ConversionParamSetValueModel?>> execute(
    int input,
  ) async {
    int conversionGroupId = input;

    try {
      // ConversionParamSetModel? paramSet = ObjectUtils.tryGet(
      //   await conversionParamSetRepository.getMandatory(conversionGroupId),
      // );
      //
      // if (paramSet == null) {
      //   return const Right(null);
      // }
      //
      // List<ConversionParamModel> params = ObjectUtils.tryGet(
      //   await conversionParamRepository.get(paramSet.id),
      // );
      //
      // List<ConversionParamValueModel> paramValues = params
      //     .map(
      //       (p) => ConversionParamValueModel(
      //         param: p,
      //       ),
      //     )
      //     .toList();
      //
      // var paramSetValues = ConversionParamSetValueModel(
      //   paramSet: paramSet,
      //   paramValues: paramValues,
      // );

      var paramSetValues = const ConversionParamSetValueModel(
        paramSet: ConversionParamSetModel(
          id: 1,
          name: "Clothing Size by Height",
          mandatory: true,
          groupId: 10,
        ),
        paramValues: [
          ConversionParamValueModel(
            param: ConversionParamModel(
              name: "Gender",
              unitGroupId: null,
              calculable: false,
              valueType: ConvertouchValueType.text,
              listType: ConvertouchListType.gender,
              paramSetId: 1,
            ),
            unit: null,
            calculated: false,
            value: ValueModel.empty,
            defaultValue: ValueModel.empty,
          ),
          ConversionParamValueModel(
            param: ConversionParamModel(
              name: "Garment",
              unitGroupId: null,
              calculable: false,
              valueType: ConvertouchValueType.text,
              listType: ConvertouchListType.garment,
              paramSetId: 1,
            ),
            unit: null,
            calculated: false,
            value: ValueModel.empty,
            defaultValue: ValueModel.empty,
          ),
          ConversionParamValueModel(
            param: ConversionParamModel(
              name: "Height",
              unitGroupId: 1,
              calculable: false,
              valueType:
              ConvertouchValueType.decimalPositive,
              listType: null,
              paramSetId: 1,
            ),
            unit: null,
            calculated: false,
            value: ValueModel.empty,
            defaultValue: ValueModel.empty,
          ),
        ],
      );

      return Right(paramSetValues);
    } catch (e, stackTrace) {
      return Left(
        InternalException(
          message: "Error when creating a conversion param set",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }
}
