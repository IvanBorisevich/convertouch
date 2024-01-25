import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
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
  final RefreshingJobModel? job;

  const BuildConversion({
    required this.conversionParams,
    this.job,
  });

  @override
  List<Object?> get props => [
    conversionParams,
    job,
  ];

  @override
  String toString() {
    return 'BuildConversion{'
        'conversionParams: $conversionParams}';
  }
}

class RebuildConversionAfterUnitReplacement extends BuildConversion {
  final UnitModel newUnit;
  final UnitModel oldUnit;

  const RebuildConversionAfterUnitReplacement({
    required this.newUnit,
    required this.oldUnit,
    required super.conversionParams,
    super.job,
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
  final RefreshingJobModel job;

  const ShowNewConversionAfterRefresh({
    required this.newConversion,
    required this.job,
  });

  @override
  List<Object?> get props => [
    newConversion,
    job,
  ];

  @override
  String toString() {
    return 'ShowNewConversionAfterRefresh{'
        'newConversion: $newConversion, '
        'jobOfConversion: $job}';
  }
}

class RemoveConversionItem extends ConversionEvent {
  final UnitGroupModel? unitGroupInConversion;
  final int itemUnitId;
  final List<ConversionItemModel> conversionItems;

  const RemoveConversionItem({
    required this.unitGroupInConversion,
    required this.itemUnitId,
    required this.conversionItems,
  });

  @override
  List<Object?> get props => [
        unitGroupInConversion,
        itemUnitId,
        conversionItems,
      ];

  @override
  String toString() {
    return 'RemoveConversionItem{'
        'unitGroupInConversion: $unitGroupInConversion, '
        'itemUnitId: $itemUnitId, '
        'conversionItems: $conversionItems}';
  }
}

class RestoreLastConversion extends ConversionEvent {
  const RestoreLastConversion();

  @override
  String toString() {
    return 'RestoreLastConversion{}';
  }
}
