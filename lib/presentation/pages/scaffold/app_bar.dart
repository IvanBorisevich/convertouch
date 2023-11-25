import 'package:flutter/material.dart';

class ConvertouchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget content;

  const ConvertouchAppBar({
    required this.content,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return content;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}