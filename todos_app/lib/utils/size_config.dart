import 'package:flutter/widgets.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;

  static late double blockWidth;
  static late double blockHeight;

  static late bool isMobile;
  static late bool isTablet;
  static late bool isDesktop;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;

    blockWidth = screenWidth / 100;
    blockHeight = screenHeight / 100;

    isMobile = screenWidth < 600;
    isTablet = screenWidth >= 600 && screenWidth < 1024;
    isDesktop = screenWidth >= 1024;
  }

  // Font size multiplier based on screen width
  static double scaleText(double size) {
    return blockWidth * (size / 3);
  }

  static double getProportionalWidth(double inputWidth) {
    return (inputWidth / 375.0) * screenWidth;
  }

  static double getProportionalHeight(double inputHeight) {
    return (inputHeight / 812.0) * screenHeight;
  }
}
