import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_value_model.dart';
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
  final UnitValueModel? sourceConversionItem;
  final List<UnitValueModel> conversionItems;
  final bool floatingButtonVisible;

  const ConversionBuilt({
    this.unitGroup,
    this.sourceConversionItem,
    this.conversionItems = const [],
    this.floatingButtonVisible = true,
  });

  @override
  List<Object?> get props => [
    unitGroup,
    sourceConversionItem,
    conversionItems,
    floatingButtonVisible,
  ];

  @override
  String toString() {
    return 'ConversionBuilt{'
        'unitGroup: $unitGroup, '
        'sourceConversionItem: $sourceConversionItem, '
        'conversionItems: $conversionItems, '
        'floatingButtonVisible: $floatingButtonVisible}';
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