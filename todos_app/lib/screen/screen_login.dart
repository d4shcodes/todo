import 'dart:convert';

import 'package:todos_app/constant/colors.dart';
import 'package:todos_app/constant/taxonomy.dart';
import 'package:todos_app/screen/screen_home.dart';
import 'package:todos_app/services/auth_service.dart';
import 'package:todos_app/utils/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:todos_app/widgets/button.dart';
import 'package:todos_app/widgets/textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final unameController = TextEditingController();
  final pwdController = TextEditingController();

  login(context) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: Transform.scale(scale: MediaQuery.of(context).size.width * 0.0018, child: CircularProgressIndicator()),
      ),
    );

    var data = {'username': unameController.text, 'password': pwdController.text};
    var res = await CallAPI().postData(data, 'login');

    Navigator.pop(context); // Dismiss dialog

    if (res.statusCode == 200) {
      var body = json.decode(res.body);

      SharedPreferences preferences = await SharedPreferences.getInstance();

      preferences.setInt('id', body['id']);
      preferences.setString('name', body['username']);

      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Home()), (Route<dynamic> route) => false);
    } else if ((res.statusCode == 401)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid credentials', style: AppTypography.labelMedium.copyWith(color: AppColors.white)),
          backgroundColor: AppColors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final double padding = isTablet ? 40 : 20;

    return CustomWrapper(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),

              SizedBox(height: isTablet ? 350 : 250, width: isTablet ? 350 : 250, child: Image.asset('assets/images/login-img.png')),
              Padding(
                padding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('WELCOME BACK !', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w800)),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Text('Please enter your credentials', style: AppTypography.labelSmall.copyWith(color: AppColors.gray)),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    textField(false, false, 'Username', unameController, 1, null, TextInputType.text),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    textField(true, false, 'Password', pwdController, 1, null, TextInputType.text),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    SizedBox(
                      width: double.infinity,
                      child: button('Log in', AppColors.primary, Colors.white, () {
                        login(context);
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
