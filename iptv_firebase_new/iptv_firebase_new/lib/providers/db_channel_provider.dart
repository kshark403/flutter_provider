// ignore_for_file: prefer_const_declarations

import 'package:sembast/sembast.dart';
import 'package:tekartik_common_utils/common_utils_import.dart';
import 'package:tv/manger/Section.dart';
import 'package:tv/models/DbChannelModel.dart';
import 'package:tv/models/channelModel.dart';

DbChannelModel snapshotToNote(RecordSnapshot snapshot) {
  return DbChannelModel()
    ..fromMap(snapshot.value as Map)
    ..id = snapshot.key as int;
}

class DbChannelModels extends ListBase<DbChannelModel> {
  final List<RecordSnapshot<int, Map<String, Object?>>> list;
  // ignore: unnecessary_question_mark
  late List<dynamic?> _cacheNotes;

  DbChannelModels(this.list) {
    //print("Channel list length is : " + list.length.toString());
    _cacheNotes = List.generate(list.length, (index) => null);
  }

  @override
  DbChannelModel operator [](int index) {
    return _cacheNotes[index] ??= snapshotToNote(list[index]);
  }

  @override
  int get length => list.length;

  @override
  void operator []=(int index, DbChannelModel? value) => throw 'read-only';

  @override
  set length(int newLength) => throw 'read-only';
}

class DbChannelModels2 extends ListBase<ChannelModel> {
  final List<RecordSnapshot<int, Map<String, Object?>>> list;
  // ignore: unnecessary_question_mark
  late List<dynamic?> _cacheNotes;

  DbChannelModels2(this.list) {
    //print("Section list length is : " + list.length.toString());
    _cacheNotes = List.generate(list.length, (index) => null);
  }

  @override
  ChannelModel operator [](int index) {
    // return _cacheNotes[index] ??= snapshotToNote(list[index]);

    // print("print : " + list[index].value['titleEN'].toString());
    var sect = ChannelModel(
        titleEN: list[index].value['titleEN'].toString(),
        titleAR: list[index].value['titleAR'].toString(),
        streamURL: list[index].value['streamURL'].toString(),
        logoURL: list[index].value['logoURL'].toString(),
        sectionuid: list[index].value['sectionuid'].toString(),
        section:
            Section.values[int.parse(list[index].value['section'].toString())],
        uid: list[index].value['uid'].toString(),
        createDt: DateTime.parse(list[index].value['createDt'].toString()),
        updateDt: DateTime.parse(list[index].value['updateDt'].toString()));
    return _cacheNotes[index] ??= sect;
  }

  @override
  int get length => list.length;

  @override
  void operator []=(int index, ChannelModel? value) => throw 'read-only';

  @override
  set length(int newLength) => throw 'read-only';
}

class DbChannelProvider {
  static const String dbName = 'channel.db';
  static const int kVersion1 = 1;
  static final String notesStoreName = 'channel';
  final lock = Lock(reentrant: true);
  final DatabaseFactory dbFactory;
  Database? db;

  final notesStore = intMapStoreFactory.store(notesStoreName);

  DbChannelProvider(this.dbFactory);

  Future<Database> openPath(String path) async {
    db = await dbFactory.openDatabase(path,
        version: kVersion1, onVersionChanged: _onVersionChanged);
    //print("db path is : " + db!.path);
    return db!;
  }

  Future<Database> get ready async =>
      db ??= await lock.synchronized<Database>(() async {
        if (db == null) {
          await open();
        }
        return db!;
      });

  Future<DbChannelModel?> getNote(int id) async {
    var map = await notesStore.record(id).get(db!);
    // devPrint('getNote: ${map}');
    if (map != null) {
      return DbChannelModel()
        ..fromMap(map)
        ..id = id;
    }
    return null;
  }

  void _onVersionChanged(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < kVersion1) {
      await notesStore.addAll(db, [
        (DbChannelModel()
              ..titleEN.v = 'chaovapan'
              ..titleAR.v = 'chaovapan'
              ..section.v = 2
              ..sectionuid.v = 'xxx'
              ..streamURL.v = 'xxx'
              ..logoURL.v = 'xxx'
              ..uid.v = '212121515')
            .toMap(),
        // (DbChannelModel()
        //       ..titleEN.v = 'panmee'
        //       ..titleAR.v = 'panmee'
        //       ..section.v = 2
        //       ..uid.v = '212121516')
        //     .toMap(),
        // (DbNote()
        //       ..title.v = 'Welcome to NotePad'
        //       ..content.v =
        //           'Enter your notes\n\nThis is a content. Just tap anywhere to edit the note.\n'
        //               '${kIsWeb ? '\nYou can open multiple tabs or windows and see that the content is the same in all tabs' : ''}'
        //       ..date.v = 2)
        //     .toMap(),
      ]);
    }
  }

  Future<Database> open() async {
    return await openPath(await fixPath(dbName));
  }

  Future<String> fixPath(String path) async => path;

  Future saveNote(DbChannelModel updatedNote) async {
    if (updatedNote.id != null) {
      await notesStore.record(updatedNote.id!).put(db!, updatedNote.toMap());
    } else {
      updatedNote.id = await notesStore.add(db!, updatedNote.toMap());
    }
  }

  Future deleteNote(int? id) async {
    if (id != null) {
      await notesStore.record(id).delete(db!);
    }
  }

  var notesTransformer = StreamTransformer<
      List<RecordSnapshot<int, Map<String, Object?>>>,
      List<DbChannelModel>>.fromHandlers(handleData: (snapshotList, sink) {
    sink.add(DbChannelModels(snapshotList));
  });

  var notesTransformer2 = StreamTransformer<
      List<RecordSnapshot<int, Map<String, Object?>>>,
      List<ChannelModel>>.fromHandlers(handleData: (snapshotList, sink) {
    sink.add(DbChannelModels2(snapshotList));
  });

  var noteTransformer = StreamTransformer<
      RecordSnapshot<int, Map<String, Object?>>?,
      DbChannelModel?>.fromHandlers(handleData: (snapshot, sink) {
    sink.add(snapshot == null ? null : snapshotToNote(snapshot));
  });

  /// Listen for changes on any note
  Stream<List<DbChannelModel>> onNotes(sectionUid) {
    return notesStore
        .query(
            finder: Finder(
                filter: Filter.equals('sectionuid', sectionUid),
                sortOrders: [SortOrder('titleEN', true)]))
        .onSnapshots(db!)
        .transform(notesTransformer);
  }

  Stream<List<ChannelModel>> onChannelModels(sectionUid) {
    // print("sectionUid 1 is " + sectionUid);
    return notesStore
        .query(
            finder: Finder(
                filter: Filter.equals('sectionuid', sectionUid),
                sortOrders: [SortOrder('titleEN', true)]))
        .onSnapshots(db!)
        .transform(notesTransformer2);
    // print("aa 1 is " + aa.length.toString());
  }

  Stream<List<ChannelModel>> onChannelModelsBySectionType(sectionType) {
    return notesStore
        .query(
            finder: Finder(
                filter: Filter.equals('section', sectionType),
                sortOrders: [SortOrder('titleEN', true)]))
        .onSnapshots(db!)
        .transform(notesTransformer2);
  }

  /// Listed for changes on a given note
  Stream<DbChannelModel?> onNote(int id) {
    return notesStore.record(id).onSnapshot(db!).transform(noteTransformer);
  }

  Future clearAllNotes() async {
    await notesStore.delete(db!);
  }

  Future close() async {
    await db!.close();
  }

  Future deleteDb() async {
    await dbFactory.deleteDatabase(await fixPath(dbName));
  }
}
