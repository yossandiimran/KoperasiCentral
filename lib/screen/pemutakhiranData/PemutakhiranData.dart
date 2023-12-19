// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_key_in_widget_constructors, no_logic_in_create_state, avoid_print, avoid_unnecessary_containers, unnecessary_null_comparison, invalid_use_of_visible_for_testing_member, prefer_interpolation_to_compose_strings
part of '../../header.dart';

class PemutakhiranData extends StatefulWidget {
  @override
  PemutakhiranDataState createState() => PemutakhiranDataState();
}

class PemutakhiranDataState extends State<PemutakhiranData> {
  List<dynamic> item = [], kecamatan = [], kecamatanDom = [];

  TextEditingController nik = TextEditingController(), nama = TextEditingController();
  TextEditingController ttl = TextEditingController(), alamat = TextEditingController();
  var jenisKelamin = "", kotaSelected = "", kecamatanSelected = "";
  TextEditingController kelurahan = TextEditingController(), kodePos = TextEditingController();
  var statGaji = "", npwp = TextEditingController(), domAlamat = TextEditingController();
  var domKelurahan = TextEditingController(), domKotaSelected = "", domkecSelected = "";
  var noHp = TextEditingController(), domKodePos = TextEditingController(), norek = TextEditingController();
  var ktp, wajah, dokPendukung, dokNorek, isLoading = true;
  Map centralData = {};
  bool isDomKtp = false;

  @override
  void initState() {
    super.initState();
    getInitForm();
  }

  Future<dynamic> getInitForm() async {
    MasterService masterService = MasterService(context: context);
    Map respData = await masterService.getMasterKota();
    item = await respData["data"];
    centralData = await AuthService(context: context).getCentralData();
    for (int i = 0; i < item.length; i++) {
      item[i]['name'] = await item[i]['name'].toUpperCase();
    }
    await parseCentral();
    setState(() {
      isLoading = false;
    });
  }

  Future<dynamic> parseCentral() async {
    print(jsonEncode(centralData));
    // try {
    nik.text = await centralData["data"]["nik"];
    nama.text = await centralData["data"]["nama"];
    ttl.text = global.formatDate3(DateTime.parse(await centralData["data"]["tgllahir"]));
    jenisKelamin = await centralData["data"]["sex"] ? "LAKI - LAKI" : "PEREMPUAN";
    alamat.text = await centralData["data"]["alamat"] ?? "";
    kotaSelected = await centralData["data"]["kota"] ?? "";
    kecamatanSelected = await centralData["data"]["kecamatan"] ?? "";
    // kotaSelected = "BANDUNG";
    // kecamatanSelected = "ANDIR";
    kelurahan.text = await centralData["data"]["kelurahan"] ?? "";
    kodePos.text = await centralData["data"]["kode_pos"] ?? "";
    statGaji = await centralData["data"]["statgaji"] == "1"
        ? "1 Mingguan"
        : centralData["data"]["statgaji"] == "2"
            ? "3 Mingguan"
            : "Bulanan";
    // statGaji = await centralData["data"]["statgaji"] == "2" ? "Bulanan" : "Harian";
    norek.text = await centralData["data"]["norek_bank"] ?? "";
    npwp.text = await centralData["data"]["npwp"] ?? "";
    noHp.text = await centralData["data"]["no_hp"] ?? "";
    // var getIdKota = item.where((element) => element['name'] == centralData["data"]["kota"]).first;
    var getIdKota = item.where((element) => element['name'] == kotaSelected);
    if (getIdKota.isNotEmpty) {
      getKecamatan(getIdKota.first['id'].toString(), false);
    } else {
      kotaSelected = "";
      kecamatanSelected = "";
    }
    // } catch (err) {

    //   setState(() {});
    // }

    try {
      ktp = await downloadAndSaveFile(
        url: "${global.ktpPath}${centralData["data"]["f_ktp"]}",
        filename: "ktp_image_${centralData["data"]["nama"]}.jpg",
      );
      wajah = await downloadAndSaveFile(
        url: "${global.pasPath}${centralData["data"]["f_pasfoto"]}",
        filename: "wajah_image_${centralData["data"]["nama"]}.jpg",
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<dynamic> parseDomisiliKtp() async {
    if (!isDomKtp) {
      domAlamat.text = alamat.text;
      domKotaSelected = kotaSelected;
      domkecSelected = kecamatanSelected;
      domKelurahan.text = kelurahan.text;
      domKodePos.text = kodePos.text;
      var getIdKota = item.where((element) => element['name'] == domKotaSelected);
      if (getIdKota.isNotEmpty) {
        getKecamatan(getIdKota.first['id'].toString(), true);
      } else {
        domKotaSelected = "";
        domkecSelected = "";
      }
      isDomKtp = true;
    } else {
      isDomKtp = false;
    }

    setState(() {});
  }

  Future<File> downloadAndSaveFile({required String url, required String filename}) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final dir = await getApplicationDocumentsDirectory();
      File file = File('${dir.path}/$filename');
      await file.writeAsBytes(response.bodyBytes);
      return file;
    } else {
      throw Exception('Failed to download file');
    }
  }

  Future<dynamic> getKecamatan(String idKota, bool isDom) async {
    MasterService masterService = MasterService(context: context, objParam: {'id_kota': idKota});
    Map respData = await masterService.getMasterKecamatan();
    if (isDom) {
      kecamatanDom = respData["data"];
      for (int i = 0; i < kecamatanDom.length; i++) {
        kecamatanDom[i]['name'] = kecamatanDom[i]['name'].toUpperCase();
      }
    } else {
      kecamatan = respData["data"];
      for (int i = 0; i < kecamatan.length; i++) {
        kecamatan[i]['name'] = kecamatan[i]['name'].toUpperCase();
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        alert.alertLogout(context);
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Form Pemutakhiran Data", style: textStyling.defaultWhite(20)),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
          ),
        ),
        backgroundColor: Colors.blueGrey.shade50,
        extendBodyBehindAppBar: true,
        body: getBody(),
      ),
    );
  }

  getBody() => Stack(
        children: [
          Positioned(
            child: Column(
              children: [
                Container(
                  height: global.getWidth(context),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
                    color: defBlack2,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: kToolbarHeight + 15,
            left: 0,
            bottom: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: widget.decCont2(defWhite, 8, 8, 8, 8),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(top: 10),
                      child: Text("  NIK", textAlign: TextAlign.left),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                      margin: EdgeInsets.only(top: 5),
                      decoration: widget.decCont(Colors.blueGrey.shade50, 10, 10, 10, 10),
                      width: global.getWidth(context),
                      child: TextFormField(
                        controller: nik,
                        maxLength: 16,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "NIK",
                          counterText: "",
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(top: 10),
                      child: Text("  Nama Lengkap KTP-el", textAlign: TextAlign.left),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                      margin: EdgeInsets.only(top: 5),
                      decoration: widget.decCont(Colors.blueGrey.shade50, 10, 10, 10, 10),
                      width: global.getWidth(context),
                      child: TextFormField(
                        controller: nama,
                        textCapitalization: TextCapitalization.characters,
                        inputFormatters: [UpperCaseTextFormatter()],
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Nama Lengkap KTP-el",
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(top: 10),
                      child: Text("  Tanggal Lahir", textAlign: TextAlign.left),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                      margin: EdgeInsets.only(top: 5),
                      decoration: widget.decCont(Colors.blueGrey.shade50, 10, 10, 10, 10),
                      width: global.getWidth(context),
                      child: TextFormField(
                        controller: ttl,
                        keyboardType: TextInputType.datetime,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Tanggal Lahir",
                        ),
                        onTap: () async {
                          var splitDate = ttl.text.split("-");
                          var splitted = splitDate[2] + "" + splitDate[1] + "" + splitDate[0];
                          var initDt = global.formatDate2(DateTime.parse(splitted));
                          DateTime date = DateTime(1900);
                          FocusScope.of(context).requestFocus(FocusNode());
                          date = (await showDatePicker(
                            context: context,
                            initialDate: DateTime.parse(initDt),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
                          ))!;

                          ttl.text = global.formatDate3(date);
                        },
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(top: 10),
                      child: Text("  Jenis Kelamin", textAlign: TextAlign.left),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      margin: EdgeInsets.only(top: 5),
                      decoration: widget.decCont(Colors.blueGrey.shade50, 10, 10, 10, 10),
                      width: global.getWidth(context),
                      child: SizedBox(
                        width: global.getWidth(context),
                        child: DropdownSearch<String>(
                          mode: Mode.MENU,
                          items: ["LAKI - LAKI", "PEREMPUAN"],
                          dropdownSearchDecoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                          selectedItem: jenisKelamin,
                          onChanged: (itm) {
                            jenisKelamin = itm!;
                          },
                          popupTitle: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: defBlack1,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(0),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Jenis Kelamin',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          popupShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(0),
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(top: 10),
                      child: Text("  Alamat Lengkap KTP-el", textAlign: TextAlign.left),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                      margin: EdgeInsets.only(top: 5),
                      decoration: widget.decCont(Colors.blueGrey.shade50, 10, 10, 10, 10),
                      width: global.getWidth(context),
                      child: TextFormField(
                        controller: alamat,
                        keyboardType: TextInputType.text,
                        maxLines: 2,
                        readOnly: false,
                        textCapitalization: TextCapitalization.characters,
                        inputFormatters: [UpperCaseTextFormatter()],
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Alamat Lengkap",
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(top: 10),
                      child: Text("  Kota", textAlign: TextAlign.left),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      margin: EdgeInsets.only(top: 5),
                      decoration: widget.decCont(Colors.blueGrey.shade50, 10, 10, 10, 10),
                      width: global.getWidth(context),
                      child: SizedBox(
                        width: global.getWidth(context) / 1.2,
                        child: DropdownSearch<String>(
                          showSearchBox: true,
                          mode: Mode.MENU,
                          items: [for (var i = 0; i < item.length; i++) item[i]["name"].toUpperCase()],
                          dropdownSearchDecoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                          selectedItem: kotaSelected,
                          onChanged: (itm) {
                            kecamatanSelected = '';
                            setState(() {});
                            kotaSelected = itm!;
                            var getIdKota = item.where((element) => element['name'] == itm).first;
                            getKecamatan(getIdKota['id'].toString(), false);
                          },
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                              labelText: "Cari",
                            ),
                          ),
                          popupTitle: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: defBlack1,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(0),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Pilih Kota',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          popupShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(top: 10),
                      child: Text("  Kecamatan", textAlign: TextAlign.left),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      margin: EdgeInsets.only(top: 5),
                      decoration: widget.decCont(Colors.blueGrey.shade50, 10, 10, 10, 10),
                      width: global.getWidth(context),
                      child: SizedBox(
                        width: global.getWidth(context) / 1.2,
                        child: DropdownSearch<String>(
                          showSearchBox: true,
                          mode: Mode.MENU,
                          items: [for (var i = 0; i < kecamatan.length; i++) kecamatan[i]["name"]],
                          dropdownSearchDecoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                          selectedItem: kecamatanSelected,
                          onChanged: (itm) {
                            kecamatanSelected = itm!;
                          },
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                              labelText: "Cari",
                            ),
                          ),
                          popupTitle: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: defBlack1,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(0),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Pilih Kecamatan',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          popupShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(top: 10),
                      child: Text("  Kelurahan", textAlign: TextAlign.left),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                      margin: EdgeInsets.only(top: 5),
                      decoration: widget.decCont(Colors.blueGrey.shade50, 10, 10, 10, 10),
                      width: global.getWidth(context),
                      child: TextFormField(
                        textCapitalization: TextCapitalization.characters,
                        inputFormatters: [UpperCaseTextFormatter()],
                        controller: kelurahan,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Kelurahan",
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(top: 10),
                      child: Text("  Kode Pos", textAlign: TextAlign.left),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                      margin: EdgeInsets.only(top: 5),
                      decoration: widget.decCont(Colors.blueGrey.shade50, 10, 10, 10, 10),
                      width: global.getWidth(context),
                      child: TextFormField(
                        controller: kodePos,
                        keyboardType: TextInputType.number,
                        maxLength: 5,
                        decoration: InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                          hintText: "Kode pos",
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(top: 10),
                      child: Text("  Foto Ktp", textAlign: TextAlign.left),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: global.getWidth(context),
                      decoration: widget.decCont(defWhite, 20, 20, 20, 20),
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.all(15),
                      child: Wrap(
                        children: [
                          ktp != null
                              ? GestureDetector(
                                  onTap: () {
                                    ktp = null;
                                    setState(() {});
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(5),
                                    width: global.getWidth(context) / 1.6,
                                    height: 140,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: defBlue),
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                      image: DecorationImage(
                                        image: FileImage(File(ktp.path)),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () async {
                                    getImage(picker: 'foto', type: 'ktp');
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(5),
                                    width: global.getWidth(context) / 1.6,
                                    height: 140,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: defBlack1),
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Center(
                                      child: Icon(Icons.camera_alt, color: defBlack1),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(top: 10),
                      child: Text("  Pas Foto", textAlign: TextAlign.left),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: global.getWidth(context),
                      decoration: widget.decCont(defWhite, 20, 20, 20, 20),
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.all(15),
                      child: Wrap(
                        children: [
                          wajah != null
                              ? GestureDetector(
                                  onTap: () {
                                    wajah = null;
                                    setState(() {});
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(5),
                                    width: global.getWidth(context) / 1.6,
                                    height: 360,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: defBlue),
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                      image: DecorationImage(
                                        image: FileImage(File(wajah.path)),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () async {
                                    getImage(picker: 'foto', type: 'wajah');
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(5),
                                    width: global.getWidth(context) / 1.6,
                                    height: 360,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: defBlack1),
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Center(
                                      child: Icon(Icons.camera_alt, color: defBlack1),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(top: 10),
                      child: Text("  NPWP", textAlign: TextAlign.left),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                      margin: EdgeInsets.only(top: 5),
                      decoration: widget.decCont(Colors.blueGrey.shade50, 10, 10, 10, 10),
                      width: global.getWidth(context),
                      child: TextFormField(
                        controller: npwp,
                        maxLength: 15,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                          hintText: "NPWP",
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(top: 10),
                      child: Text("  Alamat Domisili", textAlign: TextAlign.left),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      margin: EdgeInsets.only(top: 5),
                      decoration: widget.decCont(Colors.blueGrey.shade50, 0, 0, 10, 10),
                      width: global.getWidth(context),
                      child: ListTile(
                        leading: IconButton(
                          onPressed: () async {
                            await parseDomisiliKtp();
                          },
                          icon: Icon(
                            isDomKtp ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                            color: isDomKtp ? defGreen : defGrey,
                          ),
                        ),
                        title: Text("*) Sesuaikan dengan KTP-el",
                            style: TextStyle(fontStyle: FontStyle.italic, color: defBlue)),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                      decoration: widget.decCont(Colors.blueGrey.shade50, 10, 10, 0, 0),
                      width: global.getWidth(context),
                      child: TextFormField(
                        controller: domAlamat,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.characters,
                        inputFormatters: [UpperCaseTextFormatter()],
                        maxLines: 2,
                        readOnly: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Alamat Domisili",
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(top: 10),
                      child: Text("  Kota", textAlign: TextAlign.left),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      margin: EdgeInsets.only(top: 5),
                      decoration: widget.decCont(Colors.blueGrey.shade50, 10, 10, 10, 10),
                      width: global.getWidth(context),
                      child: SizedBox(
                        width: global.getWidth(context) / 1.2,
                        child: DropdownSearch<String>(
                          showSearchBox: true,
                          mode: Mode.MENU,
                          items: [for (var i = 0; i < item.length; i++) item[i]["name"]],
                          dropdownSearchDecoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                          selectedItem: domKotaSelected,
                          onChanged: (itm) {
                            domkecSelected = '';
                            setState(() {});
                            domKotaSelected = itm!;
                            var getIdKota = item.where((element) => element['name'] == itm).first;
                            getKecamatan(getIdKota['id'].toString(), true);
                          },
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                              labelText: "Cari",
                            ),
                          ),
                          popupTitle: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: defBlack1,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(0),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Pilih Kota',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          popupShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(top: 10),
                      child: Text("  Kecamatan", textAlign: TextAlign.left),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      margin: EdgeInsets.only(top: 5),
                      decoration: widget.decCont(Colors.blueGrey.shade50, 10, 10, 10, 10),
                      width: global.getWidth(context),
                      child: SizedBox(
                        width: global.getWidth(context) / 1.2,
                        child: DropdownSearch<String>(
                          showSearchBox: true,
                          mode: Mode.MENU,
                          items: [for (var i = 0; i < kecamatanDom.length; i++) kecamatanDom[i]["name"]],
                          dropdownSearchDecoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                          selectedItem: domkecSelected,
                          onChanged: (itm) {
                            domkecSelected = itm!;
                          },
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                              labelText: "Cari",
                            ),
                          ),
                          popupTitle: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: defBlack1,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(0),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Pilih Kecamatan',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          popupShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(top: 10),
                      child: Text("  Kelurahan", textAlign: TextAlign.left),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                      margin: EdgeInsets.only(top: 5),
                      decoration: widget.decCont(Colors.blueGrey.shade50, 10, 10, 10, 10),
                      width: global.getWidth(context),
                      child: TextFormField(
                        controller: domKelurahan,
                        textCapitalization: TextCapitalization.characters,
                        inputFormatters: [UpperCaseTextFormatter()],
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: " Kelurahan",
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(top: 10),
                      child: Text("  Kode Pos", textAlign: TextAlign.left),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                      margin: EdgeInsets.only(top: 5),
                      decoration: widget.decCont(Colors.blueGrey.shade50, 10, 10, 10, 10),
                      width: global.getWidth(context),
                      child: TextFormField(
                        controller: domKodePos,
                        maxLength: 5,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                          hintText: " Kode pos",
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(top: 10),
                      child: Text("  Nomor Rekening", textAlign: TextAlign.left),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                      margin: EdgeInsets.only(top: 5),
                      decoration: widget.decCont(Colors.blueGrey.shade50, 10, 10, 10, 10),
                      width: global.getWidth(context),
                      child: TextFormField(
                        controller: norek,
                        maxLength: 10,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                          hintText: "Nomor Rekening",
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(top: 10),
                      child: Text("  Foto Rekening", textAlign: TextAlign.left),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: global.getWidth(context),
                      decoration: widget.decCont(defWhite, 20, 20, 20, 20),
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.all(15),
                      child: Wrap(
                        children: [
                          dokNorek != null
                              ? GestureDetector(
                                  onTap: () {
                                    dokNorek = null;
                                    setState(() {});
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(5),
                                    width: global.getWidth(context) / 1.6,
                                    height: 140,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: defBlue),
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                      image: DecorationImage(
                                        image: FileImage(File(dokNorek.path)),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () async {
                                    getImage(picker: 'foto', type: 'rekening');
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(5),
                                    width: global.getWidth(context) / 1.6,
                                    height: 140,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: defBlack1),
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Center(
                                      child: Icon(Icons.camera_alt, color: defBlack1),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(top: 10),
                      child: Text("  No Hp", textAlign: TextAlign.left),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                      margin: EdgeInsets.only(top: 5),
                      decoration: widget.decCont(Colors.blueGrey.shade50, 10, 10, 10, 10),
                      width: global.getWidth(context),
                      child: TextFormField(
                        controller: noHp,
                        maxLength: 13,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                          hintText: "No Hp",
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(top: 10),
                      child: Text("  Status Gaji", textAlign: TextAlign.left),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      margin: EdgeInsets.only(top: 5),
                      decoration: widget.decCont(Colors.blueGrey.shade50, 10, 10, 10, 10),
                      width: global.getWidth(context),
                      child: SizedBox(
                        width: global.getWidth(context) / 1.2,
                        child: DropdownSearch<String>(
                          enabled: false,
                          mode: Mode.DIALOG,
                          items: ["1 Mingguan", "3 Mingguan", "Bulanan"],
                          // items: ["Harian", "Bulanan"],
                          dropdownSearchDecoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                          selectedItem: statGaji,
                          onChanged: (itm) {
                            // statGaji = itm!;
                          },
                          popupTitle: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: defBlack1,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Status Gaji',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          popupShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(24)),
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
                              alert.alertLogout(context);
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
                                  Text(" Logout", style: textStyling.customColor(14, defWhite)),
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
                              decoration: widget.decCont(defBlue, 15, 15, 15, 15),
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
            ),
          ),
        ],
      );

  Future getImage({required String picker, required String type}) async {
    var img = await ImagePicker.platform.pickImage(
      source: ImageSource.camera,
      maxWidth: 2048,
      maxHeight: 1080,
      imageQuality: 100,
    );
    if (img != null) {
      File rotatedImage = await FlutterExifRotation.rotateAndSaveImage(path: img.path);
      if (type == 'ktp') {
        ktp = rotatedImage;
      } else if (type == 'wajah') {
        wajah = rotatedImage;
      } else if (type == 'rekening') {
        dokNorek = rotatedImage;
      }

      setState(() {});
    }
  }

  save() async {
    if (nik.text == '') return alert.alertWarning(context: context, text: "Nik Wajib Diisi !");
    if (nama.text == '') return alert.alertWarning(context: context, text: "Nama Wajib Diisi !");
    if (ttl.text == '') return alert.alertWarning(context: context, text: "Tgl Lahir Wajib Diisi !");
    if (jenisKelamin == '') return alert.alertWarning(context: context, text: "Jenis Kelamin Wajib Diisi !");
    if (alamat.text == '') return alert.alertWarning(context: context, text: "Alamat Wajib Diisi !");
    if (kotaSelected == '') return alert.alertWarning(context: context, text: "Kota Wajib Diisi !");
    if (kecamatanSelected == '') return alert.alertWarning(context: context, text: "Kecamatan Wajib Diisi !");
    if (kelurahan.text == '') return alert.alertWarning(context: context, text: "Kelurahan Wajib Diisi !");
    if (kodePos.text == '') return alert.alertWarning(context: context, text: "Kode Pos Wajib Diisi !");
    if (ktp == null) return alert.alertWarning(context: context, text: "KTP Wajib Diupload !");
    if (wajah == null) return alert.alertWarning(context: context, text: "Pas Foto Wajib Diupload !");
    if (statGaji == '') return alert.alertWarning(context: context, text: "Status Gaji Belum Dipilih !");
    if (norek.text == '') return alert.alertWarning(context: context, text: "Nomor Rekening Wajib Diisi !");
    if (dokNorek == null) return alert.alertWarning(context: context, text: "Foto Rekening Wajib Diupload !");
    if (npwp.text == '') return alert.alertWarning(context: context, text: "NPWP Wajib Diisi !");
    if (domAlamat.text == '') return alert.alertWarning(context: context, text: "Alamat Domisili Wajib Diisi !");
    if (domKotaSelected == '') return alert.alertWarning(context: context, text: "Kota Domisili Wajib Diisi !");
    if (domkecSelected == '') return alert.alertWarning(context: context, text: "Kecamatan Domisili Wajib Diisi !");
    if (domKelurahan.text == '') return alert.alertWarning(context: context, text: "Kelurahan Domisili Wajib Diisi !");
    if (domKodePos.text == '') return alert.alertWarning(context: context, text: "Kode Pos Domisili Wajib Diisi !");
    if (noHp.text == '') return alert.alertWarning(context: context, text: "NO HP Wajib Diisi !");

    var getIdKota = item.where((element) => element['name'] == kotaSelected).first;
    var getIdKeca = kecamatan.where((element) => element['name'] == kecamatanSelected).first;
    var getDomIdKota = item.where((element) => element['name'] == domKotaSelected).first;
    var getDomIdKeca = kecamatanDom.where((element) => element['name'] == domkecSelected).first;

    // Convert Date TTL
    var splitDate = ttl.text.split("-");
    var splitted = splitDate[2] + "" + splitDate[1] + "" + splitDate[0];
    Map objParam = {
      'nik': nik.text,
      'nama': nama.text.toUpperCase(),
      'tanggal_lahir': global.formatDate2(DateTime.parse(splitted)),
      'jk': jenisKelamin == "LAKI - LAKI" ? "1" : "0",
      'alamat': alamat.text,
      'kota_id': getIdKota['id'].toString(),
      'kecamatan_id': getIdKeca['id'].toString(),
      'kelurahan': kelurahan.text,
      'kode_pos': kodePos.text,
      'f_ktp': ktp,
      'f_foto': wajah,
      'statgaji': statGaji == "1 Mingguan"
          ? "1"
          : statGaji == "3 Mingguan"
              ? "2"
              : "3",
      'norek': norek.text,
      'f_norek': dokNorek,
      'npwp': npwp.text,
      'dom_alamat': domAlamat.text,
      'dom_kota_id': getDomIdKota['id'].toString(),
      'dom_kecamatan_id': getDomIdKeca['id'].toString(),
      'dom_kelurahan': domKelurahan.text,
      'dom_kodepos': domKodePos.text,
      'no_hp': noHp.text,
    };

    alert.alertConfirmation(
      context: context,
      action: () async {
        Navigator.pop(context);
        PemutakhiranDataService pemutakhiranDataService = PemutakhiranDataService(context: context, objParam: objParam);
        pemutakhiranDataService.postPemutakhiranData();
      },
      message: "Data yang Anda kirimkan akan dikonfirmasi dan tidak dapat diubah. Pastikan semua input sudah benar !",
    );
  }
}
