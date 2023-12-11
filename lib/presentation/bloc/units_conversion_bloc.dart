import 'package:convertouch/domain/model/input/units_conversion_events.dart';
import 'package:convertouch/domain/model/output/units_conversion_states.dart';
import 'package:convertouch/domain/model/unit_value_model.dart';
import 'package:convertouch/domain/usecases/units_conversion/convert_unit_value_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitsConversionBloc
    extends Bloc<UnitsConversionEvent, UnitsConversionState> {
  final ConvertUnitValueUseCase convertUnitValueUseCase;

  UnitsConversionBloc({
    required this.convertUnitValueUseCase,
  }) : super(const ConversionBuilt(
          unitGroup: null,
          sourceConversionItem: null,
        ));

  @override
  Stream<UnitsConversionState> mapEventToState(
      UnitsConversionEvent event) async* {
    if (event is BuildConversion) {
      yield const ConversionInBuilding();

      final conversionResult = await convertUnitValueUseCase.execute(
        input: event,
      );

      yield conversionResult.fold(
        (error) => UnitsConversionErrorState(
          message: error.message,
        ),
        (conversionBuild) => conversionBuild,
      );
    } else if (event is RemoveConversionItem) {
      yield const ConversionInBuilding();

      List<UnitValueModel> conversionItems = event.conversionItems;
      conversionItems.removeWhere((item) => event.itemUnitId == item.unit.id);

      yield ConversionBuilt(
        sourceConversionItem: conversionItems.firstOrNull,
        conversionItems: conversionItems,
        unitGroup: event.unitGroupInConversion,
      );
    }
  }
}
