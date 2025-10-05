import 'package:todos_app/constant/colors.dart';
import 'package:todos_app/provider/user_provider.dart';
import 'package:todos_app/screen/screen_home.dart';
import 'package:todos_app/screen/screen_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

BottomNavigationBar buildBottomNav({required dynamic context, required double iconSize, required double labelSize, required int selectedIndex}) {
  return BottomNavigationBar(
    onTap: (index) {
      handleNavigation(context, index);
      selectedIndex = index;
    },

    backgroundColor: AppColors.primary,
    selectedItemColor: AppColors.white,
    unselectedItemColor: AppColors.white,
    type: BottomNavigationBarType.fixed,
    iconSize: iconSize,
    selectedLabelStyle: TextStyle(fontSize: labelSize),
    unselectedLabelStyle: TextStyle(fontSize: labelSize),
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
    ],

    currentIndex: selectedIndex,
  );
}

void handleNavigation(context, index) {
  final int uid = Provider.of<UserProvider>(context, listen: false).uid;

  Widget page;
  switch (index) {
    case 0:
      page = Home();
      break;
    case 1:
      page = Profile(uid: uid);
      break;
    default:
      return;
  }

  Navigator.push(
    context,
    PageRouteBuilder(
      // If you don’t touch context, animation, or secondaryAnimation, the underscore placeholders are fine
      pageBuilder: (_, __, ___) => page,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    ),
  );
}
