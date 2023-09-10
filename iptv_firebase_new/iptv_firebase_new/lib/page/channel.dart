import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tv/app.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/manger/language.dart';
import 'package:tv/manger/user-type.dart';
import 'package:tv/models/DbFavoriteModel.dart';
import 'package:tv/models/channelModel.dart';
import 'package:tv/models/channel_favorite_model.dart';
import 'package:tv/models/loader.dart';
import 'package:tv/models/user-model.dart';
import 'package:tv/models/user_profile.dart';
import 'package:tv/providers/stream_combiner.dart';
import 'package:tv/utils/utils.dart';

import 'add-channel.dart';
// import 'channel-Details.dart';
// import 'channel-Details-vlc.dart';

// ignore: camel_case_types, must_be_immutable
class chanelsection extends StatefulWidget {
  // ignore: annotate_overrides
  _chanelsectionState createState() => _chanelsectionState();
  // ignore: non_constant_identifier_names
  final String Channel;
  final String screenTitle;
  bool searchMode = false;
  int? section;

  // ignore: use_key_in_widget_constructors
  chanelsection(this.Channel, this.screenTitle, {this.section});
}

// ignore: camel_case_types
class _chanelsectionState extends State<chanelsection> {
  Language lang = Language.ENGLISH;
  Widget? appBarTitle;
  final TextEditingController? searchTextField = TextEditingController();

  @override
  void initState() {
    // #: implement initState
    super.initState();
    UserProfile.shared.getLanguage().then((value) {
      setState(() {
        appBarTitle = Text(
          widget.screenTitle,
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
    return FutureBuilder<UserModel?>(
        // key: _scaffoldKey,
        future: UserProfile.shared.getUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserModel? user = snapshot.data;

            return Scaffold(
              appBar: AppBar(
                  backgroundColor: Theme.of(context).canvasColor,
                  elevation: 0,
                  iconTheme: IconThemeData(
                    color: Theme.of(context).primaryColor,
                  ),
                  title: appBarTitle,
                  centerTitle: true,
                  actions: <Widget>[
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
                                  color: Theme.of(context).primaryColor),
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
                              widget.screenTitle,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            );
                          }
                        });
                      },
                    ),
                    // IconButton(
                    //   icon: const Icon(
                    //     Icons.favorite,
                    //   ),
                    //   onPressed: () => Navigator.pushNamed(context, '/Profile'),
                    // ),
                  ]),
              // body: fetchFavourite(context, searchTextField, user),
              body: _widgetTech(context, searchTextField, user),

              // body: user?.userType == UserType.ADMIN
              //     ? _widgetTech(context, searchTextField)
              //     : _widgetUser(context, searchTextField),
            );
          }

          return const SizedBox();
        });
  }

  // Widget fetchFavourite(context, searchController, user) {
  //   return StreamBuilder<List<FavoriteModel>>(
  //       stream: (isFirebaseDown
  //           ? favoriteProvider.onFavoritesBySectionUid(widget.Channel)
  //           : FirebaseManager.shared
  //               .getMyFavoritesBySectionUid(sectionUid: widget.Channel)),
  //       builder: (context, snapshot) {
  //         List<FavoriteModel>? favChannels = [];
  //         if (snapshot.hasData) {
  //           favChannels = snapshot.data;
  //         }

  //         return (user?.userType == UserType.ADMIN
  //             ? _widgetTech(context, searchTextField, favChannels, user)
  //             : _widgetTech(context, searchTextField, favChannels, user));
  //       });
  // }

  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Widget _widgetTech(context, searchController, user) {
    return StreamBuilder<List<ChannelFavoriteModel>>(
        stream:
            StreamCombiner().getCombineChannelFavoriteStreams(widget.Channel),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // print("Yeaaaaaa");
            // ignore: non_constant_identifier_names
            List? chlFavs = snapshot.data;
            // print("chlFavs.length 1 : " + chlFavs!.length.toString());
            if (widget.searchMode) {
              chlFavs = chlFavs!
                  .where((element) => element.channel.titleEN
                      .toUpperCase()
                      .contains(searchController.text.toUpperCase()))
                  .toList();
              // for (int i = 0; i < Channel!.length; i++) {
              //   // ignore: unrelated_type_equality_checks
              //   if (Channel[i].sectionuid != widget.Channel) {
              //     Channel.removeAt(i);
              //   }
              // }
            }

            // print("chlFavs.length 2 : " + chlFavs.length.toString());
            if (chlFavs!.isEmpty) {
              return Center(
                  child: Text(
                "No  added",
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 18),
              ));
            }
            return ListView.builder(
                itemCount: chlFavs.length,
                itemBuilder: (item, index) {
                  return MaterialButton(
                    onPressed: () {
                      openApp(chlFavs![index].channel.streamURL);
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (_) => (Channel[index].streamURL)
                      //                 .toString()
                      //                 .contains("rtsp:")
                      //             ? cchannelDetailsVlc(
                      //                 Channel: Channel[index],
                      //               )
                      //             :
                      //             cchannelDetails(
                      //                 Channel: Channel[index],
                      //               )
                      //             ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Card(
                        color: Theme.of(context).canvasColor,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
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
                                            builder: (_) => addchannel(
                                                channelSelected:
                                                    chlFavs![index].channel))),
                                  ),
                                Image.network(chlFavs![index].channel.logoURL,
                                    width: 50, height: 50, errorBuilder:
                                        (BuildContext context, Object exception,
                                            StackTrace? stackTrace) {
                                  // return Image.asset(
                                  //   // "assets/ic-logo.png",
                                  //   Assets.shared.icLogo,
                                  //   width: 50,
                                  //   height: 50,
                                  // );
                                  return const FlutterLogo(size: 50);
                                }),
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                            lang == Language.ENGLISH
                                                ? chlFavs[index].channel.titleEN
                                                : chlFavs[index]
                                                    .channel
                                                    .titleAR,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500)),
                                        Text(
                                            DateFormat("dd/MM/yyyy H:m:s")
                                                .format(chlFavs[index]
                                                    .channel
                                                    .updateDt),
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500)),
                                      ]),
                                )),
                                IconButton(
                                  iconSize: 35,
                                  icon:
                                      // favChannels
                                      //       .map((item) => item.channelId)
                                      //       .contains(chlFavs[index].channel.uid)
                                      (chlFavs[index].favorite != null)
                                          ? Icon(
                                              Icons.favorite,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            )
                                          : Icon(
                                              Icons.favorite_border_outlined,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                  onPressed: () {
                                    // var favId = favChannels.where((e) =>
                                    //     e.channelId == chlFavs![index].channel.uid);
                                    // print("favId is : " + favId.first);

                                    // favChannels
                                    //         .map((item) => item.channelId)
                                    //         .contains(Channel![index].uid)
                                    (chlFavs![index].favorite != null)
                                        ? deleteFavoriteChannel(
                                            chlFavs[index].favorite?.uid)
                                        : addFavoriteChannel(
                                            chlFavs[index].channel);
                                  },
                                ),
                                if (user?.userType == UserType.ADMIN)
                                  IconButton(
                                    iconSize: 35,
                                    icon: Icon(
                                      Icons.delete_forever,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    onPressed: () {
                                      _deleteaddchannel(
                                          context, chlFavs![index].channel.uid);
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

  addFavoriteChannel(ChannelModel channel) async {
    // print("going to add favourit na ja : " + channel.uid);
    var favId = idGenerator();
    var userId = userIdAdmin();

    (isFirebaseDown
        ? favoriteProvider.saveNote(DbFavoriteModel()
          ..id = int.parse(favId)
          ..titleEN.v = channel.titleEN
          ..titleAR.v = channel.titleAR
          ..streamURL.v = channel.streamURL
          ..channelId.v = channel.uid
          ..sectionUid.v = channel.sectionuid
          ..logoURL.v = channel.logoURL
          ..uid.v = "fv_" + favId.toString()
          ..userId.v = userId
          ..section.v = channel.section.index)
        : FirebaseManager.shared.addToFavorite(context,
            channelId: channel.uid,
            section: channel.section.index,
            channel: channel));
  }

  deleteFavoriteChannel(uid) {
    //print("going to delete favourit na ja : " + uid);
    (isFirebaseDown
        ? favoriteProvider.deleteNote(int.parse(uid.substring(3)))
        : FirebaseManager.shared.deleteFavoriteChannel(context, uid: uid));
  }

  _deleteaddchannel(context, String uidchannel) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Theme.of(context).canvasColor,
        title: Text(
          "Delete",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        content: Text(
          "Are you sure to delete?",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async => {
              (isFirebaseDown
                  ? await channelProvider
                      .deleteNote(int.parse(uidchannel.substring(3)))
                  : await FirebaseManager.shared
                      .deletechannel(context, uidchannel: uidchannel)),
              Navigator.of(context).pop(),
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

  // callExternalBetter() async {
  //   try {
  //     ///checks if the app is installed on your mobile device
  //     bool isInstalled =
  //         await DeviceApps.isAppInstalled('com.mxtech.videoplayer.ad');
  //     if (isInstalled) {
  //       DeviceApps.openApp("com.mxtech.videoplayer.ad");
  //     } else {
  //       ///if the app is not installed it lunches google play store so you can install it from there
  //       launch("market://details?id=" + "com.mxtech.videoplayer.ad");
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

}
