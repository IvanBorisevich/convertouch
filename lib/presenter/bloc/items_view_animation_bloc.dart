import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class ItemsViewAnimationBloc {
  static final ItemsViewAnimationBloc I = GetIt.I<ItemsViewAnimationBloc>();

  ItemsViewAnimationBloc() {
    _positionItem = PublishSubject<int>();
  }

  late PublishSubject<int> _positionItem;

  Stream<int> get listenToItemIndexToAnimate => _positionItem.stream;

  void sendItemIndexToAnimate(int position) {
    _positionItem.add(position);
  }

  void dispose() {
    _positionItem.close();
  }
}
