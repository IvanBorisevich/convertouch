import 'package:convertouch/model/entity/unit_value_model.dart';
import 'package:convertouch/presenter/states/base_state.dart';

class ConvertedItemsState extends BlocState {
  const ConvertedItemsState({required this.convertedItems});

  final List<UnitValueModel> convertedItems;

  @override
  List<Object> get props => [
    convertedItems
  ];

  @override
  String toString() {
    return 'ConvertedItemsState{'
        'convertedItems: $convertedItems}';
  }
}