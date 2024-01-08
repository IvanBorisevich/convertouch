import 'package:convertouch/data/entities/unit_group_entity.dart';
import 'package:floor/floor.dart';

const String refreshingJobsTableName = 'refreshing_jobs';

@Entity(
  tableName: refreshingJobsTableName,
  indices: [
    Index(value: ['unit_group_id'], unique: true),
  ],
  foreignKeys: [
    ForeignKey(
      childColumns: ['unit_group_id'],
      parentColumns: ['id'],
      entity: UnitGroupEntity,
      onDelete: ForeignKeyAction.cascade,
    ),
  ],
)
class RefreshingJobEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  @ColumnInfo(name: 'unit_group_id')
  final int unitGroupId;
  @ColumnInfo(name: 'refreshable_data_part')
  final int refreshableDataPartNum;
  @ColumnInfo(name: 'last_refresh_time')
  final String? lastRefreshTime;
  @ColumnInfo(name: 'auto_refresh')
  final int autoRefresh;
  @ColumnInfo(name: 'cron_name')
  final String? cronName;

  const RefreshingJobEntity({
    this.id,
    required this.name,
    required this.unitGroupId,
    required this.refreshableDataPartNum,
    required this.lastRefreshTime,
    required this.autoRefresh,
    required this.cronName,
  });
}
