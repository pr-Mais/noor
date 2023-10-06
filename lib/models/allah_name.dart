import 'package:noor/exports/constants.dart' show NoorCategory, Ribbon;

class AllahName {
  late final String id;
  late final String name;
  late final String text;

  late final bool isFav;
  late final int section;
  late final bool inApp;
  late final List<String> highlight;
  late final List<String> noHighlight;
  late final List<String> occurances;

  final String sectionName = 'أسماء الله الحسنى';
  final String ribbon = Ribbon.ribbon6;
  final NoorCategory category = NoorCategory.allahname;

  AllahName._(
    this.id,
    this.name,
    this.text,
    this.isFav,
    this.inApp,
    this.highlight,
    this.noHighlight,
    this.occurances,
  );

  factory AllahName.fromMap(Map<String, dynamic> map) => AllahName._(
        map['id'] as String,
        map['name'] as String,
        map['text'] as String,
        map['isFav'] ?? false,
        map['inApp'] as bool,
        map['highlight']?.cast<String>() ?? <String>[],
        map['noHighlight']?.cast<String>() ?? <String>[],
        map['occurances']?.cast<String>() ?? <String>[],
      );
}
