import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:koperasi_central/header.dart';

Global global = Global();
Preference preference = Preference();
Alert alert = Alert();
CustomWidget widget = CustomWidget();
TextStyling textStyling = TextStyling();
FirebaseMessagingHelper fbmessaging = FirebaseMessagingHelper();

var appVersion = '0.0.1';
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
  getWidth(context) => MediaQuery.of(context).size.width;
  getHeight(context) => MediaQuery.of(context).size.height;
  //Handle Service ===============================================================
  // DEV PUBLIC 36.91.208.116
  // var baseUrl = 'http://192.168.1.113:30/master-data/public/api/';
  var baseUrl = 'http://192.168.1.113:30/service-koperasi/public/user/';
  var basePath = 'http://192.168.1.113:30/service-koperasi/public/storage/file/';
  // var bapiUrl = 'http://36.91.208.116:8000/user-center/getkend';

  //PRD PUBLIC
  // var baseUrl = 'http://210.210.165.197/geura/public/api/';
  // var basePath = 'http://210.210.165.197/geura/public/storage/file/';

  getMainServiceUrl(String link) => Uri.parse(baseUrl + link);

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
}

class CurrencyFormat {
  static String convertToIdr(dynamic number, int decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(number);
  }
}
