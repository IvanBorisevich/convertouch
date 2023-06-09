import 'package:flutter/material.dart';

class ConvertouchSearchBarTextField extends StatefulWidget {
  const ConvertouchSearchBarTextField({super.key});

  @override
  State createState() => _ConvertouchSearchBarTextFieldState();
}

class _ConvertouchSearchBarTextFieldState
    extends State<ConvertouchSearchBarTextField> {
  static const double fontSize = 16;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
          autofocus: false,
          obscureText: false,
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.search, color: Color(0xFF7BA2D3)),
            hintText: 'Search unit groups...',
            hintStyle: TextStyle(color: Color(0xFF7BA2D3), fontSize: fontSize),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide.none),
            filled: true,
            fillColor: Color(0xFFF6F9FF),
            contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
          ),
          style: const TextStyle(
            color: Color(0xFF426F99),
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.start,
        ),
    );
  }
}
