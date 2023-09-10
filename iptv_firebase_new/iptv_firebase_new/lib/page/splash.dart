import 'package:flutter/material.dart';
import 'package:tv/main.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/manger/language.dart';
import 'package:tv/utils/utils.dart';
import 'package:tv/manger/status.dart';
import 'package:tv/models/user-model.dart';
import 'package:tv/models/user_profile.dart';

// ignore: use_key_in_widget_constructors
class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // #: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      _wrapper();
    });
  }

  @override
  Widget build(BuildContext context) {
    //print("Splash 1 ");
    return Scaffold(
      body: const Center(
        child:
            // Image.asset(
            //   Assets.shared.icLogo,
            //   width: 225,
            //   height: 225,
            //   fit: BoxFit.cover,
            //   color: Theme.of(context).canvasColor,
            // ),
            FlutterLogo(
          size: 225,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Text(
          "Flutter",
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18),
        ),
      ),
    );
  }

  _wrapper() async {
    await UserProfile.shared.getLanguage().then((lang) {
      MyApp.setLocale(context, Locale(lang == Language.ARABIC ? "ar" : "en"));
    });
    UserModel? user;
    await UserProfile.shared.getUser().then((value) {
      if (value == null) {
        return;
      } else {
        user = value;
      }
    });

    //print("user is null ?? ");

    if (user != null) {
      FirebaseManager.shared.getUserByUid(uid: user!.uid!).then((user) {
        if (user.accountStatus == Status.ACTIVE) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              "/TabBarPage", (route) => false,
              arguments: user.userType);
        } else {
          Navigator.of(context)
              .pushNamedAndRemoveUntil("/SignIn", (route) => false);
        }
      });
    } else {
      if (!isFirebaseDown) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/SignIn", (route) => false);
      } else {
        FirebaseManager.shared.getUserByUid(uid: "xxx").then((user) {
          // print("2 what is user's status : " + user.accountStatus.toString());
          if (user.accountStatus == Status.ACTIVE) {
            UserProfile.shared.setUser(user: user);
            Navigator.of(context).pushNamedAndRemoveUntil(
                "/TabBarPage", (route) => false,
                arguments: user.userType);
          } else {
            Navigator.of(context)
                .pushNamedAndRemoveUntil("/SignIn", (route) => false);
          }
        });
      }
    }
  }
}
