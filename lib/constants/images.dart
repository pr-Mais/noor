class Images {
  static LightAppImages get light => LightAppImages();
  static DarkAppImages get dark => DarkAppImages();

  final String logo = '';
  final String athkarIcon = '';
  final String quraanIcon = '';
  final String sunnahIcon = '';
  final String ruqyaIcon = '';
  final String myAd3yahIcon = '';
  final String allahNamesIcon = '';
  final String homeHeader = '';
  final String athkarCard = '';
  final String ad3yahCard = '';
  final String allahNamesCard = '';
  final String noAd3yah = '';
  final String noAd3yahFav = '';
  final String twitterButton = '';
  final String igButton = '';
  final String myAd3yahBg = '';
  final String addMyAd3yah = '';

  final String generalNotificationsIcon = '';

  // Bellow images aren't tied to theme mode
  // So they can be static and accessed directly
  static String cloutTop = 'assets/images/home-header/cloud-top.png';
  static String cloudBottom = 'assets/images/home-header/cloud-bottom.png';
  static String circleStar = 'assets/images/home-header/circle_star.png';
  static String star = 'assets/images/home-header/star.png';

  static String copyIcon = 'assets/icons/copy.png';
  static String editeIcon = 'assets/icons/edite.png';
  static String eraseIcon = 'assets/icons/erase.png';
  static String outlineHeartIcon = 'assets/icons/outline_heart.png';
  static String filledHeartIcon = 'assets/icons/filled_heart.png';
  static String referenceIcon = 'assets/icons/back.png';

  static String athkarTitleLeaf = 'assets/images/athkar-title-leaf.png';
  static String allahNameTitleLeaf = 'assets/images/allah-name-title-leaf.png';
  static String titleBg = 'assets/images/title-bg.png';

  static String allFav = 'assets/images/fav-buttons/all.png';
  static String athkarFav = 'assets/images/fav-buttons/athkar.png';
  static String quraanFav = 'assets/images/fav-buttons/quraan.png';
  static String sunnahFav = 'assets/images/fav-buttons/sunnah.png';
  static String ruqyaFav = 'assets/images/fav-buttons/ruqya.png';
  static String myAd3yahFav = 'assets/images/fav-buttons/myad3ya.png';
  static String allahNamesFav = 'assets/images/fav-buttons/allahNames.png';

  static List<String> get favButtonsList {
    return <String>[
      allFav,
      athkarFav,
      quraanFav,
      sunnahFav,
      ruqyaFav,
      myAd3yahFav,
      allahNamesFav,
    ];
  }
}

class LightAppImages extends Images {
  final String logo = 'assets/images/logo-light.svg';

  // Categories icons
  final String athkarIcon = 'assets/icons/athkar.png';
  final String quraanIcon = 'assets/icons/ad3yah/1.png';
  final String sunnahIcon = 'assets/icons/ad3yah/2.png';
  final String ruqyaIcon = 'assets/icons/ad3yah/3.png';
  final String myAd3yahIcon = 'assets/icons/ad3yah/4.png';
  final String allahNamesIcon = 'assets/icons/allah-names.png';
  // Home assets
  final String homeHeader = 'assets/images/home-header/header-light.png';
  final String athkarCard = 'assets/images/home-cards/light/Athkar.png';
  final String ad3yahCard = 'assets/images/home-cards/light/Ad3yah.png';
  final String allahNamesCard = 'assets/images/home-cards/light/AllahNames.png';
  // Backgrounds
  final String noAd3yah = 'assets/images/backgrounds/NoAd3yah.png';
  final String noAd3yahFav = 'assets/images/backgrounds/NoAd3yahFav.png';
  final String myAd3yahBg = 'assets/images/backgrounds/myAd3yahBg.svg';
  // Buttons
  final String twitterButton = 'assets/images/social-buttons/twitter-light.png';
  final String igButton = 'assets/images/social-buttons/ig-light.png';
  final String addMyAd3yah = 'assets/icons/addDo3aa.png';
  // Icons
  final String generalNotificationsIcon = 'assets/icons/general_noti_light.png';
}

class DarkAppImages extends Images {
  final String logo = 'assets/images/logo-dark.svg';

  // Categories icons
  final String athkarIcon = 'assets/icons/athkar-dark.png';
  final String quraanIcon = 'assets/icons/ad3yah/1-night.png';
  final String sunnahIcon = 'assets/icons/ad3yah/2-night.png';
  final String ruqyaIcon = 'assets/icons/ad3yah/3-night.png';
  final String myAd3yahIcon = 'assets/icons/ad3yah/4-night.png';
  final String allahNamesIcon = 'assets/icons/allah-names-dark.png';
  // Home assets
  final String homeHeader = 'assets/images/home-header/header-dark.png';
  final String athkarCard = 'assets/images/home-cards/dark/Athkar.png';
  final String ad3yahCard = 'assets/images/home-cards/dark/Ad3yah.png';
  final String allahNamesCard = 'assets/images/home-cards/dark/AllahNames.png';
  // Backgrounds
  final String noAd3yah = 'assets/images/backgrounds/NoAd3yahNight.png';
  final String noAd3yahFav = 'assets/images/backgrounds/NoAd3yahFavNight.png';
  final String myAd3yahBg = 'assets/images/backgrounds/myAd3yahBgDark.svg';
  // Buttons
  final String twitterButton = 'assets/images/social-buttons/twitter-dark.png';
  final String igButton = 'assets/images/social-buttons/ig-dark.png';
  final String addMyAd3yah = 'assets/icons/addDo3aa.png';
  // Icons
  final String generalNotificationsIcon = 'assets/icons/general_noti_dark.png';
}
