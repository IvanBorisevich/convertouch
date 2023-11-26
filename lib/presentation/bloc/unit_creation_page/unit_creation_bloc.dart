// import 'package:convertouch/domain/usecases/units/add_unit_use_case.dart';
// import 'package:convertouch/domain/usecases/units/get_base_unit_use_case.dart';
// import 'package:convertouch/presentation/bloc/base_event.dart';
// import 'package:convertouch/presentation/bloc/unit_creation_page/unit_creation_events.dart';
// import 'package:convertouch/presentation/bloc/unit_creation_page/unit_creation_states.dart';
// import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// class UnitCreationBloc extends Bloc<ConvertouchCommonEvent, UnitCreationState> {
//   final GetBaseUnitUseCase getBaseUnitUseCase;
//   final AddUnitUseCase addUnitUseCase;
//
//   UnitCreationBloc({
//     required this.getBaseUnitUseCase,
//     required this.addUnitUseCase,
//   }) : super(const UnitCreationInitState());
//
//   @override
//   Stream<UnitCreationState> mapEventToState(ConvertouchCommonEvent event) async* {
//     if (event is PrepareUnitCreation) {
//       yield const UnitCreationPreparing();
//
//       final getBaseUnitResult =
//           await getBaseUnitUseCase.execute(event.unitGroup.id!);
//
//       yield getBaseUnitResult.fold(
//         (error) => UnitCreationErrorState(
//           message: error.message,
//         ),
//         (baseUnit) => UnitCreationPrepared(
//           equivalentUnit: event.equivalentUnit ?? baseUnit,
//           unitGroupInUnitCreation: event.unitGroup,
//           unitGroupOnStart: event.unitGroup,
//         ),
//       );
//     } else if (event is AddUnit) {
//       yield const UnitExistenceChecking();
//
//       // final addUnitResult = await addUnitUseCase.execute(
//       //   UnitAddingInput(
//       //     newUnit: event.unit,
//       //     newUnitValue: event.newUnitValue,
//       //     equivalentUnit: event.equivalentUnit,
//       //     equivalentUnitValue: event.equivalentUnitValue,
//       //   ),
//       // );
//       //
//       // if (addUnitResult.isLeft) {
//       //   yield UnitsErrorState(
//       //     message: addUnitResult.left.message,
//       //   );
//       // } else {
//       //   int addedUnitId = addUnitResult.right;
//       //   if (addedUnitId > -1) {
//       //     yield const UnitsFetching();
//       //
//       //     final fetchUnitsOfGroupResult =
//       //     await fetchUnitsOfGroupUseCase.execute(event.unitGroup.id!);
//       //     yield fetchUnitsOfGroupResult.fold(
//       //           (error) => UnitsErrorState(
//       //         message: error.message,
//       //       ),
//       //           (unitsOfGroup) => UnitsFetched(
//       //         units: unitsOfGroup,
//       //         unitGroup: event.unitGroup,
//       //         markedUnits: event.markedUnits,
//       //         addedUnitId: addedUnitId,
//       //         useMarkedUnitsInConversion:
//       //         event.markedUnits.length >= _minUnitsNumToSelect,
//       //       ),
//       //     );
//       //   } else {
//       //     yield UnitExists(unitName: event.unitName);
//       //   }
//       // }
//     }
//   }
// }
