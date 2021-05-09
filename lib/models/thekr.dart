class Thekr {
  String id;
  String text;
  String additionalContent;
  int counter;
  bool isTitle;
  int isFav;
  String sectionName;
  int section;
  int titleSection;

  Thekr({
    this.id,
    this.text,
    this.counter,
    this.additionalContent,
    this.isTitle,
    this.isFav,
    this.sectionName,
    this.section = 1,
  }) : super();

  factory Thekr.fromMap(
    Map<String, dynamic> map, {
    String text,
    bool isTitle,
    String sectionName,
  }) =>
      new Thekr(
        id: map['id'],
        text: map['text'],
        counter: map['counter'],
        isTitle: isTitle ?? false,
        isFav: 0,
        sectionName: sectionName ?? map['section'],
        section: 1,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'content': text,
        'counter': counter,
        'isTitle': isTitle,
        'sectionName': sectionName,
        'section': section,
      };
}
