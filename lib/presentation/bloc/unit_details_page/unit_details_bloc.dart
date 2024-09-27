import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_unit_details_build_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_unit_details_modify_model.dart';
import 'package:convertouch/domain/use_cases/unit_details/build_unit_details_use_case.dart';
import 'package:convertouch/domain/use_cases/unit_details/change_arg_unit_use_case.dart';
import 'package:convertouch/domain/use_cases/unit_details/change_unit_group_use_case.dart';
import 'package:convertouch/domain/use_cases/unit_details/edit_arg_value_use_case.dart';
import 'package:convertouch/domain/use_cases/unit_details/edit_unit_code_use_case.dart';
import 'package:convertouch/domain/use_cases/unit_details/edit_unit_name_use_case.dart';
import 'package:convertouch/domain/use_cases/unit_details/edit_unit_value_use_case.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_events.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_events.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitDetailsBloc
    extends ConvertouchBloc<ConvertouchEvent, UnitDetailsState> {
  final BuildUnitDetailsUseCase buildUnitDetailsUseCase;
  final ChangeUnitGroupUseCase changeUnitGroupUseCase;
  final ChangeArgUnitUseCase changeArgUnitUseCase;
  final EditUnitNameUseCase editUnitNameUseCase;
  final EditUnitCodeUseCase editUnitCodeUseCase;
  final EditUnitValueUseCase editUnitValueUseCase;
  final EditArgValueUseCase editArgValueUseCase;
  final NavigationBloc navigationBloc;

  UnitDetailsBloc({
    required this.buildUnitDetailsUseCase,
    required this.changeUnitGroupUseCase,
    required this.changeArgUnitUseCase,
    required this.editUnitNameUseCase,
    required this.editUnitCodeUseCase,
    required this.editUnitValueUseCase,
    required this.editArgValueUseCase,
    required this.navigationBloc,
  }) : super(const UnitDetailsInitialState()) {
    on<GetNewUnitDetails>(_onNewUnitDetailsGet);
    on<GetExistingUnitDetails>(_onExistingUnitDetailsGet);
    on<ChangeGroupInUnitDetails>(_onUnitGroupChange);
    on<ChangeArgumentUnitInUnitDetails>(_onArgumentUnitChange);
    on<UpdateUnitNameInUnitDetails>(_onUnitNameUpdate);
    on<UpdateUnitCodeInUnitDetails>(_onUnitCodeUpdate);
    on<UpdateUnitValueInUnitDetails>(_onUnitValueUpdate);
    on<UpdateArgumentUnitValueInUnitDetails>(_onArgumentUnitValueUpdate);
  }

  _onNewUnitDetailsGet(
    GetNewUnitDetails event,
    Emitter<UnitDetailsState> emit,
  ) async {
    final result = await buildUnitDetailsUseCase.execute(
      InputUnitDetailsBuildModel(
        unitGroup: event.unitGroup,
      ),
    );

    await _handleAndEmit(result, emit, navigationFunc: () {
      navigationBloc.add(
        const NavigateToPage(pageName: PageName.unitDetailsPage),
      );
    });
  }

  _onExistingUnitDetailsGet(
    GetExistingUnitDetails event,
    Emitter<UnitDetailsState> emit,
  ) async {
    final result = await buildUnitDetailsUseCase.execute(
      InputExistingUnitDetailsBuildModel(
        unit: event.unit,
        unitGroup: event.unitGroup,
      ),
    );

    await _handleAndEmit(result, emit, navigationFunc: () {
      navigationBloc.add(
        const NavigateToPage(pageName: PageName.unitDetailsPage),
      );
    });
  }

  _onUnitGroupChange(
    ChangeGroupInUnitDetails event,
    Emitter<UnitDetailsState> emit,
  ) async {
    final result = await changeUnitGroupUseCase.execute(
      await _buildInputParamsForModify(event.unitGroup),
    );

    await _handleAndEmit(result, emit, navigationFunc: () {
      navigationBloc.add(const NavigateBack());
    });
  }

  _onArgumentUnitChange(
    ChangeArgumentUnitInUnitDetails event,
    Emitter<UnitDetailsState> emit,
  ) async {
    final result = await changeArgUnitUseCase.execute(
      await _buildInputParamsForModify(event.argumentUnit),
    );

    await _handleAndEmit(result, emit, navigationFunc: () {
      navigationBloc.add(const NavigateBack());
    });
  }

  _onUnitNameUpdate(
    UpdateUnitNameInUnitDetails event,
    Emitter<UnitDetailsState> emit,
  ) async {
    final result = await editUnitNameUseCase.execute(
      await _buildInputParamsForModify(event.newValue),
    );

    await _handleAndEmit(result, emit);
  }

  _onUnitCodeUpdate(
    UpdateUnitCodeInUnitDetails event,
    Emitter<UnitDetailsState> emit,
  ) async {
    final result = await editUnitCodeUseCase.execute(
      await _buildInputParamsForModify(event.newValue),
    );

    await _handleAndEmit(result, emit);
  }

  _onUnitValueUpdate(
    UpdateUnitValueInUnitDetails event,
    Emitter<UnitDetailsState> emit,
  ) async {
    final result = await editUnitValueUseCase.execute(
      await _buildInputParamsForModify(event.newValue),
    );

    await _handleAndEmit(result, emit);
  }

  _onArgumentUnitValueUpdate(
    UpdateArgumentUnitValueInUnitDetails event,
    Emitter<UnitDetailsState> emit,
  ) async {
    final result = await editArgValueUseCase.execute(
      await _buildInputParamsForModify(event.newValue),
    );

    await _handleAndEmit(result, emit);
  }

  Future<InputUnitDetailsModifyModel<T>> _buildInputParamsForModify<T>(
    T newValue,
  ) async {
    UnitDetailsReady currentState = state as UnitDetailsReady;

    return InputUnitDetailsModifyModel(
      draft: currentState.details.draft,
      saved: currentState.details.saved,
      secondaryBaseUnit: currentState.details.secondaryBaseUnit,
      delta: newValue,
    );
  }

  Future<void> _handleAndEmit(
    final result,
    Emitter<UnitDetailsState> emit, {
    void Function()? navigationFunc,
  }) async {
    if (result.isLeft) {
      navigationBloc.add(
        ShowException(exception: result.left),
      );
    } else {
      emit(
        UnitDetailsReady(details: result.right),
      );

      navigationFunc?.call();
    }
  }
}
