// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_key_in_widget_constructors, no_logic_in_create_state, avoid_print, avoid_unnecessary_containers, unnecessary_null_comparison, invalid_use_of_visible_for_testing_member, prefer_interpolation_to_compose_strings
part of '../../../header.dart';

class ProfileUser extends StatefulWidget {
  @override
  ProfileUserState createState() => ProfileUserState();
}

class ProfileUserState extends State<ProfileUser> {
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
    nik.text = await centralData["data"]["nik"];
    nama.text = await centralData["data"]["nama"];
    ttl.text = global.formatDate3(DateTime.parse(await centralData["data"]["tgllahir"]));
    jenisKelamin = await centralData["data"]["sex"] ? "LAKI - LAKI" : "PEREMPUAN";
    alamat.text = await centralData["data"]["alamat"];
    kotaSelected = await centralData["data"]["kota"];
    kecamatanSelected = await centralData["data"]["kecamatan"];
    // kotaSelected = "BANDUNG";
    // kecamatanSelected = "ANDIR";
    kelurahan.text = await centralData["data"]["kelurahan"];
    kodePos.text = await centralData["data"]["kode_pos"];
    statGaji = await centralData["data"]["statgaji"] == "1"
        ? "1 Mingguan"
        : centralData["data"]["statgaji"] == "2"
            ? "3 Mingguan"
            : "Bulanan";
    // statGaji = await centralData["data"]["statgaji"] == "2" ? "Bulanan" : "Harian";
    norek.text = await centralData["data"]["norek_bank"];
    npwp.text = await centralData["data"]["npwp"];
    noHp.text = await centralData["data"]["no_hp"];
    // var getIdKota = item.where((element) => element['name'] == centralData["data"]["kota"]).first;
    var getIdKota = item.where((element) => element['name'] == kotaSelected);
    if (getIdKota.isNotEmpty) {
      getKecamatan(getIdKota.first['id'].toString(), false);
    } else {
      kotaSelected = "";
      kecamatanSelected = "";
    }

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
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("PROFILE", style: textStyling.defaultWhite(20)),
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
                        readOnly: true,
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
                        readOnly: true,
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
                        readOnly: true,
                        controller: ttl,
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Tanggal Lahir",
                        ),
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
                        width: global.getWidth(context) / 1.2,
                        child: DropdownSearch<String>(
                          enabled: false,
                          mode: Mode.DIALOG,
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
                                'Jenis Kelamin',
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
                      child: Text("  Alamat Lengkap KTP-el", textAlign: TextAlign.left),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                      margin: EdgeInsets.only(top: 5),
                      decoration: widget.decCont(Colors.blueGrey.shade50, 10, 10, 10, 10),
                      width: global.getWidth(context),
                      child: TextFormField(
                        readOnly: true,
                        controller: alamat,
                        keyboardType: TextInputType.text,
                        maxLines: 2,
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
                          enabled: false,
                          showSearchBox: true,
                          mode: Mode.DIALOG,
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
                                'Pilih Kota',
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
                          enabled: false,
                          showSearchBox: true,
                          mode: Mode.DIALOG,
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
                                'Pilih Kecamatan',
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
                      child: Text("  Kelurahan", textAlign: TextAlign.left),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                      margin: EdgeInsets.only(top: 5),
                      decoration: widget.decCont(Colors.blueGrey.shade50, 10, 10, 10, 10),
                      width: global.getWidth(context),
                      child: TextFormField(
                        readOnly: true,
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
                        readOnly: true,
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
                                  child: Container(
                                    margin: EdgeInsets.all(5),
                                    width: global.getWidth(context) / 1.6,
                                    height: 140,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: defOrange),
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Center(
                                      child: Icon(Icons.camera_alt, color: defOrange),
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
                                  child: Container(
                                    margin: EdgeInsets.all(5),
                                    width: global.getWidth(context) / 1.6,
                                    height: 360,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: defOrange),
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Center(
                                      child: Icon(Icons.camera_alt, color: defOrange),
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
                        readOnly: true,
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
                    // Container(
                    //   alignment: Alignment.bottomLeft,
                    //   margin: EdgeInsets.only(top: 10),
                    //   child: Text("  Alamat Domisili", textAlign: TextAlign.left),
                    // ),
                    // Container(
                    //   padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    //   margin: EdgeInsets.only(top: 5),
                    //   decoration: widget.decCont(Colors.blueGrey.shade50, 0, 0, 10, 10),
                    //   width: global.getWidth(context),
                    //   child: ListTile(
                    //     leading: IconButton(
                    //       onPressed: () async {
                    //         await parseDomisiliKtp();
                    //       },
                    //       icon: Icon(
                    //         isDomKtp ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                    //         color: isDomKtp ? defGreen : defGrey,
                    //       ),
                    //     ),
                    //     title: Text("*) Sesuaikan dengan KTP-el",
                    //         style: TextStyle(fontStyle: FontStyle.italic, color: defBlue)),
                    //   ),
                    // ),
                    // Container(
                    //   padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    //   decoration: widget.decCont(Colors.blueGrey.shade50, 10, 10, 0, 0),
                    //   width: global.getWidth(context),
                    //   child: TextFormField(
                    //     readOnly: true,
                    //     controller: domAlamat,
                    //     keyboardType: TextInputType.text,
                    //     textCapitalization: TextCapitalization.characters,
                    //     inputFormatters: [UpperCaseTextFormatter()],
                    //     maxLines: 2,
                    //     decoration: InputDecoration(
                    //       border: InputBorder.none,
                    //       hintText: "Alamat Domisili",
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   alignment: Alignment.bottomLeft,
                    //   margin: EdgeInsets.only(top: 10),
                    //   child: Text("  Kota", textAlign: TextAlign.left),
                    // ),
                    // Container(
                    //   padding: EdgeInsets.symmetric(horizontal: 10),
                    //   margin: EdgeInsets.only(top: 5),
                    //   decoration: widget.decCont(Colors.blueGrey.shade50, 10, 10, 10, 10),
                    //   width: global.getWidth(context),
                    //   child: SizedBox(
                    //     width: global.getWidth(context) / 1.2,
                    //     child: DropdownSearch<String>(
                    //       showSearchBox: true,
                    //       mode: Mode.DIALOG,
                    //       items: [for (var i = 0; i < item.length; i++) item[i]["name"]],
                    //       dropdownSearchDecoration: InputDecoration(
                    //         enabledBorder: UnderlineInputBorder(
                    //           borderSide: BorderSide.none,
                    //         ),
                    //       ),
                    //       selectedItem: domKotaSelected,
                    //       onChanged: (itm) {
                    //         domkecSelected = '';
                    //         setState(() {});
                    //         domKotaSelected = itm!;
                    //         var getIdKota = item.where((element) => element['name'] == itm).first;
                    //         getKecamatan(getIdKota['id'].toString(), true);
                    //       },
                    //       searchFieldProps: TextFieldProps(
                    //         decoration: InputDecoration(
                    //           border: OutlineInputBorder(),
                    //           contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                    //           labelText: "Cari",
                    //         ),
                    //       ),
                    //       popupTitle: Container(
                    //         height: 50,
                    //         decoration: BoxDecoration(
                    //           color: defOrange,
                    //           borderRadius: BorderRadius.only(
                    //             topLeft: Radius.circular(20),
                    //             topRight: Radius.circular(20),
                    //           ),
                    //         ),
                    //         child: Center(
                    //           child: Text(
                    //             'Pilih Kota',
                    //             style: TextStyle(
                    //               fontSize: 22,
                    //               fontWeight: FontWeight.bold,
                    //               color: Colors.white,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       popupShape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.only(
                    //           topLeft: Radius.circular(24),
                    //           topRight: Radius.circular(24),
                    //           bottomRight: Radius.circular(24),
                    //           bottomLeft: Radius.circular(24),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   alignment: Alignment.bottomLeft,
                    //   margin: EdgeInsets.only(top: 10),
                    //   child: Text("  Kecamatan", textAlign: TextAlign.left),
                    // ),
                    // Container(
                    //   padding: EdgeInsets.symmetric(horizontal: 10),
                    //   margin: EdgeInsets.only(top: 5),
                    //   decoration: widget.decCont(Colors.blueGrey.shade50, 10, 10, 10, 10),
                    //   width: global.getWidth(context),
                    //   child: SizedBox(
                    //     width: global.getWidth(context) / 1.2,
                    //     child: DropdownSearch<String>(
                    //       showSearchBox: true,
                    //       mode: Mode.DIALOG,
                    //       items: [for (var i = 0; i < kecamatanDom.length; i++) kecamatanDom[i]["name"]],
                    //       dropdownSearchDecoration: InputDecoration(
                    //         enabledBorder: UnderlineInputBorder(
                    //           borderSide: BorderSide.none,
                    //         ),
                    //       ),
                    //       selectedItem: domkecSelected,
                    //       onChanged: (itm) {
                    //         domkecSelected = itm!;
                    //       },
                    //       searchFieldProps: TextFieldProps(
                    //         decoration: InputDecoration(
                    //           border: OutlineInputBorder(),
                    //           contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                    //           labelText: "Cari",
                    //         ),
                    //       ),
                    //       popupTitle: Container(
                    //         height: 50,
                    //         decoration: BoxDecoration(
                    //           color: defOrange,
                    //           borderRadius: BorderRadius.only(
                    //             topLeft: Radius.circular(20),
                    //             topRight: Radius.circular(20),
                    //           ),
                    //         ),
                    //         child: Center(
                    //           child: Text(
                    //             'Pilih Kecamatan',
                    //             style: TextStyle(
                    //               fontSize: 22,
                    //               fontWeight: FontWeight.bold,
                    //               color: Colors.white,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       popupShape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.only(
                    //           topLeft: Radius.circular(24),
                    //           topRight: Radius.circular(24),
                    //           bottomRight: Radius.circular(24),
                    //           bottomLeft: Radius.circular(24),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   alignment: Alignment.bottomLeft,
                    //   margin: EdgeInsets.only(top: 10),
                    //   child: Text("  Kelurahan", textAlign: TextAlign.left),
                    // ),
                    // Container(
                    //   padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                    //   margin: EdgeInsets.only(top: 5),
                    //   decoration: widget.decCont(Colors.blueGrey.shade50, 10, 10, 10, 10),
                    //   width: global.getWidth(context),
                    //   child: TextFormField(
                    //     readOnly: true,
                    //     controller: domKelurahan,
                    //     textCapitalization: TextCapitalization.characters,
                    //     inputFormatters: [UpperCaseTextFormatter()],
                    //     keyboardType: TextInputType.text,
                    //     decoration: InputDecoration(
                    //       border: InputBorder.none,
                    //       hintText: " Kelurahan",
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   alignment: Alignment.bottomLeft,
                    //   margin: EdgeInsets.only(top: 10),
                    //   child: Text("  Kode Pos", textAlign: TextAlign.left),
                    // ),
                    // Container(
                    //   padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                    //   margin: EdgeInsets.only(top: 5),
                    //   decoration: widget.decCont(Colors.blueGrey.shade50, 10, 10, 10, 10),
                    //   width: global.getWidth(context),
                    //   child: TextFormField(
                    //     readOnly: true,
                    //     controller: domKodePos,
                    //     maxLength: 5,
                    //     keyboardType: TextInputType.text,
                    //     decoration: InputDecoration(
                    //       counterText: "",
                    //       border: InputBorder.none,
                    //       hintText: " Kode pos",
                    //     ),
                    //   ),
                    // ),

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
                        readOnly: true,
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
                    // Container(
                    //   alignment: Alignment.bottomLeft,
                    //   margin: EdgeInsets.only(top: 10),
                    //   child: Text("  Foto Rekening", textAlign: TextAlign.left),
                    // ),
                    // Container(
                    //   alignment: Alignment.center,
                    //   width: global.getWidth(context),
                    //   decoration: widget.decCont(defWhite, 20, 20, 20, 20),
                    //   margin: EdgeInsets.only(top: 10),
                    //   padding: EdgeInsets.all(15),
                    //   child: Wrap(
                    //     children: [
                    //       dokNorek != null
                    //           ? GestureDetector(
                    //               onTap: () {
                    //                 dokNorek = null;
                    //                 setState(() {});
                    //               },
                    //               child: Container(
                    //                 margin: EdgeInsets.all(5),
                    //                 width: global.getWidth(context) / 1.6,
                    //                 height: 140,
                    //                 decoration: BoxDecoration(
                    //                   border: Border.all(color: defBlue),
                    //                   borderRadius: BorderRadius.all(Radius.circular(20)),
                    //                   image: DecorationImage(
                    //                     image: FileImage(File(dokNorek.path)),
                    //                     fit: BoxFit.cover,
                    //                   ),
                    //                 ),
                    //               ),
                    //             )
                    //           : GestureDetector(
                    //               onTap: () async {
                    //                 getImage(picker: 'foto', type: 'rekening');
                    //               },
                    //               child: Container(
                    //                 margin: EdgeInsets.all(5),
                    //                 width: global.getWidth(context) / 1.6,
                    //                 height: 140,
                    //                 decoration: BoxDecoration(
                    //                   border: Border.all(color: defOrange),
                    //                   borderRadius: BorderRadius.all(Radius.circular(20)),
                    //                 ),
                    //                 child: Center(
                    //                   child: Icon(Icons.camera_alt, color: defOrange),
                    //                 ),
                    //               ),
                    //             ),
                    //     ],
                    //   ),
                    // ),
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
                        readOnly: true,
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
                      padding: EdgeInsets.symmetric(horizontal: 10),
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
                            statGaji = itm!;
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
}
