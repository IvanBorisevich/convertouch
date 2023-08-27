import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/unit_value_model.dart';
import 'package:convertouch/domain/usecases/units_conversion/convert_unit_value_use_case.dart';
import 'package:convertouch/domain/usecases/units_conversion/model/unit_conversion_input.dart';
import 'package:convertouch/presentation/bloc/units_conversion/units_conversion_events.dart';
import 'package:convertouch/presentation/bloc/units_conversion/units_conversion_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitsConversionBloc
    extends Bloc<UnitsConversionEvent, UnitsConversionState> {
  final ConvertUnitValueUseCase convertUnitValueUseCase;

  UnitsConversionBloc({
    required this.convertUnitValueUseCase,
  }) : super(const UnitsConversionEmptyState());

  @override
  Stream<UnitsConversionState> mapEventToState(
      UnitsConversionEvent event) async* {
    if (event is InitializeConversion) {
      yield const ConversionInitializing();
      UnitModel inputUnit = event.inputUnit ?? event.conversionUnits[0];
      String inputValue = event.inputValue;

      UnitValueModel inputUnitValue = UnitValueModel(
        unit: inputUnit,
        value: inputValue,
      );

      List<UnitValueModel> convertedUnitValues = [];
      bool stoppedOnError = false;
      for (UnitModel targetUnit in event.conversionUnits) {
        final conversionResult = await convertUnitValueUseCase.execute(
          UnitConversionInput(
            inputUnitValue: inputUnitValue,
            targetUnit:
                targetUnit == event.prevInputUnit ? inputUnit : targetUnit,
          ),
        );

        if (conversionResult.isLeft) {
          yield UnitsConversionErrorState(
            message: conversionResult.left.message,
          );
          stoppedOnError = true;
          break;
        } else {
          convertedUnitValues.add(conversionResult.right);
        }
      }

      if (!stoppedOnError) {
        yield ConversionInitialized(
          conversionItems: convertedUnitValues,
          sourceUnit: inputUnit,
          sourceUnitValue: inputValue,
          unitGroup: event.unitGroup,
        );
      }
    } else if (event is ConvertUnitValue) {
      UnitValueModel inputUnitValue = UnitValueModel(
        unit: event.inputUnit,
        value: event.inputValue,
      );

      for (UnitValueModel conversionItem in event.conversionItems) {
        if (conversionItem.unit != event.inputUnit) {
          yield const UnitConverting();

          final conversionResult = await convertUnitValueUseCase.execute(
            UnitConversionInput(
              inputUnitValue: inputUnitValue,
              targetUnit: conversionItem.unit,
            ),
          );

          if (conversionResult.isLeft) {
            yield UnitsConversionErrorState(
              message: conversionResult.left.message,
            );
            break;
          } else {
            yield UnitConverted(
              unitValue: conversionResult.right,
            );
          }
        }
      }
    }
  }
}
