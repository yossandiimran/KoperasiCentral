// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:koperasi_central/header.dart';

Global global = Global();
Preference preference = Preference();
Alert alert = Alert();
CustomWidget ui = CustomWidget();
TextStyling textStyling = TextStyling();
ShimmerWidget shimmerWidget = ShimmerWidget();
FirebaseMessagingHelper fbmessaging = FirebaseMessagingHelper();

var appVersion = '0.5.6';
var isMenuActive = 0;

//Default Theme Color
Color defBlue = const Color(0xff1572e8), defRed = const Color(0xffea4d56);
Color defOrange = const Color(0xffff910a), defGreen = const Color(0xff2bb930);
Color defGrey = const Color(0xff8d9498), defBlack1 = const Color(0xff1a2035);
Color defBlack2 = const Color(0xff202940), defWhite = Colors.white;
Color defPurple = const Color(0xff6861ce), defPurple2 = const Color(0xff5c55bf);
Color defOrange2 = const Color(0xffe7a92c), defblue2 = const Color(0xff22328f);
Color defTaro1 = const Color(0xff8894c4), defTaro2 = const Color(0xffa4a9cf);
Color defTaro3 = const Color(0xff7c8cbc), defwheat = const Color(0xfff6d99c);
var defblue3 = Colors.blue[100], defred2 = Colors.red[100], defgreen2 = Colors.green[100];
var deforg3 = Colors.orange[200], defyel = Colors.yellow[100], defteal = Colors.teal[100];

class Global {
  Future<double> getWidthPerHeight({String ctr = "Currenct", required BuildContext ctx}) async {
    Size hts = MediaQuery.of(ctx).size;
    double queit = ctr == "Current" ? hts.height / hts.width : 200;

    return queit;
  }

  getWidth(context) => MediaQuery.of(context).size.width;
  getHeight(context) => MediaQuery.of(context).size.height;
  //Handle Service ===============================================================

  // final mainUrl = 'http://192.168.1.128/';
  // final mainUrl = 'http://192.168.1.113:30/';
  final mainUrl = 'http://210.210.165.197/';
  // final mainUrl = 'http://192.168.1.114:88/';
  late String baseUrl, basePath, ktpPath, pasPath, baseUrlPengurus, imageUrl, rekeningPath;

  @override
  Global() {
    imageUrl = '${mainUrl}service-koperasi/public/storage/file/';
    baseUrl = '${mainUrl}service-koperasi/public/user/';
    baseUrlPengurus = '${mainUrl}service-koperasi/public/pengurus/';
    basePath = '${mainUrl}service-koperasi/public/storage/file/';

    // ktpPath = '${mainUrl}recruitment-e-central/public/img/identity/';
    // pasPath = '${mainUrl}recruitment-e-central/public/img/user/';
    // rekeningPath = '${mainUrl}e-central/public/storage/images/rekening/';

    ktpPath = 'http://jobs.gsg.co.id:81/img/identity/';
    pasPath = 'http://jobs.gsg.co.id:81/img/user/';
    rekeningPath = 'http://developer.gsg.co.id/e-central/public/storage/images/rekening/';
  }

  getMainServiceUrl(String link) => Uri.parse(baseUrl + link);
  getImageUrl(String link) => Uri.parse(imageUrl + link);
  getMainServiceUrlPengurus(String link) => Uri.parse(baseUrlPengurus + link);

  defaultErrorResponse(context, message) => alert.alertWarning(context: context, text: message);

  defaultSuccessResponse(context, message) => alert.alertSuccess(context: context, text: message);

  errorResponse(context, message) {
    Navigator.pop(context);
    alert.alertWarning(context: context, text: message);
  }

  errorResponseNavigate(context, message, route) {
    Navigator.pushNamed(context, route);
    alert.alertWarning(context: context, text: message);
  }

  successResponse(context, message) {
    Navigator.pop(context);
    alert.alertSuccess(context: context, text: message);
  }

  successResponseNavigate(context, message, route) {
    Navigator.pushNamed(context, route);
    alert.alertSuccess(context: context, text: message);
  }

  errorResponsePop(context, message) {
    Navigator.pop(context);
    alert.alertWarning(context: context, text: message);
  }

  successResponsePop(context, message) {
    Navigator.pop(context);
    alert.alertSuccess(context: context, text: message);
  }

  String formatDate(DateTime dateTime) {
    return DateFormat('MM/dd/yyyy').format(dateTime);
  }

  String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  String formatDate2(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  String formatDate3(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  Future<void> cekLogin7day({required BuildContext context}) async {
    var lastLogin = await preference.getData('lastLogin') ?? "-";
    DateTime now = DateTime.now();
    if (lastLogin == '-') {
      await preference.setString('lastLogin', now.toString());
    } else {
      DateTime dateLast = DateTime.parse(lastLogin);
      Duration difference = now.difference(dateLast);
      int daysDifference = difference.inDays;
      if (daysDifference >= 7) {
        preference.clearPreference();
        Navigator.pushReplacementNamed(context, '/');
      } else {
        await preference.setString('lastLogin', now.toString());
      }
    }
  }

  //Auto Logout 1 jam
  Future<void> autoLogoutCheck(context) async {
    var strDate = await preference.getData("dtLogin");
    DateTime targetTime = DateTime.parse(strDate);
    DateTime now = DateTime.now();
    Duration difference = now.difference(targetTime);
    int hoursDifference = difference.inHours;
    if (hoursDifference >= 1) {
      Navigator.pushNamed(context, '/login');
      alert.alertWarning(context: context, text: "Sesi Anda Habis Silahkan Login Ulang !");
      return preference.clearPreference();
    }
  }

  // Keranjang Belanja
  Future<void> addToCart(object, context, cntCart) async {
    var checkCart = await preference.getData("cart"), msg = "menambahkan ke";
    object["qty"] = cntCart;
    Map tempCart;

    if (checkCart == null) {
      tempCart = {
        "cart": [object]
      };
    } else {
      tempCart = jsonDecode(utf8.decode(base64.decode(checkCart)));
      Map<String, dynamic>? targetElemen = tempCart['cart'].firstWhere(
        (elemen) => elemen['kode'] == object["kode"],
        orElse: () => null,
      );
      if (targetElemen != null) {
        if (cntCart == 0) {
          tempCart['cart'].removeWhere((elemen) => elemen['kode'] == object["kode"]);
          msg = "menghapus dari";
        } else {
          msg = "mengupdate ke";
          targetElemen["qty"] = cntCart;
        }
      } else {
        tempCart["cart"].add(object);
      }
    }
    await preference.setString("cart", base64Encode(utf8.encode(jsonEncode(tempCart))));
    if (msg != "menghapus dari") {
      alert.alertSuccess(context: context, text: "Berhasil $msg keranjang");
    }
  }
}

class CurrencyFormat {
  static String convertToIdr(dynamic number, int decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
      // decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(number);
  }
}

//Upper Case Text Field
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

// Masking Satuan
class NumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final int selectionIndexFromTheRight = newValue.text.length - newValue.selection.end;

    // Hapus pemisah ribuan sebelum melakukan parsing
    final double number = double.parse(newValue.text.replaceAll('.', '').replaceAll(',', ''));

    final formatter = NumberFormat('#,###',
        'de_DE'); // Menggunakan konfigurasi de_DE agar pemisah ribuan menjadi titik dan pemisah desimal menjadi koma

    final newText = formatter.format(number);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: newText.length - selectionIndexFromTheRight.clamp(0, newText.length),
      ),
    );
  }
}
