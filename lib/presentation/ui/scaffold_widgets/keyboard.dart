import 'package:flutter/material.dart';

enum KeyboardType {
  numeric,
  numericHexadecimal,
}

class ConvertouchKeyboard extends StatefulWidget {
  final TextEditingController controller;
  final KeyboardType keyboardType;

  const ConvertouchKeyboard({
    required this.controller,
    this.keyboardType = KeyboardType.numeric,
    super.key,
  });

  @override
  State<ConvertouchKeyboard> createState() => _ConvertouchKeyboardState();
}

class _ConvertouchKeyboardState extends State<ConvertouchKeyboard> {
  static const double _keysPadding = 4;
  static const Widget _horizontalPadding = SizedBox(width: _keysPadding);
  static const Widget _verticalPadding = SizedBox(height: _keysPadding);

  late TextEditingController _controller;

  @override
  void initState() {
    _controller = widget.controller;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      height: 200,
      width: MediaQuery.of(context).size.width,
      bottom: 0,
        child: Container(
          padding: EdgeInsets.all(_keysPadding),
          decoration: const BoxDecoration(
            color: Color(0xFFDEE9FF),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  _buildButton(symbolOrIcon: '1'),
                  _horizontalPadding,
                  _buildButton(symbolOrIcon: '2'),
                  _horizontalPadding,
                  _buildButton(symbolOrIcon: '3'),
                  _horizontalPadding,
                  _buildButton(symbolOrIcon: ''),
                ],
              ),
              _verticalPadding,
              Row(
                children: [
                  _buildButton(symbolOrIcon: '5'),
                  _horizontalPadding,
                  _buildButton(symbolOrIcon: '6'),
                  _horizontalPadding,
                  _buildButton(symbolOrIcon: '3'),
                  _horizontalPadding,
                  _buildButton(symbolOrIcon: '4'),
                ],
              ),
            ],
          ),
        ),
    );
  }

  Widget _buildButton({
    required dynamic symbolOrIcon,
    void Function()? onPressed,
  }) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(0),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF4A7096),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: TextButton(
            onPressed: onPressed,
            child: symbolOrIcon is String
                ? Text(
              symbolOrIcon,
              style: const TextStyle(
                color: Color(0xFFF5F7FF),
              ),
            )
                : Icon(
              symbolOrIcon,
              color: const Color(0xFFF5F7FF),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
