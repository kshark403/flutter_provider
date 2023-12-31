import 'package:flutter/material.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/models/extensions.dart';
import 'package:tv/models/input_style.dart';
import '../models/lang.dart';

class Signup extends StatefulWidget {
  @override
  const Signup({
    Key? key,
  }) : super(key: key);
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey();

  late String username;
  late String email;
  late String password;
  late String city;
  late String phoneNumber;
  bool agreeToPrivacy = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Center(
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 400,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 1),
                      // MediaQuery.of(context).size.height * (60 / 812)),
                      // Image.asset(
                      //   Assets.shared.icLogo,
                      //   fit: BoxFit.cover,
                      //   height:
                      //       MediaQuery.of(context).size.height * (250 / 812),
                      // ),
                      const FlutterLogo(
                        // size: MediaQuery.of(context).size.height * (250 / 812),
                        size: 50,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              onSaved: (value) => username = value!.trim(),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).primaryColor,
                              ),
                              decoration: customInputForm
                                  .copyWith(
                                      prefixIcon: Icon(
                                        Icons.person_outline,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      fillColor: Theme.of(context).canvasColor)
                                  .copyWith(
                                      hintText: AppLocalization.of(context)!
                                          .trans("User name")),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
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
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      fillColor: Theme.of(context).canvasColor)
                                  .copyWith(
                                      hintText: AppLocalization.of(context)!
                                          .trans("Email")),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              onSaved: (value) => password = value!.trim(),
                              textInputAction: TextInputAction.next,
                              obscureText: true,
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).primaryColor,
                              ),
                              decoration: customInputForm
                                  .copyWith(
                                      prefixIcon: Icon(
                                        Icons.lock_outline,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      fillColor: Theme.of(context).canvasColor)
                                  .copyWith(
                                      hintText: AppLocalization.of(context)!
                                          .trans("Password")),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              onSaved: (value) => city = value!.trim(),
                              textInputAction: TextInputAction.next,
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).primaryColor,
                              ),
                              decoration: customInputForm
                                  .copyWith(
                                      prefixIcon: Icon(
                                        Icons.location_city_outlined,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      fillColor: Theme.of(context).canvasColor)
                                  .copyWith(
                                      hintText: AppLocalization.of(context)!
                                          .trans("City")),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              onSaved: (value) => phoneNumber = value!.trim(),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).primaryColor,
                              ),
                              decoration: customInputForm
                                  .copyWith(
                                      prefixIcon: Icon(
                                        Icons.phone_outlined,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      fillColor: Theme.of(context).canvasColor)
                                  .copyWith(
                                      hintText: AppLocalization.of(context)!
                                          .trans("Phone Number")),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor:
                                        Theme.of(context).primaryColor,
                                  ),
                                  child: Checkbox(
                                      value: agreeToPrivacy,
                                      activeColor:
                                          Theme.of(context).primaryColor,
                                      checkColor: Theme.of(context).canvasColor,
                                      onChanged: (value) => {
                                            setState(() {
                                              agreeToPrivacy = value!;
                                            })
                                          }),
                                ),
                                Text("Agree to the ",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).primaryColor)),
                                InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushNamed("/PrivacyTerms");
                                    },
                                    child: Text(
                                      "terms of privacy",
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 16,
                                        decoration: TextDecoration.underline,
                                      ),
                                    )),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
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
                                        .trans("Sign Up"),
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    )),
                                onPressed: _btnSignup),
                            // const SizedBox(
                            //   height: 20,
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool validation() {
    return !(username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        city.isEmpty ||
        phoneNumber.isEmpty);
  }

  _btnSignup() {
    _formKey.currentState!.save();
    if (!validation()) {
      _scaffoldKey.showTosta(
          message:
              AppLocalization.of(context)!.trans("Please fill in all fields"),
          isError: true);
      return;
    }
    if (!agreeToPrivacy) {
      _scaffoldKey.showTosta(
          message: AppLocalization.of(context)!
              .trans("Please agree to the privacy terms"),
          isError: true);
      return;
    }
    FirebaseManager.shared.createAccountUser(
      scaffoldKey: _scaffoldKey,
      name: username,
      phone: phoneNumber,
      email: email,
      city: city,
      password: password,
    );
  }
}
