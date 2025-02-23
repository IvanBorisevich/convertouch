abstract class ValueRange<T> {
  final T left;
  final T right;

  const ValueRange(this.left, this.right);

  bool contains(
    T value, {
    bool includeLeft = true,
    bool includeRight = true,
  });
}

class NumValueRange extends ValueRange<num> {
  const NumValueRange(super.left, super.right);

  @override
  bool contains(
    num value, {
    bool includeLeft = true,
    bool includeRight = true,
  }) {
    bool isMoreThanLeft = includeLeft ? left <= value : left < value;
    bool isLessThanRight = includeRight ? right >= value : right > value;
    return isMoreThanLeft && isLessThanRight;
  }
}
