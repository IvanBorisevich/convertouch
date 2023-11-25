import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_value_model.dart';
import 'package:convertouch/presentation/bloc/base_state.dart';

abstract class UnitsConversionState extends ConvertouchPageState {
  const UnitsConversionState({
    super.pageId = unitsConversionPageId,
    super.pageTitle = "Conversions",
    super.startPageIndex = 0,
    super.unitGroupInConversion,
    super.floatingButtonVisible = true,
    super.removalMode,
    super.selectedItemIdsForRemoval,
    super.theme,
  });
}

class UnitsConversionInitState extends UnitsConversionState {
  const UnitsConversionInitState();

  @override
  String toString() {
    return 'UnitsConversionInitState{${super.toString()}}';
  }
}

class ConversionInitializing extends UnitsConversionState {
  const ConversionInitializing();

  @override
  String toString() {
    return 'ConversionInitializing{}';
  }
}

class ConversionInitialized extends UnitsConversionState {
  final UnitValueModel? sourceConversionItem;
  final List<UnitValueModel> conversionItems;

  const ConversionInitialized({
    required this.sourceConversionItem,
    this.conversionItems = const [],
    required super.unitGroupInConversion,
  });

  @override
  List<Object?> get props => [
    sourceConversionItem,
    conversionItems,
    super.props,
  ];

  @override
  String toString() {
    return 'ConversionInitialized{'
        'sourceConversionItem: $sourceConversionItem, '
        'conversionItems: $conversionItems, '
        '${super.toString()}'
        '}';
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