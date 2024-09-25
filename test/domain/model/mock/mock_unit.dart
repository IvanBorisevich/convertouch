import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_model.dart';

const mockUnit = UnitModel(
  id: 1,
  name: "name",
  code: "code",
  coefficient: 3,
  valueType: ConvertouchValueType.decimal,
);

const mockBaseUnit = UnitModel(
  id: 2,
  name: "name2",
  code: "code2",
  coefficient: 1,
);

const mockOobUnit = UnitModel(
  id: 3,
  name: "name3",
  code: "code3",
  coefficient: 2,
  oob: true,
);

const mockOobBaseUnit = UnitModel(
  id: 4,
  name: "name4",
  code: "code4",
  coefficient: 1,
  oob: true,
);

const mockOobBaseUnit2 = UnitModel(
  id: 2,
  name: "name2",
  code: "code2",
  coefficient: 1,
  oob: true,
);
