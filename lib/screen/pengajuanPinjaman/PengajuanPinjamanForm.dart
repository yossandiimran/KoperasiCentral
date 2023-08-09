// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_key_in_widget_constructors, no_logic_in_create_state, avoid_print, avoid_unnecessary_containers, unnecessary_null_comparison, invalid_use_of_visible_for_testing_member, prefer_interpolation_to_compose_strings
part of '../../header.dart';

class PengajuanPinjamanForm extends StatefulWidget {
  @override
  PengajuanPinjamanFormState createState() => PengajuanPinjamanFormState();
}

class PengajuanPinjamanFormState extends State<PengajuanPinjamanForm> {
  List<dynamic> item = [];

  var jumlahPinjaman = TextEditingController(), tenorSelected = "", jenisSelected = "";

  @override
  void initState() {
    super.initState();
    getInitForm();
  }

  Future<dynamic> getInitForm() async {
    MasterService masterService = MasterService(context: context);
    Map respData = await masterService.getMasterJenisPinjam();
    item = respData["data"];
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
              decoration: widget.decCont(Colors.white, 15, 15, 15, 15),
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
              decoration: widget.decCont(Colors.white, 15, 15, 15, 15),
              width: global.getWidth(context),
              child: TextFormField(
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
              child: Text("  Tenor", textAlign: TextAlign.left),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              margin: EdgeInsets.only(top: 5),
              decoration: widget.decCont(Colors.white, 15, 15, 15, 15),
              width: global.getWidth(context),
              child: SizedBox(
                width: global.getWidth(context) / 1.2,
                child: DropdownSearch<String>(
                  showSearchBox: false,
                  mode: Mode.DIALOG,
                  items: ["3 Bulan", "6 Bulan", "12 Bulan", "24 Bulan", "36 Bulan", "48 Bulan"],
                  dropdownSearchDecoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                  selectedItem: tenorSelected,
                  onChanged: (itm) {
                    tenorSelected = itm!;
                    setState(() {});
                  },
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
                        'Pilih Tenor',
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
                      decoration: widget.decCont(defRed, 15, 15, 15, 15),
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
                      save();
                    },
                    child: Container(
                      width: global.getWidth(context) / 2.7,
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      margin: EdgeInsets.only(top: 5),
                      decoration: widget.decCont(defGreen, 15, 15, 15, 15),
                      child: Row(
                        children: [
                          Spacer(),
                          Text("Simpan ", style: textStyling.customColor(14, defWhite)),
                          Icon(Icons.arrow_forward_rounded, color: defWhite),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: global.getHeight(context) / 2),
          ],
        ),
      ),
    );
  }

  save() async {
    if (jumlahPinjaman.text == '') return alert.alertWarning(context: context, text: "Jumlah Pinjaman Wajib Diisi !");

    List kodeJenis = item.where((element) => element['nama'] == jenisSelected).toList();
    List splitted = tenorSelected.split(' ');

    Map objParam = {
      'kode_jenis': kodeJenis[0]['kode'],
      'besar_pinjaman': jumlahPinjaman.text,
      'tenor': splitted[0],
    };

    alert.alertConfirmation(
      context: context,
      action: () async {
        PengajuanPinjamanService pps = PengajuanPinjamanService(context: context, objParam: objParam);
        await pps.postPengajuanPinjaman();
      },
      message: "Apakah Form diatas sudah benar ?",
    );
  }
}
