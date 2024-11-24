import 'package:flutter/material.dart';

mixin ItemsLazyLoadingMixin {
  void onScroll({
    required ScrollController controller,
    required bool hasReachedMax,
    required int itemsNum,
    required int itemsNumInRow,
    required double itemHeight,
    required double itemsSpacing,
    void Function()? onLoad,
  }) {
    if (hasReachedMax || !controller.hasClients) {
      return;
    }

    double seenExtent =
        controller.position.pixels + controller.position.viewportDimension;
    double filledExtent = _calculateFilledExtent(
      itemsNum: itemsNum,
      itemsNumInRow: itemsNumInRow,
      itemHeight: itemHeight,
      itemsSpacing: itemsSpacing,
    );

    if (filledExtent * 0.9 <= seenExtent) {
      onLoad?.call();
    }
  }

  double _calculateFilledExtent({
    required int itemsNum,
    required int itemsNumInRow,
    required double itemHeight,
    required double itemsSpacing,
  }) {
    int numOfFullRows = (itemsNum / itemsNumInRow).floor();
    double rowHeight = itemHeight + itemsSpacing;
    return rowHeight * numOfFullRows;
  }
}
