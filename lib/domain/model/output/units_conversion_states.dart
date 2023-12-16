import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:equatable/equatable.dart';

abstract class UnitsConversionState extends Equatable {
  const UnitsConversionState();

  @override
  List<Object?> get props => [];
}

class ConversionInBuilding extends UnitsConversionState {
  const ConversionInBuilding();

  @override
  String toString() {
    return 'ConversionInBuilding{}';
  }
}

class ConversionBuilt extends UnitsConversionState {
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

class UnitsConversionErrorState extends UnitsConversionState {
  final String message;

  const UnitsConversionErrorState({
    required this.message,
  });

  @override
  List<Object> get props => [
    message,
  ];

  @override
  String toString() {
    return 'UnitsConversionErrorState{message: $message}';
  }
}