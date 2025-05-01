import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/value_range.dart';

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
  x("X"),
  xl("XL"),
  xx("XX"),
  xxl("XXL"),
  xxx("3X"),
  xxxl("3XL");

  final String name;

  const ClothingSizeInter(this.name);

  static ClothingSizeInter? valueOf(String? name) {
    return values.firstWhereOrNull((element) => name == element.name);
  }
}

class SizesMap {
  final NumValueRange height;
  final Map<ClothingSizeCode, dynamic> sizeMap;

  const SizesMap({
    required this.height,
    required this.sizeMap,
  });
}

const Map<Gender, Map<Garment, List<SizesMap>>> clothingSizes = {
  Gender.male: {
    Garment.shirt: [
      SizesMap(
        height: NumValueRange(0, 1.6),
        sizeMap: {
          ClothingSizeCode.inter: ClothingSizeInter.xxs,
          ClothingSizeCode.ru: 38,
          ClothingSizeCode.eu: 32,
          ClothingSizeCode.uk: 4,
          ClothingSizeCode.us: 0,
          ClothingSizeCode.it: 36,
          ClothingSizeCode.fr: 30,
          ClothingSizeCode.jp: 3,
        },
      ),
      SizesMap(
        height: NumValueRange(1.6, 1.7),
        sizeMap: {
          ClothingSizeCode.inter: ClothingSizeInter.xs,
          ClothingSizeCode.ru: 40,
          ClothingSizeCode.eu: 34,
          ClothingSizeCode.uk: 6,
          ClothingSizeCode.us: 2,
          ClothingSizeCode.it: 38,
          ClothingSizeCode.fr: 34,
          ClothingSizeCode.jp: 7,
        },
      ),
    ]
  },
};
