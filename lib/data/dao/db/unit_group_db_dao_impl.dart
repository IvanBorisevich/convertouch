import 'package:convertouch/data/dao/unit_group_dao.dart';
import 'package:convertouch/data/models/unit_group_model.dart';

class UnitGroupDbDaoImpl extends UnitGroupDao {
  @override
  Future<List<UnitGroupModel>> fetchUnitGroups() async {
    return Future(
      () => allUnitGroups,
    );
  }
}

const List<UnitGroupModel> allUnitGroups = [
  UnitGroupModel(id: 1, name: 'Length'),
  UnitGroupModel(id: 2, name: 'Area'),
  UnitGroupModel(id: 3, name: 'Volume'),
  UnitGroupModel(id: 4, name: 'Speed'),
  UnitGroupModel(id: 5, name: 'Mass'),
  UnitGroupModel(id: 6, name: 'Currency'),
  UnitGroupModel(id: 7, name: 'Temperature'),
  UnitGroupModel(id: 8, name: 'Numeral System'),
];
