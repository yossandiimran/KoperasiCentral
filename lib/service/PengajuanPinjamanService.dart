// ignore_for_file: file_names, avoid_print, overridden_fields, prefer_typing_uninitialized_variables, use_build_context_synchronously
part of '../header.dart';

class PengajuanPinjamanService extends HandleStatusCode {
  @override
  BuildContext context;
  Map? objParam;
  var returnData;

  PengajuanPinjamanService({required this.context, this.objParam}) : super(context);

  Future<Map> postPengajuanPinjaman() async {
    alert.loadingAlert(context: context, text: "Mohon tunggu ... ", isPop: false);
    Uri url = global.getMainServiceUrl('transaksi/pinjaman/create');
    Map<String, String> header = {
      'authorization': 'Bearer ${preference.getData('token')}',
    };

    try {
      returnData = {};
      await http.post(url, headers: header, body: objParam).then((response) async {
        Map res = await handle(code: response.statusCode, response: response.body);
        Navigator.pop(context);
        print(response.statusCode);
        print(json.decode(response.body));
        if (res['success']) {
          Navigator.pushNamed(context, '/home');
          alert.alertSuccess(context: context, text: res['message']);
        } else {
          Navigator.pop(context);
          alert.alertWarning(context: context, text: res['message']);
        }
      });
    } catch (err) {
      returnData = {};
    }

    return returnData;
  }

  Future<Map> getListPengajuan() async {
    Uri url = global.getMainServiceUrl('transaksi/pinjaman/list');
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
}
