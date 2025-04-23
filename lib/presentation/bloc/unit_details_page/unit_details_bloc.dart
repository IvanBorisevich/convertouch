import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_details_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_unit_details_build_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/unit_details/build_unit_details_use_case.dart';
import 'package:convertouch/domain/use_cases/unit_details/modify_unit_details_use_case.dart';
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
  final ModifyUnitDetailsUseCase modifyUnitDetailsUseCase;
  final NavigationBloc navigationBloc;

  UnitDetailsBloc({
    required this.buildUnitDetailsUseCase,
    required this.modifyUnitDetailsUseCase,
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
    var inputParam = _buildInputParams();
    inputParam = inputParam.copyWith(
      unitGroup: event.unitGroup,
    );

    await _handleInputParamAndEmit(inputParam, emit, navigationFunc: () {
      navigationBloc.add(const NavigateBack());
    });
  }

  _onArgumentUnitChange(
    ChangeArgumentUnitInUnitDetails event,
    Emitter<UnitDetailsState> emit,
  ) async {
    var inputParam = _buildInputParams();
    inputParam = inputParam.copyWith(
      conversionRule: inputParam.conversionRule.copyWith(
        argUnit: event.argumentUnit,
      ),
    );

    await _handleInputParamAndEmit(inputParam, emit, navigationFunc: () {
      navigationBloc.add(const NavigateBack());
    });
  }

  _onUnitNameUpdate(
    UpdateUnitNameInUnitDetails event,
    Emitter<UnitDetailsState> emit,
  ) async {
    var inputParam = _buildInputParams();
    inputParam = inputParam.copyWith(
      draftUnit: inputParam.draftUnitData.copyWith(
        name: event.newValue,
      ),
    );

    await _handleInputParamAndEmit(inputParam, emit);
  }

  _onUnitCodeUpdate(
    UpdateUnitCodeInUnitDetails event,
    Emitter<UnitDetailsState> emit,
  ) async {
    var inputParam = _buildInputParams();
    inputParam = inputParam.copyWith(
      draftUnit: inputParam.draftUnitData.copyWith(
        code: event.newValue,
      ),
    );

    await _handleInputParamAndEmit(inputParam, emit);
  }

  _onUnitValueUpdate(
    UpdateUnitValueInUnitDetails event,
    Emitter<UnitDetailsState> emit,
  ) async {
    var inputParam = _buildInputParams();
    inputParam = inputParam.copyWith(
      conversionRule: inputParam.conversionRule.copyWith(
        unitValue: ValueModel.str(event.newValue),
      ),
    );
    await _handleInputParamAndEmit(inputParam, emit);
  }

  _onArgumentUnitValueUpdate(
    UpdateArgumentUnitValueInUnitDetails event,
    Emitter<UnitDetailsState> emit,
  ) async {
    var inputParam = _buildInputParams();
    inputParam = inputParam.copyWith(
      conversionRule: inputParam.conversionRule.copyWith(
        draftArgValue: ValueModel.str(event.newValue),
      ),
    );

    await _handleInputParamAndEmit(inputParam, emit);
  }

  UnitDetailsModel _buildInputParams() {
    UnitDetailsReady currentState = state as UnitDetailsReady;
    return currentState.details;
  }

  Future<void> _handleInputParamAndEmit(
    final UnitDetailsModel inputParam,
    Emitter<UnitDetailsState> emit, {
    void Function()? navigationFunc,
  }) async {
    final result = await modifyUnitDetailsUseCase.execute(inputParam);
    await _handleAndEmit(result, emit, navigationFunc: navigationFunc);
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
