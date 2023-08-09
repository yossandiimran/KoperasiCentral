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
  var ktp, wajah, dokPendukung, dokNorek;

  @override
  void initState() {
    super.initState();
    getInitForm();
  }

  Future<dynamic> getInitForm() async {
    MasterService masterService = MasterService(context: context);
    Map respData = await masterService.getMasterKota();
    item = respData["data"];
    setState(() {});
  }

  Future<dynamic> getKecamatan(String idKota, bool isDom) async {
    MasterService masterService = MasterService(context: context, objParam: {'id_kota': idKota});
    Map respData = await masterService.getMasterKecamatan();
    if (isDom) {
      kecamatanDom = respData["data"];
    } else {
      kecamatan = respData["data"];
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

  getBody() => SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20),
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
                decoration: widget.decCont(Colors.white, 15, 15, 15, 15),
                width: global.getWidth(context),
                child: TextFormField(
                  controller: nik,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "NIK",
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(top: 15),
                child: Text("  Nama Lengkap", textAlign: TextAlign.left),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                margin: EdgeInsets.only(top: 5),
                decoration: widget.decCont(Colors.white, 15, 15, 15, 15),
                width: global.getWidth(context),
                child: TextFormField(
                  controller: nama,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Nama Lengkap",
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(top: 15),
                child: Text("  Tanggal Lahir", textAlign: TextAlign.left),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                margin: EdgeInsets.only(top: 5),
                decoration: widget.decCont(Colors.white, 15, 15, 15, 15),
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
                    DateTime date = DateTime(1900);
                    FocusScope.of(context).requestFocus(FocusNode());
                    date = (await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    ))!;
                    ttl.text = global.formatDate2(date);
                  },
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(top: 15),
                child: Text("  Jenis Kelamin", textAlign: TextAlign.left),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.only(top: 5),
                decoration: widget.decCont(Colors.white, 15, 15, 15, 15),
                width: global.getWidth(context),
                child: SizedBox(
                  width: global.getWidth(context) / 1.2,
                  child: DropdownSearch<String>(
                    mode: Mode.DIALOG,
                    items: ["Laki - Laki", "Perempuan"],
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
                margin: EdgeInsets.only(top: 15),
                child: Text("  Alamat Lengkap", textAlign: TextAlign.left),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                margin: EdgeInsets.only(top: 5),
                decoration: widget.decCont(Colors.white, 15, 15, 15, 15),
                width: global.getWidth(context),
                child: TextFormField(
                  controller: alamat,
                  keyboardType: TextInputType.text,
                  maxLines: 2,
                  readOnly: false,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Alamat Lengkap",
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(top: 15),
                child: Text("  Kota", textAlign: TextAlign.left),
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
                    items: [for (var i = 0; i < item.length; i++) item[i]["name"]],
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
                        color: defOrange,
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
                margin: EdgeInsets.only(top: 15),
                child: Text("  Kecamatan", textAlign: TextAlign.left),
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
                margin: EdgeInsets.only(top: 15),
                child: Text("  Kelurahan", textAlign: TextAlign.left),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                margin: EdgeInsets.only(top: 5),
                decoration: widget.decCont(Colors.white, 15, 15, 15, 15),
                width: global.getWidth(context),
                child: TextFormField(
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
                margin: EdgeInsets.only(top: 15),
                child: Text("  Kode Pos", textAlign: TextAlign.left),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                margin: EdgeInsets.only(top: 5),
                decoration: widget.decCont(Colors.white, 15, 15, 15, 15),
                width: global.getWidth(context),
                child: TextFormField(
                  controller: kodePos,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Kode pos",
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(top: 15),
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
                margin: EdgeInsets.only(top: 15),
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
                              height: 140,
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
                margin: EdgeInsets.only(top: 15),
                child: Text("  Status Gaji", textAlign: TextAlign.left),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.only(top: 5),
                decoration: widget.decCont(Colors.white, 15, 15, 15, 15),
                width: global.getWidth(context),
                child: SizedBox(
                  width: global.getWidth(context) / 1.2,
                  child: DropdownSearch<String>(
                    mode: Mode.DIALOG,
                    items: ["Harian", "Bulanan"],
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
              Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(top: 15),
                child: Text("  Nomor Rekening", textAlign: TextAlign.left),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                margin: EdgeInsets.only(top: 5),
                decoration: widget.decCont(Colors.white, 15, 15, 15, 15),
                width: global.getWidth(context),
                child: TextFormField(
                  controller: norek,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Nomor Rekening",
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(top: 15),
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
                margin: EdgeInsets.only(top: 15),
                child: Text("  NPWP", textAlign: TextAlign.left),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                margin: EdgeInsets.only(top: 5),
                decoration: widget.decCont(Colors.white, 15, 15, 15, 15),
                width: global.getWidth(context),
                child: TextFormField(
                  controller: npwp,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "NPWP",
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(top: 15),
                child: Text("  Domisili Alamat Lengkap", textAlign: TextAlign.left),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                margin: EdgeInsets.only(top: 5),
                decoration: widget.decCont(Colors.white, 15, 15, 15, 15),
                width: global.getWidth(context),
                child: TextFormField(
                  controller: domAlamat,
                  keyboardType: TextInputType.datetime,
                  maxLines: 2,
                  readOnly: false,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Domisili Alamat Lengkap",
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(top: 15),
                child: Text("  Domisili Kota", textAlign: TextAlign.left),
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
                          'Pilih Domisili Kota',
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
                margin: EdgeInsets.only(top: 15),
                child: Text("  Domisili Kecamatan", textAlign: TextAlign.left),
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
                          'Pilih Domisili Kecamatan',
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
                margin: EdgeInsets.only(top: 15),
                child: Text("  Domisili Kelurahan", textAlign: TextAlign.left),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                margin: EdgeInsets.only(top: 5),
                decoration: widget.decCont(Colors.white, 15, 15, 15, 15),
                width: global.getWidth(context),
                child: TextFormField(
                  controller: domKelurahan,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Domisili Kelurahan",
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(top: 15),
                child: Text("  Domisili Kode Pos", textAlign: TextAlign.left),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                margin: EdgeInsets.only(top: 5),
                decoration: widget.decCont(Colors.white, 15, 15, 15, 15),
                width: global.getWidth(context),
                child: TextFormField(
                  controller: domKodePos,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Domisili Kode pos",
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(top: 15),
                child: Text("  No Hp", textAlign: TextAlign.left),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                margin: EdgeInsets.only(top: 5),
                decoration: widget.decCont(Colors.white, 15, 15, 15, 15),
                width: global.getWidth(context),
                child: TextFormField(
                  controller: noHp,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "No Hp",
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(top: 15),
                child: Text("  Attachment", textAlign: TextAlign.left),
              ),
              Container(
                alignment: Alignment.center,
                width: global.getWidth(context),
                decoration: widget.decCont(defWhite, 20, 20, 20, 20),
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.all(15),
                child: Wrap(
                  children: [
                    dokPendukung != null
                        ? GestureDetector(
                            onTap: () {
                              dokPendukung = null;
                              setState(() {});
                            },
                            child: Container(
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.all(20),
                              width: global.getWidth(context) / 1.6,
                              height: 140,
                              decoration: BoxDecoration(
                                border: Border.all(color: defOrange),
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Column(
                                children: [
                                  Spacer(),
                                  Icon(Icons.attachment_rounded, color: defOrange),
                                  Text(dokPendukung.name.toString()),
                                  Spacer(),
                                ],
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () async {
                              getAttachment();
                            },
                            child: Container(
                              margin: EdgeInsets.all(5),
                              width: global.getWidth(context) / 1.6,
                              height: 140,
                              decoration: BoxDecoration(
                                border: Border.all(color: defOrange),
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Center(
                                child: Icon(Icons.attachment_rounded, color: defOrange),
                              ),
                            ),
                          ),
                  ],
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

  Future getAttachment() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      dokPendukung = result.files.single;
    }
    setState(() {});
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
    if (dokPendukung == null) return alert.alertWarning(context: context, text: "File Attachment Wajib Diupload !");

    var getIdKota = item.where((element) => element['name'] == kotaSelected).first;
    var getIdKeca = kecamatan.where((element) => element['name'] == kecamatanSelected).first;
    var getDomIdKota = item.where((element) => element['name'] == domKotaSelected).first;
    var getDomIdKeca = kecamatanDom.where((element) => element['name'] == domkecSelected).first;

    Map objParam = {
      'nik': nik.text,
      'nama': nama.text,
      'tanggal_lahir': ttl.text,
      'jk': jenisKelamin == "Laki - Laki" ? "1" : "2",
      'alamat': alamat.text,
      'kota_id': getIdKota['id'].toString(),
      'kecamatan_id': getIdKeca['id'].toString(),
      'kelurahan': kelurahan.text,
      'kode_pos': kodePos.text,
      'f_ktp': ktp,
      'f_foto': wajah,
      'statgaji': statGaji == "Harian" ? "1" : "2",
      'norek': norek.text,
      'f_norek': dokNorek,
      'npwp': npwp.text,
      'dom_alamat': domAlamat.text,
      'dom_kota_id': getDomIdKota['id'].toString(),
      'dom_kecamatan_id': getDomIdKeca['id'].toString(),
      'dom_kelurahan': domKelurahan.text,
      'dom_kodepos': domKodePos.text,
      'no_hp': noHp.text,
      'f_pengkinian': dokPendukung,
    };

    alert.alertConfirmation(
      context: context,
      action: () async {
        PemutakhiranDataService pemutakhiranDataService = PemutakhiranDataService(context: context, objParam: objParam);
        pemutakhiranDataService.postPemutakhiranData();
      },
      message: "Apakah Form diatas sudah benar ?",
    );
  }
}
