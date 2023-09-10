// ignore_for_file: file_names

import 'dart:convert';
// To parse this JSON data, do
//
//     final channelModel = channelModelFromJson(jsonString);

import 'package:tv/manger/Section.dart';

ChannelModel channelModelFromJson(String str) =>
    ChannelModel.fromJson(json.decode(str));

String channelModelToJson(ChannelModel data) => json.encode(data.toJson());

class ChannelModel {
  ChannelModel({
    required this.sectionuid,
    required this.section,
    required this.streamURL,
    required this.logoURL,
    required this.titleEN,
    required this.titleAR,
    required this.uid,
    required this.createDt,
    required this.updateDt,
  });

  String streamURL;
  String sectionuid;
  String titleEN;
  String titleAR;
  Section section;
  String uid;
  String logoURL;
  DateTime? createDt;
  DateTime updateDt;

  factory ChannelModel.fromJson(Map<String, dynamic>? json) => ChannelModel(
        streamURL: json!["streamURL"],
        logoURL: json["logoURL"],
        sectionuid: json["section-uid"],
        titleEN: json["title-en"],
        titleAR: json["title-ar"],
        section: Section.values[json["section"]],
        uid: json["uid"],
        createDt: DateTime.parse(json["createDt"]),
        updateDt: DateTime.parse(json["updateDt"]),
      );

  Map<String, dynamic> toJson() => {
        "section-uid": sectionuid,
        "url-image": streamURL,
        "url-logo": logoURL,
        "title-en": titleEN,
        "title-ar": titleAR,
        "section": section.index,
        "uid": uid,
        "createDt": createDt,
        "updateDt": updateDt,
      };
}
