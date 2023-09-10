import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/manger/themes.dart';
import 'package:tv/models/assets.dart';
import 'package:tv/models/extensions.dart';
import 'package:tv/models/input_style.dart';
import 'package:tv/utils/utils.dart';

import '../models/lang.dart';

class SignIn extends StatefulWidget {
  final Object? message;

  const SignIn({Key? key, this.message}) : super(key: key);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey();

  late String email;
  late String password;
  bool isShowPassword = false;
  @override
  @override
  void initState() {
    // #: implement initState
    super.initState();
    if (widget.message != null) {
      Future.delayed(const Duration(seconds: 1), () {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            backgroundColor: Theme.of(context).canvasColor,
            title: Text('Done Successfully',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 18)),
            content: Text(
              'Account created successfully, Your account in now under review',
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 18),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                ),
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text(
                  "OK",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          child: Column(
            children: [
              Center(
                  child: Container(
                      constraints: const BoxConstraints(
                        maxWidth: 400,
                      ),
                      child: Column(children: [
                        // Image.asset(
                        //   Assets.shared.icLogo,
                        //   fit: BoxFit.cover,
                        //   height:
                        //       MediaQuery.of(context).size.height * (250 / 812),
                        // ),
                        FlutterLogo(
                          size:
                              MediaQuery.of(context).size.height * (250 / 812),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(children: [
                            Column(
                              children: [
                                TextFormField(
                                  onSaved: (value) => email = value!.trim(),
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  decoration: customInputForm
                                      .copyWith(
                                          prefixIcon: Icon(
                                            Icons.email_outlined,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          fillColor:
                                              Theme.of(context).canvasColor)
                                      .copyWith(
                                          hintText: AppLocalization.of(context)!
                                              .trans("Email")),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  onSaved: (value) => password = value!.trim(),
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  obscureText: !isShowPassword,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  decoration: customInputForm
                                      .copyWith(
                                          prefixIcon: Icon(
                                            Icons.lock_outline,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          fillColor:
                                              Theme.of(context).canvasColor)
                                      .copyWith(
                                          hintText: AppLocalization.of(context)!
                                              .trans("Password"))
                                      .copyWith(
                                          suffixIcon: GestureDetector(
                                        onTap: () => setState(() {
                                          isShowPassword = !isShowPassword;
                                        }),
                                        child: Container(
                                            padding: const EdgeInsets.all(10),
                                            child: SvgPicture.asset(
                                              isShowPassword
                                                  ? Assets.shared.icInvisible
                                                  : Assets.shared.icVisibility,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              height: 5,
                                              width: 5,
                                            )),
                                      )),
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                ElevatedButton(
                                    // elevation: 20,
                                    // focusElevation: 20,
                                    // hoverElevation: 20,
                                    // highlightElevation: 20,
                                    // disabledElevation: 0,
                                    // shape: StadiumBorder(),
                                    // color: Theme.of(context).primaryColor,
                                    style: ElevatedButton.styleFrom(
                                      elevation: 20,
                                      shape: const StadiumBorder(),
                                      primary: Theme.of(context).canvasColor,
                                    ),
                                    child: Text(
                                        AppLocalization.of(context)!
                                            .trans("Sign In"),
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                        )),
                                    onPressed: _btnSignin),
                                Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    TextButton(
                                        onPressed: () => Navigator.pushNamed(
                                            context, '/ForgotPassword'),
                                        child: Text(
                                          AppLocalization.of(context)!
                                              .trans("Forgot Password?"),
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const SizedBox(height: 1),
                                    TextButton(
                                        onPressed: () => Navigator.pushNamed(
                                            context, '/SignUp'),
                                        child: Text(
                                          AppLocalization.of(context)!
                                              .trans("Create new account"),
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )),
                                  ],
                                ),
                                FlutterSwitch(
                                  height: 20.0,
                                  width: 40.0,
                                  padding: 4.0,
                                  toggleSize: 15.0,
                                  borderRadius: 10.0,
                                  //  activeColor: Colors.accents,
                                  value: isFirebaseDown,
                                  onToggle: (value) {
                                    setState(() {
                                      isFirebaseDown = value;
                                      checkFirebaseDown(context);
                                    });
                                  },
                                ),
                                const SizedBox(height: 10),
                                FlutterSwitch(
                                  height: 20.0,
                                  width: 40.0,
                                  padding: 4.0,
                                  toggleSize: 15.0,
                                  borderRadius: 10.0,
                                  //  activeColor: Colors.accents,
                                  value: Provider.of<CustomTheme>(context)
                                      .isDarkMode,
                                  onToggle: (value) {
                                    setState(() {
                                      // isDarkMode = value;
                                      Provider.of<CustomTheme>(context,
                                              listen: false)
                                          .toggleDarkMode();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ]),
                        )
                      ])))
            ],
          ),
        ),
      ),
    );
  }

  bool _validation() {
    return !(email == "" || password == "");
  }

  _btnSignin() {
    _formKey.currentState!.save();
    //print("sign in !!!!");

    if (!_validation()) {
      _scaffoldKey.showTosta(
          message:
              AppLocalization.of(context)!.trans("Please fill in all fields2"),
          isError: true);
      return;
    }

    //print("sign in 2 !!!!");

    FirebaseManager.shared
        .login(scaffoldKey: _scaffoldKey, email: email, password: password);
  }
}
