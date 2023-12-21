import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';

class RefreshingJobModel extends IdNameItemModel {
  final UnitGroupModel? unitGroup;
  final RefreshableDataPart dataRefreshType;
  final String cron;
  final String cronDescription;

  const RefreshingJobModel({
    required super.id,
    required super.name,
    required this.unitGroup,
    required this.dataRefreshType,
    this.cron = defaultCron,
    this.cronDescription = defaultCronDescription,
    super.itemType = ItemType.refreshingJob,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    unitGroup,
    dataRefreshType,
    cron,
    itemType,
  ];

  @override
  String toString() {
    return 'RefreshingJobModel{'
        'name: $name, '
        'unitGroup: $unitGroup, '
        'dataRefreshType: $dataRefreshType}';
  }
}