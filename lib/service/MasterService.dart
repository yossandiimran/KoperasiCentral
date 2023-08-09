// ignore_for_file: file_names, avoid_print, overridden_fields, prefer_typing_uninitialized_variables, use_build_context_synchronously
part of '../header.dart';

class MasterService extends HandleStatusCode {
  @override
  BuildContext context;
  Map? objParam;
  var returnData;

  MasterService({required this.context, this.objParam}) : super(context);

  Future<Map> getMasterKota() async {
    Uri url = global.getMainServiceUrl('select-values/kota');
    try {
      returnData = {};
      await http.get(url, headers: {
        'authorization': 'Bearer ${preference.getData('token')}',
      }).then((response) async {
        Map res = await handle(code: response.statusCode, response: response.body);
        returnData = {'data': res["data"]};
      });
    } catch (err) {
      returnData = {};
    }

    return returnData;
  }

  Future<Map> getMasterKecamatan() async {
    Uri url = global.getMainServiceUrl('select-values/kecamatan?kota_id=${objParam!['id_kota']}');
    try {
      returnData = {};
      await http.get(url, headers: {
        'authorization': 'Bearer ${preference.getData('token')}',
      }).then((response) async {
        Map res = await handle(code: response.statusCode, response: response.body);
        returnData = {'data': res["data"]};
      });
    } catch (err) {
      returnData = {};
    }

    return returnData;
  }

  Future<Map> getMasterJenisPinjam() async {
    Uri url = global.getMainServiceUrl('select-values/jenis-pinjaman');
    try {
      returnData = {};
      await http.get(url, headers: {
        'authorization': 'Bearer ${preference.getData('token')}',
      }).then((response) async {
        Map res = await handle(code: response.statusCode, response: response.body);
        returnData = {'data': res["data"]};
      });
    } catch (err) {
      returnData = {};
    }

    return returnData;
  }

  Future<Map> getDashboardService() async {
    Uri url = global.getMainServiceUrl('dashboard');
    try {
      returnData = {};
      await http.get(url, headers: {
        'authorization': 'Bearer ${preference.getData('token')}',
      }).then((response) async {
        Map res = await handle(code: response.statusCode, response: response.body);
        returnData = {'data': res["data"]};
      });
    } catch (err) {
      returnData = {};
    }

    return returnData;
  }

  // User Aggreement Service ========================================================================
  Future<Map> getUserAggreement() async {
    Uri url = global.getMainServiceUrl('user-aggrement');
    try {
      returnData = {};
      await http.get(url, headers: {
        'authorization': 'Bearer ${preference.getData('token')}',
      }).then((response) async {
        Map res = await handle(code: response.statusCode, response: response.body);
        returnData = {'data': res["data"]};
      });
    } catch (err) {
      returnData = {};
    }

    return returnData;
  }

  Future<Map> postUserAggreement() async {
    alert.loadingAlert(context: context, text: "Mohon tunggu ... ", isPop: false);
    Uri url = global.getMainServiceUrl('user-aggrement');
    try {
      returnData = {};
      await http.patch(url, headers: {
        'authorization': 'Bearer ${preference.getData('token')}',
      }).then((response) async {
        Map res = await handle(code: response.statusCode, response: response.body);
        Navigator.pop(context);
        if (res['success']) {
          alert.alertSuccess(context: context, text: res['message']);
          // Relogin
          var obj = {
            "username": preference.getData('username'),
            "password": preference.getData('pass'),
          };
          await AuthService(context: context, objParam: obj).login();
        }
      });
    } catch (err) {
      returnData = {};
    }

    return returnData;
  }
}
