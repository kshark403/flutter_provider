import 'package:flutter/material.dart';
import 'package:tv/app.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/manger/Section.dart';
import 'package:tv/manger/language.dart';
import 'package:tv/models/SectionModel.dart';
import 'package:tv/models/channelModel.dart';
import 'package:tv/models/favorite_section_model.dart';
import 'package:tv/models/loader.dart';
import 'package:tv/models/user-model.dart';
import 'package:tv/models/user_profile.dart';
import 'package:tv/providers/stream_combiner.dart';
import 'package:tv/utils/utils.dart';

// import 'channel-Details.dart';
import 'channel-Details-vlc.dart';

// ignore: must_be_immutable
class FavoriteChannel extends StatefulWidget {
  // ignore: annotate_overrides
  _FavoriteChannelState createState() => _FavoriteChannelState();
  // ignore: non_constant_identifier_names
  final String Channel;
  final String screenTitle;
  bool searchMode = false;
  int? section;
  // ignore: use_key_in_widget_constructors
  FavoriteChannel(this.Channel, this.screenTitle, {this.section});
}

class _FavoriteChannelState extends State<FavoriteChannel> {
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
            // UserModel? user = snapshot.data;

            return Scaffold(
                appBar: AppBar(
                  backgroundColor: Theme.of(context).canvasColor,
                  elevation: 0,
                  iconTheme: IconThemeData(
                    color: Theme.of(context).primaryColor,
                  ),
                  title: appBarTitle,
                  centerTitle: true,
                ),
                body: _widgetTech(context, searchTextField));
          }

          return const SizedBox();
        });
  }

  // Widget fetchChannel(context, searchController, user) {
  //   return StreamBuilder<List<SectionModel>>(
  //       stream: (isFirebaseDown
  //           ? sectionProvider.onSections(widget.section)
  //           : FirebaseManager.shared.getSectionBySectionType(widget.section!)),
  //       builder: (context, snapshot) {
  //         List<SectionModel>? sections = [];
  //         if (snapshot.hasData) {
  //           sections = snapshot.data;
  //         }

  //         return _widgetTech(context, searchTextField, sections);
  //       });
  // }

  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Widget _widgetTech(context, searchController) {
    return StreamBuilder<List<FavoriteSectionModel>>(
        stream:
            StreamCombiner().getCombineFavoriteSectionStreams(widget.section),
        builder: (context, snapshot) {
          // print("Yooooooo");
          if (snapshot.hasData) {
            // ignore: non_constant_identifier_names
            List<FavoriteSectionModel>? Channel = snapshot.data;

            if (Channel!.isEmpty) {
              return Center(
                  child: Text(
                "No  added",
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 18),
              ));
            }
            return ListView.builder(
                itemCount: Channel.length,
                itemBuilder: (item, index) {
                  return MaterialButton(
                    onPressed: () {
                      openApp(Channel[index].favorite.streamURL);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Card(
                        color: Theme.of(context).canvasColor,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                IconButton(
                                  iconSize: 35,
                                  icon: Icon(
                                    Icons.favorite,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () {
                                    String uid = Channel[index].favorite.uid;
                                    (isFirebaseDown
                                        ? favoriteProvider.deleteNote(
                                            int.parse(uid.substring(3)))
                                        : FirebaseManager.shared
                                            .deleteFavoriteChannel(context,
                                                uid: Channel[index]
                                                    .favorite
                                                    .uid));
                                  },
                                ),
                                Image.network(Channel[index].favorite.logoURL,
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
                                                  (lang == Language.ENGLISH
                                                      ? Channel[index]
                                                          .favorite
                                                          .titleen
                                                      : Channel[index]
                                                          .favorite
                                                          .titlear),
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              Text(
                                                  // getSectionname(
                                                  //     sections,
                                                  //     Channel[index].favorite
                                                  //         .sectionUid),
                                                  Channel[index]
                                                      .section!
                                                      .titleEN,
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w500))
                                            ]))),
                                IconButton(
                                  iconSize: 35,
                                  icon: Icon(
                                    Icons.play_arrow,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => (Channel[index]
                                                        .favorite
                                                        .streamURL)
                                                    .toString()
                                                    .contains("rtsp:")
                                                ? cchannelDetailsVlc(
                                                    Channel: ChannelModel(
                                                        section: Section.values[
                                                            Channel[index]
                                                                .favorite
                                                                .section],
                                                        uid: Channel[index]
                                                            .favorite
                                                            .channelId,
                                                        streamURL:
                                                            Channel[index]
                                                                .favorite
                                                                .streamURL,
                                                        logoURL: Channel[index]
                                                            .favorite
                                                            .logoURL,
                                                        titleAR: Channel[index]
                                                            .favorite
                                                            .titlear,
                                                        titleEN: Channel[index]
                                                            .favorite
                                                            .titleen,
                                                        sectionuid: "",
                                                        createDt:
                                                            DateTime.now(),
                                                        updateDt:
                                                            DateTime.now()),
                                                  )
                                                // : cchannelDetails(
                                                : cchannelDetailsVlc(
                                                    Channel: ChannelModel(
                                                        section: Section.values[
                                                            Channel[index]
                                                                .favorite
                                                                .section],
                                                        uid: Channel[index]
                                                            .favorite
                                                            .channelId,
                                                        streamURL:
                                                            Channel[index]
                                                                .favorite
                                                                .streamURL,
                                                        logoURL: Channel[index]
                                                            .favorite
                                                            .logoURL,
                                                        titleAR: Channel[index]
                                                            .favorite
                                                            .titlear,
                                                        titleEN: Channel[index]
                                                            .favorite
                                                            .titleen,
                                                        sectionuid: "",
                                                        createDt:
                                                            DateTime.now(),
                                                        updateDt:
                                                            DateTime.now()),
                                                  )));
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

  String getSectionname(List<SectionModel> sections, String sectionUid) {
    // (channels.map((item) => item.uid).contains(channelId)
    //     ? "Yes"
    //     : "No");

    List outputList = sections.where((o) => o.uid == sectionUid).toList();
    return "@" + outputList.first.titleEN;
  }

  //  Stream<List<ChannelModel>> getMyFavorite(){

  //  Stream<List<FavoriteModel>> x = FirebaseManager.shared.getMyFavorites();
  //    FirebaseManager.shared.getchannelById(id: x.c)
}
