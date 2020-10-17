import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mntd_pass_lite/models/secret.dart';
import 'package:jiffy/jiffy.dart' as jiffy;

class Environment {
  static String apiUrl = Platform.isAndroid
      ? 'http://kenri-mntd-pass-api.herokuapp.com'
      : 'http://kenri-mntd-pass-api.herokuapp.com';

  static String getTimeStamp(Secret secret) {
    var jiffy1 = jiffy.Jiffy(secret.createdAt);
    var jiffy2 = jiffy.Jiffy(DateTime.now().toIso8601String());
    return secret.createdAt == null ? jiffy2.fromNow() : jiffy1.fromNow();
  }

  static List<String> menuItems = ["secrets", "home"];
}

class GFColors {
  static const Color PRIMARY = Color(0xffbee3f8);
  static const Color SECONDARY = Color(0xffAA66CC);
  static const Color SUCCESS = Color(0xff10DC60);
  static const Color INFO = Color(0xff33B5E5);
  static const Color WARNING = Color(0xffFFBB33);
  static const Color DANGER = Color(0xffF04141);
  static const Color LIGHT = Color(0xffE0E0E0);
  static const Color DARK = Color(0xff222428);
  static const Color WHITE = Color(0xffffffff);
  static const Color FOCUS = Color(0xff434054);
  static const Color ALT = Color(0xff794c8a);
  static const Color TRANSPARENT = Colors.transparent;
  static const kPrimarySpotifyLightColor = Color(0xFFF1E6FF);
  static const kPrimarySpotify800Color = Color(0xFF181818);
  static Color kPrimarySpotify400Color = Colors.grey[600];
  static const kPrimarySpotify700Color = Color(0xFF282828);
  static const kPrimarySpotifyButtomColor = Color(0xFF38a169);
  static const kPrimarySpotifyLabels = Color(0xFF38a169);
  static Color colorPrimary400 = Colors.grey[400];
  static Color colorPrimary200 = Colors.grey[200];
  static Color colorPrimary900 = Colors.grey[900];
  static Color colorBtnPrimary600 = Colors.grey[600];
}
