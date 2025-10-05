import 'package:flutter/material.dart';
import 'package:todos_app/constant/colors.dart';
import 'package:todos_app/utils/size_config.dart';

class AppTypography {
  // Headline
  static TextStyle get headlineLarge => TextStyle(fontSize: SizeConfig.scaleText(32), color: AppColors.black);

  static TextStyle get headlineMedium => TextStyle(fontSize: SizeConfig.scaleText(28), color: AppColors.black);

  static TextStyle get headlineSmall => TextStyle(fontSize: SizeConfig.scaleText(24), color: AppColors.black);

  static TextStyle get headlineSupersmall => TextStyle(fontSize: SizeConfig.scaleText(20), color: AppColors.black);

  // Title
  static TextStyle get titleLarge => TextStyle(fontSize: SizeConfig.scaleText(22), color: AppColors.black);

  static TextStyle get titleMedium => TextStyle(fontSize: SizeConfig.scaleText(16), color: AppColors.black);

  static TextStyle get titleSmall => TextStyle(fontSize: SizeConfig.scaleText(14), color: AppColors.black);

  static TextStyle get titleSupersmall => TextStyle(fontSize: SizeConfig.scaleText(12), color: AppColors.black);

  // Body
  static TextStyle get bodyLarge => TextStyle(fontSize: SizeConfig.scaleText(16), color: AppColors.black);

  static TextStyle get bodyMedium => TextStyle(fontSize: SizeConfig.scaleText(14), color: AppColors.black);

  static TextStyle get bodySmall => TextStyle(fontSize: SizeConfig.scaleText(12), color: AppColors.black);

  static TextStyle get bodySupersmall => TextStyle(fontSize: SizeConfig.scaleText(10), color: AppColors.black);

  // Label
  static TextStyle get labelLarge => TextStyle(fontSize: SizeConfig.scaleText(14), color: AppColors.black);

  static TextStyle get labelMedium => TextStyle(fontSize: SizeConfig.scaleText(12), color: AppColors.black);

  static TextStyle get labelSmall => TextStyle(fontSize: SizeConfig.scaleText(11), color: AppColors.black);

  static TextStyle get labelSupersmall => TextStyle(fontSize: SizeConfig.scaleText(9), color: AppColors.black);
}
