import 'package:convertouch/domain/model/unit_model.dart';

const mockUnit = UnitModel(
  id: 1,
  name: "name1",
  code: "n1",
  coefficient: 2,
);

const mockOobUnit = UnitModel(
  id: 2,
  name: "name1oob",
  code: "n1o",
  coefficient: 2,
  oob: true,
);

const mockBaseUnit = UnitModel(
  id: 3,
  name: "base1",
  code: "b1",
  coefficient: 1,
);

const mockOobBaseUnit = UnitModel(
  id: 4,
  name: "base1oob",
  code: "b1o",
  coefficient: 1,
  oob: true,
);

const mockBaseUnit2 = UnitModel(
  id: 5,
  name: "base2",
  code: "b2",
  coefficient: 1,
);

const mockOobBaseUnit2 = UnitModel(
  id: 6,
  name: "base2oob",
  code: "b2o",
  coefficient: 1,
  oob: true,
);
