// ignore_for_file: file_names

import 'dart:convert';

import 'package:tv/manger/Section.dart';

SectionModel sectionModelFromJson(String str) =>
    SectionModel.fromJson(json.decode(str));

class SectionModel {
  SectionModel({
    required this.titleEN,
    required this.titleAR,
    required this.section,
    required this.uid,
    required this.createDt,
    required this.updateDt,
  });

  String titleEN;
  String titleAR;
  Section section;
  String uid;
  DateTime createDt;
  DateTime updateDt;

  factory SectionModel.fromJson(Map<String, dynamic>? json) => SectionModel(
        titleEN: json!["title-en"],
        titleAR: json["title-ar"],
        section: Section.values[json["section"]],
        uid: json["uid"],
        createDt: DateTime.parse(json["createDt"]),
        updateDt: DateTime.parse(json["updateDt"]),
      );
  Map<String, dynamic> toJson() => {
        "title-en": titleEN,
        "title-ar": titleAR,
        "section": section.index,
        "uid": uid,
        "createDt": createDt,
        "updateDt": updateDt,
      };
}
