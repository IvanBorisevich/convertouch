import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/output/abstract_state.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';

abstract class ConversionState extends ConvertouchState {
  const ConversionState();
}

class ConversionInBuilding extends ConversionState {
  const ConversionInBuilding();

  @override
  String toString() {
    return 'ConversionInBuilding{}';
  }
}

class ConversionBuilt extends ConversionState {
  final UnitGroupModel? unitGroup;
  final ConversionItemModel? sourceConversionItem;
  final List<ConversionItemModel> conversionItems;

  const ConversionBuilt({
    required this.unitGroup,
    required this.sourceConversionItem,
    this.conversionItems = const [],
  });

  @override
  List<Object?> get props => [
    unitGroup,
    sourceConversionItem,
    conversionItems,
  ];

  @override
  String toString() {
    return 'ConversionBuilt{'
        'unitGroup: $unitGroup, '
        'sourceConversionItem: $sourceConversionItem, '
        'conversionItems: $conversionItems}';
  }
}

class ConversionErrorState extends ConversionState {
  final String message;

  const ConversionErrorState({
    required this.message,
  });

  @override
  List<Object> get props => [
    message,
  ];

  @override
  String toString() {
    return 'ConversionErrorState{message: $message}';
  }
}