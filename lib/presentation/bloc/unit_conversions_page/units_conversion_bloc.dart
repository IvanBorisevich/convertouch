import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/unit_value_model.dart';
import 'package:convertouch/domain/usecases/units_conversion/convert_unit_value_use_case.dart';
import 'package:convertouch/domain/usecases/units_conversion/model/unit_conversion_input.dart';
import 'package:convertouch/presentation/bloc/unit_conversions_page/units_conversion_events.dart';
import 'package:convertouch/presentation/bloc/unit_conversions_page/units_conversion_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitsConversionBloc
    extends Bloc<UnitsConversionEvent, UnitsConversionState> {
  final ConvertUnitValueUseCase convertUnitValueUseCase;

  UnitsConversionBloc({
    required this.convertUnitValueUseCase,
  }) : super(const ConversionBuilt());

  @override
  Stream<UnitsConversionState> mapEventToState(UnitsConversionEvent event) async* {
    if (event is BuildConversion) {
      yield const ConversionInBuilding();

      List<UnitValueModel> convertedUnitValues = [];
      bool stoppedOnError = false;
      UnitValueModel? sourceConversionItem = event.sourceConversionItem;

      if (event.units != null && event.unitGroup != null) {

        sourceConversionItem ??= UnitValueModel(
          unit: event.units![0],
          value: 1,
        );

        for (UnitModel targetUnit in event.units!) {
          final conversionResult = await convertUnitValueUseCase.execute(
            UnitConversionInput(
              inputUnitValue: sourceConversionItem,
              targetUnit: targetUnit,
              unitGroup: event.unitGroup!,
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
        yield ConversionBuilt(
          conversionItems: convertedUnitValues,
          sourceConversionItem: sourceConversionItem,
          unitGroup: event.unitGroup,
        );
      }
    } else if (event is RemoveConversionItem) {
      yield const ConversionInBuilding();

      List<UnitValueModel> conversionItems = event.conversionItems;
      conversionItems
          .removeWhere((item) => event.itemUnitId == item.unit.id);

      yield ConversionBuilt(
        sourceConversionItem: conversionItems[0],
        conversionItems: conversionItems,
        unitGroup: event.unitGroupInConversion,
      );
    }
  }
}
