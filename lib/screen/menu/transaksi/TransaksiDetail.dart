// ignore_for_file: file_names, avoid_unnecessary_containers, prefer_const_constructors, prefer_typing_uninitialized_variables, no_logic_in_create_state
part of '../../../header.dart';

class TransaksiDetail extends StatefulWidget {
  final obj;
  const TransaksiDetail({this.obj, super.key});
  @override
  TransaksiDetailState createState() => TransaksiDetailState(obj: obj);
}

class TransaksiDetailState extends State<TransaksiDetail> {
  final obj;
  TransaksiDetailState({this.obj});
  List listPengajuan = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    initDetailData();
  }

  Future<void> initDetailData() async {
    Map objParam = {'id': obj['data']['id']};
    PengajuanPinjamanService pps = PengajuanPinjamanService(context: context, objParam: objParam);
    Map dataPengajuan = await pps.getDetailPengajuan();
    for (int i = 0; i < dataPengajuan["data"].length; i++) {
      listPengajuan.add(dataPengajuan["data"][i]);
    }
    isLoading = false;
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
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: !isLoading
                ? obj['data']["batalkan"] == null
                    ? Column(
                        children: [
                          SizedBox(height: kToolbarHeight * 4.3),
                          for (var i = 0; i < listPengajuan.length; i++)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                              decoration: ui.decCont2(defWhite, 15, 15, 15, 15),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: ExpansionTile(
                                  leading: Icon(
                                    listPengajuan[i]['sudah_dibayar']
                                        ? Icons.check_circle
                                        : Icons.remove_circle_outline_rounded,
                                    color: listPengajuan[i]['sudah_dibayar'] ? defGreen : defRed,
                                    size: 35,
                                  ),
                                  title: Text(
                                    "Cicilan Angsuran Ke - ${listPengajuan[i]["angsuran_ke"]}",
                                    style: textStyling.mcLarenBold(13, defBlack1),
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Text(
                                        listPengajuan[i]['sudah_dibayar'] ? 'Lunas' : 'Belum Lunas',
                                        style: textStyling.mcLaren(
                                          12,
                                          listPengajuan[i]['sudah_dibayar'] ? defGreen : defRed,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        !listPengajuan[i]['sudah_dibayar']
                                            ? CurrencyFormat.convertToIdr(
                                                double.parse((double.parse(listPengajuan[i]["nominal"].toString()) +
                                                        double.parse(listPengajuan[i]["bunga"].toString()))
                                                    .toString()),
                                                2,
                                              ).toString()
                                            : "",
                                        style: textStyling.mcLaren(
                                            13, listPengajuan[i]['sudah_dibayar'] ? defGreen : defRed),
                                      ),
                                    ],
                                  ),
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Pokok   ",
                                          style: textStyling.nunitoBold(15, defBlack1),
                                        ),
                                        Spacer(),
                                        Text(
                                          CurrencyFormat.convertToIdr(
                                                  double.parse(listPengajuan[i]["nominal"].toString()), 2)
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
                                          CurrencyFormat.convertToIdr(
                                                  double.parse(listPengajuan[i]["bunga"].toString()), 2)
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
                                            double.parse((double.parse(listPengajuan[i]["nominal"].toString()) +
                                                    double.parse(listPengajuan[i]["bunga"].toString()))
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
                            ),
                          SizedBox(height: 10),
                        ],
                      )
                    : SizedBox(
                        height: global.getHeight(context),
                        child: Column(
                          children: [
                            Spacer(),
                            Icon(Icons.cancel_rounded, color: defRed, size: 40),
                            Text("Transaksi Dibatalkan !", style: textStyling.mcLarenBold(20, defRed)),
                            Spacer(),
                          ],
                        ),
                      )
                : Column(
                    children: [
                      SizedBox(height: kToolbarHeight * 4),
                      for (var i = 0; i < 10; i++) shimmerWidget.listTileShimmer(context: context)
                    ],
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
                height: kToolbarHeight * 4.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
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
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  margin: EdgeInsets.only(top: 40, left: 10, right: 10, bottom: 10),
                  decoration: ui.decCont2(defWhite, 28, 28, 28, 28),
                  child: Column(children: [
                    SizedBox(height: 5),
                    ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      title: Text(
                        "Detail Transaksi",
                        style: textStyling.customColorBold(18, defOrange),
                      ),
                      subtitle: Text(
                        '''Nomor Transaksi : ${obj["data"]['nomor_transaksi']}
Nama Barang :  ${obj["data"]['nama']}
Tanggal Transaksi :  ${obj["data"]['tgl_transaksi']}
Besar Pinjaman :  ${CurrencyFormat.convertToIdr(double.parse(obj["data"]['besar_pinjaman']), 2).toString()}
Realisasi :  ${CurrencyFormat.convertToIdr(double.parse(obj["data"]['realisasi_pinjaman']), 2).toString()}
Sisa Tagihan :  ${CurrencyFormat.convertToIdr(double.parse(obj["data"]['sisa_pembayaran'].toString()), 2).toString()}
Angsuran : ${obj["data"]['tenor']}x''',
                        style: textStyling.nunitoBold(15, defGrey),
                      ),
                    ),
                    SizedBox(height: 5),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
