abstract class Translator<M, E> {
  M toModel(E entity);
  E fromModel(M model);
}