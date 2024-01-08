import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';

class RefreshingJobModel extends IdNameItemModel {
  final UnitGroupModel? unitGroup;
  final RefreshableDataPart refreshableDataPart;
  final Cron? cron;
  final JobAutoRefresh autoRefresh;
  final String? lastRefreshTime;

  const RefreshingJobModel({
    required super.id,
    required super.name,
    required this.unitGroup,
    required this.refreshableDataPart,
    this.cron,
    this.autoRefresh = JobAutoRefresh.off,
    this.lastRefreshTime,
    super.itemType = ItemType.refreshingJob,
  });

  RefreshingJobModel.coalesce(
    RefreshingJobModel savedModel, {
    String? lastRefreshTime,
    JobAutoRefresh? autoRefresh,
    Cron? cron,
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
          autoRefresh: _coalesce(
            what: savedModel.autoRefresh,
            patchWith: autoRefresh,
            replaceWithNull: replaceWithNull,
          ),
          cron: _coalesce(
            what: savedModel.cron,
            patchWith: cron,
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
        autoRefresh,
        lastRefreshTime,
        itemType,
      ];

  @override
  String toString() {
    return 'RefreshingJobModel{'
        'id: $id, '
        'name: $name, '
        'unitGroup: $unitGroup, '
        'refreshableDataPart: $refreshableDataPart, '
        'cron: $cron, '
        'autoRefresh: $autoRefresh, '
        'lastRefreshTime: $lastRefreshTime}';
  }
}
