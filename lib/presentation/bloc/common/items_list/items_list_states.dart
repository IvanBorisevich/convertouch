import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_items_fetch_model.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

abstract class ItemsListState extends ConvertouchState {
  const ItemsListState();
}

class ItemsFetched<T extends IdNameSearchableItemModel,
    P extends ItemsFetchParams> extends ItemsListState {
  final OutputItemsFetchModel<T, P> itemsFetch;
  final List<int> oobIds;

  const ItemsFetched({
    required this.itemsFetch,
    this.oobIds = const [],
  });

  @override
  List<Object?> get props => [
        itemsFetch,
        oobIds,
      ];

  @override
  String toString() {
    return 'ItemsFetched{'
        'itemsFetch: $itemsFetch, '
        'oobIds: $oobIds}';
  }
}
