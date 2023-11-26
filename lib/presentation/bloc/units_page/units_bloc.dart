// import 'package:convertouch/domain/model/unit_model.dart';
// import 'package:convertouch/domain/usecases/unit_groups/get_unit_group_use_case.dart';
// import 'package:convertouch/domain/usecases/units/fetch_units_of_group_use_case.dart';
// import 'package:convertouch/domain/usecases/units/remove_units_use_case.dart';
// import 'package:convertouch/presentation/bloc/base_event.dart';
// import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_events.dart';
// import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
// import 'package:convertouch/presentation/bloc/units_page/units_states.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// class UnitsBloc extends Bloc<ConvertouchCommonEvent, UnitsState> {
//   static const int _minUnitsNumToSelect = 2;
//
//   final GetUnitGroupUseCase getUnitGroupUseCase;
//   final FetchUnitsOfGroupUseCase fetchUnitsOfGroupUseCase;
//   final RemoveUnitsUseCase removeUnitsUseCase;
//
//   UnitsBloc({
//     required this.getUnitGroupUseCase,
//     required this.fetchUnitsOfGroupUseCase,
//     required this.removeUnitsUseCase,
//   }) : super(const UnitsInitState());
//
//   @override
//   Stream<UnitsState> mapEventToState(ConvertouchCommonEvent event) async* {
//     if (event is FetchUnitsOfGroup) {
//       yield const UnitsFetching();
//       final fetchUnitsOfGroupResult = await fetchUnitsOfGroupUseCase.execute(
//         event.unitGroupId,
//       );
//
//       if (fetchUnitsOfGroupResult.isLeft) {
//         yield UnitsErrorState(message: fetchUnitsOfGroupResult.left.message);
//       } else {
//         final unitGroupCaseResult =
//             await getUnitGroupUseCase.execute(event.unitGroupId);
//
//         if (unitGroupCaseResult.isLeft) {
//           yield UnitsErrorState(message: unitGroupCaseResult.left.message);
//         } else {
//           List<UnitModel> unitsOfGroup = fetchUnitsOfGroupResult.right;
//
//           // List<UnitModel> markedUnits = _updateMarkedUnits(
//           //   event.markedUnits,
//           //   event.newMarkedUnit,
//           //   event.action,
//           // );
//           //
//           // UnitModel? selectedUnit = event.selectedUnit;
//           // if (selectedUnit == null &&
//           //     event.action ==
//           //         ConvertouchAction.fetchUnitsToSelectForUnitCreation) {
//           //   selectedUnit =
//           //       markedUnits.isNotEmpty ? markedUnits.first : unitsOfGroup.first;
//           // }
//
//           yield UnitsFetched(
//             units: unitsOfGroup,
//           );
//         }
//       }
//     } else if (event is RemoveUnits) {
//       // yield const UnitsFetching();
//       // final result = await removeUnitsUseCase.execute(event.ids);
//       // if (result.isLeft) {
//       //   yield UnitsErrorState(
//       //     message: result.left.message,
//       //   );
//       // } else {
//       //   final fetchUnitGroupsResult = await fetchUnitsOfGroupUseCase.execute(
//       //     event.unitGroup.id!,
//       //   );
//       //
//       //   List<UnitModel>? markedUnits = event.markedUnits;
//       //   if (markedUnits != null) {
//       //     markedUnits.removeWhere((element) => event.ids.contains(element.id));
//       //   }
//       //
//       //   yield fetchUnitGroupsResult.fold(
//       //     (error) => UnitsErrorState(
//       //       message: error.message,
//       //     ),
//       //     (units) => UnitsFetched(
//       //       units: units,
//       //       unitGroup: event.unitGroup,
//       //       needToNavigate: false,
//       //       markedUnits: markedUnits ?? [],
//       //     ),
//       //   );
//       // }
//     }
//   }
//
//   // List<UnitModel> _updateMarkedUnits(
//   //   List<UnitModel>? markedUnits,
//   //   UnitModel? markedUnit,
//   //   ConvertouchAction action,
//   // ) {
//   //   List<UnitModel> resultMarkedUnits = List.from(markedUnits ?? []);
//   //   if (action != ConvertouchAction.fetchUnitsToSelectForUnitCreation &&
//   //       markedUnit != null) {
//   //     if (!resultMarkedUnits.contains(markedUnit)) {
//   //       resultMarkedUnits.add(markedUnit);
//   //     } else {
//   //       resultMarkedUnits.removeWhere((unit) => unit == markedUnit);
//   //     }
//   //   }
//   //   return resultMarkedUnits;
//   // }
// }
