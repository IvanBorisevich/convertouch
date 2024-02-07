import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_details_model.dart';
import 'package:convertouch/domain/use_cases/units/add_unit_use_case.dart';
import 'package:convertouch/domain/use_cases/units/prepare_unit_details_use_case.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_events.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_states.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitDetailsBloc
    extends ConvertouchBloc<UnitDetailsEvent, UnitDetailsState> {
  final PrepareUnitDetailsUseCase prepareUnitDetailsUseCase;
  final AddUnitUseCase addUnitUseCase;

  UnitDetailsBloc({
    required this.prepareUnitDetailsUseCase,
    required this.addUnitUseCase,
  }) : super(
          const UnitDetailsReady(
            unitDetails: UnitDetailsModel.empty(),
          ),
        ) {
    on<GetNewUnitDetails>(_onNewUnitDetailsGet);
    on<GetExistingUnitDetails>(_onExistingUnitDetailsGet);
    on<UpdateGroupInUnitDetails>(_onUnitGroupUpdate);
    on<UpdateArgumentUnitInUnitDetails>(_onArgumentUnitUpdate);
  }

  _onNewUnitDetailsGet(
    GetNewUnitDetails event,
    Emitter<UnitDetailsState> emit,
  ) async {
    final result = await prepareUnitDetailsUseCase.execute(
      UnitDetailsModel(
        unitGroup: event.unitGroup,
        unitName: "",
        unitCode: "",
      ),
    );

    _checkPreparedUnitDetails(result, emit);
  }

  _onExistingUnitDetailsGet(
    GetExistingUnitDetails event,
    Emitter<UnitDetailsState> emit,
  ) async {
    final result = await prepareUnitDetailsUseCase.execute(
      UnitDetailsModel(
        unitGroup: event.unitGroup,
        unitName: event.unit.name,
        unitCode: event.unit.code,
        unitValue: "1",
        argumentUnitValue: event.unit.coefficient?.toString(),
      ),
    );

    _checkPreparedUnitDetails(result, emit);
  }

  _onUnitGroupUpdate(
    UpdateGroupInUnitDetails event,
    Emitter<UnitDetailsState> emit,
  ) async {
    UnitDetailsModel unitDetails = (state as UnitDetailsReady).unitDetails;

    if (event.unitGroup.id! == unitDetails.unitGroup?.id) {
      emit(state);
    } else {
      final result = await prepareUnitDetailsUseCase.execute(
        UnitDetailsModel(
          unitGroup: event.unitGroup,
          unitName: unitDetails.unitName,
          unitCode: unitDetails.unitCode,
          unitValue: unitDetails.unitValue,
          argumentUnitValue: "1",
        ),
      );

      _checkPreparedUnitDetails(result, emit);
    }
  }

  _onArgumentUnitUpdate(
    UpdateArgumentUnitInUnitDetails event,
    Emitter<UnitDetailsState> emit,
  ) async {
    UnitDetailsModel unitDetails = (state as UnitDetailsReady).unitDetails;

    emit(
      UnitDetailsReady(
        unitDetails: UnitDetailsModel(
          unitGroup: unitDetails.unitGroup,
          unitName: unitDetails.unitName,
          unitCode: unitDetails.unitCode,
          unitValue: unitDetails.unitValue,
          argumentUnit: event.argumentUnit,
          argumentUnitValue: unitDetails.argumentUnitValue,
        ),
      ),
    );
  }

  _checkPreparedUnitDetails(
    Either<ConvertouchException, UnitDetailsModel> preparedUnitDetails,
    Emitter<UnitDetailsState> emit,
  ) async {
    if (preparedUnitDetails.isLeft) {
      emit(
        UnitDetailsErrorState(
          exception: preparedUnitDetails.left,
          lastSuccessfulState: state,
        ),
      );
    } else {
      if (preparedUnitDetails.right.argumentUnit == null) {
        emit(
          const UnitDetailsNotificationState(
            message: "For the first unit coefficient is 1 by default",
          ),
        );
      }

      emit(
        UnitDetailsReady(
          unitDetails: preparedUnitDetails.right,
        ),
      );
    }
  }
}
