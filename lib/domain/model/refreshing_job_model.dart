import 'dart:async';

import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';

class RefreshingJobModel extends IdNameItemModel {
  final UnitGroupModel? unitGroup;
  final RefreshableDataPart dataRefreshType;
  final RefreshingStatus refreshingStatus;
  final String cron;
  final String cronDescription;
  final String lastRefreshTime;
  final StreamSubscription<int>? progressStream;

  const RefreshingJobModel({
    required super.id,
    required super.name,
    required this.unitGroup,
    required this.dataRefreshType,
    this.refreshingStatus = RefreshingStatus.initial,
    this.cron = defaultCron,
    this.cronDescription = defaultCronDescription,
    this.lastRefreshTime = "-",
    this.progressStream,
    super.itemType = ItemType.refreshingJob,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    unitGroup,
    dataRefreshType,
    cron,
    lastRefreshTime,
    itemType,
  ];

  @override
  String toString() {
    return 'RefreshingJobModel{'
        'unitGroup: $unitGroup, '
        'dataRefreshType: $dataRefreshType, '
        'refreshingStatus: $refreshingStatus, '
        'cronDescription: $cronDescription, '
        'lastRefreshTime: $lastRefreshTime}';
  }
}