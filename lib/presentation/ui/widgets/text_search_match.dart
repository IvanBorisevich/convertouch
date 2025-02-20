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

  const TextSearchMatch({
    required this.match,
    required this.sourceString,
    this.fontSize = 14,
    this.foreground,
    this.matchForeground,
    this.matchBackground,
    this.fontWeight = FontWeight.w600,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (match == ItemSearchMatch.none) {
      return Text(
        sourceString,
        style: TextStyle(
          fontFamily: quicksandFontFamily,
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: foreground,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontFamily: quicksandFontFamily,
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: foreground,
        ),
        children: match.lexemes
            .mapIndexed(
              (index, lexeme) => index == match.matchedLexemeIndex
                  ? WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Container(
                        decoration: BoxDecoration(
                          color: matchBackground,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: Text(
                          lexeme,
                          style: TextStyle(
                            color: matchForeground ?? foreground,
                            fontFamily: quicksandFontFamily,
                            fontSize: fontSize,
                            fontWeight: fontWeight,
                          ),
                        ),
                      ),
                    )
                  : TextSpan(text: lexeme),
            )
            .toList(),
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }
}
