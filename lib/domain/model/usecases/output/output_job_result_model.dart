import 'package:convertouch/domain/model/refreshable_value_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';

abstract class OutputJobResultModel {
  final Stream<double>? progress;

  const OutputJobResultModel({
    this.progress,
  });
}

class OutputUnitValueRefreshingResult extends OutputJobResultModel {
  final RefreshableValueModel? refreshableValue;

  const OutputUnitValueRefreshingResult({
    super.progress,
    this.refreshableValue,
  });
}

class OutputUnitCoefficientRefreshingResult extends OutputJobResultModel {
  final UnitModel? unitWithNewCoefficient;

  const OutputUnitCoefficientRefreshingResult({
    super.progress,
    this.unitWithNewCoefficient,
  });
}