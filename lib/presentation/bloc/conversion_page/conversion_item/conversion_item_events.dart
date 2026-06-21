import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';

abstract class ConversionItemEvent<T extends ItemValueModel>
    extends ConvertouchEvent {
  const ConversionItemEvent();
}

abstract class ConversionUnitValueEvent
    extends ConversionItemEvent<ConversionUnitValueModel> {
  const ConversionUnitValueEvent();
}

abstract class ConversionParamValueEvent
    extends ConversionItemEvent<ConversionParamValueModel> {
  const ConversionParamValueEvent();
}

class UpdateUnitValue extends ConversionUnitValueEvent {
  final String id;
  final ConversionUnitValueModel newValue;
  final bool isSource;

  const UpdateUnitValue({
    required this.id,
    required this.newValue,
    required this.isSource,
  });

  @override
  List<Object?> get props => [
        id,
        newValue,
        isSource,
      ];

  @override
  String toString() {
    return 'UpdateUnitValue{'
        'id: $id, '
        'newValue: $newValue, '
        'isSource: $isSource}';
  }
}

class UpdateParamValue extends ConversionParamValueEvent {
  final String id;
  final ConversionParamValueModel newValue;

  const UpdateParamValue({
    required this.id,
    required this.newValue,
  });

  @override
  List<Object?> get props => [
        id,
        newValue,
      ];

  @override
  String toString() {
    return 'UpdateParamValue{'
        'id: $id, '
        'newValue: $newValue}';
  }
}

class ResetUnitValues extends ConversionUnitValueEvent {
  const ResetUnitValues();

  @override
  String toString() {
    return 'ResetUnitValues{}';
  }
}

class ResetParamValues extends ConversionParamValueEvent {
  const ResetParamValues();

  @override
  String toString() {
    return 'ResetParamValues{}';
  }
}
