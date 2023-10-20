// ignore_for_file: file_names, avoid_unnecessary_containers, prefer_const_constructors

part of '../../../header.dart';

class Transaksi extends StatefulWidget {
  const Transaksi({super.key});
  @override
  TransaksiState createState() => TransaksiState();
}

class TransaksiState extends State<Transaksi> {
  List listPengajuan = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getDashboardData();
  }

  Future<void> getDashboardData() async {
    isLoading = true;
    listPengajuan.clear();
    setState(() {});
    try {
      PengajuanPinjamanService pps = PengajuanPinjamanService(context: context);
      Map dataPengajuan = await pps.getListPengajuan();
      for (int i = 0; i < dataPengajuan["data"].length; i++) {
        listPengajuan.add(dataPengajuan["data"][i]);
      }
      isLoading = false;
      setState(() {});
    } catch (err) {
      Navigator.pushNamed(context, '/home');
      setState(() {});
      // alert.alertWarning(context: context, text: "Koneksi tidak stabil");
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
        backgroundColor: Colors.blueGrey.shade50,
        extendBodyBehindAppBar: true,
        body: getBodyView(),
      ),
    );
  }

  Widget getBodyView() {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          bottom: 0,
          right: 0,
          child: RefreshIndicator(
            onRefresh: () async => getDashboardData(),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: !isLoading
                  ? Column(
                      children: [
                        SizedBox(height: kToolbarHeight * 1.5),
                        for (var i = 0; i < listPengajuan.length; i++)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                            decoration: widget.decCont2(defWhite, 15, 15, 15, 15),
                            child: Column(children: [
                              Divider(thickness: 3),
                              ListTile(
                                dense: true,
                                visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                title: Text(
                                  "Pengajuan Pinjaman : ${listPengajuan[i]['nomor_transaksi']}\n",
                                  style: textStyling.customColorBold(
                                      15, listPengajuan[i]['tanpa_angsuran'] ? defPurple : defBlack1),
                                ),
                                subtitle: Text(
                                  // '''Nomor Transaksi : ${listPengajuan[i]['nomor_transaksi']}
                                  '''
Tanggal Transaksi :  ${listPengajuan[i]['tgl_transaksi']}
Tanggal Pencairan :  ${listPengajuan[i]['diterima'] ?? "-"}
Besar Pinjaman :  ${CurrencyFormat.convertToIdr(double.parse(listPengajuan[i]['besar_pinjaman']), 2).toString()}
Realisasi :  ${CurrencyFormat.convertToIdr(double.parse(listPengajuan[i]['realisasi_pinjaman']), 2).toString()}
Sisa Tagihan :  ${CurrencyFormat.convertToIdr(int.parse(listPengajuan[i]['sisa_pembayaran'].toString()), 2).toString()}
Tenor : ${listPengajuan[i]['tenor']} Bulan''',
                                  style: textStyling.nunitoBold(14, defGrey),
                                ),
                              ),
                              Divider(thickness: 3),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (listPengajuan[i]["batalkan"] != null) {}
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                      decoration: widget.decCont2(defWhite, 15, 15, 15, 15),
                                      child: Row(
                                        children: [
                                          getIconStatus(listPengajuan[i]),
                                          gettextStatus(listPengajuan[i]),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      Map objParam = {'data': listPengajuan[i]};
                                      Navigator.pushNamed(context, '/detailTransaksi', arguments: objParam);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                      decoration: widget.decCont2(defBlue, 15, 15, 15, 15),
                                      child: Row(
                                        children: [
                                          Icon(Icons.info_outline_rounded, color: defWhite, size: 20),
                                          Text("  Detail", style: textStyling.customColorBold(14, defWhite)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                            ]),
                          ),
                        SizedBox(height: 10),
                        SizedBox(height: 200),
                      ],
                    )
                  : Column(
                      children: [
                        SizedBox(height: kToolbarHeight * 1.5),
                        for (var i = 0; i < 10; i++) shimmerWidget.listTileShimmer(context: context)
                      ],
                    ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          bottom: 0,
          right: 0,
          child: Column(
            children: [
              Container(
                height: kToolbarHeight * 1.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
                  image: DecorationImage(image: AssetImage("assets/bgbg2.png"), fit: BoxFit.cover),
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
                child: Center(child: Text("\nDaftar Transaksi", style: textStyling.customColorBold(18, defWhite))),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Icon getIconStatus(data) {
    Icon icon = Icon(Icons.access_time_rounded, color: defOrange, size: 20);
    if (data["lunas"] == true) return Icon(Icons.check_circle, color: defGreen, size: 20);
    if (data["batalkan"] != null) return Icon(Icons.remove_circle_outline_rounded, color: defRed, size: 20);
    if (data["diterima"] != null) return Icon(Icons.access_time_rounded, color: defPurple, size: 20);
    return icon;
  }

  Text gettextStatus(data) {
    Text text = Text("  Menunggu", style: textStyling.customColorBold(14, defOrange));
    if (data["lunas"] == true) return Text("  Lunas", style: textStyling.customColorBold(14, defGreen));
    if (data["batalkan"] != null) return Text("  Dibatalkan", style: textStyling.customColorBold(14, defRed));
    if (data["diterima"] != null) return Text("  Berjalan", style: textStyling.customColorBold(14, defPurple));
    return text;
  }
}
