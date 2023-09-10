// ignore_for_file: file_names

// ignore: camel_case_types
class w3uModel {
  String? name;
  String? author;
  String? image;
  String? url;
  List<Stations>? stations;

  w3uModel({this.name, this.author, this.image, this.url, this.stations});

  w3uModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    author = json['author'];
    image = json['image'];
    url = json['url'];
    if (json['stations'] != null) {
      stations = <Stations>[];
      json['stations'].forEach((v) {
        stations!.add(Stations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['author'] = author;
    data['image'] = image;
    data['url'] = url;
    if (stations != null) {
      data['stations'] = stations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Stations {
  String? name;
  String? author;
  String? image;
  String? url;
  String? import;
  String? info;

  Stations(Set<String> set,
      {this.name, this.author, this.image, this.url, this.import, this.info});

  Stations.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    author = json['author'];
    image = json['image'];
    url = json['url'];
    import = json['import'];
    info = json['info'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['author'] = author;
    data['image'] = image;
    data['url'] = url;
    data['import'] = import;
    data['info'] = info;
    return data;
  }
}
