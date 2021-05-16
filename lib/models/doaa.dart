import 'package:noor/constants/categories.dart';

class Doaa {
  late final String id;
  late final String text;
  late final String info;
  late final String ribbon;
  late bool isFav;

  late final String sectionName;

  late final NoorCategory? category;

  Doaa._(
    this.id,
    this.text,
    this.info,
    this.sectionName,
    this.ribbon,
    this.isFav, {
    this.category,
  });

  factory Doaa.fromMap(Map<String, dynamic> map) => Doaa._(
        map['id'] ?? '',
        map['text'] as String,
        map['info'] as String,
        map['sectionName'] as String,
        map['ribbon'] ?? '',
        map['isFav'] ?? false,
        category: map['category'],
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'text': text,
        'info': info,
        'isFav': isFav ? 1 : 0,
      };
}
