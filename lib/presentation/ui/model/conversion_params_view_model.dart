import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:equatable/equatable.dart';

class ConversionParamsViewModel extends Equatable {
  final ConversionParamSetValueModel? selected;
  final int selectedIndex;
  final List<String> paramSetsNames;
  final bool removalIconVisible;
  final UnitGroupModel unitGroup;

  const ConversionParamsViewModel({
    this.selected,
    this.selectedIndex = -1,
    this.paramSetsNames = const [],
    this.removalIconVisible = false,
    required this.unitGroup,
  });

  @override
  List<Object?> get props => [
        selected,
        selectedIndex,
        paramSetsNames,
        removalIconVisible,
        unitGroup,
      ];
}
