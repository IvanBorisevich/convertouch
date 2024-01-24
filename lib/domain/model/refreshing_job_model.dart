import 'dart:async';

import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/job_data_source_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

class RefreshingJobModel extends IdNameItemModel {
  final UnitGroupModel unitGroup;
  final RefreshableDataPart refreshableDataPart;
  final Cron cron;
  final JobDataSourceModel? selectedDataSource;
  final String? lastRefreshTime;
  final StreamController<double>? progressController;

  const RefreshingJobModel({
    required super.id,
    required super.name,
    required this.unitGroup,
    required this.refreshableDataPart,
    this.cron = Cron.never,
    this.selectedDataSource,
    this.lastRefreshTime,
    this.progressController,
    super.itemType = ItemType.refreshingJob,
  });

  RefreshingJobModel.coalesce(
    RefreshingJobModel savedModel, {
    String? lastRefreshTime,
    Cron? cron,
    JobDataSourceModel? selectedDataSource,
    StreamController<double>? progressController,
    bool replaceWithNull = false,
  }) : this(
          id: savedModel.id,
          name: savedModel.name,
          unitGroup: savedModel.unitGroup,
          refreshableDataPart: savedModel.refreshableDataPart,
          lastRefreshTime: ObjectUtils.coalesce(
            what: savedModel.lastRefreshTime,
            patchWith: lastRefreshTime,
            replaceWithNull: replaceWithNull,
          ),
          cron: ObjectUtils.coalesce(
            what: savedModel.cron,
            patchWith: cron ?? Cron.never,
            replaceWithNull: replaceWithNull,
          )!,
          selectedDataSource: ObjectUtils.coalesce(
            what: savedModel.selectedDataSource,
            patchWith: selectedDataSource,
            replaceWithNull: replaceWithNull,
          ),
          progressController: ObjectUtils.coalesce(
            what: savedModel.progressController,
            patchWith: progressController,
            replaceWithNull: replaceWithNull,
          ),
        );

  @override
  List<Object?> get props => [
    id,
    name,
    unitGroup,
    refreshableDataPart,
    cron,
    lastRefreshTime,
    selectedDataSource,
    progressController,
    itemType,
  ];

  @override
  String toString() {
    return 'RefreshingJobModel{'
        'id: $id, '
        'name: $name';
  }
}
