// ignore_for_file: file_names, use_build_context_synchronously, prefer_typing_uninitialized_variables, prefer_interpolation_to_compose_strings

part of "../header.dart";

class LoginService {
  final BuildContext context;
  final objParam;
  LoginService({required this.context, this.objParam});

  Future login() async {
    alert.loadingAlert(context: context, text: "Mohon Tunggu .. ", isPop: false);

    try {
      var url = global.getMainServiceUrl('login');
      var dvc = await FirebaseMessaging.instance.getToken();
      var obj = {"username": objParam["user"], "password": objParam["pass"], "device_token": dvc};
      await http.post(url, body: obj).then((res) async {
        var data = json.decode(res.body), lm = LoginModel.fromJson(data);
        if (res.statusCode == 200) {
          if (lm.success == false) {
            return global.errorResponse(context, lm.message);
          } else {
            var checkPreference = await setUserPreference(lm, objParam["pass"]);
            if (checkPreference == 200) {
              var firstLogin = preference.getData("first_login");
              if (firstLogin == "") {
                return global.successResponseNavigate(context, lm.message, '/changePass');
              } else {
                return global.successResponseNavigate(context, lm.message, '/home');
              }
            } else {
              return global.errorResponse(context, 'Tidak dapat Login !');
            }
          }
        } else {
          return global.errorResponse(context, lm.message);
        }
      }).timeout(const Duration(seconds: 10), onTimeout: () {
        return global.errorResponsePop(context, "Koneksi Timeout ...");
      });
    } catch (e) {
      return 500;
    }
  }

  Future changePass() async {
    alert.loadingAlert(context: context, text: "Mohon Tunggu .. ", isPop: false);
    try {
      var url = global.getMainServiceUrl('change-password');
      var obj = {"password": objParam["password"], "password_confirmation": objParam["password_confirmation"]};
      var header = {'authorization': 'Bearer ' + preference.getData('token')};
      await http.post(url, headers: header, body: obj).then((res) async {
        var data = json.decode(res.body), lm = LoginModel.fromJson(data);
        if (res.statusCode == 200) {
          if (lm.success == false) {
            return global.errorResponse(context, lm.message);
          } else {
            preference.setString("first_login", "true");
            return global.successResponseNavigate(context, lm.message, '/home');
          }
        } else {
          preference.clearPreference();
          return global.errorResponseNavigate(context, "Sesi anda habis, silahkan login ulang !", '/');
        }
      }).timeout(const Duration(seconds: 10), onTimeout: () {
        return global.errorResponsePop(context, "Koneksi Timeout ...");
      });
    } catch (e) {
      return 500;
    }
  }

  Future setUserPreference(LoginModel lm, pass) async {
    try {
      await preference.setString("name", lm.data!.user!.name);
      await preference.setString("email", lm.data!.user!.email);
      await preference.setString("pass", pass);
      await preference.setString("first_login", lm.data!.user!.firstLogin);
      await preference.setString("token", lm.data!.accessToken);
      return 200;
    } catch (err) {
      return 201;
    }
  }
}
