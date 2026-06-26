import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

abstract class ConversionItemState<T extends ItemValueModel>
    extends ConvertouchState {
  final String? id;
  final T? value;

  const ConversionItemState({
    required this.id,
    required this.value,
  });

  @override
  List<Object?> get props => [
        id,
        value,
      ];
}

abstract class ConversionUnitValueState
    extends ConversionItemState<ConversionUnitValueModel> {
  final bool isSource;

  const ConversionUnitValueState({
    required super.id,
    required super.value,
    required this.isSource,
  });

  @override
  List<Object?> get props => [
        isSource,
        super.props,
      ];
}

class ConversionUnitValueInitialState extends ConversionUnitValueState {
  const ConversionUnitValueInitialState()
      : super(
          id: null,
          value: null,
          isSource: false,
        );

  @override
  String toString() {
    return 'ConversionUnitValueInitialState{}';
  }
}

class ConversionUnitValueUpdating extends ConversionUnitValueState {
  const ConversionUnitValueUpdating({
    required super.id,
    required super.value,
    required super.isSource,
  });

  @override
  String toString() {
    return 'ConversionUnitValueUpdating{'
        'id: $id, '
        'newValue: $value, '
        'isSource: $isSource}';
  }
}

class ConversionUnitValueUpdated extends ConversionUnitValueState {
  const ConversionUnitValueUpdated({
    required super.id,
    required super.value,
    required super.isSource,
  });

  @override
  String toString() {
    return 'ConversionUnitValueUpdated{'
        'id: $id, '
        'newValue: $value, '
        'isSource: $isSource}';
  }
}

abstract class ConversionParamValueState
    extends ConversionItemState<ConversionParamValueModel> {
  const ConversionParamValueState({
    required super.id,
    required super.value,
  });

  @override
  String toString() {
    return 'ConversionParamValueState{'
        'id: $id, '
        'newValue: $value}';
  }
}

class ConversionParamValueInitialState extends ConversionParamValueState {
  const ConversionParamValueInitialState()
      : super(
          id: null,
          value: null,
        );

  @override
  String toString() {
    return 'ConversionParamValueInitialState{}';
  }
}

class ConversionParamValueUpdating extends ConversionParamValueState {
  const ConversionParamValueUpdating({
    required super.id,
    required super.value,
  });

  @override
  String toString() {
    return 'ConversionParamValueUpdating{'
        'id: $id, '
        'newValue: $value}';
  }
}

class ConversionParamValueUpdated extends ConversionParamValueState {
  const ConversionParamValueUpdated({
    required super.id,
    required super.value,
  });

  @override
  String toString() {
    return 'ConversionParamValueUpdated{'
        'id: $id, '
        'newValue: $value}';
  }
}
