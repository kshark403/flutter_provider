import 'dart:convert';

List<UserModel> userModelFromJson(String str) => List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userModelToJson(List<UserModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
    String? id;
    String? username;
    String? fullname;
    String? imgProfile;
    String? status;

    UserModel({
        this.id,
        this.username,
        this.fullname,
        this.imgProfile,
        this.status,
    });

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        username: json["username"],
        fullname: json["fullname"],
        imgProfile: json["img_profile"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "fullname": fullname,
        "img_profile": imgProfile,
        "status": status,
    };
}
