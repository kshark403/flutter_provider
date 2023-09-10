// ignore_for_file: file_names

import 'package:tv/db/db.dart';

class DbFavoriteModel extends DbRecord {
  final titleEN = CvField<String>('titleEN');
  final titleAR = CvField<String>('titleAR');
  final section = CvField<int>('section');
  final channelId = CvField<String>('channelId');
  final streamURL = CvField<String>('streamURL');
  final logoURL = CvField<String>('logoURL');
  final uid = CvField<String>('uid');
  final userId = CvField<String>('userId');
  final sectionUid = CvField<String>('sectionUid');

  @override
  List<CvField> get fields => [
        titleEN,
        titleAR,
        section,
        channelId,
        streamURL,
        logoURL,
        uid,
        userId,
        sectionUid
      ];
}
