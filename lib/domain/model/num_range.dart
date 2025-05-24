class NumRange {
  final num left;
  final num right;
  final bool includeLeft;
  final bool includeRight;

  const NumRange(
    this.left,
    this.right, {
    this.includeLeft = true,
    this.includeRight = true,
  });

  const NumRange.leftOpen(num left, num right)
      : this(
          left,
          right,
          includeLeft: false,
          includeRight: true,
        );

  const NumRange.rightOpen(num left, num right)
      : this(
          left,
          right,
          includeLeft: true,
          includeRight: false,
        );

  const NumRange.open(num left, num right)
      : this(
          left,
          right,
          includeLeft: false,
          includeRight: false,
        );

  const NumRange.closed(num left, num right)
      : this(
          left,
          right,
          includeLeft: true,
          includeRight: true,
        );

  bool contains(num? value) {
    if (value == null) {
      return false;
    }

    bool isMoreThanLeft = includeLeft ? left <= value : left < value;
    bool isLessThanRight = includeRight ? right >= value : right > value;
    return isMoreThanLeft && isLessThanRight;
  }

  num valOrLeft(num? val) {
    return val != null && contains(val) ? val : left;
  }

  num valOrRight(num? val) {
    return val != null && contains(val) ? val : right;
  }
}
