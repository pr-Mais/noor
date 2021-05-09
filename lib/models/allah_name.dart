class AllahName {
  String id;
  String name;
  String text;
  int isFav;
  String sectionName;
  int section;
  bool inApp;
  List<String> highlight;
  List<String> noHighlight;
  List<String> occurances;

  AllahName({
    this.id,
    this.name,
    this.text,
    this.isFav,
    this.sectionName,
    this.section = 6,
    this.inApp,
    this.highlight,
    this.noHighlight,
    this.occurances,
  }) : super();

  factory AllahName.fromMap(Map<String, dynamic> map) => new AllahName(
        id: map['id'],
        name: map['name'],
        text: map['text'],
        sectionName: 'أسماء الله الحسنى',
        isFav: 0,
        inApp: map['inApp'],
        highlight: map['highlight']?.cast<String>() ?? <String>[],
        noHighlight: map['noHighlight']?.cast<String>() ?? <String>[],
        occurances: map['occurances']?.cast<String>() ?? <String>[],
      );
}
