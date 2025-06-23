class NumRange {
  final num left;
  final num right;
  final bool includeLeft;
  final bool includeRight;

  const NumRange._(
    this.left,
    this.right, {
    this.includeLeft = true,
    this.includeRight = true,
  })  : assert(left <= right, 'Left must be less or equal than right'),
        assert(right != double.negativeInfinity,
            'Negative infinity cannot be at right'),
        assert(left != double.infinity, 'Positive infinity cannot be at left');

  const NumRange.leftOpen(num? left, num? right)
      : this._(
          left ?? double.negativeInfinity,
          right ?? double.infinity,
          includeLeft: false,
          includeRight: true,
        );

  const NumRange.rightOpen(num? left, num? right)
      : this._(
          left ?? double.negativeInfinity,
          right ?? double.infinity,
          includeLeft: true,
          includeRight: false,
        );

  const NumRange.open(num? left, num? right)
      : this._(
          left ?? double.negativeInfinity,
          right ?? double.infinity,
          includeLeft: false,
          includeRight: false,
        );

  const NumRange.closed(num? left, num? right)
      : this._(
          left ?? double.negativeInfinity,
          right ?? double.infinity,
          includeLeft: true,
          includeRight: true,
        );

  bool contains(num? value) {
    if (value == null) {
      return true;
    }

    bool isMoreThanLeft = includeLeft ? left <= value : left < value;
    bool isLessThanRight = includeRight ? right >= value : right > value;
    return isMoreThanLeft && isLessThanRight;
  }

  num? valOrLeft(num? val) {
    return val != null && contains(val) ? val : left;
  }

  num? valOrRight(num? val) {
    return val != null && contains(val) ? val : right;
  }

  String? get validationMessage {
    if (left.isInfinite && right.isInfinite) {
      return null;
    }

    String suffix = left.isFinite && right.isFinite ? " in range" : "";
    return "Value should be$suffix $name";
  }

  String get name {
    if (left.isFinite && right.isInfinite) {
      if (left == 0) {
        return includeLeft ? "non-negative" : "positive";
      } else {
        return includeLeft ? "not less than $left" : "greater than $left";
      }
    }

    if (left.isFinite && right.isFinite) {
      return "${includeLeft ? '[' : '('}"
          "$left..$right"
          "${includeRight ? ']' : ')'}";
    }

    if (left.isInfinite && right.isFinite) {
      if (right == 0) {
        return includeRight ? "non-positive" : "negative";
      } else {
        return includeRight ? "not greater than $right" : "less than $right";
      }
    }

    return "any";
  }
}
