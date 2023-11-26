// import 'package:convertouch/domain/constants/constants.dart';
// import 'package:convertouch/domain/model/unit_model.dart';
// import 'package:convertouch/presentation/bloc/base_state.dart';
// import 'package:convertouch/presentation/bloc/unit_creation_page/unit_creation_states.dart';
// import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_states.dart';
//
// abstract class UnitsState extends ConvertouchCommonState {
//   const UnitsState({
//     super.pageId = unitsPageId,
//     super.prevState,
//     super.pageTitle = "Units",
//     super.startPageIndex = 1,
//     super.unitGroupInConversion,
//     super.floatingButtonVisible = true,
//     super.removalMode,
//     super.selectedItemIdsForRemoval,
//     super.pageViewMode = ItemsViewMode.grid,
//     super.iconViewMode = ItemsViewMode.list,
//     super.theme,
//   });
// }
//
// class UnitsInitState extends UnitsState {
//   const UnitsInitState();
//
//   @override
//   String toString() {
//     return 'UnitsInitState{}';
//   }
// }
//
// class UnitsFetching extends UnitsState {
//   const UnitsFetching();
//
//   @override
//   String toString() {
//     return 'UnitsFetching{}';
//   }
// }
//
// class UnitsFetched extends UnitsState {
//   final List<UnitModel> units;
//
//   const UnitsFetched({
//     this.units = const [],
//     super.prevState = UnitGroupsFetched,
//     super.startPageIndex,
//     super.pageTitle,
//   });
//
//   @override
//   List<Object?> get props => [
//     units,
//     super.props,
//   ];
//
//   @override
//   String toString() {
//     return 'UnitsFetched{'
//         'units: $units, '
//         '${super.toString()}'
//         '}';
//   }
// }
//
//
// class UnitsFetchedForConversion extends UnitsFetched {
//   final List<UnitModel> unitsAlreadyInConversion;
//   final List<UnitModel> unitsSelectedForConversion;
//
//   const UnitsFetchedForConversion({
//     required super.units,
//     required this.unitsAlreadyInConversion,
//     required this.unitsSelectedForConversion,
//     super.prevState,
//     super.startPageIndex = 0,
//     super.pageTitle = "Select Units for conversion",
//   });
//
//   @override
//   List<Object?> get props => [
//     unitsAlreadyInConversion,
//     unitsSelectedForConversion,
//     super.props,
//   ];
//
//   @override
//   String toString() {
//     return 'UnitsFetchedForConversion{'
//         'unitsAlreadyInConversion: $unitsAlreadyInConversion, '
//         'unitsSelectedForConversion: $unitsSelectedForConversion, '
//         '${super.toString()}'
//         '}';
//   }
// }
//
//
// class UnitsFetchedForEquivalentUnitSelection extends UnitsFetched {
//   final UnitModel? selectedEquivalentUnit;
//
//   const UnitsFetchedForEquivalentUnitSelection({
//     super.units,
//     this.selectedEquivalentUnit,
//     super.prevState = UnitCreationPrepared,
//     super.pageTitle = "Select Equivalent Unit",
//   });
//
//   @override
//   List<Object?> get props => [
//     selectedEquivalentUnit,
//     super.props,
//   ];
//
//   @override
//   String toString() {
//     return 'UnitsFetchedForEquivalentUnitSelection{'
//         'selectedEquivalentUnit: $selectedEquivalentUnit'
//         '${super.toString()}'
//         '}';
//   }
// }
//
// class UnitsErrorState extends UnitsState {
//   final String message;
//
//   const UnitsErrorState({
//     required this.message,
//   });
//
//   @override
//   List<Object> get props => [message];
//
//   @override
//   String toString() {
//     return 'UnitsErrorState{message: $message}';
//   }
// }