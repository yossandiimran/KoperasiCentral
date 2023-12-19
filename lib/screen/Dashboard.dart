// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_key_in_widget_constructors, no_logic_in_create_state, avoid_print, avoid_unnecessary_containers, unnecessary_null_comparison, invalid_use_of_visible_for_testing_member, prefer_interpolation_to_compose_strings, use_build_context_synchronously
part of '../../header.dart';

class Dashboard extends StatefulWidget {
  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  List listPengajuan = [];
  Map dataMaster = {};
  var sisaAngsuran = 0, sisaTagihan = 0, pinjamanAktif = 0;
  var limit = 0, pinjamanLunas = 0, saldo = 0;
  bool isLoading = true, isShowCash = false;
  @override
  void initState() {
    super.initState();
    global.autoLogoutCheck(context);
    global.cekLogin7day(context: context);
    getDashboardData();
  }

  Future<void> getDashboardData() async {
    isShowCash = preference.getData("isShowCash") ?? true;
    print(isShowCash);
    listPengajuan.clear();
    isLoading = true;
    setState(() {});
    try {
      MasterService masterService = MasterService(context: context);
      dataMaster = await masterService.getDashboardService();
      sisaAngsuran = int.parse(dataMaster["data"]['sisa_angsuran'].toString());
      sisaTagihan = int.parse(dataMaster["data"]['sisa_tagihan'].toString());
      pinjamanAktif = dataMaster["data"]['pinjaman_aktif'];
      limit = dataMaster["data"]['limit_pinjaman'];
      pinjamanLunas = dataMaster["data"]['pinjaman_lunas'];
      saldo = int.parse(dataMaster["data"]['saldo_simpanan']);
      PengajuanPinjamanService pps = PengajuanPinjamanService(context: context);
      Map dataPengajuan = await pps.getListPengajuan();
      for (int i = 0; i < dataPengajuan["data"].length; i++) {
        if (i == 0) {
          listPengajuan.add(dataPengajuan["data"][i]);
        }
      }
      setState(() {
        isLoading = false;
      });
    } catch (err) {
      print(err);
      sisaAngsuran = 0;
      sisaTagihan = 0;
      pinjamanAktif = 0;
      limit = 0;
      pinjamanLunas = 0;
      saldo = 0;

      setState(() {
        isLoading = false;
      });
      await checkStatusUser();

      // alert.alertWarning(context: context, text: "Koneksi tidak stabil");
    }
  }

  Future<void> checkStatusUser() async {
    print(dataMaster);
    if (dataMaster["data"]["first_login"] == false) {
      return global.successResponseNavigate(
        context,
        "Akun anda ditolak saat pemutakhiran data, silahkan betulkan kembali form data diri berikut ini ! ",
        '/mutakhirData',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        alert.alertConfirmExit(context);
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: defWhite,
        extendBodyBehindAppBar: true,
        appBar: widget.appBarTitle(context, "Mobile Koperasi Central", Colors.transparent),
        body: RefreshIndicator(
          onRefresh: () async => getDashboardData(),
          child: Stack(children: [
            widget.bgAppbar(context),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Spacer(),
                  Container(
                    padding: EdgeInsets.only(top: 15, left: 10, right: 10),
                    height: global.getHeight(context) - (kToolbarHeight * 2.6),
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                      image: DecorationImage(image: AssetImage("assets/bgbg2.png"), fit: BoxFit.cover),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          width: global.getWidth(context),
                          child: Row(
                            children: [
                              SizedBox(width: 15),
                              Text(
                                "Selamat datang, \n" + preference.getData("name"),
                                style: textStyling.customColor(global.getWidth(context) / 21, defWhite),
                              ),
                              Spacer(),
                              PopupMenuButton<String>(
                                icon: Icon(Icons.more_vert_rounded, color: defWhite),
                                onSelected: (value) async {
                                  if (value == "Logout") {
                                    alert.alertLogout(context);
                                  } else {
                                    var token = await FirebaseMessaging.instance.getToken();
                                    print(token);
                                  }
                                },
                                itemBuilder: (BuildContext context) => widget.getChoicePopUp(context),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Spacer(),
                  Container(
                    padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                    height: global.getHeight(context) - (kToolbarHeight * 5),
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                      color: Colors.white,
                    ),
                    child: ScrollConfiguration(
                      behavior: const ScrollBehavior().copyWith(overscroll: false),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: kToolbarHeight * 2.8),
                  Container(
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    margin: EdgeInsets.only(left: 10, right: 10),
                    height: (kToolbarHeight * 2.7),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      image: DecorationImage(image: AssetImage("assets/bgcard-o.png"), fit: BoxFit.cover),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ScrollConfiguration(
                      behavior: const ScrollBehavior().copyWith(overscroll: false),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.monetization_on_rounded,
                              color: defOrange,
                              size: 36,
                            ),
                            // trailing: Text("22D055", style: textStyling.customColorBold(15, defBlack1)),
                          ),
                          Spacer(),
                          ListTile(
                            title: Text("Total Saldo", style: textStyling.customColorBold(16, defOrange)),
                            subtitle: !isLoading
                                ? Text(
                                    isShowCash ? CurrencyFormat.convertToIdr(saldo, 2).toString() : "Rp ●●●.●●●.●●●,-",
                                    style: textStyling.customColorBold(20, defBlack1),
                                  )
                                : shimmerWidget.defaultShimmer(
                                    width: global.getWidth(context),
                                    height: 10,
                                  ),
                            trailing: IconButton(
                              onPressed: () {
                                isShowCash ? isShowCash = false : isShowCash = true;
                                preference.setBool("isShowCash", isShowCash);
                                setState(() {});
                              },
                              icon: Icon(
                                !isShowCash ? Icons.remove_red_eye_rounded : Icons.visibility_off_rounded,
                                color: defBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          if (!dataMaster["data"]["ditinjau"]) {
                            Navigator.pushNamed(context, '/formPengajuanPinjaman');
                          } else {
                            alert.alertWarning(context: context, text: "Akun anda sedang ditinjau !");
                          }
                        },
                        child: Container(
                          width: global.getWidth(context) / 2.3,
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.only(top: 10, left: 10, right: 5),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                            color: defRed,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Text("Pinjaman", style: textStyling.customColorBold(16, defWhite)),
                              Spacer(),
                              Icon(Icons.download_rounded, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (!dataMaster["data"]["ditinjau"]) {
                            Navigator.pushNamed(context, '/formPengajuanSimpanan');
                          } else {
                            alert.alertWarning(context: context, text: "Akun anda sedang ditinjau !");
                          }
                        },
                        child: Container(
                          width: global.getWidth(context) / 2.3,
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.only(top: 10, left: 0, right: 10),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                            color: defBlue,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.upload_rounded, color: Colors.white),
                              Spacer(),
                              Text("Simpanan", style: textStyling.customColorBold(16, defWhite)),
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            decoration: widget.decCont2(defWhite, 10, 10, 10, 10),
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                ListTile(
                                  dense: true,
                                  visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                  leading: Icon(Icons.payment_rounded, color: defblue2),
                                  title: !isLoading
                                      ? Text(
                                          isShowCash
                                              ? CurrencyFormat.convertToIdr(limit, 2).toString()
                                              : "Rp ●●●.●●●.●●●,-",
                                          style: textStyling.nunitoBold(15, defBlack2),
                                        )
                                      : shimmerWidget.defaultShimmer(
                                          width: global.getWidth(context),
                                          height: 10,
                                        ),
                                  subtitle: Text(
                                    "Limit Pinjaman",
                                    style: textStyling.nunitoBold(14, defGrey),
                                  ),
                                ),
                                ListTile(
                                  dense: true,
                                  leading: Icon(Icons.calendar_month_rounded, color: defRed),
                                  title: !isLoading
                                      ? Text(
                                          isShowCash
                                              ? CurrencyFormat.convertToIdr(sisaTagihan, 2).toString()
                                              : "Rp ●●●.●●●.●●●,-",
                                          style: textStyling.nunitoBold(15, defBlack2),
                                        )
                                      : shimmerWidget.defaultShimmer(
                                          width: global.getWidth(context),
                                          height: 10,
                                        ),
                                  subtitle: Text(
                                    "Sisa Tagihan Aktif",
                                    style: textStyling.nunitoBold(14, defGrey),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: global.getWidth(context) / 5,
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.only(left: 20, right: 0, bottom: 10),
                                      decoration: widget.decCont(defOrange, 8, 0, 8, 0),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Sisa Angsuran",
                                            style: textStyling.customColorBold(12, defWhite),
                                            textAlign: TextAlign.center,
                                          ),
                                          !isLoading
                                              ? Text(
                                                  sisaAngsuran.toString(),
                                                  style: textStyling.customColorBold(20, defWhite),
                                                )
                                              : Container(
                                                  width: 20,
                                                  height: 20,
                                                  margin: EdgeInsets.only(top: 5),
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 1.5,
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        width: global.getWidth(context) / 5,
                                        padding: EdgeInsets.all(10),
                                        margin: EdgeInsets.only(left: 0, right: 0, bottom: 10),
                                        decoration: widget.decCont(defblue2, 0, 0, 0, 0),
                                        child: Column(
                                          children: [
                                            Text(
                                              "Pinjaman Aktif",
                                              style: textStyling.customColorBold(12, defWhite),
                                              textAlign: TextAlign.center,
                                            ),
                                            !isLoading
                                                ? Text(
                                                    pinjamanAktif.toString(),
                                                    style: textStyling.customColorBold(20, defWhite),
                                                  )
                                                : Container(
                                                    width: 20,
                                                    height: 20,
                                                    margin: EdgeInsets.only(top: 5),
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 1.5,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: global.getWidth(context) / 5,
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.only(left: 0, right: 0, bottom: 10),
                                      decoration: widget.decCont(defPurple, 0, 0, 0, 0),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Pinjaman Lunas",
                                            style: textStyling.customColorBold(12, defWhite),
                                            textAlign: TextAlign.center,
                                          ),
                                          !isLoading
                                              ? Text(
                                                  pinjamanLunas.toString(),
                                                  style: textStyling.customColorBold(20, defWhite),
                                                )
                                              : Container(
                                                  width: 20,
                                                  height: 20,
                                                  margin: EdgeInsets.only(top: 5),
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 1.5,
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: global.getWidth(context) / 5,
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.only(left: 0, right: 20, bottom: 10),
                                      decoration: widget.decCont(getStatPembayaran("l"), 0, 8, 0, 8),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Pembayaran Lancar",
                                            // "Pembayaran Tidak Lancar",
                                            style: textStyling.customColorBold(10, defWhite),
                                            textAlign: TextAlign.center,
                                          ),
                                          !isLoading
                                              ? Icon(
                                                  getStatPembayaranIcon("l"),
                                                  color: defWhite,
                                                  size: 28,
                                                )
                                              : Container(
                                                  width: 20,
                                                  height: 20,
                                                  margin: EdgeInsets.only(top: 10),
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 1.5,
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          isLoading ? shimmerWidget.listTileShimmer(context: context) : Container(),
                          isLoading ? SizedBox(height: 20) : Container(),
                          // Badge Status Pengajuan Pinjaman / Tracking
                          for (var i = 0; i < listPengajuan.length; i++)
                            Dismissible(
                              key: Key(listPengajuan[i]['nomor_transaksi']),
                              onDismissed: (direction) {
                                setState(() {
                                  listPengajuan.removeAt(i);
                                });
                              },
                              child: GestureDetector(
                                onTap: () {
                                  Map objParam = {'data': listPengajuan[i]};
                                  Navigator.pushNamed(context, '/detailTransaksi', arguments: objParam);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                  margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                                  decoration: widget.decCont(defGrey, 10, 10, 10, 10),
                                  child: ListTile(
                                    dense: true,
                                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                    title: Text(
                                      "Pengajuan Pinjaman Terakhir",
                                      style: textStyling.customColorBold(14, defWhite),
                                    ),
                                    subtitle: Text(
                                      '''Nomor Transaksi : ${listPengajuan[i]['nomor_transaksi']}
Tanggal Transaksi :  ${listPengajuan[i]['tgl_transaksi']}
Besar Pinjaman :  ${CurrencyFormat.convertToIdr(int.parse(listPengajuan[i]['besar_pinjaman']), 2).toString()}
Angsuran : ${listPengajuan[i]['tenor']}x''',
                                      style: textStyling.nunitoBold(13, defWhite),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  getStatPembayaran(stat) {
    if (stat == "tl") {
      return defRed;
    } else {
      return defGreen;
    }
  }

  getStatPembayaranIcon(stat) {
    if (stat == "tl") {
      return Icons.remove_circle_outline_rounded;
    } else {
      return Icons.check_circle_outline_rounded;
    }
  }
}
