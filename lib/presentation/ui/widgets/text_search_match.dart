import 'package:collection/collection.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:flutter/material.dart';

class TextSearchMatch extends StatelessWidget {
  final ItemSearchMatch match;
  final String sourceString;
  final double fontSize;
  final Color? foreground;
  final Color? matchForeground;
  final Color? matchBackground;
  final FontWeight fontWeight;
  final int maxLines;

  const TextSearchMatch({
    required this.match,
    required this.sourceString,
    this.fontSize = 14,
    this.foreground,
    this.matchForeground,
    this.matchBackground,
    this.fontWeight = FontWeight.w600,
    this.maxLines = 1,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      textAlign: TextAlign.center,
      text: match != ItemSearchMatch.none
          ? TextSpan(
              children: match.lexemes
                  .mapIndexed(
                    (index, lexeme) => TextSpan(
                      text: lexeme,
                      style: TextStyle(
                        backgroundColor: index == match.matchedLexemeIndex
                            ? matchBackground
                            : null,
                        color: index == match.matchedLexemeIndex
                            ? matchForeground
                            : foreground,
                        fontFamily: quicksandFontFamily,
                        fontSize: fontSize,
                        fontWeight: fontWeight,
                        letterSpacing: 0,
                      ),
                    ),
                  )
                  .toList(),
            )
          : TextSpan(
              text: sourceString,
              style: TextStyle(
                fontFamily: quicksandFontFamily,
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: foreground,
                letterSpacing: 0,
              ),
            ),
    );
  }
}
