import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/input/conversion_events.dart';
import 'package:convertouch/domain/model/output/conversion_states.dart';
import 'package:convertouch/domain/usecases/units_conversion/build_conversion_use_case.dart';
import 'package:convertouch/domain/usecases/units_conversion/restore_last_conversion_use_case.dart';
import 'package:convertouch/domain/usecases/units_conversion/save_conversion_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversionBloc extends Bloc<ConversionEvent, ConversionState> {
  final BuildConversionUseCase buildConversionUseCase;
  final SaveConversionUseCase saveConversionUseCase;
  final RestoreLastConversionUseCase restoreLastConversionUseCase;

  ConversionBloc({
    required this.buildConversionUseCase,
    required this.saveConversionUseCase,
    required this.restoreLastConversionUseCase,
  }) : super(
          const ConversionBuilt(
            unitGroup: null,
            sourceConversionItem: null,
          ),
        ) {
    on<BuildConversion>(_onBuildConversion);
    on<RemoveConversionItem>(_onRemoveConversion);
    on<RestoreLastConversion>(_onRestoreConversion);
  }

  _onBuildConversion(
    BuildConversion event,
    Emitter<ConversionState> emit,
  ) async {
    emit(const ConversionInBuilding());
    final conversionResult = await buildConversionUseCase.execute(event);

    if (conversionResult.isLeft) {
      emit(ConversionErrorState(
        message: conversionResult.left.message,
      ));
    } else {
      ConversionBuilt conversionBuilt = conversionResult.right;
      await saveConversionUseCase.execute(conversionBuilt);
      emit(conversionBuilt);
    }
  }

  _onRemoveConversion(
    RemoveConversionItem event,
    Emitter<ConversionState> emit,
  ) async {
    emit(const ConversionInBuilding());

    List<ConversionItemModel> conversionItems = event.conversionItems;
    conversionItems.removeWhere((item) => event.itemUnitId == item.unit.id);

    ConversionBuilt conversionState = ConversionBuilt(
      sourceConversionItem: conversionItems.firstOrNull,
      conversionItems: conversionItems,
      unitGroup: event.unitGroupInConversion,
    );

    await saveConversionUseCase.execute(conversionState);

    emit(conversionState);
  }

  _onRestoreConversion(
    RestoreLastConversion event,
    Emitter<ConversionState> emit,
  ) async {
    emit(const ConversionInBuilding());

    var result = await restoreLastConversionUseCase.execute();

    emit(
      result.fold(
        (error) => ConversionErrorState(
          message: error.message,
        ),
        (conversionBuild) => conversionBuild,
      ),
    );
  }
}
