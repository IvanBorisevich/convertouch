import 'package:collection/collection.dart';

const String genderParamName = "Gender";
const String garmentParamName = "Garment";
const String heightParamName = "Height";

enum Gender {
  male("Male"),
  female("Female");

  final String name;

  const Gender(this.name);

  static Gender? valueOf(String? name) {
    return values.firstWhereOrNull((element) => name == element.name);
  }
}

enum Garment {
  shirt("Shirt"),
  trousers("Trousers");

  final String name;

  const Garment(this.name);

  static Garment? valueOf(String? name) {
    return values.firstWhereOrNull((element) => name == element.name);
  }
}

enum ClothingSizeCode {
  inter("INT"),
  ru("RU"),
  eu("EU"),
  uk("UK"),
  us("US"),
  it("IT"),
  fr("FR"),
  jp("JP");

  final String name;

  const ClothingSizeCode(this.name);
}

enum ClothingSizeInter {
  xxs("XXS"),
  xs("XS"),
  s("S"),
  m("M"),
  l("L"),
  xl("XL"),
  x("X"),
  xx("XX"),
  xxx("3X");

  final String name;

  const ClothingSizeInter(this.name);

  static ClothingSizeInter? valueOf(String? name) {
    return values.firstWhereOrNull((element) => name == element.name);
  }
}

var t = ClothingSizeInter.xxs.name;
