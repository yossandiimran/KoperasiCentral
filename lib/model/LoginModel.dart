// ignore_for_file: file_names
part of "../header.dart";

class LoginModel {
  bool? success;
  String? message;
  Data? data;

  LoginModel({this.success, this.message, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? accessToken;
  User? user;

  Data({this.accessToken, this.user});

  Data.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access_token'] = accessToken;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  String? name;
  String? username;
  String? email;
  String? werks;
  String? imei;
  int? groupUser;
  String? firstLogin;
  String? createdAt;
  String? updatedAt;

  User(
      {this.name,
      this.username,
      this.email,
      this.werks,
      this.imei,
      this.groupUser,
      this.firstLogin,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    username = json['username'];
    email = json['email'];
    werks = json['werks'];
    imei = json['imei'];
    groupUser = json['group_user'];
    firstLogin = json['first_login'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['username'] = username;
    data['email'] = email;
    data['werks'] = werks;
    data['imei'] = imei;
    data['group_user'] = groupUser;
    data['first_login'] = firstLogin;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
