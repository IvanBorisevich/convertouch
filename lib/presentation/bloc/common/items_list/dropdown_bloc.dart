import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_list_value_selection_model.dart';
import 'package:convertouch/domain/use_cases/common/get_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/common/select_list_value_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_bloc.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_events.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_states.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectListValue extends ItemsListEvent {
  final String? value;
  final ConvertouchListType listType;
  final void Function(ListValueModel?)? onItemSelect;

  const SelectListValue({
    required this.value,
    required this.listType,
    this.onItemSelect,
  });

  @override
  List<Object?> get props => [
        value,
        listType,
      ];

  @override
  String toString() {
    return 'SelectListValue{'
        'value: $value, '
        'listType: $listType}';
  }
}

class DropdownBloc
    extends ItemsListBloc<ListValueModel, ItemsFetched<ListValueModel>> {
  final GetListValuesUseCase getListValuesUseCase;
  final SelectListValueUseCase selectListValueUseCase;

  DropdownBloc({
    required this.getListValuesUseCase,
    required this.selectListValueUseCase,
  }) {
    on<SelectListValue>(_onSelectListValue);
  }

  @override
  ListValueModel addSearchMatch(ListValueModel item, String searchString) {
    return item;
  }

  @override
  Future<Either<ConvertouchException, List<ListValueModel>>> fetchItems(
    InputItemsFetchModel input,
  ) async {
    return await getListValuesUseCase.execute(input);
  }

  @override
  Future<Either<ConvertouchException, void>> removeItems(List<int> ids) async {
    return const Right(null);
  }

  @override
  Future<Either<ConvertouchException, ListValueModel>> saveItem(
    ListValueModel item,
  ) async {
    return Right(item);
  }

  _onSelectListValue(
    SelectListValue event,
    Emitter<ItemsFetched<ListValueModel>> emit,
  ) async {
    ListValueModel? listValue = ObjectUtils.tryGet(
      await selectListValueUseCase.execute(
        InputListValueSelectionModel(
          value: event.value,
          listType: event.listType,
        ),
      ),
    );

    emit(
      state.copyWith(
        selectedItem: listValue,
      ),
    );

    event.onItemSelect?.call(listValue);
  }
}
