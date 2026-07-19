import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

class ConversionItemState extends ConvertouchState {
  final String? id;
  final ItemValueModel? itemValue;
  final bool isSource;
  final bool isParamValueInitialState;
  final bool isUnitValueInitialState;

  const ConversionItemState({
    required this.id,
    required this.itemValue,
    this.isSource = false,
    this.isParamValueInitialState = true,
    this.isUnitValueInitialState = true,
  });

  @override
  List<Object?> get props => [
        id,
        itemValue,
        isSource,
        isParamValueInitialState,
        isUnitValueInitialState,
      ];

  @override
  String toString() {
    return 'ConversionItemState{'
        'id: $id, '
        'itemValue: $itemValue, '
        'isSource: $isSource, '
        'isParamValueInitialState: $isParamValueInitialState, '
        'isUnitValueInitialState: $isUnitValueInitialState}';
  }
}
