import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

typedef ItemValueFuture<M extends ItemValueModel>
    = Future<Either<ConvertouchException, M>>;

abstract class OutputItemValueCalculationModel<M extends ItemValueModel> {
  final M itemValue;
  final ItemValueFuture<M>? itemValueFuture;

  const OutputItemValueCalculationModel({
    required this.itemValue,
    this.itemValueFuture,
  });

  Future<M> result({bool awaitFuture = true}) async =>
      itemValueFuture != null && awaitFuture
          ? ObjectUtils.tryGet(await itemValueFuture!)
          : itemValue;
}

class OutputUnitValueCalculationModel
    extends OutputItemValueCalculationModel<ConversionUnitValueModel> {
  const OutputUnitValueCalculationModel({
    required super.itemValue,
    super.itemValueFuture,
  });
}

class OutputParamValueCalculationModel
    extends OutputItemValueCalculationModel<ConversionParamValueModel> {
  const OutputParamValueCalculationModel({
    required super.itemValue,
    super.itemValueFuture,
  });
}
