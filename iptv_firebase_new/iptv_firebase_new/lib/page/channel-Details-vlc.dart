//import 'package:flick_video_player/flick_video_player.dart';
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:tv/app.dart';
import 'package:tv/manger/M.S.dart';
// import 'package:video_player/video_player.dart';

import 'package:tv/manger/language.dart';
import 'package:tv/models/DbFavoriteModel.dart';
import 'package:tv/models/channelModel.dart';
import 'package:tv/models/favoriteModel.dart';
import 'package:tv/models/user_profile.dart';
// import 'package:flick_video_player/flick_video_player.dart';

import 'package:flutter/scheduler.dart';
// import 'package:fijkplayer/fijkplayer.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:tv/utils/utils.dart';

// ignore: camel_case_types, must_be_immutable
class cchannelDetailsVlc extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final ChannelModel Channel;
  bool isFavorite = false;
  // ignore: use_key_in_widget_constructors
  cchannelDetailsVlc({
    // ignore: non_constant_identifier_names
    required this.Channel,
  });

  @override
  cchannelDetailsVlcState createState() => cchannelDetailsVlcState();
}

// ignore: camel_case_types
class cchannelDetailsVlcState extends State<cchannelDetailsVlc> {
  // late FlickManager _controller;
  // FijkPlayer player = FijkPlayer();
  late VlcPlayerController _videoPlayerController;
  Future<void> initializePlayer() async {}

  Language lang = Language.ENGLISH;
  // late VideoPlayerController controller;

  @override
  // ignore: must_call_super
  void initState() {
    try {
      _videoPlayerController = VlcPlayerController.network(
        // 'https://media.w3.org/2010/05/sintel/trailer.mp4',
        widget.Channel.streamURL,
        hwAcc: HwAcc.full,
        autoPlay: true,
        autoInitialize: true,
        options: VlcPlayerOptions(),
      );
      // _videoPlayerController.setVideoAspectRatio(this.context.);
    } catch (e) {
      // print(e);
    }

    // player.setDataSource(widget.Channel.streamURL, autoPlay: true);
    KeepScreenOn.turnOn(true);

    // _controller = FlickManager(
    //   videoPlayerController: VideoPlayerController.network(
    //     widget.Channel.streamURL,
    //   ),
    // );
    UserProfile.shared.getLanguage().then((value) {
      setState(() {
        lang = value!;
      });
    });
  }

  @override
  void dispose() async {
    super.dispose();
    // _controller.dispose();
    // player.release();
    await _videoPlayerController.stopRendererScanning();
    // await _videoViewController.dispose();

    KeepScreenOn.turnOff();
  }

  addFavoriteChannel() async {
    if (isFirebaseDown) {
      var favId = idGenerator();
      var userId = userIdAdmin();

      await favoriteProvider.saveNote(DbFavoriteModel()
        ..id = int.parse(favId)
        ..titleEN.v = widget.Channel.titleEN
        ..titleAR.v = widget.Channel.titleAR
        ..streamURL.v = widget.Channel.streamURL
        ..channelId.v = widget.Channel.uid
        ..sectionUid.v = widget.Channel.sectionuid
        ..logoURL.v = widget.Channel.logoURL
        ..uid.v = widget.Channel.uid
        ..userId.v = userId
        ..section.v = widget.Channel.section.index);
    } else {
      FirebaseManager.shared.addToFavorite(context,
          channelId: widget.Channel.uid,
          section: widget.Channel.section.index,
          channel: widget.Channel);
    }
  }

  deleteFavoriteChannel(uid) {
    if (isFirebaseDown) {
      favoriteProvider.deleteNote(int.parse(uid.substring(3)));
    } else {
      FirebaseManager.shared.deleteFavoriteChannel(context, uid: uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    //   return Container(child: Text("Chao"));
    // }

    return OrientationBuilder(builder: (context, orientation) {
      if (MediaQuery.of(context).orientation == Orientation.landscape) {
        WidgetsFlutterBinding.ensureInitialized();
        // player.enterFullScreen();
      }
      if (MediaQuery.of(context).orientation == Orientation.portrait) {
        WidgetsFlutterBinding.ensureInitialized();
        SchedulerBinding.instance.addPostFrameCallback((_) {
          // player.exitFullScreen();
        });
      }
      return WillPopScope(
          onWillPop: () async {
            // _videoPlayerController.pause();
            // player.pause();
            // player.release();
            // player = FijkPlayer();
            // Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.of(context).pop();
            return false;
          },
          child: Scaffold(
              appBar: AppBar(
                  actions: [
                    StreamBuilder<List<FavoriteModel>>(
                      stream: (isFirebaseDown
                          ? favoriteProvider
                              .onFavoritesByChannelId(widget.Channel.uid)
                          : FirebaseManager.shared.getFavoriteByChannel(
                              channelId: widget.Channel.uid)),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<FavoriteModel>? section = snapshot.data;
                          return IconButton(
                              onPressed: () {
                                section!.isEmpty
                                    ? addFavoriteChannel()
                                    : deleteFavoriteChannel(section[0].uid);
                              },
                              icon: section!.isEmpty
                                  ? const Icon(Icons.favorite_border_outlined)
                                  : const Icon(Icons.favorite));
                        } else {
                          return Container();
                        }
                      },
                    )
                  ],
                  backgroundColor: Theme.of(context).canvasColor,
                  elevation: 0,
                  iconTheme: IconThemeData(
                    color: Theme.of(context).primaryColor,
                  ),
                  centerTitle: true,
                  title: Text(
                      lang == Language.ENGLISH
                          ? widget.Channel.titleEN
                          : widget.Channel.titleAR,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500))),
              body: Center(
                child: VlcPlayer(
                  controller: _videoPlayerController,
                  // aspectRatio: 16 / 9,
                  aspectRatio: _videoPlayerController.value.aspectRatio,
                  placeholder: const Center(child: CircularProgressIndicator()),
                ),
              ))
          // body: Container(
          //   alignment: Alignment.center,
          //   child: FijkView(
          //     player: player,
          //   ),
          // )),
          // body: SingleChildScrollView(
          //   // child: FlickVideoPlayer(
          //     flickManager: _controller,
          //   ),
          // ));
          );
    });
  }
}
