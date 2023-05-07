import 'package:flutter/material.dart';

class ConvertouchSearchBarTextField extends StatefulWidget {
  const ConvertouchSearchBarTextField({super.key});

  @override
  State createState() => _ConvertouchSearchBarTextFieldState();
}

class _ConvertouchSearchBarTextFieldState
    extends State<ConvertouchSearchBarTextField> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 2, 3),
          child: TextFormField(
            autofocus: false,
            obscureText: false,
            decoration: InputDecoration(
              suffixIcon: const Icon(Icons.search, color: Color(0xFF7BA2D3)),
              hintText: 'Search unit groups...',
              hintStyle: const TextStyle(
                color: Color(0xFF7BA2D3),
                fontSize: 16
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  )),
              filled: true,
              fillColor: const Color(0xFFF6F9FF),
              contentPadding: const EdgeInsetsDirectional.fromSTEB(15, 0, 0, 0),
            ),
            style: const TextStyle(
              color: Color(0xFF426F99),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.start,
            // minLines: 1,
          ),
        ),
      ),
    );
  }
}
