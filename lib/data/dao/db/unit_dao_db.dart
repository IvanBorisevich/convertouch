import 'package:convertouch/data/dao/unit_dao.dart';
import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class UnitDaoDb extends UnitDao {
  @override
  @Query('select * from $unitsTableName where unit_group_id = :unitGroupId')
  Future<List<UnitEntity>> fetchUnitsOfGroup(int unitGroupId);

  @override
  @Query('select * from $unitsTableName '
      'where unit_group_id = :unitGroupId '
      'and coefficient = 1')
  Future<UnitEntity?> getBaseUnit(int unitGroupId);

  @override
  @Query(
      'select * from $unitsTableName '
      'where unit_group_id = :unitGroupId limit 1')
  Future<UnitEntity?> getFirstUnit(int unitGroupId);

  @override
  @insert
  Future<int> addUnit(UnitEntity unit);
}

// final List<UnitEntity> _allUnits = [
//   const UnitEntity(
//     id: 1,
//     name: 'Centimeter',
//     abbreviation: 'cm',
//     coefficient: 0.01,
//     unitGroupId: 1,
//   ),
//   const UnitEntity(
//     id: 2,
//     name: 'Decimeter',
//     abbreviation: 'dm',
//     coefficient: 0.1,
//     unitGroupId: 1,
//   ),
//   const UnitEntity(
//     id: 3,
//     name: 'Millimeter',
//     abbreviation: 'mm',
//     coefficient: 0.001,
//     unitGroupId: 1,
//   ),
//   const UnitEntity(
//     id: 4,
//     name: 'Meter',
//     abbreviation: 'm',
//     coefficient: 1,
//     unitGroupId: 1,
//   ),
//   const UnitEntity(
//     id: 5,
//     name: 'Kilometer',
//     abbreviation: 'km',
//     coefficient: 1000,
//     unitGroupId: 1,
//   ),
//   const UnitEntity(
//     id: 6,
//     name: 'Foot',
//     abbreviation: 'ft',
//     coefficient: 0.3048,
//     unitGroupId: 1,
//   ),
//   const UnitEntity(
//     id: 7,
//     name: 'Inch',
//     abbreviation: 'in',
//     coefficient: 25.4E-3,
//     unitGroupId: 1,
//   ),
//   const UnitEntity(
//     id: 8,
//     name: 'Centimeter Square',
//     abbreviation: 'cm2',
//     coefficient: 0.0001,
//     unitGroupId: 2,
//   ),
//   const UnitEntity(
//     id: 9,
//     name: 'Meter Square',
//     abbreviation: 'm2',
//     coefficient: 1,
//     unitGroupId: 2,
//   ),
//   const UnitEntity(
//     id: 10,
//     name: 'Kilogram',
//     abbreviation: 'kg',
//     coefficient: 1,
//     unitGroupId: 3,
//   ),
//   const UnitEntity(
//     id: 11,
//     name: 'Gram',
//     abbreviation: 'g',
//     coefficient: 0.001,
//     unitGroupId: 3,
//   ),
// ];
