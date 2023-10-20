// ignore_for_file: file_names
part of '../header.dart';

class HandleStatusCode {
  BuildContext context;
  HandleStatusCode(this.context);

  Map returnObj = {};

  Future<dynamic> handle({required code, required response, isDashboard = false}) async {
    try {
      Map data = jsonDecode(response);
      if (code == 200) {
        return returnObj = {'success': true, 'data': data["data"], 'message': data['message']};
      } else if (code == 201) {
        return returnObj = {'success': true, 'data': data["data"], 'message': data['message']};
      } else if (code == 202) {
        return returnObj = {'success': false, 'data': data["data"], 'message': data['message']};
      } else if (code == 203) {
        return returnObj = {'success': false, 'data': data["data"], 'message': data['message']};
      } else if (code == 400) {
        return returnObj = {'success': false, 'data': data["data"], 'message': data['message']};
      } else if (code == 401) {
        preference.clearPreference();
        Navigator.pushReplacementNamed(context, '/');
        return alert.alertWarning(context: context, text: "Sesi anda telah habis, silahkan login ulang");
      } else if (code == 404) {
        return alert.alertWarning(context: context, text: "Service tidak tersedia ! \nerr(404)");
      } else if (code == 403) {
        isMenuActive = 0;
        // Navigator.pushNamed(context, '/home');
        if (!isDashboard) {
          return alert.alertWarning(context: context, text: data["message"]);
        }
        // return returnObj = {'success': true, 'data': data["data"], 'message': data['message']};
      } else if (code == 405) {
        return alert.alertWarning(context: context, text: "Metode akses ditolak ! \nerr(405)");
      } else if (code == 422) {
        var dynamicData = data["data"];
        if (dynamicData.length != 0) {
          for (var key in dynamicData.keys) {
            var valueList = dynamicData[key]!;
            return alert.alertWarning(context: context, text: valueList[0].toString());
          }
        } else {
          return alert.alertWarning(context: context, text: data["message"]);
        }
      } else if (code == 500) {
        // return alert.alertWarning(context: context, text: "Kesalahan service ! \nerr(500)");
        return alert.alertWarning(context: context, text: data["message"]);
      } else {
        return alert.alertWarning(context: context, text: "Kesalahan service tidak diketahui ! \nerr(not avaliable)");
      }
    } catch (err) {
      return alert.alertWarning(context: context, text: "Kesalahan Aplikasi ! \nerr($err)");
    }
  }
}
