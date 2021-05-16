enum NoorCategory { ATHKAR, QURAAN, SUNNAH, RUQIYA, MYAD3YAH, ALLAHNAME }

const Map<NoorCategory, String> categoryTitle = <NoorCategory, String>{
  NoorCategory.ATHKAR: 'الأذكار',
  NoorCategory.QURAAN: 'أدعية من القرآن الكريم',
  NoorCategory.SUNNAH: 'أدعية من السنة النبوية',
  NoorCategory.RUQIYA: 'الرقية الشرعية',
  NoorCategory.MYAD3YAH: 'أدعيتي',
  NoorCategory.ALLAHNAME: 'أسماء الله الحسنى',
};
