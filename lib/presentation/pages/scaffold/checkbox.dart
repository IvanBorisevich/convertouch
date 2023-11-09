import 'package:flutter/material.dart';

class ConvertouchCheckbox extends StatefulWidget {
  final bool value;
  final Color color;
  final Color colorChecked;

  const ConvertouchCheckbox(
    this.value, {
    this.color = Colors.blueAccent,
    this.colorChecked = const Color(0xFF1D4D9D),
    super.key,
  });

  @override
  State<ConvertouchCheckbox> createState() => _ConvertouchCheckboxState();
}

class _ConvertouchCheckboxState extends State<ConvertouchCheckbox> {
  late bool _value;

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: _value ? widget.colorChecked : widget.color,
          width: 1,
        ),
        color: _value ? widget.colorChecked : Colors.transparent,
      ),
      child: Icon(
        Icons.check_outlined,
        size: 15,
        color: _value ? Colors.white : Colors.transparent,
      ),
    );
  }
}
