import 'package:convertouch/domain/constants/constants.dart';

class RefreshingJobEntity {
  final int id;
  final String name;
  final String unitGroupName;
  final int dataRefreshTypeNum;

  RefreshingJobEntity({
    required this.id,
    required this.name,
    required this.unitGroupName,
    required this.dataRefreshTypeNum,
  });

  static RefreshingJobEntity fromJson(Map<String, dynamic> data) {
    return RefreshingJobEntity(
      id: data['id'],
      name: data['name'],
      unitGroupName: data['unitGroupName'],
      dataRefreshTypeNum: RefreshableDataPart.values.indexOf(data['dataRefreshType']),
    );
  }
}
