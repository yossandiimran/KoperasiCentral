// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_key_in_widget_constructors, no_logic_in_create_state, avoid_print, avoid_unnecessary_containers, unnecessary_null_comparison, invalid_use_of_visible_for_testing_member, prefer_interpolation_to_compose_strings
part of '../../header.dart';

class PengajuanSimpananForm extends StatefulWidget {
  @override
  PengajuanSimpananFormState createState() => PengajuanSimpananFormState();
}

class PengajuanSimpananFormState extends State<PengajuanSimpananForm> {
  List<dynamic> item = [];

  var jenisSelected = "";
  List<String> listTenor = [];
  @override
  void initState() {
    super.initState();
    getInitForm();
  }

  Future<dynamic> getInitForm() async {
    MasterService masterService = MasterService(context: context);
    Map respData = await masterService.getMasterJenisSimpanan();
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
          title: Text("Form Pengajuan Simpanan", style: textStyling.defaultWhite(20)),
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
              child: Text("  Jenis Simpanan", textAlign: TextAlign.left),
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
                  items: [
                    for (var i = 0; i < item.length; i++)
                      "${item[i]["kode"]}- Rp. ${CurrencyFormat.convertToIdr(double.parse(item[i]["nominal"]), 2).toString()}"
                  ],
                  dropdownSearchDecoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                  selectedItem: jenisSelected,
                  onChanged: (itm) {
                    jenisSelected = itm!;
                    print(jenisSelected);

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
                        'Pilih Jenis Simpanan',
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
                      save();
                    },
                    child: Container(
                      width: global.getWidth(context) / 2.7,
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      margin: EdgeInsets.only(top: 5),
                      decoration: ui.decCont(defGreen, 15, 15, 15, 15),
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
    if (jenisSelected == '') return alert.alertWarning(context: context, text: "Jenis Pinjaman Wajib Diisi !");
    List splitted = jenisSelected.split('-');
    Map objParam = {'kode': splitted[0]};

    alert.alertConfirmation(
      context: context,
      action: () async {
        Navigator.pop(context);
        PengajuanSimpananService pps = PengajuanSimpananService(context: context, objParam: objParam);
        await pps.postPengajuanSimpanan();
      },
      message: "Apakah data yang Anda masukan sudah benar ?",
    );
  }
}
