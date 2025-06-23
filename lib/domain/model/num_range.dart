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

    if (left.isFinite && right.isInfinite) {
      if (left == 0) {
        return includeLeft
            ? _ValidationMessage.nonNegative.text
            : _ValidationMessage.positive.text;
      } else {
        return includeLeft
            ? _ValidationMessage.notLessThan.withParam(left.toString())
            : _ValidationMessage.greaterThan.withParam(left.toString());
      }
    }

    if (left.isFinite && right.isFinite) {
      return _ValidationMessage.inside.withParam(rangeName);
    }

    if (left.isInfinite && right.isFinite) {
      if (right == 0) {
        return includeRight
            ? _ValidationMessage.nonPositive.text
            : _ValidationMessage.negative.text;
      } else {
        return includeRight
            ? _ValidationMessage.notGreaterThan.withParam(right.toString())
            : _ValidationMessage.lessThan.withParam(right.toString());
      }
    }

    return null;
  }

  String get rangeName => "${(includeLeft && left.isFinite) ? '[' : '('}"
      "${left.isFinite ? left : '-∞'}..${right.isFinite ? right : '+∞'}"
      "${(includeRight && right.isFinite) ? ']' : ')'}";
}

enum _ValidationMessage {
  negative("Value should be negative"),
  nonNegative("Value should be non-negative"),
  positive("Value should be positive"),
  nonPositive("Value should be non-positive"),
  greaterThan("Value should be greater than {}"),
  notGreaterThan("Value should not be greater than {}"),
  lessThan("Value should be less than {}"),
  notLessThan("Value should be at least {}"),
  inside("Value should be in range {}"),
  ;

  final String text;

  const _ValidationMessage(this.text);

  String withParam(String p) => text.replaceFirst('{}', p);
}
