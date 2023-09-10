// ignore_for_file: file_names
import 'dart:convert';
import 'dart:io';

import 'package:m3u_nullsafe/m3u_nullsafe.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tv/app.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/manger/Section.dart';
import 'package:tv/models/DbChannelModel.dart';
import 'package:tv/models/W3uM3uModel.dart';
import 'package:tv/models/extensions.dart';
import 'package:tv/models/input_style.dart';
import 'package:tv/models/loader.dart';
import 'package:tv/models/DbSectionModel.dart';
import 'package:tv/page/FloatingActionButtonWidget.dart';

import 'package:http/http.dart' as http;
import 'package:tv/utils/utils.dart';

import '../models/lang.dart';

// ignore: camel_case_types, must_be_immutable, use_key_in_widget_constructors
class import_m3u extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey();

  String? newPassword;
  String? confirmPassword;

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
        title: Text(
          AppLocalization.of(context)!.trans("Import M3U"),
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Icon(
                Icons.lock_outline,
                size: 150,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(
                  // height: MediaQuery.of(context).size.height * (100 / 812)),
                  height: MediaQuery.of(context).size.height * (100 / 1300)),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      onSaved: (value) => newPassword = value!.trim(),
                      textInputAction: TextInputAction.next,
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
                                  .trans("Url Address")),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      onSaved: (value) => confirmPassword = value!.trim(),
                      textInputAction: TextInputAction.next,
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
                                  .trans("Section Name")),
                    ),
                    const SizedBox(height: 20),
                    // MediaQuery.of(context).size.height * (100 / 812)),
                    ElevatedButton(
                        // shape: StadiumBorder(),
                        // elevation: 20,
                        // focusElevation: 20,
                        // hoverElevation: 20,
                        // highlightElevation: 20,
                        // disabledElevation: 0,
                        // color: Theme.of(context).primaryColor,
                        style: ElevatedButton.styleFrom(
                          elevation: 20,
                          shape: const StadiumBorder(),
                          primary: Theme.of(context).canvasColor,
                        ),
                        child: Text(
                            AppLocalization.of(context)!.trans("Import Url"),
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )),
                        onPressed: () => fetchHtml(context)),
                    const SizedBox(height: 20),
                    // MediaQuery.of(context).size.height * (100 / 812)),
                    Visibility(
                      visible: isFirebaseDown,
                      child: ElevatedButton(
                          // shape: StadiumBorder(),
                          // elevation: 20,
                          // focusElevation: 20,
                          // hoverElevation: 20,
                          // highlightElevation: 20,
                          // disabledElevation: 0,
                          // color: Theme.of(context).primaryColor,
                          style: ElevatedButton.styleFrom(
                            elevation: 20,
                            shape: const StadiumBorder(),
                            primary: Theme.of(context).canvasColor,
                          ),
                          child: Text(
                              AppLocalization.of(context)!.trans("Delete DB"),
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              )),
                          // onPressed: () => deleteDB(context)
                          onPressed: () async {
                            if (await showDialog<bool>(
                                    context: context,
                                    barrierDismissible:
                                        false, // user must tap button!
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor:
                                            Theme.of(context).canvasColor,
                                        title: Text(
                                          'Delete note?',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text(
                                                  'Tap \'YES\' to confirm note deletion.',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor)),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(true);
                                            },
                                            child: const Text('YES'),
                                            style: TextButton.styleFrom(
                                              primary: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(false);
                                            },
                                            child: const Text('NO'),
                                            style: TextButton.styleFrom(
                                              primary: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                        ],
                                      );
                                    }) ??
                                false) {
                              await sectionProvider.clearAllNotes();
                              await channelProvider.clearAllNotes();
                              await favoriteProvider.clearAllNotes();
                              // Pop twice to go back to the list
                              // ignore: use_build_context_synchronously
                              // Navigator.of(context).pop();
                              // ignore: use_build_context_synchronously
                              // Navigator.of(context).pop();
                            }
                          }),
                    ),
                    buildAddButton(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _addSectionDB(context, sectionType, titleEN, titleAR) async {
    if (isFirebaseDown) {
      var lst = await sectionProvider.onSections(sectionType).first;
      List outputList = lst.where((o) => o.titleEN == titleEN).toList();

      if (outputList.isNotEmpty) {
        return outputList.first.uid;
      } else {
        var secId = int.parse(idGenerator());

        await sectionProvider.saveNote(DbSectionModel()
          ..id = secId
          ..titleEN.v = titleEN
          ..titleAR.v = titleAR
          ..uid.v = "sc_" + secId.toString()
          ..section.v = sectionType
          ..createDt.v = DateTime.now().toIso8601String()
          ..updateDt.v = DateTime.now().toIso8601String());

        return "sc_" + secId.toString();
      }
    } else {
      return await FirebaseManager.shared.section(
        context,
        uid: "",
        scaffoldKey: _scaffoldKey,
        section: Section.values[sectionType],
        titleEN: titleEN,
        titleAR: titleAR,
        createDt: DateTime.now().toIso8601String(),
        updateDt: DateTime.now().toIso8601String(),
      );
    }
  }

  Future<String> _addChannelDB(context, sectionId, sectionType, titleEN,
      titleAR, streamURL, logoURL) async {
    if (isFirebaseDown) {
      var lst = await channelProvider.onChannelModels(sectionId).first;
      List outputList = lst.where((o) => o.streamURL == streamURL).toList();

      if (outputList.isNotEmpty) {
        return outputList.first.uid;
      } else {
        var chnId = int.parse(idGenerator());

        await channelProvider.saveNote(DbChannelModel()
          ..id = chnId
          ..titleEN.v = titleEN
          ..titleAR.v = titleAR
          ..streamURL.v = streamURL
          ..sectionuid.v = sectionId
          ..logoURL.v = logoURL
          ..uid.v = "ch_" + chnId.toString()
          ..section.v = sectionType
          ..createDt.v = DateTime.now().toIso8601String()
          ..updateDt.v = DateTime.now().toIso8601String());

        return "ch_" + chnId.toString();
      }
    } else {
      return await FirebaseManager.shared.addOrEditChanne(context,
          scaffoldKey: _scaffoldKey,
          uid: "",
          sectionuid: sectionId,
          section: Section.values[sectionType],
          titleAR: titleAR,
          titleEN: titleEN,
          streamURL: streamURL!,
          logoURL: logoURL,
          createDt: DateTime.now().toIso8601String(),
          updateDt: DateTime.now().toIso8601String());
    }
  }

  Widget buildAddButton(context) => Container(
        padding: const EdgeInsets.all(32),
        child: FloatingActionButtonWidget(onPressed: () async {
          final file = await pickM3UFile();
          if (file == null) return;

          // To remove empty lines
          var lstStr = await file.readAsLines().then((List<String> lines) {
            return (lines.where((String s) => s.isNotEmpty));
          });

          //print("lstStr.length : " + lstStr.length.toString());

          var fileContent =
              lstStr.reduce((value, element) => value + '\n' + element);
          // print("filecontent is : " + fileContent);
          showLoaderDialog(context);
          if (file.path.contains("m3u")) {
            processM3u(context, fileContent, Section.Movies.index, "xxxx");
          } else if (file.path.contains("w3u")) {
            processW3u(context, fileContent, Section.Series.index, "xxxx");
          }
          showLoaderDialog(context, isShowLoader: false);
        }),
      );

  Future<File?> pickM3UFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result == null) return null;

    var path = result.files.single.path;
    return File(path!);
  }

  bool _validation() {
    return !(newPassword == "" || confirmPassword == "");
  }

  void deleteDB(context) async {
    //print("deleteDB is going.");

    await sectionProvider.clearAllNotes();
    await channelProvider.clearAllNotes();
    await favoriteProvider.clearAllNotes();

    //print("deleteDB completed");
  }

  void fetchHtml(context) async {
    // print("fetchHtml is " + newPassword);

    _formKey.currentState!.save();

    String? url = "";
    // http://tiny.cc/bwis022
    // https://drive.google.com/uc?id=1WSl1fiGr_9UB6dOUN9XB-7SnMzmFQ7j7

    if (_validation()) {
      url = newPassword;

      //print("Url is : " + url!);
      // var url = "https://drive.google.com/uc?id=1WSl1fiGr_9UB6dOUN9XB-7SnMzmFQ7j7";

      showLoaderDialog(context);
      final response = await http.get(Uri.parse(url!));

      if (response.statusCode == 200) {
        // String fileContent = response.body;
        var fileContent = utf8.decode(response.bodyBytes);

        if (fileContent.contains("#EXTM3U")) {
          processM3u(context, fileContent, Section.LIVE.index, confirmPassword);
        } else {
          processW3u(context, fileContent, Section.LIVE.index, confirmPassword);
        }
        showLoaderDialog(context, isShowLoader: false);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load data');
      }
    } else {
      _scaffoldKey.showTosta(
          message:
              AppLocalization.of(context)!.trans("Please fill in all fields"),
          isError: true);
    }
  }

  // ignore: non_constant_identifier_names
  void processW3u(context, fileContent, section_id, section_name) async {
    // print("fetchHtml is " + newPassword);

    if (fileContent != "") {
      // For checking the header of w3u file
      RegExp expHeader = RegExp(r".*{.*[^\[]*");
      Iterable<RegExpMatch> matchesHeader = expHeader.allMatches(fileContent);
      List<Match> listOfMatchesHeader = matchesHeader.toList();

      Iterable<String> listOfStringMatchesHeader =
          listOfMatchesHeader.map((Match m) {
        return m.input.substring(m.start, m.end);
      });
      if (listOfStringMatchesHeader.isNotEmpty) {
        try {
          String tempHeader = listOfStringMatchesHeader.first;
          tempHeader = tempHeader.substring(0, tempHeader.lastIndexOf(","));
          var jsonData = convertToJson(tempHeader);

          final list = json.decode(jsonData) as List<dynamic>;
          List<dynamic>? lstW3u =
              list.map((e) => w3uM3uModel.fromJson(e)).toList();
          if (lstW3u.first.name != "") {
            section_name = lstW3u.first.name;
          }
        } catch (e) {
          //print(e);
        }
      }

      RegExp exp = RegExp(r".*{.*[^\}|\[]*");
      Iterable<RegExpMatch> matches = exp.allMatches(fileContent);
      List<Match> listOfMatches = matches.toList();

      Iterable<String> listOfStringMatches = listOfMatches.map((Match m) {
        return m.input.substring(m.start, m.end);
      });

      // print("matches.length  : " + listOfStringMatches.length.toString());

      if (listOfStringMatches.isNotEmpty) {
        // final secId = await _addSection(
        //     context, "", section_id, section_name, section_name);
        var secId = "";
        // print("secId is " + secId);
        //print("section_name is " + section_name);
        // secId = await _addSectionDB(
        //     context, secId, section_id, section_name, section_name);

        secId = await _addSectionDB(
            context, section_id, section_name, section_name);

        for (var m in listOfStringMatches) {
          try {
            m = convertToJson(m);

            // print("m is : " + m);
            //print("==========================");

            final list = json.decode(m) as List<dynamic>;
            List<dynamic>? lstW3u =
                list.map((e) => w3uM3uModel.fromJson(e)).toList();

            // print("name is : " + lstW3u.first.name);
            // print("url is : " + lstW3u.first.url);
            // print("image is : " + lstW3u.first.image);

            if (lstW3u.first.url != "" && lstW3u.first.name != "") {
              // var chnId = "";
              //print("secId is " + secId);

              await _addChannelDB(
                  context,
                  secId,
                  section_id,
                  lstW3u.first.name,
                  lstW3u.first.name,
                  lstW3u.first.url,
                  (lstW3u.first.image ?? "nologo"));
              // await _addChannel(
              //     context,
              //     "",
              //     secId,
              //     section_id,
              //     lstW3u.first.name,
              //     lstW3u.first.name,
              //     lstW3u.first.url,
              //     (lstW3u.first.image ?? "nologo"));
            }
          } catch (e) {
            //print("m error is : " + m);
            //print(e);
          }
        }
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }

  void processM3u(context, fileContent, sectionId, sectionName) async {
    final listOfTracks = await parseFile("#EXTM3U " + fileContent);

    // Organized categories
    final categories =
        sortedCategories(entries: listOfTracks, attributeName: 'group-title');
    // print(categories);
    //print(" categories.length :  ${categories.length}");

    // categories.forEach((k, v) async {
    for (var entry in categories.entries) {
      var secId = "";
      // print("secId is " + secId);
      // print("section_name is " + section_name);
      var k = entry.key;
      var v = entry.value;

      // await _addSectionDB(context, secId, Section.Movies, k, k)
      //     .then((value) => {
      //           // print("section Id is : " + value),
      //           secId = value
      //         });

      //print("Group => ${k}");
      //print("secId => ${secId}");

      secId = await _addSectionDB(context, sectionId, k, k);

      // await sectionProvider.saveNote(DbSectionModel()
      //   ..id = secId
      //   ..titleEN.v = k
      //   ..titleAR.v = k
      //   ..uid.v = "sc_" + secId.toString()
      //   ..section.v = Section.Movies.index);

      //print("================000==================");
      // print("Group => ${k}, value => ${v}");

      // print("section Id is : " + secId);
      for (final e in v) {
        // for (var i = 0; i < v.length; i++) {
        // final e = v[i];

        // M3uGenericEntry currentElement = e;
        // //print(e.title + " ::::: " + e.link);

        if (e.link != "" && e.title != "") {
          // //print("group-title => ${e.attributes["group-title"]}");

          // _addChannel(context, uid, section, titleEN, titleAR, streamURL
          // await _addChannel(context, "", secId, Section.Movies, e.title,
          //     e.title, e.link, (e.attributes["tvg-logo"] ?? "nologo"));

          // var chnId = "";
          // print("chnId is " + chnId);

          await _addChannelDB(context, secId, sectionId, e.title, e.title,
              e.link, (e.attributes["tvg-logo"] ?? "nologo"));

          // await channelProvider.saveNote(DbChannelModel()
          //   ..id = chnId
          //   ..titleEN.v = e.title
          //   ..titleAR.v = e.title
          //   ..streamURL.v = e.link
          //   ..sectionuid.v = secId
          //   ..logoURL.v = (e.attributes["tvg-logo"] ?? "nologo")
          //   ..uid.v = "ch_" + chnId.toString()
          //   ..section.v = Section.Movies.index);

          //print("================1111==================");
          //print("Group => ${k}");
          //print("secId => sc_${secId}");
          //print("chnId => ch_${chnId}");
          //print("   Title => ${e.title}");
          //print("      logo => ${e.attributes["tvg-logo"]}");
          //print("      Link => ${e.link}");
          //print("================2222==================");
        }
      }
    }
  }

  String convertToJson(fileContent) {
    fileContent = fileContent.trim();
    fileContent = fileContent.replaceAll("author:", "\"author\":");
    fileContent = fileContent.replaceAll("stations:", "\"stations\":");
    fileContent = fileContent.replaceAll("\"groups\":", "\"stations\":");
    fileContent = fileContent.replaceAll("groups:", "\"stations\":");
    fileContent = fileContent.replaceAll("name:", "\"name\":");
    fileContent = fileContent.replaceAll("info:", "\"info\":");
    fileContent = fileContent.replaceAll("image:", "\"image\":");
    fileContent = fileContent.replaceAll("url:", "\"url\":");
    fileContent = fileContent.replaceAll("referer:", "\"referer\":");

    fileContent = fileContent.replaceAll("userAgent:", "\"userAgent\":");
    fileContent =
        fileContent.replaceAll("playInNatPlayer:", "\"playInNatPlayer\":");

    // To remove comma(,) of header of w3u file.
    if (fileContent.substring(fileContent.length - 1, fileContent.length) ==
        ",") {
      fileContent = fileContent.substring(0, fileContent.length - 1);
    }
    return "[" + fileContent + "}]";
  }
}
