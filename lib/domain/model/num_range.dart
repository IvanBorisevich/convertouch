class NumRange {
  final num left;
  final num right;

  const NumRange(this.left, this.right);

  bool contains(
    num? value, {
    bool includeLeft = true,
    bool includeRight = true,
  }) {
    if (value == null) {
      return false;
    }

    bool isMoreThanLeft = includeLeft ? left <= value : left < value;
    bool isLessThanRight = includeRight ? right >= value : right > value;
    return isMoreThanLeft && isLessThanRight;
  }
}
