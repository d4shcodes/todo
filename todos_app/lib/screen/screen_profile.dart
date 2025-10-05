import 'dart:convert';

import 'package:todos_app/services/cache_service.dart';
import 'package:todos_app/services/user_service.dart';
import 'package:todos_app/utils/wrapper.dart';
import 'package:todos_app/widgets/appbar.dart';
import 'package:todos_app/constant/colors.dart';
import 'package:todos_app/constant/taxonomy.dart';
import 'package:todos_app/screen/screen_login.dart';
import 'package:todos_app/utils/responsive_builder.dart';
import 'package:todos_app/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:todos_app/utils/bottom_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  final int uid;

  const Profile({super.key, required this.uid});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isLoading = false;
  Map userData = {};

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  logout(context) async {
    final preferences = await SharedPreferences.getInstance();

    preferences.clear();

    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => Login()), (Route<dynamic> route) => false);
  }

  loadProfile() async {
    setState(() => isLoading = true);

    final data = await CacheManager.fetchWithCache(
      key: 'user_details_${widget.uid}',
      apiCall: () async {
        final res = await UserService().getDetails(widget.uid);
        return json.decode(res.body);
      },
    );

    setState(() {
      userData = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.of(context).size.width * 0.04;
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return CustomWrapper(
      child: Scaffold(
        appBar: appBar(context, 1),
        body: SafeArea(
          child: isLoading || userData.isEmpty
              ? Center(
                  child: Transform.scale(scale: MediaQuery.of(context).size.width * 0.0018, child: CircularProgressIndicator()),
                )
              : SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(pad),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('MY PROFILE', style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w900)),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipOval(
                              child: Image.asset(
                                'assets/images/kermit.jpeg',
                                width: isTablet ? 135 : 110,
                                height: isTablet ? 135 : 110,
                                fit: BoxFit.fill,
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                            Text(userData['username'] ?? '', style: AppTypography.titleSupersmall, textAlign: TextAlign.center),
                          ],
                        ),
                      ),

                      SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                      Divider(thickness: 1, color: AppColors.gray),

                      SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                      profileInfo('FULL NAME', userData['fullName'] ?? '-', context),

                      profileInfo('ROLE', userData['role'] ?? '-', context),

                      profileInfo('HP NO :', userData['phoneNumber'] ?? '-', context),

                      profileInfo('ACCONT TYPE :', userData['accountType']?.toString() ?? '-', context),

                      SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                      SizedBox(
                        width: double.infinity,
                        child: button('Log out', AppColors.red, Colors.white, () {
                          logout(context);
                        }),
                      ),
                    ],
                  ),
                ),
        ),

        bottomNavigationBar: ResponsiveBuilder(
          mobile: buildBottomNav(context: context, iconSize: 24, labelSize: 12, selectedIndex: 1),
          tablet: buildBottomNav(context: context, iconSize: 42, labelSize: 24, selectedIndex: 1),
        ),
      ),
    );
  }

  Column profileInfo(String label, String info, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.titleSupersmall.copyWith(fontWeight: FontWeight.w900)),
        Text(info, style: AppTypography.titleSupersmall),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
      ],
    );
  }
}
