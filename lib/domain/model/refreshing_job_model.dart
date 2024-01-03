import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';

class RefreshingJobModel extends IdNameItemModel {
  final UnitGroupModel? unitGroup;
  final RefreshableDataPart refreshableDataPart;
  final DataRefreshingStatus dataRefreshingStatus;
  final int? cronId;
  final String? lastExecutionTime;

  const RefreshingJobModel({
    required super.id,
    required super.name,
    required this.unitGroup,
    required this.refreshableDataPart,
    this.dataRefreshingStatus = DataRefreshingStatus.off,
    this.cronId,
    this.lastExecutionTime,
    super.itemType = ItemType.refreshingJob,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    unitGroup,
    refreshableDataPart,
    cronId,
    lastExecutionTime,
    itemType,
  ];

  @override
  String toString() {
    return 'RefreshingJobModel{'
        'id: $id, '
        'name: $name, '
        'unitGroup: $unitGroup, '
        'refreshableDataPart: $refreshableDataPart, '
        'dataRefreshingStatus: $dataRefreshingStatus, '
        'cronId: $cronId, '
        'lastExecutionTime: $lastExecutionTime}';
  }
}
