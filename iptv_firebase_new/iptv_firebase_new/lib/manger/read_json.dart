import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
// import 'package:read_json_file/ProductDataModel.dart';
// ignore: library_prefixes
import 'package:flutter/services.dart' as rootBundle;
import 'package:tv/models/w3uModel.dart';

void main() {
  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

// ignore: use_key_in_widget_constructors
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: ReadJsonDataFile(),
      builder: (context, data) {
        if (data.hasError) {
          return Center(child: Text("${data.error}"));
        } else if (data.hasData) {
          var items = data.data as List<Stations>;
          return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Container(
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: Image(
                            image: NetworkImage(items[index].image.toString()),
                            fit: BoxFit.fill,
                          ),
                        ),
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: Text(
                                  items[index].name.toString(),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: Text(items[index].url.toString()),
                              )
                            ],
                          ),
                        ))
                      ],
                    ),
                  ),
                );
              });
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ));
  }

  // ignore: non_constant_identifier_names
  Future<List<Stations>?> ReadJsonDataFile() async {
    // final jsondata = await rootBundle.rootBundle.loadString('person.json');
    try {
      // final jsondata =
      //     await rootBundle.rootBundle.loadString('m3u/w3u_test_2.w3u');

      // final file = await pickM3UFile();
      final file = await pickJsonFile();
      if (file == null) return [];

      final jsondata = await file.readAsString();

      // print(jsondata);
      final list = json.decode("[" + jsondata + "]") as List<dynamic>;

      return (list.map((e) => w3uModel.fromJson(e)).toList()).first.stations;
    } catch (e) {
      // print(e);
    }
    return [];
  }

  Future<File?> pickJsonFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result == null) return null;

    var path2 = result.files.single.path;
    return File(path2!);
  }

  // ignore: non_constant_identifier_names
  Future<List<Stations>?> ReadJsonData() async {
    // final jsondata = await rootBundle.rootBundle.loadString('person.json');
    try {
      final jsondata =
          await rootBundle.rootBundle.loadString('m3u/w3u_test_2.w3u');
      // print(jsondata);
      final list = json.decode("[" + jsondata + "]") as List<dynamic>;
      // print(list.toString());
      // var stu = Stations({
      //   "this.name",
      //   "this.author",
      //   "this.image",
      //   "this.url",
      //   "this.import",
      //   "this.info"
      // });
      return (list.map((e) => w3uModel.fromJson(e)).toList()).first.stations;
    } catch (e) {
      // print(e);
    }
    return [];
  }
}
