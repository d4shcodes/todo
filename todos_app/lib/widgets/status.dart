import 'package:todos_app/constant/taxonomy.dart';
import 'package:flutter/material.dart';

Scaffold customScaffold(src, desc) {
  return Scaffold(
    body: SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(src),
            Text(desc, style: AppTypography.labelMedium, textAlign: TextAlign.center),
          ],
        ),
      ),
    ),
  );
}
