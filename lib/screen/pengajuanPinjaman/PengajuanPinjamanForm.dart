// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_key_in_widget_constructors, no_logic_in_create_state, avoid_print, avoid_unnecessary_containers, unnecessary_null_comparison, invalid_use_of_visible_for_testing_member, prefer_interpolation_to_compose_strings, use_build_context_synchronously
part of '../../header.dart';

class PengajuanPinjamanForm extends StatefulWidget {
  @override
  PengajuanPinjamanFormState createState() => PengajuanPinjamanFormState();
}

class PengajuanPinjamanFormState extends State<PengajuanPinjamanForm> {
  List<dynamic> item = [];
  Map dataSimulasi = {};
  bool tanpaAngsuran = false;

  var jumlahPinjaman = TextEditingController(), tenorSelected = "", jenisSelected = "";
  var angsuranInput = TextEditingController();
  List<String> listTenor = [];
  @override
  void initState() {
    super.initState();
    getInitForm();
  }

  Future<dynamic> getInitForm() async {
    MasterService masterService = MasterService(context: context);
    Map respData = await masterService.getMasterJenisPinjam();
    item = respData["data"];

    print(item);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Form Pengajuan Pinjaman", style: textStyling.defaultWhite(20)),
          elevation: 0,
          centerTitle: true,
          backgroundColor: defOrange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
        ),
        backgroundColor: Colors.blueGrey.shade50,
        extendBodyBehindAppBar: true,
        body: getBody(),
      ),
    );
  }

  getBody() {
    return SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.bottomLeft,
              margin: EdgeInsets.only(top: 15),
              child: Text("  Jenis Pinjaman", textAlign: TextAlign.left),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              margin: EdgeInsets.only(top: 5),
              decoration: ui.decCont(Colors.white, 15, 15, 15, 15),
              width: global.getWidth(context),
              child: SizedBox(
                width: global.getWidth(context) / 1.2,
                child: DropdownSearch<String>(
                  showSearchBox: true,
                  mode: Mode.DIALOG,
                  items: [for (var i = 0; i < item.length; i++) item[i]["nama"]],
                  dropdownSearchDecoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                  selectedItem: jenisSelected,
                  onChanged: (itm) {
                    jenisSelected = itm!;
                    print(jenisSelected);
                    List kodeJenis = item.where((element) => element['nama'] == jenisSelected).toList();
                    dataSimulasi.clear();
                    angsuranInput.clear();
                    jumlahPinjaman.clear();
                    if (kodeJenis[0]["tanpa_angsuran"]) {
                      listTenor = ["1x"];
                      tenorSelected = "1x";
                      tanpaAngsuran = true;
                    } else {
                      tanpaAngsuran = false;
                      listTenor = ["1x", "3x", "6x", "12x", "24x", "36x", "48x"];
                    }
                    setState(() {});
                  },
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                      labelText: "Cari",
                    ),
                  ),
                  popupTitle: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: defOrange,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Pilih Jenis Pinjaman',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  popupShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                      bottomLeft: Radius.circular(24),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              margin: EdgeInsets.only(top: 10),
              child: Text("  Jumlah Pinjaman", textAlign: TextAlign.left),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
              margin: EdgeInsets.only(top: 5),
              decoration: ui.decCont(Colors.white, 15, 15, 15, 15),
              width: global.getWidth(context),
              child: TextFormField(
                inputFormatters: [NumberTextInputFormatter()],
                controller: jumlahPinjaman,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Jumlah Pinjaman",
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              margin: EdgeInsets.only(top: 15),
              child: Text("  Lama Cicilan (x)", textAlign: TextAlign.left),
            ),
            !tanpaAngsuran
                ? Container(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                    margin: EdgeInsets.only(top: 5),
                    decoration: ui.decCont(Colors.white, 15, 15, 15, 15),
                    width: global.getWidth(context),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: angsuranInput,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Lama Cicilan (x)",
                      ),
                    ),
                  )
                // Container(
                //     padding: EdgeInsets.symmetric(horizontal: 10),
                //     margin: EdgeInsets.only(top: 5),
                //     decoration: ui.decCont(Colors.white, 15, 15, 15, 15),
                //     width: global.getWidth(context),
                //     child: SizedBox(
                //       width: global.getWidth(context) / 1.2,
                //       child: DropdownSearch<String>(
                //         showSearchBox: false,
                //         mode: Mode.DIALOG,
                //         items: listTenor,
                //         dropdownSearchDecoration: InputDecoration(
                //           enabledBorder: UnderlineInputBorder(
                //             borderSide: BorderSide.none,
                //           ),
                //         ),
                //         selectedItem: tenorSelected,
                //         onChanged: (itm) {
                //           tenorSelected = itm!;
                //           setState(() {});
                //         },
                //         popupTitle: Container(
                //           height: 50,
                //           decoration: BoxDecoration(
                //             color: defOrange,
                //             borderRadius: BorderRadius.only(
                //               topLeft: Radius.circular(20),
                //               topRight: Radius.circular(20),
                //             ),
                //           ),
                //           child: Center(
                //             child: Text(
                //               'Pilih Angsuran',
                //               style: TextStyle(
                //                 fontSize: 22,
                //                 fontWeight: FontWeight.bold,
                //                 color: Colors.white,
                //               ),
                //             ),
                //           ),
                //         ),
                //         popupShape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.only(
                //             topLeft: Radius.circular(24),
                //             topRight: Radius.circular(24),
                //             bottomRight: Radius.circular(24),
                //             bottomLeft: Radius.circular(24),
                //           ),
                //         ),
                //       ),
                //     ),
                //   )
                : Container(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                    margin: EdgeInsets.only(top: 5),
                    decoration: ui.decCont(Colors.white, 15, 15, 15, 15),
                    width: global.getWidth(context),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      readOnly: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "1x",
                      ),
                    ),
                  ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
              margin: EdgeInsets.symmetric(vertical: 10),
              width: global.getWidth(context),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: global.getWidth(context) / 2.7,
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      margin: EdgeInsets.only(top: 5),
                      decoration: ui.decCont(defRed, 15, 15, 15, 15),
                      child: Row(
                        children: [
                          Spacer(),
                          Icon(Icons.arrow_back_rounded, color: defWhite),
                          Text(" Batal", style: textStyling.customColor(14, defWhite)),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () async {
                      cekAngsuran();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      margin: EdgeInsets.only(top: 5),
                      decoration: ui.decCont(defBlue, 15, 15, 15, 15),
                      child: Row(
                        children: [
                          Text("Simulasi Cicilan", style: textStyling.customColor(14, defWhite)),
                          Icon(Icons.list, color: defWhite),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            dataSimulasi.isNotEmpty
                ? Container(
                    decoration: ui.decCont2(defWhite, 10, 10, 10, 10),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text("Simulasi Cicilan : ", style: textStyling.mcLarenBold(16, defBlack1)),
                        Divider(thickness: 2),
                        ListTile(
                          dense: true,
                          visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                          subtitle: Text(
                            // '''Nomor Transaksi : ${listPengajuan[i]['nomor_transaksi']}
// Besar Pinjaman :  ${CurrencyFormat.convertToIdr(double.parse(jumlahPinjaman.text.replaceAll('.', '')), 2).toString()}
                            '''
Besar Pinjaman :  ${CurrencyFormat.convertToIdr(double.parse(dataSimulasi["data"]["besar_pinjaman"].toString()), 2).toString()}
Realisasi :  ${CurrencyFormat.convertToIdr(double.parse(dataSimulasi["data"]["realisasi"].toString()), 2).toString()}
Lama Cicilan : ${angsuranInput.text != "" ? angsuranInput.text : "1"}x''',
                            style: textStyling.nunitoBold(15, defBlack1),
                          ),
                        ),
                        ExpansionTile(
                          expandedAlignment: Alignment.bottomLeft,
                          title: Text("Detail Angsuran"),
                          children: [
                            for (var element in dataSimulasi["data"]["cicilan"])
                              Container(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Cicilan Angsuran Ke - ${element["angsuran_ke"]}",
                                      style: textStyling.mcLarenBold(13, defBlack1),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Pokok   ",
                                          style: textStyling.nunitoBold(15, defBlack1),
                                        ),
                                        Spacer(),
                                        Text(
                                          CurrencyFormat.convertToIdr(double.parse(element["nominal"].toString()), 2)
                                              .toString(),
                                          style: textStyling.nunitoBold(15, defBlack1),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Bunga   ",
                                          style: textStyling.nunitoBold(15, defBlack1),
                                        ),
                                        Spacer(),
                                        Text(
                                          CurrencyFormat.convertToIdr(double.parse(element["bunga"].toString()), 2)
                                              .toString(),
                                          style: textStyling.nunitoBold(15, defBlack1),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Total     ",
                                          style: textStyling.mcLaren(15, defBlue),
                                        ),
                                        Spacer(),
                                        Text(
                                          CurrencyFormat.convertToIdr(
                                            double.parse((double.parse(element["nominal"].toString()) +
                                                    double.parse(element["bunga"].toString()))
                                                .toString()),
                                            2,
                                          ).toString(),
                                          style: textStyling.mcLaren(15, defBlue),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () async {
                            save();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            margin: EdgeInsets.only(top: 5),
                            decoration: ui.decCont(defGreen, 15, 15, 15, 15),
                            child: Row(
                              children: [
                                Spacer(),
                                Text("Ajukan Pinjaman ", style: textStyling.customColor(14, defWhite)),
                                Icon(Icons.arrow_forward_rounded, color: defWhite),
                                Spacer(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
            SizedBox(height: global.getHeight(context) / 2),
          ],
        ),
      ),
    );
  }

  cekAngsuran() async {
    if (jumlahPinjaman.text.replaceAll('.', '') == '') {
      return alert.alertWarning(context: context, text: "Jumlah Pinjaman Wajib Diisi !");
    }
    List kodeJenis = item.where((element) => element['nama'] == jenisSelected).toList();
    var angsr = angsuranInput.text != "" ? angsuranInput.text : "1";
    print(angsr);
    if (double.parse(angsr.toString()) > double.parse(kodeJenis[0]['tenor'].toString())) {
      return alert.alertWarning(
          context: context,
          text: "Jumlah angsuran pada ${kodeJenis[0]['nama']} tidak boleh melebihi ${kodeJenis[0]['tenor']}x");
    }
    Map objParam = {
      'kode_jenis': kodeJenis[0]['kode'],
      'besar_pinjaman': jumlahPinjaman.text.replaceAll('.', ''),
      'tenor': angsr,
    };
    PengajuanPinjamanService pps = PengajuanPinjamanService(context: context, objParam: objParam);
    alert.loadingAlert(context: context, text: "Menghitung angsuran ... ", isPop: false);
    dataSimulasi = await pps.getListSimulasi();

    print(dataSimulasi);
    setState(() {});
    Navigator.pop(context);
  }

  save() async {
    if (jumlahPinjaman.text.replaceAll('.', '') == '') {
      return alert.alertWarning(context: context, text: "Jumlah Pinjaman Wajib Diisi !");
    }

    List kodeJenis = item.where((element) => element['nama'] == jenisSelected).toList();

    Map objParam = {
      'kode_jenis': kodeJenis[0]['kode'],
      'besar_pinjaman': jumlahPinjaman.text.replaceAll('.', ''),
      'tenor': angsuranInput.text != "" ? angsuranInput.text : "1",
    };

    alert.alertConfirmation(
      context: context,
      action: () async {
        Navigator.pop(context);
        PengajuanPinjamanService pps = PengajuanPinjamanService(context: context, objParam: objParam);
        await pps.postPengajuanPinjaman();
      },
      message:
          "Setelah data tersimpan, pengajuan pinjaman tidak dapat dibatalkan, apakah data yang Anda masukan sudah benar?",
    );
  }
}
