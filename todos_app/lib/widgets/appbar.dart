import 'package:todos_app/constant/colors.dart';
import 'package:flutter/material.dart';

PreferredSize appBar(BuildContext context, int type) {
  final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

  return type == 1
      ? PreferredSize(
          preferredSize: Size.fromHeight(MediaQuery.of(context).padding.top),
          child: Container(
            color: AppColors.primary, // Status bar color
            child: SafeArea(
              bottom: false, // Only affect the top (status bar)
              child: SizedBox.shrink(), // No actual AppBar content
            ),
          ),
        )
      : PreferredSize(
          preferredSize: Size.fromHeight(isTablet ? 80.0 : 56.0),
          child: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, size: isTablet ? 35 : 22),
              color: AppColors.white,
              onPressed: () => Navigator.pop(context),
            ),
          ),
        );
}
