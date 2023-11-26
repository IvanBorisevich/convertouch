// import 'package:convertouch/domain/constants/constants.dart';
// import 'package:convertouch/presentation/bloc/base_state.dart';
// import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_states.dart';
//
// abstract class UnitGroupCreationState extends ConvertouchCommonState {
//   const UnitGroupCreationState({
//     super.pageId = unitGroupCreationPageId,
//     super.prevState = UnitGroupsFetched,
//     super.pageTitle = "New Unit Group",
//     super.startPageIndex = 1,
//     super.unitGroupInConversion,
//     super.floatingButtonVisible = false,
//     super.theme,
//   });
// }
//
// class UnitGroupCreationInitState extends UnitGroupCreationState {
//   const UnitGroupCreationInitState();
//
//   @override
//   String toString() {
//     return 'UnitGroupsCreationInitState{${super.toString()}}';
//   }
// }
//
// class UnitGroupCreationPreparing extends UnitGroupCreationState {
//   const UnitGroupCreationPreparing();
//
//   @override
//   String toString() {
//     return 'UnitGroupCreationPreparing{}';
//   }
// }
//
// class UnitGroupCreationPrepared extends UnitGroupCreationState {
//   const UnitGroupCreationPrepared();
//
//   @override
//   String toString() {
//     return 'UnitGroupCreationPrepared{}';
//   }
// }
//
// class UnitGroupExistenceChecking extends UnitGroupCreationState {
//   const UnitGroupExistenceChecking();
//
//   @override
//   String toString() {
//     return 'UnitGroupExistenceChecking{${super.toString()}}';
//   }
// }
//
// class UnitGroupExists extends UnitGroupCreationState {
//   final String unitGroupName;
//
//   const UnitGroupExists({
//     required this.unitGroupName,
//   });
//
//   @override
//   List<Object?> get props => [
//     unitGroupName,
//     super.props,
//   ];
//
//   @override
//   String toString() {
//     return 'UnitGroupExists{'
//         'unitGroupName: $unitGroupName'
//         '${super.toString()}'
//         '}';
//   }
// }
//
// class UnitGroupCreationErrorState extends UnitGroupCreationState {
//   final String message;
//
//   const UnitGroupCreationErrorState({
//     required this.message,
//   });
//
//   @override
//   List<Object> get props => [message];
//
//   @override
//   String toString() {
//     return 'UnitGroupCreationErrorState{message: $message}';
//   }
// }
