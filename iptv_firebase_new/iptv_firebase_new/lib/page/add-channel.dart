// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tv/app.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/models/DbChannelModel.dart';
import 'package:tv/models/alert_sheet.dart';
import 'package:tv/models/channelModel.dart';
import 'package:tv/models/extensions.dart';
import 'package:tv/models/input_style.dart';
import 'package:tv/manger/Section.dart';
import 'package:tv/manger/language.dart';
import 'package:tv/models/user_profile.dart';
import 'package:tv/models/SectionModel.dart';
import 'package:tv/utils/utils.dart';

import '../models/lang.dart';

// ignore: must_be_immutable, camel_case_types
class addchannel extends StatefulWidget {
  String? uidActiveService;
  ChannelModel? channelSelected;
  // ignore: use_key_in_widget_constructors
  addchannel({this.channelSelected});
  @override
  _addchannelState createState() => _addchannelState();
}

// ignore: camel_case_types
class _addchannelState extends State<addchannel> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _userTypeController = TextEditingController();
  TextEditingController _dropDownController = TextEditingController();
  late Section section;

  late String titleEN = "";
  late String titleAR = "";
  String? streamURL = "";
  DateTime? createDt;
  String? logoURL = "";
  String? _activeDropDownItem = "";
  String? sectionUid = "";
  String buttonMode = "ADD";
  final List<SectionModel>? _dropdownMenuItem = [];
  SectionModel? currentSection;
  Language lang = Language.ENGLISH;

  @override
  void initState() {
    // #: implement initState
    super.initState();

    UserProfile.shared.getLanguage().then((value) {
      setState(() {
        lang = value!;
      });
    });

    if (widget.channelSelected != null) {
      _userTypeController =
          TextEditingController(text: widget.channelSelected!.section.name);
      _dropDownController = TextEditingController(text: _activeDropDownItem);

      titleEN = widget.channelSelected!.titleEN;
      titleAR = widget.channelSelected!.titleAR;
      streamURL = widget.channelSelected!.streamURL;
      logoURL = widget.channelSelected!.logoURL;
      createDt = widget.channelSelected!.createDt;
      section = widget.channelSelected!.section;
      getSection(widget.channelSelected!.sectionuid).then((value) {
        if (lang == Language.ENGLISH) {
          _activeDropDownItem = value.titleEN;
        } else {
          _activeDropDownItem = value.titleAR;
        }
        setState(() {
          _dropDownController =
              TextEditingController(text: _activeDropDownItem);
        });
      });

      // print("_activeDropDownItem is : " + _activeDropDownItem!);

      //print("widget.channelSelected!.section is : " +widget.channelSelected!.section.name);
      getSectionList(widget.channelSelected!.section).then((value) {
        //print("value 1 .length : " + value.length.toString());
        for (var element in value) {
          _dropdownMenuItem!.add(element);
        }
      });

      buttonMode = "UPDATE";
    }
  }

  @override
  void dispose() {
    // #: implement dispose
    _userTypeController.dispose();
    super.dispose();
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
                      // SizedBox(
                      //     height:
                      //         // MediaQuery.of(context).size.height * (60 / 812)),
                      // Image.asset(
                      //   Assets.shared.icLogo,
                      //   fit: BoxFit.cover,
                      //   height:
                      //       // MediaQuery.of(context).size.height * (250 / 812),
                      //       MediaQuery.of(context).size.height * (0.12),
                      // ),
                      FlutterLogo(
                        size: MediaQuery.of(context).size.height * (0.12),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _userTypeController,
                              onTap: () {
                                alertSheet(context,
                                    title: " type",
                                    items: ["LIVE", "Movies", "Series"],
                                    onTap: (value) {
                                  //print("M.S${value}");
                                  _userTypeController.text = value;
                                  if (value == "LIVE") {
                                    section = Section.LIVE;
                                  } else if (value == "Movies") {
                                    section = Section.Movies;
                                  } else {
                                    section = Section.Series;
                                  }
                                  _getServiceData(section);
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
                            TextFormField(
                              initialValue: titleAR,
                              onChanged: (value) => titleAR = value.trim(),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              style: TextStyle(
                                fontSize: 18,
                                // color: Theme.of(context).colorScheme.secondary,
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
                            TextFormField(
                              initialValue: titleEN,
                              onChanged: (value) => titleEN = value.trim(),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              style: TextStyle(
                                fontSize: 18,
                                // color: Theme.of(context).colorScheme.secondary,
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
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              initialValue: streamURL,
                              onChanged: (value) => streamURL = value.trim(),
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
                                  .copyWith(hintText: "streamURL"),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              initialValue: logoURL,
                              onChanged: (value) => logoURL = value.trim(),
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
                                  .copyWith(hintText: "logoURL"),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: _dropDownController,
                              onTap: () {
                                // print("before length is " +_dropdownMenuItem!.length.toString());
                                alertSheet(context,
                                    addChannel: true,
                                    title: " type",
                                    items: _dropdownMenuItem!, onTap: (value) {
                                  lang == Language.ENGLISH
                                      ? _dropDownController.text = value.titleEN
                                      : _dropDownController.text =
                                          value.titleAR;

                                  currentSection = value;

                                  // print("_getServiceData is : " + section.name);
                                  // print("after length is " + _dropdownMenuItem!.length.toString());

                                  _getServiceData(section);
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
                            const SizedBox(height: 20),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 20,
                                  shape: const StadiumBorder(),
                                  primary: Theme.of(context).canvasColor,
                                ),
                                child: Text(buttonMode,
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    )),
                                onPressed: () => widget.channelSelected != null
                                    ? _submitData(
                                        uid: widget.channelSelected!.uid)
                                    : _submitData()),
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

  _getServiceData(section) async {
    if (isFirebaseDown) {
      await sectionProvider.onSections(section.index).first.then((value) {
        // print("_getServiceData length : " + value.length.toString());
        _dropdownMenuItem!.clear();
        if (lang == Language.ARABIC) {
          for (int i = 0; i < value.length; i++) {
            // _dropdownMenuItem!.clear();
            _dropdownMenuItem!.add(value[i]);
          }
        } else {
          for (int i = 0; i < value.length; i++) {
            // _dropdownMenuItem!.clear();
            _dropdownMenuItem!.add(value[i]);
          }
        }

        // print("_dropdownMenuItem 2 length : " +  _dropdownMenuItem!.length.toString());
      });
    } else {
      await FirebaseManager.shared
          .getSection(section: section)
          .first
          .then((value) {
        _dropdownMenuItem!.clear();
        if (lang == Language.ARABIC) {
          for (int i = 0; i < value.length; i++) {
            // _dropdownMenuItem!.clear();
            _dropdownMenuItem!.add(value[i]);
          }
        } else {
          for (int i = 0; i < value.length; i++) {
            // _dropdownMenuItem!.clear();
            _dropdownMenuItem!.add(value[i]);
          }
        }
      });
    }

    setState(() {
      if (widget.uidActiveService != null) {
        _activeDropDownItem = widget.uidActiveService;
      }
    });
  }

  bool _validation() {
    return !(_activeDropDownItem == null || titleAR == "" || titleEN == ""
        // section == null
        );
  }

  _submitData({String uid = ""}) async {
    _formKey.currentState!.save();

    if (!_validation()) {
      _scaffoldKey.showTosta(
          message:
              AppLocalization.of(context)!.trans("Please fill in all fields"),
          isError: true);
      return;
    }

    //await FirebaseManager.shared.getSectionById(id: _activeDropDownItem!).first;
    // print("section : " + section.toString());
    // print("uid : " + uid);
    // print("channelSelected.sectionuid : " + widget.channelSelected!.sectionuid);
    // print("sectionuid : " + currentSection!.uid);
    if (isFirebaseDown) {
      await channelProvider.saveNote(DbChannelModel()
        ..id = int.parse(uid.substring(3))
        ..titleEN.v = titleEN
        ..titleAR.v = titleAR
        ..streamURL.v = streamURL
        ..sectionuid.v = (currentSection == null
            ? widget.channelSelected!.sectionuid
            : currentSection!.uid)
        ..logoURL.v = logoURL
        ..uid.v = uid
        ..section.v = section.index
        ..createDt.v = createDt!.toIso8601String()
        ..updateDt.v = DateTime.now().toIso8601String());
    } else {
      await FirebaseManager.shared.addOrEditChanne(context,
          scaffoldKey: _scaffoldKey,
          uid: uid,
          sectionuid: (currentSection == null
              ? widget.channelSelected!.sectionuid
              : currentSection!.uid),
          section: section,
          titleAR: titleAR,
          titleEN: titleEN,
          streamURL: streamURL!,
          logoURL: logoURL!,
          createDt: createDt!.toIso8601String(),
          updateDt: DateTime.now().toIso8601String());
    }
    //print("after add");

    Navigator.of(context).pop();
  }

  Future<SectionModel> getSection(String id) async {
    if (isFirebaseDown) {
      // print("what is id : " + id);
      var lst = await sectionProvider.onSectionByUid(id).first;
      // print("data is " + lst.toString());
      return lst.first;
    } else {
      return await FirebaseManager.shared.getSectionById(id: id).first;
    }
  }

  Future<List<SectionModel>> getSectionList(Section section) async {
    if (isFirebaseDown) {
      return await sectionProvider.onSections(section.index).first;
    } else {
      return await FirebaseManager.shared.getSection(section: section).first;
    }
  }
}

// ignore: must_be_immutable, camel_case_types, use_key_in_widget_constructors
class laddchannel extends StatefulWidget {
  String? uidActiveService;

  @override
  _laddchannelState createState() => _laddchannelState();
}

// ignore: camel_case_types
class _laddchannelState extends State<laddchannel> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _userTypeController = TextEditingController();
  late Section section;

  late String titleEN;
  late String titleAR;
  String? streamURL;
  String? logoURL;
  String? _activeDropDownItem;
  final List<DropdownMenuItem<String>>? _dropdownMenuItem = [];
  Language lang = Language.ENGLISH;

  @override
  void initState() {
    // #: implement initState
    super.initState();
    UserProfile.shared.getLanguage().then((value) {
      setState(() {
        lang = value!;
      });
    });
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
                      // SizedBox(
                      //     height:
                      //         MediaQuery.of(context).size.height * (60 / 812)),
                      // Image.asset(
                      //   Assets.shared.icLogo,
                      //   fit: BoxFit.cover,
                      //   height:
                      //       // MediaQuery.of(context).size.height * (250 / 812),
                      //       MediaQuery.of(context).size.height * (0.12),
                      // ),
                      FlutterLogo(
                        size: MediaQuery.of(context).size.height * (0.12),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
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
                                  _getServiceData(section);
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
                            TextFormField(
                              onChanged: (value) => titleAR = value.trim(),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              style: TextStyle(
                                fontSize: 18,
                                // color: Theme.of(context).colorScheme.secondary,
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
                            TextFormField(
                              onChanged: (value) => titleEN = value.trim(),
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
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              onChanged: (value) => streamURL = value.trim(),
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
                                  .copyWith(hintText: "streamURL"),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              onChanged: (value) => logoURL = value.trim(),
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
                                  .copyWith(hintText: "logoURL"),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            DropdownButtonFormField(
                              items: _dropdownMenuItem,
                              onChanged: (newValue) {
                                setState(() =>
                                    _activeDropDownItem = newValue as String?);
                              },
                              value: _activeDropDownItem,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: customInputForm
                                  .copyWith(
                                      prefixIcon: Icon(
                                        Icons.person_outline,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      fillColor: Theme.of(context).canvasColor)
                                  .copyWith(hintText: " list "),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 20,
                                  shape: const StadiumBorder(),
                                  primary: Theme.of(context).canvasColor,
                                ),
                                child: Text("ADD",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    )),
                                onPressed: _submitData),
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

  _getServiceData(Section section) async {
    // List<SectionModel> services = [];
    // if (isFirebaseDown) {
    //   print("what is section.index : " + section.index.toString());
    //   services = await sectionProvider.onSections(section.index).first;
    // } else {
    //   services =
    //       await FirebaseManager.shared.getSection(section: section).first;
    // }
    // setState(() {
    //   print("_dropdownMenuItem will get data here.");
    // _dropdownMenuItem = services
    //     .map((item) => DropdownMenuItem(
    //         child:
    //             Text(lang == Language.ARABIC ? item.titleAR : item.titleEN),
    //         value: item.uid.toString()))
    //     .toList();

    //   if (widget.uidActiveService != null) {
    //     _activeDropDownItem = widget.uidActiveService;
    //   }
    // });
    _dropdownMenuItem!.clear();
    // print(" Before DropdownMenuItem len is ::: " + _dropdownMenuItem!.length.toString());
    if (isFirebaseDown) {
      await sectionProvider.onSections(section.index).first.then((value) {
        // print("_getServiceData length : " + value.length.toString());

        if (lang == Language.ARABIC) {
          for (int i = 0; i < value.length; i++) {
            // _dropdownMenuItem!.clear();
            _dropdownMenuItem!.add(DropdownMenuItem(
                child: Text(
                  lang == Language.ARABIC ? value[i].titleAR : value[i].titleEN,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                value: value[i].uid.toString()));
          }
        } else {
          for (int i = 0; i < value.length; i++) {
            // _dropdownMenuItem!.clear();
            _dropdownMenuItem!.add(DropdownMenuItem(
                child: Text(
                  lang == Language.ARABIC ? value[i].titleAR : value[i].titleEN,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                value: value[i].uid.toString()));
          }
        }

        // print("_dropdownMenuItem 2 length : " + _dropdownMenuItem!.length.toString());
      });
    } else {
      await FirebaseManager.shared
          .getSection(section: section)
          .first
          .then((value) {
        if (lang == Language.ARABIC) {
          for (int i = 0; i < value.length; i++) {
            // _dropdownMenuItem!.clear();
            _dropdownMenuItem!.add(DropdownMenuItem(
                child: Text(
                  lang == Language.ARABIC ? value[i].titleAR : value[i].titleEN,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                value: value[i].uid.toString()));
          }
        } else {
          for (int i = 0; i < value.length; i++) {
            // _dropdownMenuItem!.clear();
            _dropdownMenuItem!.add(DropdownMenuItem(
                child: Text(
                  lang == Language.ARABIC ? value[i].titleAR : value[i].titleEN,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                value: value[i].uid.toString()));
          }
        }
      });
    }

    // print(" After DropdownMenuItem len is ::: " + _dropdownMenuItem!.length.toString());

    setState(() {
      if (widget.uidActiveService != null) {
        _activeDropDownItem = widget.uidActiveService;
      }
    });
  }

  bool _validation() {
    return !(_activeDropDownItem == null || titleAR == "" || titleEN == ""
        // section == null
        );
  }

  _submitData() async {
    if (!_validation()) {
      _scaffoldKey.showTosta(
          message: "Please fill in all fields", isError: true);
      return;
    }

    if (isFirebaseDown) {
      // print("_activeDropDownItem : " + _activeDropDownItem!);
      var chnId = idGenerator();
      await channelProvider.saveNote(DbChannelModel()
        ..id = int.parse(chnId)
        ..titleEN.v = titleEN
        ..titleAR.v = titleAR
        ..streamURL.v = streamURL
        ..sectionuid.v = _activeDropDownItem!
        ..logoURL.v = logoURL
        ..uid.v = "ch_" + chnId
        ..section.v = section.index
        ..createDt.v = DateTime.now().toIso8601String()
        ..updateDt.v = DateTime.now().toIso8601String());
    } else {
      // await FirebaseManager.shared.getSectionById(id: _activeDropDownItem!).first;

      FirebaseManager.shared.addOrEditChanne(
        context,
        sectionuid: _activeDropDownItem!,
        section: section,
        titleAR: titleAR,
        titleEN: titleEN,
        streamURL: streamURL!,
        logoURL: logoURL!,
        scaffoldKey: _scaffoldKey,
        createDt: DateTime.now().toIso8601String(),
        updateDt: DateTime.now().toIso8601String(),
      );
    }
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }
}
