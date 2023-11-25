import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/unit_value_model.dart';
import 'package:convertouch/domain/usecases/units_conversion/convert_unit_value_use_case.dart';
import 'package:convertouch/domain/usecases/units_conversion/model/unit_conversion_input.dart';
import 'package:convertouch/presentation/bloc/base_event.dart';
import 'package:convertouch/presentation/bloc/unit_conversions_page/units_conversion_events.dart';
import 'package:convertouch/presentation/bloc/unit_conversions_page/units_conversion_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitsConversionBloc
    extends Bloc<ConvertouchPageEvent, UnitsConversionState> {
  final ConvertUnitValueUseCase convertUnitValueUseCase;

  UnitsConversionBloc({
    required this.convertUnitValueUseCase,
  }) : super(const UnitsConversionInitState());

  @override
  Stream<UnitsConversionState> mapEventToState(
      ConvertouchPageEvent event) async* {
    if (event is InitializeConversion) {
      yield const ConversionInitializing();

      List<UnitValueModel> convertedUnitValues = [];
      bool stoppedOnError = false;
      UnitValueModel? sourceConversionItem = event.sourceConversionItem;

      if (event.unitsInConversion != null &&
          event.unitGroupInConversion != null) {

        sourceConversionItem ??= UnitValueModel(
          unit: event.unitsInConversion![0],
          value: 1,
        );

        for (UnitModel targetUnit in event.unitsInConversion!) {
          final conversionResult = await convertUnitValueUseCase.execute(
            UnitConversionInput(
              inputUnitValue: sourceConversionItem,
              targetUnit: targetUnit,
              unitGroup: event.unitGroupInConversion!,
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
      }

      if (!stoppedOnError) {
        yield ConversionInitialized(
          conversionItems: convertedUnitValues,
          sourceConversionItem: sourceConversionItem,
          unitGroupInConversion: event.unitGroupInConversion,
        );
      }
    } else if (event is RemoveConversion) {
      yield const ConversionInitializing();

      List<UnitValueModel> conversionItems = event.conversionItems;
      conversionItems
          .removeWhere((item) => event.unitIdBeingRemoved == item.unit.id);

      yield ConversionInitialized(
        sourceConversionItem: conversionItems[0],
        conversionItems: conversionItems,
        unitGroupInConversion: event.unitGroupInConversion,
      );
    }
  }
}
