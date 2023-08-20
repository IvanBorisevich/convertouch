import 'package:convertouch/data/models/unit_group_model.dart';

abstract class UnitGroupDao {
  const UnitGroupDao();

  Future<List<UnitGroupModel>> fetchUnitGroups();
}