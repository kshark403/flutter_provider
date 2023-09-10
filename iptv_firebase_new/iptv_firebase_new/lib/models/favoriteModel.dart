// ignore_for_file: file_names
// To parse this JSON data, do
//
//     final channelModel = channelModelFromJson(jsonString);

import 'dart:convert';

FavoriteModel favoriteModelFromJson(String str) =>
    FavoriteModel.fromJson(json.decode(str));

String favoriteModelToJson(FavoriteModel data) => json.encode(data.toJson());

class FavoriteModel {
  FavoriteModel({
    required this.channelId,
    required this.userId,
    required this.uid,
    required this.section,
    required this.streamURL,
    required this.logoURL,
    required this.titlear,
    required this.titleen,
    required this.sectionUid,
  });

  String channelId;
  String userId;
  String uid;
  int section;
  String streamURL;
  String logoURL;
  String titlear;
  String titleen;
  String sectionUid;

  factory FavoriteModel.fromJson(Map<String, dynamic>? json) => FavoriteModel(
        channelId: json!["channelId"],
        section: json["section"],
        streamURL: json["streamURL"],
        logoURL: json["logoURL"],
        titlear: json["titlear"],
        titleen: json["titleen"],
        uid: json["uid"],
        userId: json["userId"],
        sectionUid: json["sectionUid"],
      );

  Map<String, dynamic> toJson() => {
        "channelId": channelId,
        "section": section,
        "streamURL": streamURL,
        "logoURL": logoURL,
        "titlear": titlear,
        "titleen": titleen,
        "uid": uid,
        "userId": userId,
        "sectionUid": sectionUid,
      };
}
