import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/usecases/unit_groups/add_unit_group_use_case.dart';
import 'package:convertouch/presentation/bloc/base_event.dart';
import 'package:convertouch/presentation/bloc/unit_group_creation_page/unit_group_creation_events.dart';
import 'package:convertouch/presentation/bloc/unit_group_creation_page/unit_group_creation_states.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_events.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitGroupCreationBloc extends Bloc<ConvertouchPageEvent, UnitGroupCreationState> {
  final AddUnitGroupUseCase addUnitGroupUseCase;

  UnitGroupCreationBloc({
    required this.addUnitGroupUseCase,
  }) : super(const UnitGroupCreationInitState());

  @override
  Stream<UnitGroupCreationState> mapEventToState(ConvertouchPageEvent event) async* {
    if (event is AddUnitGroup) {
      yield const UnitGroupExistenceChecking();

      final addUnitGroupResult = await addUnitGroupUseCase.execute(
        UnitGroupModel(
          name: event.unitGroupName,
        ),
      );

      if (addUnitGroupResult.isLeft) {
        yield UnitGroupCreationErrorState(
          message: addUnitGroupResult.left.message,
        );
      } else {
        int addedUnitGroupId = addUnitGroupResult.right;
        if (addedUnitGroupId > -1) {
          add(const FetchUnitGroups());
        } else {
          yield UnitGroupExists(
            unitGroupName: event.unitGroupName,
          );
        }
      }
    }
  }
}
