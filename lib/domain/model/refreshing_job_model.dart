import 'dart:async';

import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/job_data_source_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';

class RefreshingJobModel extends IdNameItemModel {
  final UnitGroupModel? unitGroup;
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
          lastRefreshTime: _coalesce(
            what: savedModel.lastRefreshTime,
            patchWith: lastRefreshTime,
            replaceWithNull: replaceWithNull,
          ),
          cron: _coalesce(
            what: savedModel.cron,
            patchWith: cron,
            replaceWithNull: replaceWithNull,
          ),
          selectedDataSource: _coalesce(
            what: savedModel.selectedDataSource,
            patchWith: selectedDataSource,
            replaceWithNull: replaceWithNull,
          ),
          progressController: _coalesce(
            what: savedModel.progressController,
            patchWith: progressController,
            replaceWithNull: replaceWithNull,
          ),
        );

  static dynamic _coalesce({
    required dynamic what,
    required dynamic patchWith,
    required bool replaceWithNull,
  }) {
    if (replaceWithNull) {
      return patchWith;
    } else {
      return patchWith ?? what;
    }
  }

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
