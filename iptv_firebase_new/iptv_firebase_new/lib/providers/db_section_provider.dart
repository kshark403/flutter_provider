// ignore_for_file: prefer_const_declarations

import 'package:sembast/sembast.dart';
import 'package:tekartik_common_utils/common_utils_import.dart';
import 'package:tv/manger/Section.dart';
import 'package:tv/models/DbSectionModel.dart';
import 'package:tv/models/SectionModel.dart';

DbSectionModel snapshotToNote(RecordSnapshot snapshot) {
  return DbSectionModel()
    ..fromMap(snapshot.value as Map)
    ..id = snapshot.key as int;
}

class DbSectionModels extends ListBase<DbSectionModel> {
  final List<RecordSnapshot<int, Map<String, Object?>>> list;
  // ignore: unnecessary_question_mark
  late List<dynamic?> _cacheNotes;

  DbSectionModels(this.list) {
    //print("Section list length is : " + list.length.toString());
    _cacheNotes = List.generate(list.length, (index) => null);
  }

  @override
  DbSectionModel operator [](int index) {
    return _cacheNotes[index] ??= snapshotToNote(list[index]);
  }

  @override
  int get length => list.length;

  @override
  void operator []=(int index, DbSectionModel? value) => throw 'read-only';

  @override
  set length(int newLength) => throw 'read-only';
}

class DbSectionModels2 extends ListBase<SectionModel> {
  final List<RecordSnapshot<int, Map<String, Object?>>> list;
  // ignore: unnecessary_question_mark
  late List<dynamic?> _cacheNotes;

  DbSectionModels2(this.list) {
    //print("Section list length is : " + list.length.toString());
    _cacheNotes = List.generate(list.length, (index) => null);
  }

  @override
  SectionModel operator [](int index) {
    // return _cacheNotes[index] ??= snapshotToNote(list[index]);

    // print("print : " + list[index].value['titleEN'].toString());
    var sect = SectionModel(
        titleEN: list[index].value['titleEN'].toString(),
        titleAR: list[index].value['titleAR'].toString(),
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
  void operator []=(int index, SectionModel? value) => throw 'read-only';

  @override
  set length(int newLength) => throw 'read-only';
}

class DbSectionProvider {
  static const String dbName = 'section.db';
  static const int kVersion1 = 1;
  static final String notesStoreName = 'section';
  final lock = Lock(reentrant: true);
  final DatabaseFactory dbFactory;
  Database? db;

  final notesStore = intMapStoreFactory.store(notesStoreName);

  DbSectionProvider(this.dbFactory);

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

  Future<DbSectionModel?> getNote(int id) async {
    var map = await notesStore.record(id).get(db!);
    // devPrint('getNote: ${map}');
    if (map != null) {
      return DbSectionModel()
        ..fromMap(map)
        ..id = id;
    }
    return null;
  }

  void _onVersionChanged(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < kVersion1) {
      await notesStore.addAll(db, [
        // (DbSectionModel()
        //       ..titleEN.v = 'chaovapan'
        //       ..titleAR.v = 'chaovapan'
        //       ..section.v = 2
        //       ..uid.v = '212121515')
        //     .toMap(),
        // (DbSectionModel()
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

  Future saveNote(DbSectionModel updatedNote) async {
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
      List<DbSectionModel>>.fromHandlers(handleData: (snapshotList, sink) {
    sink.add(DbSectionModels(snapshotList));
  });

  var notesTransformer2 = StreamTransformer<
      List<RecordSnapshot<int, Map<String, Object?>>>,
      List<SectionModel>>.fromHandlers(handleData: (snapshotList, sink) {
    sink.add(DbSectionModels2(snapshotList));
  });

  var noteTransformer = StreamTransformer<
      RecordSnapshot<int, Map<String, Object?>>?,
      DbSectionModel?>.fromHandlers(handleData: (snapshot, sink) {
    sink.add(snapshot == null ? null : snapshotToNote(snapshot));
  });

  // var noteTransformer2 = StreamTransformer<
  //     RecordSnapshot<int, Map<String, Object?>>?,
  //     SectionModel?>.fromHandlers(handleData: (snapshot, sink) {
  //   sink.add(snapshot == null ? null : snapshotToNote(snapshot));
  // });

  /// Listen for changes on any note
  Stream<List<DbSectionModel>> onNotes(sectionType) {
    // getSectionsByName(sectionType);
    return notesStore
        .query(
            finder: Finder(
                filter: Filter.equals('section', sectionType),
                sortOrders: [SortOrder('titleEN', true)]))
        .onSnapshots(db!)
        .transform(notesTransformer);
  }

  /// Listen for changes on any note
  Stream<List<SectionModel>> onSections(sectionType) {
    // getSectionsByName(sectionType);
    return notesStore
        .query(
            finder: Finder(
                filter: Filter.equals('section', sectionType),
                sortOrders: [SortOrder('titleEN', true)]))
        .onSnapshots(db!)
        .transform(notesTransformer2);
  }

  Stream<List<SectionModel>> onSectionByUid(uid) {
    // getSectionsByName(sectionType);
    return notesStore
        .query(
            finder: Finder(
                filter: Filter.equals('uid', uid),
                sortOrders: [SortOrder('titleEN', true)]))
        .onSnapshots(db!)
        .transform(notesTransformer2);
  }

  /// Listed for changes on a given note
  Stream<DbSectionModel?> onNote(int id) {
    return notesStore.record(id).onSnapshot(db!).transform(noteTransformer);
  }

  // Stream<SectionModel?> onSectionById(int id) {
  //   return notesStore.record(id).onSnapshot(db!).transform(noteTransformer);
  // }

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
