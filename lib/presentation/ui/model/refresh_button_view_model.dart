import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:equatable/equatable.dart';

class RefreshButtonViewModel extends Equatable {
  const RefreshButtonViewModel({
    required this.unitGroupName,
    this.params,
    this.srcUnit,
  });

  final String unitGroupName;
  final ConversionParamSetValueModel? params;
  final UnitModel? srcUnit;

  @override
  List<Object?> get props => [
        unitGroupName,
        params,
        srcUnit,
      ];
}
