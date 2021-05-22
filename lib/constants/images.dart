import 'package:noor/main.dart';

const String iconsFolder = placeholder ? 'icons_placeholder' : 'icons';
const String imagesFolder = placeholder ? 'images_placeholder' : 'images';

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

  final String generalNotificationsIcon = '';

  // Bellow images aren't tied to theme mode
  // So they can be static and accessed directly
  static String cloutTop = 'assets/$imagesFolder/home-header/cloud-top.png';
  static String cloudBottom =
      'assets/$imagesFolder/home-header/cloud-bottom.png';
  static String circleStar = 'assets/$imagesFolder/home-header/circle_star.png';
  static String star = 'assets/$imagesFolder/home-header/star.png';

  static String copyIcon = 'assets/$iconsFolder/copy.png';
  static String editeIcon = 'assets/$iconsFolder/edite.png';
  static String eraseIcon = 'assets/$iconsFolder/erase.png';
  static String outlineHeartIcon = 'assets/$iconsFolder/outline_heart.png';
  static String filledHeartIcon = 'assets/$iconsFolder/filled_heart.png';
  static String referenceIcon = 'assets/$iconsFolder/back.png';

  static String athkarTitleLeaf = 'assets/$imagesFolder/athkar-title-leaf.png';
  static String allahNameTitleLeaf =
      'assets/$imagesFolder/allah-name-title-leaf.png';
  static String titleBg = 'assets/$imagesFolder/title-bg.png';

  static String allFavIcon = 'assets/$iconsFolder/fav/all.png';
  static String athkarFavIcon = 'assets/$iconsFolder/fav/athkar.png';
  static String quraanFavIcon = 'assets/$iconsFolder/fav/quraan.png';
  static String sunnahFavIcon = 'assets/$iconsFolder/fav/sunnah.png';
  static String ruqyaFavIcon = 'assets/$iconsFolder/fav/ruqiya.png';
  static String myAd3yahFavIcon = 'assets/$iconsFolder/fav/myAd3yah.png';
  static String allahNamesFavIcon = 'assets/$iconsFolder/fav/allahNames.png';

  static String allFavBtn = 'assets/$imagesFolder/fav-buttons/all.png';
  static String athkarFavBtn = 'assets/$imagesFolder/fav-buttons/athkar.png';
  static String quraanFavBtn = 'assets/$imagesFolder/fav-buttons/quraan.png';
  static String sunnahFavBtn = 'assets/$imagesFolder/fav-buttons/sunnah.png';
  static String ruqyaFavBtn = 'assets/$imagesFolder/fav-buttons/ruqiya.png';
  static String myAd3yahFavBtn =
      'assets/$imagesFolder/fav-buttons/myAd3yah.png';
  static String allahNamesFavBtn =
      'assets/$imagesFolder/fav-buttons/allahNames.png';

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
  final String logo = 'assets/$imagesFolder/logo-light.svg';

  // Categories icons
  final String athkarTitleIcon = 'assets/$iconsFolder/titles/athkar.png';
  final String quraanTitleIcon = 'assets/$iconsFolder/titles/quraan.png';
  final String sunnahTitleIcon = 'assets/$iconsFolder/titles/sunnah.png';
  final String ruqyaTitleIcon = 'assets/$iconsFolder/titles/ruqiya.png';
  final String myAd3yahTitleIcon = 'assets/$iconsFolder/titles/myAd3yah.png';
  final String allahNamesTitleIcon =
      'assets/$iconsFolder/titles/allah-names.png';
  // Home assets
  final String homeHeader = 'assets/$imagesFolder/home-header/header-light.png';
  final String athkarCard = 'assets/$imagesFolder/home-cards/light/Athkar.png';
  final String ad3yahCard = 'assets/$imagesFolder/home-cards/light/Ad3yah.png';
  final String allahNamesCard =
      'assets/$imagesFolder/home-cards/light/AllahNames.png';
  // Backgrounds
  final String noAd3yah = 'assets/$imagesFolder/backgrounds/NoAd3yah.png';
  final String noAd3yahFav = 'assets/$imagesFolder/backgrounds/NoAd3yahFav.png';
  final String myAd3yahBg = 'assets/$imagesFolder/backgrounds/myAd3yahBg.svg';
  // Buttons
  final String twitterButton =
      'assets/$imagesFolder/social-buttons/twitter-light.png';
  final String igButton = 'assets/$imagesFolder/social-buttons/ig-light.png';
  final String addMyAd3yah = 'assets/$iconsFolder/addDo3aa.png';
  // Icons
  final String generalNotificationsIcon = 'assets/icons/general_noti_light.png';
}

class DarkAppImages extends Images {
  final String logo = 'assets/$imagesFolder/logo-dark.svg';

  // Categories icons
  final String athkarTitleIcon = 'assets/$iconsFolder/titles/athkar-dark.png';
  final String quraanTitleIcon = 'assets/$iconsFolder/titles/quraan-dark.png';
  final String sunnahTitleIcon = 'assets/$iconsFolder/titles/sunnah-dark.png';
  final String ruqyaTitleIcon = 'assets/$iconsFolder/titles/ruqiya-dark.png';
  final String myAd3yahTitleIcon =
      'assets/$iconsFolder/titles/myAd3yah-dark.png';
  final String allahNamesTitleIcon =
      'assets/$iconsFolder/titles/allah-names-dark.png';
  // Home assets
  final String homeHeader = 'assets/$imagesFolder/home-header/header-dark.png';
  final String athkarCard = 'assets/$imagesFolder/home-cards/dark/Athkar.png';
  final String ad3yahCard = 'assets/$imagesFolder/home-cards/dark/Ad3yah.png';
  final String allahNamesCard =
      'assets/$imagesFolder/home-cards/dark/AllahNames.png';
  // Backgrounds
  final String noAd3yah = 'assets/$imagesFolder/backgrounds/NoAd3yahNight.png';
  final String noAd3yahFav =
      'assets/$imagesFolder/backgrounds/NoAd3yahFavNight.png';
  final String myAd3yahBg =
      'assets/$imagesFolder/backgrounds/myAd3yahBgDark.svg';
  // Buttons
  final String twitterButton =
      'assets/$imagesFolder/social-buttons/twitter-dark.png';
  final String igButton = 'assets/$imagesFolder/social-buttons/ig-dark.png';
  final String addMyAd3yah = 'assets/$iconsFolder/addDo3aa.png';
  // Icons
  final String generalNotificationsIcon = 'assets/icons/general_noti_dark.png';
}
