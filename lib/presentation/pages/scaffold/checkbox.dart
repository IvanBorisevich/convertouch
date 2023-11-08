import 'package:flutter/material.dart';

class ConvertouchCheckbox extends StatefulWidget {
  final bool value;
  final void Function()? onCheck;
  final void Function()? onUncheck;

  const ConvertouchCheckbox(
    this.value, {
    this.onCheck,
    this.onUncheck,
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
    return GestureDetector(
      onTap: () {
        setState(() {
          _value = !_value;
          if (_value) {
            widget.onCheck?.call();
          } else {
            widget.onUncheck?.call();
          }
        });
      },
      child: Container(
        width: 50,
        height: 50,
        padding: const EdgeInsets.all(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color(0xFF426F99),
              width: 1,
            ),
            color: _value ? const Color(0xFF426F99) : Colors.transparent,
          ),
          child: Icon(
            _value ? Icons.check : Icons.check_outlined,
            size: 20,
            color: _value ? Colors.white : const Color(0xFF426F99),
          ),
        ),
      ),
    );

  }
}
