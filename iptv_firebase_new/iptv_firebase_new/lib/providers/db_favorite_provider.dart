// ignore_for_file: prefer_const_declarations

import 'package:sembast/sembast.dart';
import 'package:tekartik_common_utils/common_utils_import.dart';
import 'package:tv/models/DbFavoriteModel.dart';
import 'package:tv/models/favoriteModel.dart';
import 'package:tv/utils/utils.dart';

DbFavoriteModel snapshotToNote(RecordSnapshot snapshot) {
  return DbFavoriteModel()
    ..fromMap(snapshot.value as Map)
    ..id = snapshot.key as int;
}

class DbFavoriteModels extends ListBase<DbFavoriteModel> {
  final List<RecordSnapshot<int, Map<String, Object?>>> list;
  // ignore: unnecessary_question_mark
  late List<dynamic?> _cacheNotes;

  DbFavoriteModels(this.list) {
    //print("Fovorite list length is : " + list.length.toString());
    _cacheNotes = List.generate(list.length, (index) => null);
  }

  @override
  DbFavoriteModel operator [](int index) {
    return _cacheNotes[index] ??= snapshotToNote(list[index]);
  }

  @override
  int get length => list.length;

  @override
  void operator []=(int index, DbFavoriteModel? value) => throw 'read-only';

  @override
  set length(int newLength) => throw 'read-only';
}

class DbFavoriteModels2 extends ListBase<FavoriteModel> {
  final List<RecordSnapshot<int, Map<String, Object?>>> list;
  // ignore: unnecessary_question_mark
  late List<dynamic?> _cacheNotes;

  DbFavoriteModels2(this.list) {
    //print("Section list length is : " + list.length.toString());
    _cacheNotes = List.generate(list.length, (index) => null);
  }

  @override
  FavoriteModel operator [](int index) {
    // return _cacheNotes[index] ??= snapshotToNote(list[index]);

    // print("print : " + list[index].value['titleEN'].toString());
    var sect = FavoriteModel(
        titleen: list[index].value['titleEN'].toString(),
        titlear: list[index].value['titleAR'].toString(),
        streamURL: list[index].value['streamURL'].toString(),
        logoURL: list[index].value['logoURL'].toString(),
        channelId: list[index].value['channelId'].toString(),
        section: int.parse(list[index].value['section'].toString()),
        userId: list[index].value['userId'].toString(),
        uid: list[index].value['uid'].toString(),
        sectionUid: list[index].value['sectionUid'].toString());
    return _cacheNotes[index] ??= sect;
  }

  @override
  int get length => list.length;

  @override
  void operator []=(int index, FavoriteModel? value) => throw 'read-only';

  @override
  set length(int newLength) => throw 'read-only';
}

class DbFavoriteProvider {
  static const String dbName = 'fovorite.db';
  static const int kVersion1 = 1;
  static final String notesStoreName = 'fovorite';
  final lock = Lock(reentrant: true);
  final DatabaseFactory dbFactory;
  Database? db;

  final notesStore = intMapStoreFactory.store(notesStoreName);

  DbFavoriteProvider(this.dbFactory);

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

  Future<DbFavoriteModel?> getNote(int id) async {
    var map = await notesStore.record(id).get(db!);
    // devPrint('getNote: ${map}');
    if (map != null) {
      return DbFavoriteModel()
        ..fromMap(map)
        ..id = id;
    }
    return null;
  }

  void _onVersionChanged(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < kVersion1) {
      await notesStore.addAll(db, [
        (DbFavoriteModel()
              ..titleEN.v = 'chaovapan'
              ..titleAR.v = 'chaovapan'
              ..section.v = 2
              ..channelId.v = 'xxx'
              ..streamURL.v = 'xxx'
              ..logoURL.v = 'xxx'
              ..uid.v = '212121515'
              ..userId.v = '212121515')
            .toMap(),
      ]);
    }
  }

  Future<Database> open() async {
    return await openPath(await fixPath(dbName));
  }

  Future<String> fixPath(String path) async => path;

  Future saveNote(DbFavoriteModel updatedNote) async {
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
      List<DbFavoriteModel>>.fromHandlers(handleData: (snapshotList, sink) {
    sink.add(DbFavoriteModels(snapshotList));
  });

  var notesTransformer2 = StreamTransformer<
      List<RecordSnapshot<int, Map<String, Object?>>>,
      List<FavoriteModel>>.fromHandlers(handleData: (snapshotList, sink) {
    sink.add(DbFavoriteModels2(snapshotList));
  });

  var noteTransformer = StreamTransformer<
      RecordSnapshot<int, Map<String, Object?>>?,
      DbFavoriteModel?>.fromHandlers(handleData: (snapshot, sink) {
    sink.add(snapshot == null ? null : snapshotToNote(snapshot));
  });

  /// Listen for changes on any note
  Stream<List<DbFavoriteModel>> onNotes(sectionType) {
    return notesStore
        .query(
            finder: Finder(
                filter: Filter.equals('section', sectionType),
                sortOrders: [SortOrder('titleEN', true)]))
        .onSnapshots(db!)
        .transform(notesTransformer);
  }

  Stream<List<FavoriteModel>> onFavorites(sectionType) {
    var userId = userIdAdmin();
    // FirebaseManager.shared.getUserByUid(uid: "xxx").then((user) {
    //   userId = user.uid!;
    // });
    // print("user id is : " + userId);
    return notesStore
        .query(
            finder: Finder(
                filter: Filter.and(
                  [
                    //you can add more filters
                    Filter.equals("userId", userId),
                    Filter.equals('section', sectionType),
                  ],
                ),
                sortOrders: [SortOrder('titleEN', true)]))
        .onSnapshots(db!)
        .transform(notesTransformer2);
  }

  Stream<List<FavoriteModel>> onFavoritesBySectionUid(sectionUid) {
    // print("sectionUid 2 is " + sectionUid);
    var userId = userIdAdmin();
    // FirebaseManager.shared.getUserByUid(uid: "xxx").then((user) {
    //   userId = user.uid!;
    // });
    // print("user id is : " + userId);
    return notesStore
        .query(
            finder: Finder(
                filter: Filter.and(
                  [
                    //you can add more filters
                    Filter.equals("userId", userId),
                    Filter.equals("sectionUid", sectionUid),
                  ],
                ),
                sortOrders: [SortOrder('titleEN', true)]))
        .onSnapshots(db!)
        .transform(notesTransformer2);
  }

  Stream<List<FavoriteModel>> onFavoritesByChannelId(channelId) {
    var userId = userIdAdmin();
    // FirebaseManager.shared.getUserByUid(uid: "xxx").then((user) {
    //   userId = user.uid!;
    // });
    return notesStore
        .query(
            finder: Finder(
                filter: Filter.and(
                  [
                    //you can add more filters
                    Filter.equals("userId", userId),
                    Filter.equals('channelId', channelId),
                  ],
                ),
                sortOrders: [SortOrder('titleEN', true)]))
        .onSnapshots(db!)
        .transform(notesTransformer2);
  }

  /// Listed for changes on a given note
  Stream<DbFavoriteModel?> onNote(int id) {
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
