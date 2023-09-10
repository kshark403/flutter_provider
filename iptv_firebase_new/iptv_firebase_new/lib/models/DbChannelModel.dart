// ignore_for_file: file_names

import 'package:tv/db/db.dart';

class DbChannelModel extends DbRecord {
  final titleEN = CvField<String>('titleEN');
  final titleAR = CvField<String>('titleAR');
  final section = CvField<int>('section');
  final sectionuid = CvField<String>('sectionuid');
  final streamURL = CvField<String>('streamURL');
  final logoURL = CvField<String>('logoURL');
  final uid = CvField<String>('uid');
  final createDt = CvField<String>('createDt');
  final updateDt = CvField<String>('updateDt');

  @override
  List<CvField> get fields => [
        titleEN,
        titleAR,
        section,
        sectionuid,
        streamURL,
        logoURL,
        uid,
        createDt,
        updateDt
      ];
  // List<CvField> get fields => [titleEN, titleAR, section, uid];

}
