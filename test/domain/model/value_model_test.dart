import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/conversion_param_constants/clothing_size.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:test/test.dart';

void main() {
  test('Build value model from raw string value', () {
    ValueModel str1 = ValueModel.str("0.0098");
    expect(str1.raw, "0.0098");
    expect(str1.alt, "0.0098");

    ValueModel str2 = ValueModel.any("0.0098");
    expect(str2.raw, "0.0098");
    expect(str2.alt, "0.0098");

    expect(ValueModel.str(null), ValueModel.empty);
    expect(ValueModel.str(""), ValueModel.empty);

    expect(ValueModel.any(null), ValueModel.empty);
    expect(ValueModel.any(""), ValueModel.empty);
  });

  test('Build value model from numeric value', () {
    expect(ValueModel.numeric(23).numVal, 23);
    expect(ValueModel.numeric(null), ValueModel.empty);
    expect(ValueModel.numeric(0), ValueModel.zero);
    expect(ValueModel.numeric(1), ValueModel.one);
    expect(ValueModel.numeric(double.nan), ValueModel.undef);

    expect(ValueModel.any(23).numVal, 23);

    ValueModel numVal = ValueModel.numeric(4000000000);
    expect(numVal.listType, ConvertouchListType.none);
    expect(numVal.numVal, 4000000000);
    expect(numVal.raw, "4000000000");
    expect(numVal.alt, "4 · 10⁹");
  });

  test('Build value model from list value', () {
    ValueModel listVal1 = ValueModel.listVal(Gender.male);
    expect(listVal1.listType, ConvertouchListType.gender);
    expect(listVal1.numVal, null);
    expect(listVal1.raw, "Male");
    expect(listVal1.alt, "");

    ValueModel listVal2 = ValueModel.any(Garment.shirt);
    expect(listVal2.listType, ConvertouchListType.garment);
    expect(listVal2.numVal, null);
    expect(listVal2.raw, "Shirt");
    expect(listVal2.alt, "");

    ValueModel listVal3 =
        ValueModel.rawListVal("Shirt", listType: ConvertouchListType.garment);
    expect(listVal3.listType, ConvertouchListType.garment);
    expect(listVal3.numVal, null);
    expect(listVal3.raw, "Shirt");
    expect(listVal3.alt, "");

    expect(ValueModel.rawListVal(null, listType: ConvertouchListType.garment),
        ValueModel.empty);
    expect(
        ValueModel.rawListVal("Unknown", listType: ConvertouchListType.garment),
        ValueModel.undef);

    expect(ValueModel.listVal(null), ValueModel.empty);
  });

  test('Build value model from raw string by type', () {
    ValueModel listVal1 =
        ValueModel.rawByType("2", ConvertouchValueType.decimal);
    expect(listVal1.listType, ConvertouchListType.none);
    expect(listVal1.numVal, 2);
    expect(listVal1.raw, "2");
    expect(listVal1.alt, "2");

    ValueModel listVal2 =
        ValueModel.rawByType("Male", ConvertouchValueType.gender);
    expect(listVal2.listType, ConvertouchListType.gender);
    expect(listVal2.numVal, null);
    expect(listVal2.raw, "Male");
    expect(listVal2.alt, "");

    expect(ValueModel.rawByType("Unknown", ConvertouchValueType.gender), ValueModel.undef);
    expect(ValueModel.rawByType("1", ConvertouchValueType.gender), ValueModel.undef);
    expect(ValueModel.rawByType("Not a number", ConvertouchValueType.decimal), ValueModel.str("Not a number"));

    expect(ValueModel.rawByType(null, ConvertouchValueType.decimal),
        ValueModel.empty);
    expect(ValueModel.rawByType("", ConvertouchValueType.decimal),
        ValueModel.empty);
  });
}
