import 'dart:async';

import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/job_data_source_model.dart';
import 'package:convertouch/domain/model/refreshing_job_result_model.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

class RefreshingJobModel extends IdNameItemModel {
  final String unitGroupName;
  final RefreshableDataPart refreshableDataPart;
  final Cron selectedCron;
  final Map<String, JobDataSourceModel> dataSources;
  final JobDataSourceModel? selectedDataSource;
  final String? lastRefreshTime;
  final StreamController<RefreshingJobResultModel>? progressController;

  const RefreshingJobModel({
    required super.name,
    required this.unitGroupName,
    required this.refreshableDataPart,
    required this.selectedCron,
    this.dataSources = const {},
    this.selectedDataSource,
    this.lastRefreshTime,
    this.progressController,
    super.itemType = ItemType.refreshingJob,
    super.oob = true,
  });

  RefreshingJobModel.coalesce(
    RefreshingJobModel savedModel, {
    Map<String, JobDataSourceModel>? dataSources,
    String? lastRefreshTime,
    Cron? cron,
    JobDataSourceModel? selectedDataSource,
    StreamController<RefreshingJobResultModel>? progressController,
  }) : this(
          name: savedModel.name,
          unitGroupName: savedModel.unitGroupName,
          refreshableDataPart: savedModel.refreshableDataPart,
          dataSources: ObjectUtils.coalesce(
                what: savedModel.dataSources,
                patchWith: dataSources,
              ) ??
              {},
          lastRefreshTime: ObjectUtils.coalesce(
            what: savedModel.lastRefreshTime,
            patchWith: lastRefreshTime,
          ),
          selectedCron: ObjectUtils.coalesce(
            what: savedModel.selectedCron,
            patchWith: cron,
          )!,
          selectedDataSource: ObjectUtils.coalesce(
            what: savedModel.selectedDataSource,
            patchWith: selectedDataSource,
          ),
          progressController: ObjectUtils.coalesce(
            what: savedModel.progressController,
            patchWith: progressController,
          ),
        );

  @override
  List<Object?> get props => [
    name,
    unitGroupName,
    refreshableDataPart,
    selectedCron,
    lastRefreshTime,
    selectedDataSource,
    progressController,
    itemType,
  ];

  static RefreshingJobModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }

    Map<String, JobDataSourceModel> dataSourceMap =
        (json["dataSources"] as Map).map(
      (key, value) => MapEntry(key, JobDataSourceModel.fromJson(value)!),
    );

    return RefreshingJobModel(
      name: json["name"],
      unitGroupName: json["group"],
      refreshableDataPart: RefreshableDataPart.valueOf(json["refreshableDataPart"]),
      dataSources: dataSourceMap,
      selectedCron: Cron.valueOf(json["selectedCron"]),
      selectedDataSource: dataSourceMap[json["selectedDataSource"]],
      lastRefreshTime: json["lastRefreshTime"],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "group": unitGroupName,
      "refreshableDataPart": refreshableDataPart.name,
      "dataSources": dataSources.map((key, value) => MapEntry(key, value.toJson())),
      "selectedCron": selectedCron.name,
      "selectedDataSource": selectedDataSource?.name,
      "lastRefreshTime": lastRefreshTime,
    };
  }

  @override
  String toString() {
    return 'RefreshingJobModel{'
        'name: $name, '
        'selectedCron: $selectedCron, '
        'lastRefreshTime: $lastRefreshTime, '
        'progressController: $progressController}';
  }
}
