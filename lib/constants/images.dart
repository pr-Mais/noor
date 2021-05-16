class Images {
  static LightAppImages get light => LightAppImages();
  static DarkAppImages get dark => DarkAppImages();

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

  final String copyIcon = 'assets/icons/copy.png';
  final String editeIcon = 'assets/icons/edite.png';
  final String eraseIcon = 'assets/icons/erase.png';
  final String outlineHeartIcon = 'assets/icons/outline_heart.png';
  final String filledHeartIcon = 'assets/icons/filled_heart.png';
  final String referenceIcon = 'assets/icons/back.png';
  final String generalNotificationsIcons = '';
}

class LightAppImages extends Images {
  // Categories icons
  final String athkarIcon = 'assets/coloredLeaf.png';
  final String quraanIcon = 'assets/icons/ad3yah/1.png';
  final String sunnahIcon = 'assets/icons/ad3yah/2.png';
  final String ruqyaIcon = 'assets/icons/ad3yah/3.png';
  final String myAd3yahIcon = 'assets/icons/ad3yah/4.png';
  final String allahNamesIcon = 'assets/icons/allahNames.png';
  // Home assets
  final String homeHeader = 'assets/headerLight.png';
  final String athkarCard = 'assets/home-cards/light/Athkar.png';
  final String ad3yahCard = 'assets/home-cards/light/Ad3yah.png';
  final String allahNamesCard = 'assets/home-cards/light/AllahNames.png';
  // Backgrounds
  final String noAd3yah = 'assets/backgrounds/NoAd3yah.png';
  final String noAd3yahFav = 'assets/backgrounds/NoAd3yahFav.png';
  final String myAd3yahBg = 'assets/backgrounds/myAd3yahBg.svg';
  // Buttons
  final String twitterButton = 'assets/social-buttons/twitter-light.png';
  final String igButton = 'assets/social-buttons/ig-light.png';
  final String addMyAd3yah = 'assets/icons/addDo3aa.png';
  // Icons
  @override
  get generalNotificationsIcons => 'assets/icons/generalNotificationsLight.png';
}

class DarkAppImages extends Images {
  // Categories icons
  final String athkarIcon = 'assets/titleLeafNight.png';
  final String quraanIcon = 'assets/icons/ad3yah/1-night.png';
  final String sunnahIcon = 'assets/icons/ad3yah/2-night.png';
  final String ruqyaIcon = 'assets/icons/ad3yah/3-night.png';
  final String myAd3yahIcon = 'assets/icons/ad3yah/4-night.png';
  final String allahNamesIcon = 'assets/icons/allahNamesDark.png';
  // Home assets
  final String homeHeader = 'assets/headerDark.png';
  final String athkarCard = 'assets/home-cards/dark/Athkar.png';
  final String ad3yahCard = 'assets/home-cards/dark/Ad3yah.png';
  final String allahNamesCard = 'assets/home-cards/dark/AllahNames.png';
  // Backgrounds
  final String noAd3yah = 'assets/backgrounds/NoAd3yahNight.png';
  final String noAd3yahFav = 'assets/backgrounds/NoAd3yahFavNight.png';
  final String myAd3yahBg = 'assets/backgrounds/myAd3yahBgDark.svg';
  // Buttons
  final String twitterButton = 'assets/social-buttons/twitter-dark.png';
  final String igButton = 'assets/social-buttons/ig-dark.png';
  final String addMyAd3yah = 'assets/icons/addDo3aa.png';
  // Icons
  get generalNotificationsIcons => 'assets/icons/generalNotificationsDark.png';
}
