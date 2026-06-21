import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

abstract class ConversionItemState extends ConvertouchState {
  final String? id;
  final ItemValueModel? value;
  final bool isSource;

  const ConversionItemState({
    required this.id,
    required this.value,
    required this.isSource,
  });

  @override
  List<Object?> get props => [
        id,
        value,
        isSource,
      ];
}

class ConversionItemInitialState extends ConversionItemState {
  const ConversionItemInitialState()
      : super(
          id: null,
          value: null,
          isSource: false,
        );

  @override
  String toString() {
    return 'ConversionItemInitialState{}';
  }
}

class ConversionItemUpdating extends ConversionItemState {
  const ConversionItemUpdating({
    required super.id,
    required super.value,
    required super.isSource,
  });

  @override
  String toString() {
    return 'ConversionItemUpdating{currentValue: $value, isSource: $isSource}';
  }
}

class ConversionItemUpdated extends ConversionItemState {
  const ConversionItemUpdated({
    required super.id,
    required super.value,
    required super.isSource,
  });

  @override
  String toString() {
    return 'ConversionItemUpdated{newValue: $value, isSource: $isSource}';
  }
}
