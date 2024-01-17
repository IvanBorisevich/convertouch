import 'package:convertouch/data/dao/db/dbconfig/migrations/migration.dart';
import 'package:convertouch/data/entities/job_data_source_entity.dart';
import 'package:convertouch/data/entities/refreshable_value_entity.dart';
import 'package:convertouch/data/entities/refreshing_job_entity.dart';
import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:convertouch/data/entities/unit_group_entity.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/default_refreshing_jobs.dart';
import 'package:convertouch/domain/constants/default_units.dart';
import 'package:sqflite/sqflite.dart';

class InitialMigration extends ConvertouchDbMigration {
  @override
  Future<void> execute(Database database) async {
    _fillDbV1(
      database,
      defaultUnitEntities: unitDataVersions[0],
    );
  }

  Future<void> _fillDbV1(
    Database database, {
    required List<dynamic> defaultUnitEntities,
  }) async {
    for (Map<String, dynamic> entity in defaultUnitEntities) {
      database.transaction(
        (txn) async {
          int unitGroupId = await _insertGroup(txn, entity);
          String groupName = entity['groupName'];
          if (jobsV1.containsKey(groupName)) {
            final jobEntity = jobsV1[groupName]!;
            int jobId = await _insertRefreshingJob(txn, unitGroupId, jobEntity);

            await _insertJobDataSources(txn, jobId, jobEntity);
          }
          List<int> unitIds = await _insertUnits(txn, unitGroupId, entity);

          bool valuesAreRefreshable = entity['refreshable'] == true &&
              entity['conversionType'] == ConversionType.formula;
          if (valuesAreRefreshable) {
            _insertRefreshableValuesUnits(txn, unitIds);
          }
        },
      );
    }
  }

  Future<int> _insertGroup(
    Transaction txn,
    Map<String, dynamic> entity,
  ) async {
    int groupId = await txn.insert(unitGroupsTableName, {
      'name': entity['groupName'],
      'icon_name': entity['iconName'],
      'conversion_type': entity['conversionType'] != null &&
              entity['conversionType'] != ConversionType.static
          ? (entity['conversionType'] as ConversionType).value
          : null,
      'refreshable': entity['refreshable'] == true ? 1 : null,
    });

    return groupId;
  }

  Future<int> _insertRefreshingJob(
    Transaction txn,
    int unitGroupId,
    Map<String, dynamic> entity,
  ) async {
    return await txn.insert(refreshingJobsTableName, {
      'name': entity['name'],
      'unit_group_id': unitGroupId,
      'refreshable_data_part':
          (entity['refreshableDataPart'] as RefreshableDataPart).val,
    });
  }

  Future<void> _insertJobDataSources(
    Transaction txn,
    int jobId,
    Map<String, dynamic> jobEntity,
  ) async {
    Batch batch = txn.batch();

    for (Map<String, dynamic> dataSource in jobEntity['dataSources']) {
      batch.insert(
        jobDataSourcesTableName,
        {
          'name': dataSource['name'],
          'url': dataSource['url'],
          'response_transformer_name':
              dataSource['responseTransformerClassName'],
          'job_id': jobId,
        },
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    }

    await batch.commit(noResult: true, continueOnError: false);
  }

  Future<List<int>> _insertUnits(
    Transaction txn,
    int unitGroupId,
    Map<String, dynamic> entity,
  ) async {
    Batch batch = txn.batch();

    for (Map<String, dynamic> unit in entity['units']) {
      batch.insert(
        unitsTableName,
        {
          'name': unit['name'],
          'abbreviation': unit['abbreviation'],
          'coefficient': unit['coefficient'],
          'unit_group_id': unitGroupId,
        },
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    }

    List<Object?> result = await batch.commit(continueOnError: false);
    return result.map((item) => item as int).toList();
  }

  Future<void> _insertRefreshableValuesUnits(
    Transaction txn,
    List<int> unitIds,
  ) async {
    Batch batch = txn.batch();

    for (int unitId in unitIds) {
      batch.insert(
        refreshableValuesTableName,
        {
          'unit_id': unitId,
        },
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    }

    await batch.commit(noResult: true, continueOnError: false);
  }
}
