// ignore_for_file: file_names, avoid_print, overridden_fields, use_build_context_synchronously
part of '../header.dart';

class PemutakhiranDataService extends HandleStatusCode {
  @override
  BuildContext context;
  Map? objParam;
  var returnData = {};

  PemutakhiranDataService({required this.context, this.objParam}) : super(context);

  Future<Map> postPemutakhiranData() async {
    Navigator.pop(context);
    alert.loadingAlert(context: context, text: "Menyimpan Data", isPop: false);
    Uri url = global.getMainServiceUrl('profile/pemutakhiran');
    var request = http.MultipartRequest('POST', url);
    request.headers["Authorization"] = 'Bearer ${preference.getData('token')}';
    request.fields['nik'] = objParam?["nik"];
    request.fields['nama'] = objParam?["nama"];
    request.fields['tanggal_lahir'] = objParam?["tanggal_lahir"];
    request.fields['jk'] = objParam?["jk"];
    request.fields['alamat'] = objParam?["alamat"];
    request.fields['kota_id'] = objParam?["kota_id"];
    request.fields['kecamatan_id'] = objParam?["kecamatan_id"];
    request.fields['kelurahan'] = objParam?["kelurahan"];
    request.fields['kode_pos'] = objParam?["kode_pos"];
    request.files.add(await http.MultipartFile.fromPath('f_ktp', objParam?["f_ktp"].path));
    request.files.add(await http.MultipartFile.fromPath('f_foto', objParam?["f_foto"].path));
    request.fields['statgaji'] = objParam?["statgaji"];
    request.fields['norek'] = objParam?["norek"];
    request.files.add(await http.MultipartFile.fromPath('f_norek', objParam?["f_norek"].path));
    request.fields['npwp'] = objParam?["npwp"];
    request.fields['dom_alamat'] = objParam?["dom_alamat"];
    request.fields['dom_kota_id'] = objParam?["dom_kota_id"];
    request.fields['dom_kecamatan_id'] = objParam?["dom_kecamatan_id"];
    request.fields['dom_kelurahan'] = objParam?["dom_kelurahan"];
    request.fields['dom_kodepos'] = objParam?["dom_kodepos"];
    request.fields['no_hp'] = objParam?["no_hp"];

    request.files.add(await http.MultipartFile.fromPath('f_pengkinian', objParam?["f_pengkinian"].path));

    try {
      await request.send().then((val) async {
        var responseString = await val.stream.bytesToString();
        Map res = await handle(code: val.statusCode, response: responseString);
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
