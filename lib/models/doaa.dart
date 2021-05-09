class Doaa {
  String id;
  String text;
  String info;
  String sectionName;
  int isFav;
  int section;

  Doaa({this.id, this.text, this.info, this.isFav, this.sectionName, this.section});

  factory Doaa.fromMap(Map<String, dynamic> map, {String sectionName, int section}) => new Doaa(
        id: map['id'].toString(),
        text: map['text'],
        info: map['info'],
        sectionName: sectionName,
        section: section,
        isFav: map['isFav'] ?? 0,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'text': text,
        'info': info,
        'section': section,
        'sectionName': sectionName,
        'isFav': isFav,
      };
}

Map<int, String> sections = <int, String>{
  2: 'أدعية من القرآن الكريم',
  3: 'أدعية من السنة النبوية',
  4: 'الرقية الشرعية',
  5: 'أدعيتي'
};
