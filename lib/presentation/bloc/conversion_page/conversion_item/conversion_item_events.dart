import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';

abstract class ConversionItemEvent extends ConvertouchEvent {
  const ConversionItemEvent();
}

abstract class UpdateItemValue extends ConversionItemEvent {
  const UpdateItemValue({
    required this.id,
    required this.newItemValue,
  });

  final String id;
  final ItemValueModel newItemValue;

  @override
  List<Object?> get props => [
        id,
        newItemValue,
      ];
}

class UpdateUnitValue extends UpdateItemValue {
  final bool isSource;

  const UpdateUnitValue({
    required super.id,
    required super.newItemValue,
    this.isSource = false,
  });

  @override
  List<Object?> get props => [
        super.props,
        isSource,
      ];

  @override
  String toString() {
    return 'UpdateUnitValue{'
        'id: $id, '
        'newItemValue: $newItemValue, '
        'isSource: $isSource}';
  }
}

class UpdateParamValue extends UpdateItemValue {
  const UpdateParamValue({
    required super.id,
    required super.newItemValue,
  });

  @override
  String toString() {
    return 'UpdateParamValue{'
        'id: $id, '
        'newItemValue: $newItemValue}';
  }
}

class ResetUnitValues extends ConversionItemEvent {
  const ResetUnitValues();

  @override
  String toString() {
    return 'ResetUnitValues{}';
  }
}

class ResetParamValues extends ConversionItemEvent {
  const ResetParamValues();

  @override
  String toString() {
    return 'ResetParamValues{}';
  }
}
