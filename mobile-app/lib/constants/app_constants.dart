import 'dart:io';

import 'package:app/config/env.dart';
import 'package:app/models/site.dart';
import 'package:flutter/material.dart';

class AppConfig {
  static final String _androidApiKey = googleKey;

  static final String _iOSApiKey = iosKey;

  static final String googleApiKey =
      Platform.isAndroid ? _androidApiKey : _iOSApiKey;

  static final String airQoApiKey = airqoApiKey;

  static String get dbName => databaseName;

  static double get defaultLatitude => defaultLatitudeValue;

  static double get defaultLongitude => defaultLongitudeValue;

  static int get maxSearchRadius => searchRadius * 2;

  static String get name => applicationName;

  static int get searchRadius => defaultSearchRadius;

  static String get version => applicationVersion;
}

class CloudStorage {
  static String get alertsCollection => alertsDb;
}

class ColorConstants {
  static Color get appBarBgColor => Colors.white;

  static Color get appBarTitleColor => appColor;

  static Color get appBodyColor => Colors.white;

  static Color get appColor => const Color(0xff3067e2);

  static Color get facebookColor => const Color(0xff4267B2);

  static Color get green => const Color(0xff3FFF33);

  static Color get inactiveColor => appColor.withOpacity(0.5);

  static Color get linkedInColor => const Color(0xff2867B2);

  static Color get maroon => const Color(0xff570B0B);

  static Color get orange => const Color(0xffFF9633);

  static Color get purple => const Color(0xFF7B1FA2);

  static Color get red => const Color(0xffF62E2E);

  static Color get snackBarBgColor => appColor.withOpacity(0.8);

  static Color get twitterColor => const Color(0xff1DA1F2);

  static Color get yellow => const Color(0xffFFF933);

  static Color get youtubeColor => const Color(0xffFF0000);
}

class ErrorMessages {
  static String get appException => 'Failed to your request. Try again later';

  static String get socketException => 'No internet connection available';

  static String get timeoutException => 'No internet connection available';
}

enum Languages { english, luganda }

class Links {
  static String get aboutUsUrl => about;

  static String get airqoFeedbackEmail => feedbackEmail;

  static String get blogUrl => airqoBlog;

  static String get contactUsUrl => contactUs;

  static String get epaUrl => epaReference;

  static String get facebookUrl => facebook;

  static String get faqsUrl => faqs;

  static String get iOSUrl => iOSLink;

  static String get linkedinUrl => linkedin;

  static String get playStoreUrl => playStoreLink;

  static String get referenceUrl => airqoReference;

  static String get termsUrl => terms;

  static String get twitterUrl => twitter;

  static String get websiteUrl => airqoWebsite;

  static String get whoUrl => whoReference;

  static String get youtubeUrl => youtube;
}

class NotificationConfig {
  static const int persistentNotificationId = 1294732;
  static const int progressNotificationId = 482842;
  static const int pushNotificationId = 9239203;
  static const int smartNotificationId = 4877231;
}

class PollutantBio {
  static String get humidity => 'Relative humidity is the amount of water '
      'vapor actually in the air, expressed as a percentage of the maximum '
      'amount of water vapor the air can hold at the same temperature. '
      '\n\nThink of the air at a chilly -10 degrees Celsius '
      '(14 degrees Fahrenheit). At that temperature, the air can hold,'
      ' at most, 2.2 grams of water per cubic meter. So if there are 2.2'
      ' grams of water per cubic meter when its -10 degrees Celsius outside, '
      'we are at an uncomfortable 100 percent relative humidity. If there was'
      ' 1.1 grams of water in the air at -10 degrees Celsius, '
      'we are at 50 percent relative humidity.';

  static String get pm10 => 'PM10 are pollutants that have a diameter of '
      '10 micrometers (0.01 mm) or smaller; they can be found '
      'in dust and smoke and can penetrate and lodge deep inside the'
      ' lungs. They are even more health-damaging particles than'
      ' the PM2.5  pollutants.';

  static String get pm2_5 => 'PM2.5 are pollutants that have a diameter '
      'of 2.5 micrometers (20-30 times smaller than the thickness of'
      ' human hair). They are very small particles usually '
      'found in smoke. PM2.5 '
      'particles are small enough for you to breathe and '
      'can penetrate the lung barrier and enter the blood system.'
      ' Prolonged exposure to particles contributes to the risk of '
      'developing cardiovascular and respiratory diseases, '
      'as well as lung cancer.';

  static String get temperature => 'Temperature is the degree of hotness or'
      ' coldness of an object. When we talk about something feeling hot '
      '(like the soup we drink when were sick) or cold (like the snow, '
      'especially if youre not wearing gloves), '
      'were talking about temperature.';
}

class PollutantConstant {
  static String get pm10 => 'pm10';

  static String get pm2_5 => 'pm2_5';
}

class PollutantDescription {
  static String get pm10 => 'PM\u2081\u2080 are pollutants that have a diameter'
      ' of 10 micrometers (0.01 mm) or smaller.'
      '\n\n'
      'They can be found in smoke, dust, soot, salts, acids, dust '
      'from unpaved roads, and metals and can penetrate and '
      'lodge deep inside the lungs. They are even more'
      ' health-damaging particles than the PM2.5  pollutants. '
      '\n\n'
      'PM\u2081\u2080 can penetrate and lodge deep inside the lungs and is'
      ' associated with adverse health impacts, '
      'such as lung tissue damage and asthma.';

  static String get pm2_5 => 'PM2.5 are pollutants that have'
      ' a diameter of '
      '2.5 micrometers (20-30 times smaller than the thickness of human hair).'
      '\n\n'
      'They are very small particles usually found in smoke from car exhausts,'
      ' crop burning, garbage burning,industrial processes,'
      ' road construction. stoves, fireplaces, and home wood burning'
      '\n\n'
      'PM2.5 particles are small enough for you to breathe and can'
      ' penetrate the lung barrier and enter the blood system. '
      'Exposure to fine particles can cause short-term health effects'
      ' such as eye, nose, throat and lung irritation, coughing, '
      'sneezing, runny nose and shortness of breath. Prolonged '
      'exposure to particles contributes to the risk of developing '
      'cardiovascular and respiratory diseases, as well as lung cancer.';
}

enum PollutantLevel {
  good,
  moderate,
  sensitive,
  unhealthy,
  veryUnhealthy,
  hazardous
}

class PrefConstant {
  static String get appTheme => 'appTheme';

  static String get dashboardSite => 'dashboardSite';

  static String get favouritePlaces => 'favouriteSites';

  static String get firstUse => 'firstUse';

  static String get initialDbLoad => 'initialDbLoad';

  static String get lastKnownLocation => 'lastKnownLocation';

  static String get reLoadDb => 'reloadDb';

  static String get siteAlerts => 'siteAlerts';
}

enum Status { none, running, stopped, paused }

enum Themes { lightTheme, darkTheme }

extension ParsePollutantLevel on PollutantLevel {
  String getString() {
    return toString().split('.').last;
  }

  String getTopic(Site site, PollutantLevel pollutantLevel) {
    if (pollutantLevel == PollutantLevel.good) {
      return '${site.id}-good';
    } else if (pollutantLevel == PollutantLevel.moderate) {
      return '${site.id}-moderate';
    } else if (pollutantLevel == PollutantLevel.sensitive) {
      return '${site.id}-sensitive';
    } else if (pollutantLevel == PollutantLevel.unhealthy) {
      return '${site.id}-unhealthy';
    } else if (pollutantLevel == PollutantLevel.veryUnhealthy) {
      return '${site.id}-very-unhealthy';
    } else if (pollutantLevel == PollutantLevel.hazardous) {
      return '${site.id}-hazardous';
    }
    return '';
  }

  List<PollutantLevel> getPollutantLevels() {
    var pollutants = <PollutantLevel>[
      PollutantLevel.good,
      PollutantLevel.moderate,
      PollutantLevel.sensitive,
      PollutantLevel.unhealthy,
      PollutantLevel.veryUnhealthy,
      PollutantLevel.hazardous
    ];

    return pollutants;
  }
}
