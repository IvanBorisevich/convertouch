import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:flutter/material.dart';

class NoItemsInfoLabel extends StatelessWidget {
  final String text;
  final ConvertouchColorScheme colors;

  const NoItemsInfoLabel({
    required this.text,
    required this.colors,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: colors.background.regular,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: colors.foreground.regular,
        ),
      ),
    );
  }
}
