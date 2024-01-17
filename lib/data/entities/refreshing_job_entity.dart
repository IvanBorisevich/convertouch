import 'package:convertouch/data/entities/job_data_source_entity.dart';
import 'package:convertouch/data/entities/unit_group_entity.dart';
import 'package:floor/floor.dart';

const String refreshingJobsTableName = 'refreshing_jobs';

@Entity(
  tableName: refreshingJobsTableName,
  indices: [
    Index(value: ['unit_group_id'], unique: true),
    Index(value: ['data_source_id'], unique: true),
  ],
  foreignKeys: [
    ForeignKey(
      childColumns: ['unit_group_id'],
      parentColumns: ['id'],
      entity: UnitGroupEntity,
      onDelete: ForeignKeyAction.cascade,
    ),
    ForeignKey(
      childColumns: ['data_source_id'],
      parentColumns: ['id'],
      entity: JobDataSourceEntity,
      onDelete: ForeignKeyAction.setNull,
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
  @ColumnInfo(name: 'data_source_id')
  final int? selectedDataSourceId;
  @ColumnInfo(name: 'cron_name')
  final String? cronName;

  const RefreshingJobEntity({
    this.id,
    required this.name,
    required this.unitGroupId,
    required this.refreshableDataPartNum,
    required this.lastRefreshTime,
    required this.selectedDataSourceId,
    required this.cronName,
  });
}
