// ignore_for_file: file_names, camel_case_types

class w3uM3uModel {
  String? name;
  String? author;
  String? image;
  String? url;
  String? stations;
  String? info;
  String? groups;
  String? referer;
  String? import;

  w3uM3uModel(
      {this.name,
      this.author,
      this.image,
      this.url,
      this.stations,
      this.info,
      this.groups,
      this.referer,
      this.import});

  w3uM3uModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    author = json['author'];
    image = json['image'];
    url = json['url'];
    stations = json['stations'];
    info = json['info'];
    groups = json['groups'];
    referer = json['referer'];
    import = json['import'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['author'] = author;
    data['image'] = image;
    data['url'] = url;
    data['stations'] = stations;
    data['info'] = info;
    data['groups'] = groups;
    data['referer'] = referer;
    data['import'] = import;
    return data;
  }
}
