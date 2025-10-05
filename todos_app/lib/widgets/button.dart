import 'package:flutter/material.dart';
import 'package:todos_app/constant/taxonomy.dart';

ElevatedButton button(text, bgColor, textColor, func) {
  return ElevatedButton(
    onPressed: func,
    style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(bgColor)),
    child: Padding(
      padding: EdgeInsets.all(10),
      child: Text(text, style: AppTypography.labelSmall.copyWith(color: textColor)),
    ),
  );
}
