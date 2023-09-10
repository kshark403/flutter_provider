import 'package:android_intent/android_intent.dart';
import 'package:flutter/cupertino.dart';
import 'package:tv/manger/M.S.dart';

String idGenerator() {
  final now = DateTime.now();
  // (new DateTime.now().millisecondsSinceEpoch).toString();
  return now.microsecondsSinceEpoch.toString();
}

bool isFirebaseDown = true;

checkFirebaseDown(context) {
  if (!isFirebaseDown) {
    FirebaseManager.shared.signOut(context);
  } else {
    Navigator.of(context).pushNamedAndRemoveUntil("/Splash", (route) => false);
  }
}

String userIdAdmin() {
  return "QZ5L4br0yGcMgodYehYNnAyo4Q72";
}

openApp(String url) async {
  // print("url is : " + url);
  // bool isInstalled =
  //     await DeviceApps.isAppInstalled('com.mxtech.videoplayer.ad');
  // if (isInstalled != false) {
  // AndroidIntent intent = AndroidIntent(action: 'action_send', data: dt, package: url);
  if (url.contains("youtu")) {
    //print("url youtu is : " + url);
    AndroidIntent intent = AndroidIntent(
      action: 'action_view',
      // data: "com.mxtech.videoplayer.ad",
      data: url,
    );
    await intent.launch();
  } else {
    //print("url video is : " + url);
    AndroidIntent intent = AndroidIntent(
      action: 'action_view',
      // data: "com.mxtech.videoplayer.ad",
      data: url,
      type: "video/*",
    );
    await intent.launch();
  }

  //     AndroidIntent.Intent()
  //       ..setAction('action_send')
  //       ..setData(Uri.parse(url))
  //       ..setPackage(p)
  //       ..startActivity().catchError((e) => print(e));
  // await intent.launch();
  // } else {
  //   // if (await canLaunch(url))
  //   //   await launch(url);
  //   // else
  //   throw 'Could not launch $url';
  // }
}
