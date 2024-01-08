import 'package:convertouch/data/entities/refreshing_job_entity.dart';
import 'package:floor/floor.dart';

const String jobDataSourcesTableName = 'job_data_sources';

@Entity(
  tableName: jobDataSourcesTableName,
  indices: [
    Index(value: ['job_id'], unique: false),
  ],
  foreignKeys: [
    ForeignKey(
      childColumns: ['job_id'],
      parentColumns: ['id'],
      entity: RefreshingJobEntity,
      onDelete: ForeignKeyAction.cascade,
    ),
  ],
)
class JobDataSourceEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final String url;
  @ColumnInfo(name: 'response_transformer_name')
  final String responseTransformerClassName;
  @ColumnInfo(name: 'job_id')
  final int jobId;

  const JobDataSourceEntity({
    this.id,
    required this.name,
    required this.url,
    required this.responseTransformerClassName,
    required this.jobId,
  });
}
