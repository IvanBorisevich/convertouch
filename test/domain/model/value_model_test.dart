import 'package:convertouch/domain/model/value_model.dart';
import 'package:test/test.dart';

ValueModel _emptyStr = ValueModel.str("");

void main() {
  test('Build value model from raw string value', () {
    ValueModel str1 = ValueModel.str("0.0098");
    expect(str1.raw, "0.0098");
    expect(str1.alt, "0.0098");

    expect(ValueModel.str(""), _emptyStr);
  });

  test('Build value model from numeric value', () {
    expect(ValueModel.numeric(23).numVal, 23);
    expect(ValueModel.numeric(0), ValueModel.zero);
    expect(ValueModel.numeric(1), ValueModel.one);
    expect(ValueModel.numeric(double.nan), _emptyStr);
    expect(ValueModel.numeric(4000000000), ValueModel.str("4000000000"));
    expect(ValueModel.numeric(0.09999999999999999), ValueModel.str("0.1"));
    expect(ValueModel.numeric(0.09999999999999999), ValueModel.numeric(0.1));
  });

  test('Build value model from any dynamic value', () {
    expect(ValueModel.any(23)?.numVal, 23);
    expect(ValueModel.any(0), ValueModel.zero);
    expect(ValueModel.any(1), ValueModel.one);
    expect(ValueModel.any(double.nan), _emptyStr);
    expect(ValueModel.any(null), null);
    expect(ValueModel.any(''), null);

    ValueModel numVal = ValueModel.numeric(4000000000);
    expect(numVal.numVal, 4000000000);
    expect(numVal.raw, "4000000000");
    expect(numVal.alt, "4 · 10⁹");
  });

  test('Serialize value model', () {
    expect(ValueModel.numeric(23).toJson(), {
      'raw': '23',
      'num': 23,
      'alt': '23',
    });

    expect(ValueModel.str('test').toJson(), {
      'raw': 'test',
      'num': null,
      'alt': 'test',
    });

    expect(ValueModel.str('231').toJson(), {
      'raw': '231',
      'num': 231,
      'alt': '231',
    });

    expect(ValueModel.numeric(0.1).toJson(), {
      'raw': '0.1',
      'alt': '0.1',
      'num': 0.1,
    });

    expect(ValueModel.numeric(0.0999999999999).toJson(), {
      'raw': '0.1',
      'alt': '0.1',
      'num': 0.1,
    });

    expect(_emptyStr.toJson(), {
      'raw': '',
      'alt': '',
      'num': null,
    });
  });

  test('Deserialize value model', () {
    expect(
      ValueModel.fromJson({
        'raw': '23',
        'num': 23,
        'alt': '23',
      }),
      ValueModel.numeric(23),
    );

    expect(
      ValueModel.fromJson({
        'raw': '0.1',
        'num': 0.1,
        'alt': '0.1',
      }),
      ValueModel.numeric(0.09999999999999999),
    );

    expect(
      ValueModel.fromJson({
        'raw': '0.1',
        'num': 0.1,
        'alt': '0.1',
      }),
      ValueModel.numeric(0.1),
    );

    expect(
      ValueModel.fromJson({
        'raw': 'test',
        'num': null,
        'alt': 'test',
      }),
      ValueModel.str('test'),
    );

    expect(
      ValueModel.fromJson({
        'raw': '231',
        'num': 231,
        'alt': '231',
      }),
      ValueModel.str('231'),
    );

    expect(
      ValueModel.fromJson({
        'raw': '231',
        'num': 231,
        'alt': '231',
      }),
      ValueModel.str('231'),
    );

    expect(
      ValueModel.fromJson({
        'raw': '',
        'num': null,
        'alt': '',
      }),
      null,
    );

    expect(
      ValueModel.fromJson({
        'raw': null,
        'num': null,
        'alt': '',
      }),
      null,
    );

    expect(
      ValueModel.fromJson({
        'raw': '34',
        'num': null,
        'scientific': '34',
      }),
      ValueModel.str('34'),
    );

    expect(
      ValueModel.fromJson({
        'raw': '',
        'num': null,
        'scientific': '',
      }),
      null,
    );

    expect(
      ValueModel.fromJson({
        'raw': null,
        'num': null,
        'scientific': null,
      }),
      null,
    );

    expect(
      ValueModel.fromJson({
        'raw': '34',
        'scientific': '34',
      }),
      ValueModel.str('34'),
    );

    expect(
      ValueModel.fromJson({
        'raw': '',
        'scientific': '',
      }),
      null,
    );

    expect(
      ValueModel.fromJson({
        'raw': null,
        'scientific': null,
      }),
      null,
    );
  });
}
