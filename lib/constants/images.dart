import 'package:noor/env_config.dart';

class Images {
  static LightAppImages get light => LightAppImages();
  static DarkAppImages get dark => DarkAppImages();

  final String logo = '';
  final String athkarTitleIcon = '';
  final String quraanTitleIcon = '';
  final String sunnahTitleIcon = '';
  final String ruqyaTitleIcon = '';
  final String myAd3yahTitleIcon = '';
  final String allahNamesTitleIcon = '';
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

  // Bellow images aren't tied to theme mode
  // So they can be static and accessed directly
  static String cloutTop = 'assets/images/home-header/cloud-top.png';
  static String cloudBottom = 'assets/images/home-header/cloud-bottom.png';
  static String circleStar = 'assets/images/home-header/circle_star.png';
  static String star = 'assets/images/home-header/star.png';

  static String copyIcon = 'assets/icons/${prefix}copy.png';
  static String editeIcon = 'assets/icons/${prefix}edite.png';
  static String eraseIcon = 'assets/icons/${prefix}erase.png';
  static String outlineHeartIcon = 'assets/icons/${prefix}outline_heart.png';
  static String filledHeartIcon = 'assets/icons/${prefix}filled_heart.png';
  static String referenceIcon = 'assets/icons/${prefix}back.png';

  static String athkarTitleLeaf =
      'assets/images/${prefix}athkar-title-leaf.png';
  static String allahNameTitleLeaf =
      'assets/images/${prefix}allah-name-title-leaf.png';
  static String titleBg = 'assets/images/${prefix}title-bg.png';

  static String allFavIcon = 'assets/icons/fav/${prefix}all.png';
  static String athkarFavIcon = 'assets/icons/fav/${prefix}athkar.png';
  static String quraanFavIcon = 'assets/icons/fav/${prefix}quraan.png';
  static String sunnahFavIcon = 'assets/icons/fav/${prefix}sunnah.png';
  static String ruqyaFavIcon = 'assets/icons/fav/${prefix}ruqiya.png';
  static String myAd3yahFavIcon = 'assets/icons/fav/${prefix}myAd3yah.png';
  static String allahNamesFavIcon = 'assets/icons/fav/${prefix}allahNames.png';

  static String allFavBtn = 'assets/images/fav-buttons/${prefix}all.png';
  static String athkarFavBtn = 'assets/images/fav-buttons/${prefix}athkar.png';
  static String quraanFavBtn = 'assets/images/fav-buttons/${prefix}quraan.png';
  static String sunnahFavBtn = 'assets/images/fav-buttons/${prefix}sunnah.png';
  static String ruqyaFavBtn = 'assets/images/fav-buttons/${prefix}ruqiya.png';
  static String myAd3yahFavBtn =
      'assets/images/fav-buttons/${prefix}myAd3yah.png';
  static String allahNamesFavBtn =
      'assets/images/fav-buttons/${prefix}allahNames.png';

  static List<String> get favButtonsList {
    return <String>[
      allFavBtn,
      athkarFavBtn,
      quraanFavBtn,
      sunnahFavBtn,
      ruqyaFavBtn,
      myAd3yahFavBtn,
      allahNamesFavBtn,
    ];
  }
}

class LightAppImages extends Images {
  final String logo = 'assets/images/${prefix}logo-light.svg';

  // Categories icons
  final String athkarTitleIcon = 'assets/icons/titles/${prefix}athkar.png';
  final String quraanTitleIcon = 'assets/icons/titles/${prefix}quraan.png';
  final String sunnahTitleIcon = 'assets/icons/titles/${prefix}sunnah.png';
  final String ruqyaTitleIcon = 'assets/icons/titles/${prefix}ruqiya.png';
  final String myAd3yahTitleIcon = 'assets/icons/titles/${prefix}myAd3yah.png';
  final String allahNamesTitleIcon =
      'assets/icons/titles/${prefix}allah-names.png';
  // Home assets
  final String homeHeader = 'assets/images/home-header/header-light.png';
  final String athkarCard =
      'assets/images/home-cards/light/${prefix}Athkar.png';
  final String ad3yahCard =
      'assets/images/home-cards/light/${prefix}Ad3yah.png';
  final String allahNamesCard =
      'assets/images/home-cards/light/${prefix}AllahNames.png';
  // Backgrounds
  final String noAd3yah = 'assets/images/backgrounds/NoAd3yah.png';
  final String noAd3yahFav = 'assets/images/backgrounds/NoAd3yahFav.png';
  final String myAd3yahBg = 'assets/images/backgrounds/${prefix}myAd3yahBg.svg';
  // Buttons
  final String twitterButton = 'assets/images/social-buttons/twitter-light.png';
  final String igButton = 'assets/images/social-buttons/ig-light.png';
  final String addMyAd3yah = 'assets/icons/${prefix}addDo3aa.png';
}

class DarkAppImages extends Images {
  final String logo = 'assets/images/${prefix}logo-dark.svg';

  // Categories icons
  final String athkarTitleIcon = 'assets/icons/titles/${prefix}athkar-dark.png';
  final String quraanTitleIcon = 'assets/icons/titles/${prefix}quraan-dark.png';
  final String sunnahTitleIcon = 'assets/icons/titles/${prefix}sunnah-dark.png';
  final String ruqyaTitleIcon = 'assets/icons/titles/${prefix}ruqiya-dark.png';
  final String myAd3yahTitleIcon =
      'assets/icons/titles/${prefix}myAd3yah-dark.png';
  final String allahNamesTitleIcon =
      'assets/icons/titles/${prefix}allah-names-dark.png';
  // Home assets
  final String homeHeader = 'assets/images/home-header/header-dark.png';
  final String athkarCard = 'assets/images/home-cards/dark/${prefix}Athkar.png';
  final String ad3yahCard = 'assets/images/home-cards/dark/${prefix}Ad3yah.png';
  final String allahNamesCard =
      'assets/images/home-cards/dark/${prefix}AllahNames.png';
  // Backgrounds
  final String noAd3yah = 'assets/images/backgrounds/NoAd3yahNight.png';
  final String noAd3yahFav = 'assets/images/backgrounds/NoAd3yahFavNight.png';
  final String myAd3yahBg =
      'assets/images/backgrounds/${prefix}myAd3yahBgDark.svg';
  // Buttons
  final String twitterButton = 'assets/images/social-buttons/twitter-dark.png';
  final String igButton = 'assets/images/social-buttons/ig-dark.png';
  final String addMyAd3yah = 'assets/icons/${prefix}addDo3aa.png';
}
