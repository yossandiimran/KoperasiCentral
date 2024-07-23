// ignore_for_file: file_names, avoid_print, overridden_fields, prefer_typing_uninitialized_variables, use_build_context_synchronously
part of '../header.dart';

class PembelianService extends HandleStatusCode {
  @override
  BuildContext context;
  Map? objParam;
  var returnData;

  PembelianService({required this.context, this.objParam}) : super(context);

  Future<Map> getKatalog() async {
    Uri url = global.getMainServiceUrl(objParam?['url']);
    print(url);
    print(preference.getData('token'));
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

  Future<void> orderCart() async {
    Uri url = global.getMainServiceUrl(objParam?['url']);
    Map<String, String> header = {'authorization': 'Bearer ${preference.getData('token')}'};
    print(url);
    try {
      Map body = {
        "tgl_order": objParam?["tgl_order"],
        "kode_anggota": objParam?["kode_anggota"],
        "kode_wilayah": objParam?["kode_wilayah"],
        "keterangan": objParam?["keterangan"],
      };

      for (int i = 0; i < objParam?["kode_barang"].length; i++) {
        body["kode_barang[$i]"] = objParam?["kode_barang"][i];
        body["harga_jual[$i]"] = objParam?["harga_jual"][i];
        body["qty[$i]"] = objParam?["qty"][i].toString();
      }

      await http.post(url, headers: header, body: body).then((resp) async {
        print(resp.statusCode);
        print(resp.body);
        Map res = await handle(code: resp.statusCode, response: resp.body);
        if (res["success"]) {
          Navigator.pop(context);
          Navigator.pop(context);
          preference.remove("cart");
          alert.alertSuccess(context: context, text: "Order berhasil disimpan");
        } else {
          Navigator.pop(context);
          alert.alertWarning(context: context, text: res["message"]);
        }
      });
    } catch (err) {
      print(err);
    }
  }
}
