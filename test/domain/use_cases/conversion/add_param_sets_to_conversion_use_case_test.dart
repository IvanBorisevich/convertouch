import 'package:convertouch/domain/use_cases/conversion/add_param_sets_to_conversion_use_case.dart';
import 'package:test/test.dart';

void main() {
  late AddParamSetsToConversionUseCase useCase;

  group('Add a mandatory param set', () {});

  group('Add an optional param set', () {
    group('Conversion already has params', () {
      group('Conversion has unit values (they should not be changed)', () {});

      group('Conversion does not have unit values', () {});
    });

    group('Conversion does not have params', () {
      group('Conversion has unit values (they should not be changed)', () {});

      group('Conversion does not have unit values', () {});
    });
  });
}
