import 'package:collection/collection.dart';
import 'package:convertouch/domain/constants/constants.dart';

const String genderParamName = "Gender";
const String garmentParamName = "Garment";
const String heightParamName = "Height";

enum Gender implements ListType {
  male("Male"),
  female("Female");

  final String name;

  const Gender(this.name);

  @override
  String get itemName => name;

  static Gender? valueOf(String? name) {
    return values.firstWhereOrNull((element) => name == element.name);
  }
}

enum Garment implements ListType {
  shirt("Shirt"),
  trousers("Trousers");

  final String name;

  const Garment(this.name);

  @override
  String get itemName => name;

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
