import 'package:flutter/material.dart';
import 'package:noor/models/allah_name.dart';
import 'package:provider/provider.dart';

import 'package:noor/exports/utils.dart' show Tashkeel;
import 'package:noor/exports/controllers.dart' show SettingsModel;

extension RegExpExtension on RegExp {
  List<String> allMatchesWithSep(String input, [int start = 0]) {
    List<String> result = <String>[];
    for (Match match in allMatches(input, start)) {
      result.add(input.substring(start, match.start));
      result.add(match[0]!);
      start = match.end;
    }
    result.add(input.substring(start));
    return result;
  }
}

extension StringExtension on String {
  List<String> splitWithDelim(RegExp pattern) =>
      pattern.allMatchesWithSep(this);
}

class CardText extends StatelessWidget {
  const CardText({
    Key? key,
    required this.text,
    this.color,
    this.item,
  }) : super(key: key);
  final String text;
  final dynamic item;

  final Color? color;

  String mask(String string) {
    String tmp;
    // for each أ، إ، آ in string, replace with ا
    tmp = string.replaceAll(
        RegExp(
          r'[\u{0622}\u{0623}\u{0625}]',
          unicode: true,
        ),
        'ا');
    // ignore unicodes start with ufxxx, for each ئ،ي in string replace with ى
    tmp = tmp.replaceAll(
        RegExp(
          r'[\u{fef1}\u{fef3}\u{fef4}\u{0626}]',
          unicode: true,
        ),
        'ى');
    // for each ة in string replace with ه
    tmp = tmp.replaceAll(
        RegExp(
          r'[\u{0629}]',
          unicode: true,
        ),
        'ه');

    return tmp;
  }

  List<TextSpan> highlightOccurrences(
    String source,
    List<String> highlight,
    List<String> noHighlight,
    BuildContext context,
  ) {
    final List<TextSpan> children = <TextSpan>[];

    List<String> sourceList = source.split(' ').toList();
    final List<String> tmpHighlight =
        highlight.map((String e) => Tashkeel.remove(e)).toList().cast<String>();

    final RegExp marks = RegExp(
      r'[\u{060C}|\u{FD3F}|\u{060C}|\u{FD3E}|\u{002E}|\u{0029}|\u{0028}|\u{0021}|\u{005B}|\u{005D}|\u{003A}]',
      unicode: true,
    );

    final RegExp letters = RegExp(
      r'^[\u{0648}|\u{0644}|\u{0628}]',
      unicode: true,
    );
    int i = 0;

    for (String s in sourceList) {
      List<String> tmpMatch = s.splitWithDelim(marks);
      tmpMatch.removeWhere((String e) => e == '');

      List<String> match = <String>[];

      if (s.length > 0) {
        for (String m in tmpMatch) {
          if (letters.hasMatch(m) && !highlight.contains(m)) {
            match.addAll(m.splitWithDelim(letters));
          } else {
            match.addAll(m.splitWithDelim(marks));
          }
        }
      }

      if (match.length > 1) {
        for (String m in match) {
          // A very special case that doesn't happen
          // and hard to catch with the algorithm
          final bool specialCase =
              !(m == 'الحقُّ' && sourceList[i - 1] != '[أنتَ');

          if ((tmpHighlight.contains(Tashkeel.remove(m)) ||
                  highlight.contains(m)) &&
              specialCase) {
            children.add(
              TextSpan(
                text: m,
                style: TextStyle(color: Theme.of(context).buttonColor),
              ),
            );
          } else {
            children.add(
              TextSpan(
                text: m,
              ),
            );
          }
        }
      } else {
        if ((tmpHighlight.contains(Tashkeel.remove(s)) ||
                highlight.contains(s)) &&
            !noHighlight.contains(Tashkeel.remove(s))) {
          children.add(
            TextSpan(
              text: s,
              style: TextStyle(color: Theme.of(context).buttonColor),
            ),
          );
        } else {
          children.add(
            TextSpan(
              text: s,
            ),
          );
        }
      }

      children.add(
        TextSpan(
          text: ' ',
        ),
      );

      i++;
    }

    return children;
  }

  @override
  Widget build(BuildContext context) {
    final SettingsModel settings = context.watch();

    return Align(
      alignment: Alignment.centerRight,
      child: DefaultTextStyle.merge(
        textAlign: TextAlign.justify,
        style: color != null
            ? Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: color,
                  fontFamily: settings.fontType,
                )
            : Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontFamily: settings.fontType,
                ),
        child: Builder(
          builder: (BuildContext context) {
            return AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: item is AllahName
                  ? RichText(
                      textScaleFactor: settings.fontSize,
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        children: highlightOccurrences(
                          settings.tashkeel ? text : Tashkeel.remove(text),
                          item.highlight.isNotEmpty
                              ? <String>[...item.highlight]
                              : <String>[
                                  ...item.name.split(' '),
                                ],
                          item.noHighlight,
                          context,
                        ),
                        style: DefaultTextStyle.of(context).style,
                      ),
                    )
                  : Text(
                      settings.tashkeel ? text : Tashkeel.remove(text),
                      key: ValueKey<bool>(settings.tashkeel),
                      textScaleFactor: settings.fontSize,
                    ),
            );
          },
        ),
      ),
    );
  }
}
