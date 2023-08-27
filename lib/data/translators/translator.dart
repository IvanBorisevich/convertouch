import 'package:convertouch/data/entities/item_entity.dart';
import 'package:convertouch/domain/model/item_model.dart';

abstract class Translator<M extends ItemModel, E extends ItemEntity> {
  M toModel(E entity);
  E fromModel(M model);
}