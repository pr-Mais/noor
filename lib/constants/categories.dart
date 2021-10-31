enum NoorCategory { athkar, quraan, sunnah, ruqiya, myad3yah, allahname }

const Map<NoorCategory, String> categoryTitle = <NoorCategory, String>{
  NoorCategory.athkar: 'الأذكار',
  NoorCategory.quraan: 'أدعية من القرآن الكريم',
  NoorCategory.sunnah: 'أدعية من السنة النبوية',
  NoorCategory.ruqiya: 'الرقية الشرعية',
  NoorCategory.myad3yah: 'أدعيتي',
  NoorCategory.allahname: 'أسماء الله الحسنى',
};
