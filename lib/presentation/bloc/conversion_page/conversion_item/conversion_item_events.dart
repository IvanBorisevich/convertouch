import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';

abstract class ConversionItemEvent extends ConvertouchEvent {
  const ConversionItemEvent();
}

class UpdateItemValue extends ConversionItemEvent {
  final String id;
  final ItemValueModel newValue;
  final bool isSource;

  const UpdateItemValue({
    required this.id,
    required this.newValue,
    this.isSource = false,
  });

  @override
  List<Object?> get props => [
    id,
    newValue,
    isSource,
  ];

  @override
  String toString() {
    return 'UpdateItemValue{id: $id, newValue: $newValue}';
  }
}

class ResetItemValues extends ConversionItemEvent {
  const ResetItemValues();

  @override
  String toString() {
    return 'ResetItemValues{}';
  }
}