import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_conversion_model.dart';
import 'package:convertouch/domain/use_cases/conversion/build_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/restore_last_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/save_conversion_use_case.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_events.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversionBloc extends ConvertouchBloc<ConversionEvent, ConversionState> {
  final BuildConversionUseCase buildConversionUseCase;
  final SaveConversionUseCase saveConversionUseCase;
  final RestoreLastConversionUseCase restoreLastConversionUseCase;

  ConversionBloc({
    required this.buildConversionUseCase,
    required this.saveConversionUseCase,
    required this.restoreLastConversionUseCase,
  }) : super(
          const ConversionBuilt(
            conversion: OutputConversionModel(),
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
    final conversionResult = await buildConversionUseCase.execute(
      event.conversionParams,
    );

    if (conversionResult.isLeft) {
      emit(
        ConversionErrorState(
          message: conversionResult.left.message,
        ),
      );
    } else {
      await saveConversionUseCase.execute(conversionResult.right);
      emit(
        ConversionBuilt(
          conversion: conversionResult.right,
        ),
      );
    }
  }

  _onRemoveConversion(
    RemoveConversionItem event,
    Emitter<ConversionState> emit,
  ) async {
    emit(const ConversionInBuilding());

    List<ConversionItemModel> conversionItems = event.conversionItems;
    conversionItems.removeWhere((item) => event.itemUnitId == item.unit.id);

    final outputConversion = OutputConversionModel(
      unitGroup: event.unitGroupInConversion,
      sourceConversionItem: conversionItems.firstOrNull,
      targetConversionItems: conversionItems,
    );

    await saveConversionUseCase.execute(outputConversion);

    emit(
      ConversionBuilt(
        conversion: outputConversion,
      ),
    );
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
        (conversion) => ConversionBuilt(
          conversion: conversion,
        ),
      ),
    );
  }
}
