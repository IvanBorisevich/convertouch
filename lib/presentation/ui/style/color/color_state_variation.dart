import 'package:convertouch/presentation/ui/style/color/color_set.dart';

class ColorStateVariation<T extends ColorSet> {
  final T regular;
  final T? marked;
  final T? selected;
  final T? focused;
  final T? disabled;

  const ColorStateVariation({
    required this.regular,
    this.marked,
    this.selected,
    this.focused,
    this.disabled,
  });
}
