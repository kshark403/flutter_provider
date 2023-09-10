// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tv/app.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/manger/Section.dart';
import 'package:tv/manger/language.dart';
import 'package:tv/manger/user-type.dart';
import 'package:tv/models/loader.dart';
import 'package:tv/models/section_channel_model.dart';
import 'package:tv/models/user-model.dart';
import 'package:tv/models/user_profile.dart';
import 'package:tv/page/add-section.dart';
import 'package:tv/page/notification.dart';
import 'package:tv/page/favorite_channel.dart';
import 'package:tv/providers/stream_combiner.dart';
import 'package:tv/utils/utils.dart';

import '../models/lang.dart';
import 'channel.dart';

// ignore: must_be_immutable
class SectionScreen extends StatefulWidget {
  @override
  _SectionScreenState createState() => _SectionScreenState();
  final Section section;
  final String screenTitle;
  bool searchMode = false;
  // ignore: use_key_in_widget_constructors
  SectionScreen(this.section, this.screenTitle);
}

class _SectionScreenState extends State<SectionScreen> {
  Language lang = Language.ENGLISH;
  final TextEditingController? searchTextField = TextEditingController();
  Widget? appBarTitle;
  @override
  void initState() {
    // #: implement initState
    super.initState();
    UserProfile.shared.getLanguage().then((value) {
      setState(() {
        appBarTitle = Text(
          AppLocalization.of(context)!.trans(widget.screenTitle),
          style: TextStyle(color: Theme.of(context).primaryColor),
        );
        lang = value!;
      });
    });
  }

  @override
  void dispose() {
    // #: implement dispose
    searchTextField!.dispose();
    super.dispose();
  }

  Icon actionIcon = const Icon(Icons.search);

  @override
  Widget build(BuildContext context) {
    //print("Inside section build 1");
    return FutureBuilder<UserModel?>(
        // key: _scaffoldKey,
        future: UserProfile.shared.getUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //print("enter 1 ");
            UserModel? user = snapshot.data;
            //print("enter 2 ");

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).canvasColor,
                elevation: 0,
                iconTheme: IconThemeData(
                  color: Theme.of(context).primaryColor,
                ),
                leading: IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => FavoriteChannel(
                                widget.section.name,
                                widget.screenTitle,
                                section: widget.section.index,
                              ))),
                ),
                title: appBarTitle,
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: actionIcon,
                    onPressed: () {
                      setState(() {
                        if (actionIcon.icon == Icons.search) {
                          actionIcon = const Icon(Icons.close);
                          appBarTitle = TextField(
                            controller: searchTextField,
                            onChanged: (value) {
                              searchTextField!.text = value;
                              searchTextField!.text.isEmpty
                                  ? widget.searchMode = false
                                  : widget.searchMode = true;
                              searchTextField!.selection =
                                  TextSelection.fromPosition(TextPosition(
                                      offset: searchTextField!.text.length));
                              setState(() {});
                            },
                            style: TextStyle(
                              // color: Colors.blue,
                              color: Theme.of(context).primaryColor,
                            ),
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search,
                                    // color: Colors.blue
                                    color: Theme.of(context).primaryColor),
                                hintText: "Search...",
                                hintStyle: TextStyle(
                                    // color: Colors.blue
                                    color: Theme.of(context).primaryColor)),
                          );
                        } else {
                          actionIcon = const Icon(Icons.search);
                          appBarTitle = Text(
                            AppLocalization.of(context)!
                                .trans(widget.screenTitle),
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          );
                        }
                      });
                    },
                  ),
                  // const NotificationsWidget(),
                  if (!isFirebaseDown) const NotificationsWidget(),
                  Visibility(
                    visible: user!.userType == UserType.ADMIN,
                    child: IconButton(
                        icon: Icon(Icons.add,
                            color: Theme.of(context).primaryColor),
                        onPressed: () {
                          showActionsheet();
                        }),
                  ),
                ],
              ),
              body: user.userType == UserType.ADMIN
                  ? _widgetTech(context, searchTextField, user)
                  : _widgetTech(context, searchTextField, user),
            );
          }

          return const SizedBox();
        });
  }

  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Widget _widgetTech(context, searchController, user) {
    return StreamBuilder<List<SectionChannelModel>>(
        stream: StreamCombiner()
            .getCombineSectionChannelStreams(widget.section.index),
        // (isFirebaseDown
        //     ? sectionProvider.onSections(widget.section.index)
        //     : FirebaseManager.shared.getSection(section: widget.section)),
        builder: (context, snapshot) {
          // print("yeahsssss");
          if (snapshot.hasData) {
            List<SectionChannelModel>? section = snapshot.data;
            if (widget.searchMode) {
              section = section!
                  .where((element) => element.section.titleEN
                      .toUpperCase()
                      .contains(searchController.text.toUpperCase()))
                  .toList();
              // for (int i = 0; i < section!.length; i++) {
              //   // ignore: unrelated_type_equality_checks
              //   if (section[i].section.index != widget.section.index) {
              //     section.removeAt(i);
              //   }
              // }
            }
            if (section!.isEmpty) {
              return Center(
                  child: Text(
                "No  added",
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 18),
              ));
            }
            return ListView.builder(
                itemCount: section.length,
                itemBuilder: (item, index) {
                  return MaterialButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => chanelsection(
                                    section![index].section.uid,
                                    lang == Language.ENGLISH
                                        ? section[index].section.titleEN
                                        : section[index].section.titleAR,
                                    section: widget.section.index,
                                  )));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Card(
                        color: Theme.of(context).canvasColor,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                if (user?.userType == UserType.ADMIN)
                                  IconButton(
                                    iconSize: 35,
                                    icon: Icon(
                                      Icons.edit,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => addsection(
                                                updateSection:
                                                    section![index].section))),
                                    //  onPressed: ()  { },
                                  ),
                                CircleAvatar(
                                    radius: 30,
                                    child: FittedBox(
                                      child: Text(section![index]
                                          .totalChannel
                                          .toString()),
                                    )),
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                            lang == Language.ENGLISH
                                                ? section[index].section.titleEN
                                                : section[index]
                                                    .section
                                                    .titleAR,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500)),
                                        Text(
                                            DateFormat("dd/MM/yyyy H:m:s")
                                                .format(section[index]
                                                    .section
                                                    .updateDt),
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500)),
                                      ]),
                                )),
                                if (user?.userType == UserType.ADMIN)
                                  IconButton(
                                    iconSize: 35,
                                    icon: Icon(Icons.delete_forever,
                                        color: Theme.of(context).primaryColor),
                                    onPressed: () {
                                      _deleteSection(
                                          context, section![index].section.uid);
                                      // FirebaseManager.shared.deleteSection(
                                      //     context,
                                      //     uidSection: section[index].uid);
                                    },
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          } else {
            return Center(
              child: loader(context),
            );
          }
        });
  }

  _deleteSection(context, String uidSection) {
    //print("going to delete section.");

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          "Delete",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        backgroundColor: Theme.of(context).canvasColor,
        content: Text("Are you sure to delete?",
            style: TextStyle(color: Theme.of(context).primaryColor)),
        actions: <Widget>[
          TextButton(
            onPressed: () async => {
              (isFirebaseDown
                  ? await sectionProvider
                      .deleteNote(int.parse(uidSection.substring(3)))
                  : await FirebaseManager.shared
                      .deleteSection(context, uidSection: uidSection)),
              Navigator.of(context).pop()
            },
            child: const Text("Delete"),
            style: TextButton.styleFrom(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
            style: TextButton.styleFrom(
              primary: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  showActionsheet() {
    {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
            title: const Text('Choose An Option'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: const Text('addsection'),
                onPressed: () => Navigator.pushNamed(context, '/addsection'),
              ),
              CupertinoActionSheetAction(
                child: const Text('addchannel'),
                isDestructiveAction: false,
                onPressed: () => Navigator.pushNamed(context, '/laddchannel'),
              )
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, 'Cancel');
              },
            )),
      );
    }
  }
}
