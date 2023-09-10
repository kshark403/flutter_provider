// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tekartik_app_flutter_sembast/sembast.dart';
import 'package:tekartik_app_platform/app_platform.dart';
import 'package:tekartik_common_utils/common_utils_import.dart';
import 'package:tv/providers/db_channel_provider.dart';
import 'package:tv/providers/db_favorite_provider.dart';
import 'package:tv/providers/db_section_provider.dart';

import 'src/import_sqflite.dart' as sqflite;

late DbSectionProvider sectionProvider;
late DbChannelProvider channelProvider;
late DbFavoriteProvider favoriteProvider;

/// App initialization
Future<void> init({required String packageName}) async {
  WidgetsFlutterBinding.ensureInitialized();
  platformInit();
  // For dev, find the proper sqlite3.dll
  if (!kIsWeb) {
    sqflite.sqfliteWindowsFfiInit();
  }
  var databaseFactory = getDatabaseFactory(packageName: packageName);

  sectionProvider = DbSectionProvider(databaseFactory);

  channelProvider = DbChannelProvider(databaseFactory);

  favoriteProvider = DbFavoriteProvider(databaseFactory);

  // devPrint('/notepad Starting');
  await sectionProvider.ready;
  await channelProvider.ready;
  await favoriteProvider.ready;
  // runApp(MyApp());
}
