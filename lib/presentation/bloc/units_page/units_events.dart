import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';

abstract class UnitsEvent extends ConvertouchEvent {
  const UnitsEvent();
}

class FetchUnits extends UnitsEvent {
  final UnitGroupModel unitGroup;
  final String? searchString;
  final bool rebuildConversion;

  const FetchUnits({
    required this.unitGroup,
    required this.searchString,
    this.rebuildConversion = false,
  });

  @override
  List<Object?> get props => [
        unitGroup,
        searchString,
        rebuildConversion,
      ];

  @override
  String toString() {
    return 'FetchUnits{'
        'unitGroup: $unitGroup, '
        'searchString: $searchString, '
        'rebuildConversion: $rebuildConversion}';
  }
}

class FetchUnitsAfterUnitSaving extends FetchUnits {
  final UnitModel modifiedUnit;

  const FetchUnitsAfterUnitSaving({
    required super.unitGroup,
    required this.modifiedUnit,
    super.rebuildConversion,
  }) : super(
          searchString: null,
        );

  @override
  List<Object?> get props => [
        modifiedUnit,
        super.props,
      ];
}

class FetchUnitsAfterUnitsRemoval extends FetchUnits {
  final List<int> removedIds;

  const FetchUnitsAfterUnitsRemoval({
    required super.unitGroup,
    this.removedIds = const [],
    super.rebuildConversion,
  }) : super(
          searchString: null,
        );

  @override
  List<Object?> get props => [
        removedIds,
        super.props,
      ];
}

class FetchUnitsOnSearchStringChange extends FetchUnits {
  const FetchUnitsOnSearchStringChange({
    required super.searchString,
    required super.unitGroup,
  });

  @override
  String toString() {
    return 'FetchUnitsOnSearchStringChange{}';
  }
}

class FetchUnitsToMarkForConversion extends FetchUnits {
  final List<UnitModel>? unitsAlreadyMarkedForConversion;
  final UnitModel? unitNewlyMarkedForConversion;
  final ConversionItemModel? currentSourceConversionItem;

  const FetchUnitsToMarkForConversion({
    required super.unitGroup,
    this.unitsAlreadyMarkedForConversion,
    this.unitNewlyMarkedForConversion,
    this.currentSourceConversionItem,
    required super.searchString,
  });

  @override
  List<Object?> get props => [
        unitNewlyMarkedForConversion,
        unitsAlreadyMarkedForConversion,
        currentSourceConversionItem,
        super.props,
      ];

  @override
  String toString() {
    return 'FetchUnitsToMarkForConversion{'
        'unitNewlyMarkedForConversion: $unitNewlyMarkedForConversion, '
        'unitsAlreadyMarkedForConversion: $unitsAlreadyMarkedForConversion, '
        'currentSourceConversionItem: $currentSourceConversionItem, '
        '${super.toString()}}';
  }
}

class FetchUnitsToMarkForConversionFirstTime
    extends FetchUnitsToMarkForConversion {
  const FetchUnitsToMarkForConversionFirstTime({
    required super.unitGroup,
    super.unitsAlreadyMarkedForConversion,
    super.unitNewlyMarkedForConversion,
    super.currentSourceConversionItem,
    required super.searchString,
  });

  @override
  String toString() {
    return 'FetchUnitsToMarkForConversionFirstTime{}';
  }
}

class FetchUnitsForChangeInConversion extends FetchUnits {
  final UnitModel currentSelectedUnit;
  final List<UnitModel> unitsInConversion;
  final ConversionItemModel? currentSourceConversionItem;

  const FetchUnitsForChangeInConversion({
    required this.currentSelectedUnit,
    required this.unitsInConversion,
    required super.unitGroup,
    this.currentSourceConversionItem,
    required super.searchString,
  });

  @override
  List<Object?> get props => [
        currentSelectedUnit,
        unitsInConversion,
        currentSourceConversionItem,
        super.props,
      ];

  @override
  String toString() {
    return 'FetchUnitsForChangeInConversion{'
        'currentSelectedUnit: $currentSelectedUnit, '
        'unitsInConversion: $unitsInConversion, '
        'currentSourceConversionItem: $currentSourceConversionItem, '
        '${super.toString()}}';
  }
}

class FetchUnitsForUnitDetails extends FetchUnits {
  final UnitModel? selectedArgUnit;
  final UnitModel? currentEditedUnit;

  const FetchUnitsForUnitDetails({
    required super.unitGroup,
    required this.selectedArgUnit,
    required this.currentEditedUnit,
    required super.searchString,
  });

  @override
  List<Object?> get props => [
        selectedArgUnit,
        currentEditedUnit,
        super.props,
      ];

  @override
  String toString() {
    return 'FetchUnitsForUnitDetails{'
        'selectedArgUnit: $selectedArgUnit, '
        'currentEditedUnit: $currentEditedUnit, '
        '${super.toString()}}';
  }
}

class FetchUnitsToMarkForRemoval extends FetchUnits {
  final List<int> alreadyMarkedIds;
  final int newMarkedId;

  const FetchUnitsToMarkForRemoval({
    required super.unitGroup,
    this.alreadyMarkedIds = const [],
    required this.newMarkedId,
    required super.searchString,
  });

  @override
  List<Object?> get props => [
        alreadyMarkedIds,
        newMarkedId,
        super.props,
      ];

  @override
  String toString() {
    return 'FetchUnitsToMarkForRemoval{'
        'alreadyMarkedIds: $alreadyMarkedIds,'
        'newMarkedId: $newMarkedId}';
  }
}

class SaveUnit extends UnitsEvent {
  final UnitModel unitToBeSaved;
  final UnitGroupModel unitGroup;
  final int prevUnitGroupId;
  final int? conversionGroupId;

  const SaveUnit({
    required this.unitToBeSaved,
    required this.unitGroup,
    required this.prevUnitGroupId,
    this.conversionGroupId,
  });

  @override
  List<Object?> get props => [
        unitToBeSaved,
        unitGroup,
        prevUnitGroupId,
        conversionGroupId,
      ];

  @override
  String toString() {
    return 'SaveUnit{'
        'unitToBeSaved: $unitToBeSaved, '
        'prevUnitGroupId: $prevUnitGroupId}';
  }
}

class RemoveUnits extends UnitsEvent {
  final List<int> ids;
  final UnitGroupModel unitGroup;

  const RemoveUnits({
    required this.ids,
    required this.unitGroup,
  });

  @override
  List<Object?> get props => [
        ids,
        unitGroup,
      ];

  @override
  String toString() {
    return 'RemoveUnits{'
        'ids: $ids, '
        'unitGroup: $unitGroup}';
  }
}

class DisableUnitsRemovalMode extends UnitsEvent {
  final UnitGroupModel unitGroup;

  const DisableUnitsRemovalMode({
    required this.unitGroup,
  });

  @override
  List<Object?> get props => [
        unitGroup,
      ];

  @override
  String toString() {
    return 'DisableUnitsRemovalMode{}';
  }
}

class ModifyGroup extends UnitsEvent {
  final UnitGroupModel modifiedGroup;

  const ModifyGroup({
    required this.modifiedGroup,
  });

  @override
  List<Object?> get props => [
        modifiedGroup,
      ];

  @override
  String toString() {
    return 'ModifyGroup{modifiedGroup: $modifiedGroup}';
  }
}
