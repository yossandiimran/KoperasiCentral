// ignore_for_file: file_names, use_build_context_synchronously, prefer_typing_uninitialized_variables, prefer_interpolation_to_compose_strings, avoid_print, overridden_fields, annotate_overrides

part of "../header.dart";

class AuthService extends HandleStatusCode {
  final BuildContext context;
  final objParam;
  AuthService({required this.context, this.objParam}) : super(context);
  Map returnData = {};
  Future login() async {
    alert.loadingAlert(context: context, text: "Mohon Tunggu .. ", isPop: false);

    try {
      var url = global.getMainServiceUrl('login');

      var dvc = await FirebaseMessaging.instance.getToken();
      var obj = {"username": objParam["username"], "password": objParam["password"], "device_token": dvc};
      print(url);
      print(obj);
      await http.post(url, body: obj).then((res) async {
        var data = json.decode(res.body), lm = LoginModel.fromJson(data);
        print(res.body);
        if (res.statusCode == 200) {
          if (lm.success == false) {
            return global.errorResponse(context, lm.message);
          } else {
            var checkPreference = await setUserPreference(lm, objParam["password"]);
            if (checkPreference == 200) {
              var firstLogin = await preference.getData("first_login");
              var aggrement = await preference.getData('aggrement');

              if (aggrement == false) {
                return Navigator.pushNamed(context, '/aggreement');
              }
              if (firstLogin == "false") {
                return global.successResponseNavigate(
                  context,
                  "Selamat datang di SmartKoperasi Central, silahkan melengkapi form berikut ini! \n ",
                  '/mutakhirData',
                );
              } else {
                return Navigator.pushNamed(context, '/home');
              }
            } else {
              return global.errorResponse(context, 'Tidak dapat Login !');
            }
          }
        } else {
          return global.errorResponse(context, lm.message);
        }
      });
    } catch (e) {
      print(e);
      return global.errorResponsePop(context, "Terjadi Kesalahan !");
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
      // print(e);
    }
  }

  Future setUserPreference(LoginModel lm, pass) async {
    print(lm.data!.user!.userData!.toString());
    try {
      await preference.setString("id", lm.data!.user!.id.toString());
      await preference.setString("reff_id", lm.data!.user!.reffId.toString());
      await preference.setString("name", lm.data!.user!.name);
      await preference.setString("kodeAnggota", lm.data!.user!.userData!.kodeAnggota);
      await preference.setString("kodeWilayah", lm.data!.wilayah ?? "BDG");
      await preference.setString("username", lm.data!.user!.username);
      await preference.setString("plafon", lm.data!.user!.userData!.plafon ?? "0");
      await preference.setString("tanggalPernyataan", lm.data!.user!.userData!.tanggalPernyataan ?? "-");
      await preference.setString("tanggalPersetujuan", lm.data!.user!.userData!.tanggalPersetujuan ?? "-");
      await preference.setString("tanggalMasuk", lm.data!.tglMasuk ?? "-");
      await preference.setString("email", lm.data!.user!.email);
      await preference.setString("email_verified_at", lm.data!.user!.emailVerifiedAt.toString());
      await preference.setString("first_login", lm.data!.user!.firstLogin.toString());
      await preference.setString("token", lm.data!.accessToken);
      await preference.setString("token_type", lm.data!.tokenType);
      await preference.setString("expires_in", lm.data!.expiresIn.toString());
      await preference.setBool("aggrement", lm.data!.aggrement);
      await preference.setString("pass", pass);
      await preference.setString("dtLogin", DateTime.now().toString());
      return 200;
    } catch (err) {
      print(lm.data!.aggrement);
      print("asdasdasds");
      return 201;
    }
  }

  Future<Map> getCentralData() async {
    Uri url = global.getMainServiceUrl('profile/central');
    print(url);
    print(preference.getData('token'));
    try {
      returnData = {};
      await http.get(url, headers: {
        'authorization': 'Bearer ${preference.getData('token')}',
      }).then((response) async {
        print(response.statusCode);
        print(response.body);
        Map res = await handle(code: response.statusCode, response: response.body);
        returnData = {'data': res["data"]};
      });
    } catch (err) {
      print(err);
      returnData = {};
    }

    return returnData;
  }

  Future<Map> getProfileData() async {
    Uri url = global.getMainServiceUrl('profile');
    print(url);
    print(preference.getData('token'));
    try {
      returnData = {};
      await http.get(url, headers: {
        'authorization': 'Bearer ${preference.getData('token')}',
      }).then((response) async {
        print(response.statusCode);
        print(response.body);
        Map res = await handle(code: response.statusCode, response: response.body);
        returnData = {'data': res["data"]};
      });
    } catch (err) {
      print(err);
      returnData = {};
    }

    return returnData;
  }
}
