import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_conversion_model.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';

abstract class ConversionEvent extends ConvertouchEvent {
  const ConversionEvent();
}

class BuildConversion extends ConversionEvent {
  final InputConversionModel conversionParams;
  final UnitModel? modifiedUnit;
  final List<int> removedUnitIds;
  final UnitGroupModel? modifiedUnitGroup;
  final List<int> removedUnitGroupIds;

  const BuildConversion({
    required this.conversionParams,
    this.modifiedUnit,
    this.removedUnitIds = const [],
    this.modifiedUnitGroup,
    this.removedUnitGroupIds = const [],
  });

  @override
  List<Object?> get props => [
        conversionParams,
        modifiedUnit,
        removedUnitIds,
        modifiedUnitGroup,
        removedUnitGroupIds,
      ];

  @override
  String toString() {
    return 'BuildConversion{'
        'conversionParams: $conversionParams, '
        'modifiedUnit: $modifiedUnit, '
        'removedUnitIds: $removedUnitIds, '
        'modifiedUnitGroup: $modifiedUnitGroup, '
        'removedUnitGroupIds: $removedUnitGroupIds}';
  }
}

class RebuildConversionOnValueChange extends BuildConversion {
  const RebuildConversionOnValueChange({
    required super.conversionParams,
  });
}

class RebuildConversionAfterUnitReplacement extends BuildConversion {
  final UnitModel newUnit;
  final UnitModel oldUnit;

  const RebuildConversionAfterUnitReplacement({
    required this.newUnit,
    required this.oldUnit,
    required super.conversionParams,
  });

  @override
  List<Object?> get props => [
        newUnit,
        oldUnit,
        super.props,
      ];

  @override
  String toString() {
    return 'RebuildConversionAfterUnitReplacement{'
        'newUnit: $newUnit, '
        'oldUnit: $oldUnit, '
        'conversionParams: $conversionParams}';
  }
}

class ShowNewConversionAfterRefresh extends ConversionEvent {
  final OutputConversionModel newConversion;

  const ShowNewConversionAfterRefresh({
    required this.newConversion,
  });

  @override
  List<Object?> get props => [
        newConversion,
      ];

  @override
  String toString() {
    return 'ShowNewConversionAfterRefresh{'
        'newConversion: $newConversion}';
  }
}

class RemoveConversionItem extends ConversionEvent {
  final int id;

  const RemoveConversionItem({
    required this.id,
  });

  @override
  List<Object?> get props => [
        id,
      ];

  @override
  String toString() {
    return 'RemoveConversionItem{'
        'id: $id}';
  }
}

class GetLastSavedConversion extends ConversionEvent {
  const GetLastSavedConversion();

  @override
  String toString() {
    return 'GetLastSavedConversion{}';
  }
}
