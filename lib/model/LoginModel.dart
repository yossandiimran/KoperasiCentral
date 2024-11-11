// ignore_for_file: file_names
part of '../header.dart';

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
  User? user;
  String? wilayah;
  String? accessToken;
  String? tokenType;
  bool? aggrement;
  String? tglMasuk;
  int? expiresIn;

  Data({this.user, this.accessToken, this.tokenType, this.expiresIn});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    tglMasuk = json['tgl_masuk'];
    aggrement = json['aggrement'];
    wilayah = json['wilayah'];
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['tgl_masuk'] = tglMasuk;
    data['aggrement'] = aggrement;
    data['wilayah'] = wilayah;
    data['access_token'] = accessToken;
    data['token_type'] = tokenType;
    data['expires_in'] = expiresIn;
    return data;
  }
}

class User {
  int? id;
  int? reffId;
  String? name;
  String? username;
  String? email;
  String? emailVerifiedAt;
  bool? firstLogin;
  UserData? userData;

  User({
    this.id,
    this.reffId,
    this.name,
    this.username,
    this.email,
    this.emailVerifiedAt,
    this.firstLogin,
    this.userData,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reffId = json['reff_id'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    firstLogin = json['first_login'];
    userData = json['data'] != null ? UserData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['reff_id'] = reffId;
    data['name'] = name;
    data['username'] = username;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['first_login'] = firstLogin;
    if (userData != null) {
      data['data'] = userData!.toJson();
    }
    return data;
  }
}

class UserData {
  int? id;
  bool? anggotaBaru;
  String? kodeAnggota;
  String? tipeAnggota;
  String? simpananWajib;
  String? plafon;
  String? saldoSimpanan;
  String? saldoPinjaman;
  int? status;
  String? tanggalPermohonan;
  String? buktiPermohonan;
  String? tanggalPersetujuan;
  String? tanggalPernyataan;

  UserData({
    this.id,
    this.anggotaBaru,
    this.kodeAnggota,
    this.tipeAnggota,
    this.simpananWajib,
    this.plafon,
    this.saldoSimpanan,
    this.saldoPinjaman,
    this.status,
    this.tanggalPermohonan,
    this.buktiPermohonan,
    this.tanggalPersetujuan,
    this.tanggalPernyataan,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    anggotaBaru = json['anggota_baru'];
    kodeAnggota = json['kode_anggota'];
    tipeAnggota = json['tipe_anggota'];
    simpananWajib = json['simpanan_wajib'];
    plafon = json['plafon'];
    saldoSimpanan = json['saldo_simpanan'];
    saldoPinjaman = json['saldo_pinjaman'];
    status = json['status'];
    tanggalPermohonan = json['tanggal_permohonan'];
    buktiPermohonan = json['bukti_permohonan'];
    tanggalPersetujuan = json['tanggal_persetujuan'];
    tanggalPernyataan = json['tanggal_pernyataan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['anggota_baru'] = anggotaBaru;
    data['kode_anggota'] = kodeAnggota;
    data['tipe_anggota'] = tipeAnggota;
    data['simpanan_wajib'] = simpananWajib;
    data['plafon'] = plafon;
    data['saldo_simpanan'] = saldoSimpanan;
    data['saldo_pinjaman'] = saldoPinjaman;
    data['status'] = status;
    data['tanggal_permohonan'] = tanggalPermohonan;
    data['bukti_permohonan'] = buktiPermohonan;
    data['tanggal_persetujuan'] = tanggalPersetujuan;
    data['tanggal_pernyataan'] = tanggalPernyataan;
    return data;
  }
}
