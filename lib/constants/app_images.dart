abstract class AppImages {
  // base images directories
  static const String _baseImagesDirectory = 'assets/images';
  static const String _generalImagesDirectory =
      '$_baseImagesDirectory/general_images';
  static const String _alertsImagesDirectory =
      '$_baseImagesDirectory/alerts_images';
  // general images
  static const String logo = '$_generalImagesDirectory/app-logo.png';
  static const String cover = '$_generalImagesDirectory/cover.jpg';

  // --> bottom bar images
  static const String homeBottomBarIcon =
      '$_baseImagesDirectory/bottom_bar_images/home.svg';
  static const String notificationBottomBarIcon =
      '$_baseImagesDirectory/bottom_bar_images/notification.svg';
  static const String moreBottomBarIcon =
      '$_baseImagesDirectory/bottom_bar_images/menu.svg';

  // for alerts messages
  static const String alertsBack = '$_alertsImagesDirectory/back.svg';
  static const String alertsBubbles = '$_alertsImagesDirectory/bubbles.svg';
  static const String alertsFailure = '$_alertsImagesDirectory/failure.svg';
  static const String alertsHelp = '$_alertsImagesDirectory/help.svg';
  static const String alertsSuccess = '$_alertsImagesDirectory/success.svg';
  static const String alertsWarning = '$_alertsImagesDirectory/warning.svg';
}
