import 'package:convertouch/data/dao/unit_group_dao.dart';
import 'package:convertouch/data/entities/unit_group_entity.dart';

class UnitGroupDaoDbImpl extends UnitGroupDao {
  @override
  Future<List<UnitGroupEntity>> fetchUnitGroups() async {
    return Future(
      () => _allUnitGroups,
    );
  }

  @override
  Future<int> addUnitGroup(UnitGroupEntity unitGroupEntity) {
    return Future(
      () {
        if (_unitGroupExists(unitGroupEntity.name)) {
          return -1;
        }
        int newId = _allUnitGroups.length + 1;
        _allUnitGroups.add(UnitGroupEntity(
          id: newId,
          name: unitGroupEntity.name,
          iconName: unitGroupEntity.iconName,
        ));
        return newId;
      },
    );
  }

  @override
  Future<UnitGroupEntity> getUnitGroup(int unitGroupId) {
    return Future(
      () => _allUnitGroups
          .firstWhere((unitGroupEntity) => unitGroupEntity.id == unitGroupId),
    );
  }

  bool _unitGroupExists(String name) {
    return _allUnitGroups.any((unitGroup) => name == unitGroup.name);
  }
}

final List<UnitGroupEntity> _allUnitGroups = [
  UnitGroupEntity(id: 1, name: 'Length'),
  UnitGroupEntity(id: 2, name: 'Area'),
  UnitGroupEntity(id: 3, name: 'Mass'),
  UnitGroupEntity(id: 4, name: 'Speed'),
  UnitGroupEntity(id: 5, name: 'Volume'),
  UnitGroupEntity(id: 6, name: 'Currency'),
  UnitGroupEntity(id: 7, name: 'Temperature'),
  UnitGroupEntity(id: 8, name: 'Numeral System'),
];
