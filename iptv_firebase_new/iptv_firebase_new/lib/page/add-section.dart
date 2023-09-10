// ignore_for_file: deprecated_member_use, file_names

import 'package:flutter/material.dart';
import 'package:tv/app.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/models/DbSectionModel.dart';
import 'package:tv/models/SectionModel.dart';
import 'package:tv/models/alert_sheet.dart';
import 'package:tv/models/extensions.dart';
import 'package:tv/models/input_style.dart';
import 'package:tv/manger/Section.dart';
import 'package:tv/utils/utils.dart';

import '../models/lang.dart';

// ignore: camel_case_types, must_be_immutable
class addsection extends StatefulWidget {
  SectionModel? updateSection;
  // ignore: use_key_in_widget_constructors
  addsection({this.updateSection});
  @override
  _addsectionState createState() => _addsectionState();
}

// ignore: camel_case_types
class _addsectionState extends State<addsection> {
  // ignore: prefer_final_fields
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _userTypeController = TextEditingController();

  late Section section;
  late DateTime createDt;
  late String titleEN = "";
  late String titleAR = "";
  String buttonMode = "ADD";

  @override
  void dispose() {
    // #: implement dispose
    _userTypeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.updateSection != null) {
      _userTypeController =
          TextEditingController(text: widget.updateSection!.section.name);
      titleEN = widget.updateSection!.titleEN;
      titleAR = widget.updateSection!.titleAR;
      section = widget.updateSection!.section;
      createDt = widget.updateSection!.createDt;
      buttonMode = "UPDATE";
    }
  }

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
                      SizedBox(
                          height:
                              MediaQuery.of(context).size.height * (60 / 812)),
                      // Image.asset(
                      //   Assets.shared.icLogo,
                      //   fit: BoxFit.cover,
                      //   height:
                      //       MediaQuery.of(context).size.height * (250 / 812),
                      // ),
                      FlutterLogo(
                        size: MediaQuery.of(context).size.height * (250 / 812),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              initialValue: titleEN,
                              onSaved: (value) => titleEN = value!.trim(),
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
                                  .copyWith(hintText: "titleEN"),
                            ),
                            TextFormField(
                              initialValue: titleAR,
                              onSaved: (value) => titleAR = value!.trim(),
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
                                  .copyWith(hintText: "titleAR"),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _userTypeController,
                              onTap: () {
                                alertSheet(context,
                                    title: " type",
                                    items: ["LIVE", "Movies", "Series"],
                                    onTap: (value) {
                                  _userTypeController.text = value;
                                  if (value == "LIVE") {
                                    section = Section.LIVE;
                                  } else if (value == "Movies") {
                                    section = Section.Movies;
                                  } else {
                                    section = Section.Series;
                                  }
                                  return;
                                });
                              },
                              readOnly: true,
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
                                  .copyWith(hintText: " type"),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                                // color: Theme.of(context).primaryColor,
                                style: ElevatedButton.styleFrom(
                                  elevation: 20,
                                  shape: const StadiumBorder(),
                                  primary: Theme.of(context).canvasColor,
                                ),
                                child: Text(buttonMode,
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    )),
                                onPressed: () => widget.updateSection != null
                                    ? _section(uid: widget.updateSection!.uid)
                                    : _section()),
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
    return !(titleEN == "" || titleAR == "");
  }

  _section({String uid = ""}) async {
    _formKey.currentState!.save();

    if (!validation()) {
      _scaffoldKey.showTosta(
          message:
              AppLocalization.of(context)!.trans("Please fill in all fields"),
          isError: true);
      return;
    }

    if (isFirebaseDown) {
      if (uid == "") {
        var secId = idGenerator();

        await sectionProvider.saveNote(DbSectionModel()
          ..id = int.parse(secId)
          ..titleEN.v = titleEN
          ..titleAR.v = titleAR
          ..uid.v = "sc_" + secId.toString()
          ..section.v = section.index
          ..createDt.v = DateTime.now().toIso8601String()
          ..updateDt.v = DateTime.now().toIso8601String());
      } else {
        await sectionProvider.saveNote(DbSectionModel()
          ..id = int.parse(uid.substring(3))
          ..titleEN.v = titleEN
          ..titleAR.v = titleAR
          ..uid.v = uid
          ..section.v = section.index
          ..createDt.v = createDt.toIso8601String()
          ..updateDt.v = DateTime.now().toIso8601String());
      }
    } else {
      if (uid == "") {
        await FirebaseManager.shared.section(
          context,
          uid: uid,
          scaffoldKey: _scaffoldKey,
          section: section,
          titleEN: titleEN,
          titleAR: titleAR,
          createDt: DateTime.now().toIso8601String(),
          updateDt: DateTime.now().toIso8601String(),
        );
      } else {
        await FirebaseManager.shared.section(
          context,
          uid: uid,
          scaffoldKey: _scaffoldKey,
          section: section,
          titleEN: titleEN,
          titleAR: titleAR,
          createDt: createDt.toIso8601String(),
          updateDt: DateTime.now().toIso8601String(),
        );
      }
    }

    Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }
}
