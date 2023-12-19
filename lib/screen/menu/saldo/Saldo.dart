// ignore_for_file: file_names, avoid_unnecessary_containers, prefer_const_constructors, sized_box_for_whitespace, curly_braces_in_flow_control_structures
part of '../../../header.dart';

class Saldo extends StatefulWidget {
  const Saldo({super.key});
  @override
  SaldoState createState() => SaldoState();
}

class SaldoState extends State<Saldo> {
  List<dynamic> listSaldo = [];
  bool isLoading = true;
  int page = 1, saldoKas = 0;
  ScrollController sc = ScrollController();

  @override
  void initState() {
    super.initState();
    global.autoLogoutCheck(context);
    getSaldoData(refresh: true);
    sc.addListener(scrollListener);
  }

  @override
  void dispose() {
    sc.removeListener(scrollListener);
    sc.dispose();
    super.dispose();
  }

  void scrollListener() async {
    if (sc.position.pixels == sc.position.maxScrollExtent) {
      if (!isLoading) {
        setState(() {
          isLoading = true;
          page = page + 1;
        });
        await getSaldoData(refresh: false);
      }
    }
  }

  Future<void> getSaldoData({required bool refresh}) async {
    isLoading = true;
    if (refresh) listSaldo.clear();
    setState(() {});
    try {
      Map objParam = {"page": page};
      PengajuanSimpananService simpananList = PengajuanSimpananService(context: context, objParam: objParam);
      Map dataPengajuan = await simpananList.getListPengajuan();
      for (int i = 0; i < dataPengajuan["data"].take(7).toList().length; i++) listSaldo.add(dataPengajuan["data"][i]);
      MasterService masterService = MasterService(context: context);
      Map dataMaster = await masterService.getDashboardService();
      saldoKas = int.parse(dataMaster["data"]['saldo_simpanan']);
      isLoading = false;
      setState(() {});
    } catch (err) {
      isMenuActive = 0;
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
          child: Column(
            children: [
              Container(
                height: kToolbarHeight * 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
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
          top: 0,
          left: 0,
          bottom: 0,
          right: 0,
          child: Column(
            children: [
              SizedBox(height: kToolbarHeight),
              Center(child: Text("History Saldo Simpanan", style: textStyling.defaultWhiteBold(20))),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(thickness: 3, color: defOrange),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Spacer(),
                  Container(
                    width: global.getWidth(context) / 1.2,
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      image: DecorationImage(image: AssetImage("assets/bgbg2.png"), fit: BoxFit.cover),
                    ),
                    child: ListTile(
                      title: Text(
                        "Total Saldo Kas",
                        style: textStyling.defaultWhiteBold(15),
                      ),
                      subtitle: Text(
                        CurrencyFormat.convertToIdr(saldoKas, 2).toString(),
                        style: textStyling.nunitoBold(13, defBlack1),
                      ),
                    ),
                  ),
                  Spacer(),
                  // Container(
                  //   width: global.getWidth(context) / 2.3,
                  //   padding: EdgeInsets.all(5),
                  //   decoration: BoxDecoration(
                  //     borderRadius: const BorderRadius.all(Radius.circular(20)),
                  //     image: DecorationImage(image: AssetImage("assets/bgbg2.png"), fit: BoxFit.cover),
                  //   ),
                  //   child: ListTile(
                  //     title: Text(
                  //       "Simpanan selanjutnya",
                  //       style: textStyling.defaultWhiteBold(13),
                  //     ),
                  //     subtitle: Text(
                  //       "Rp. 0,00",
                  //       style: textStyling.nunitoBold(13, defBlack1),
                  //     ),
                  //   ),
                  // ),
                  // Spacer(),
                ],
              ),
              Spacer(),
              Container(
                height: global.getHeight(context) / 1.5,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  controller: sc,
                  child: Column(
                    children: [
                      for (var i = 0; i < listSaldo.length; i++)
                        Container(
                          decoration: widget.decCont(defWhite, 20, 20, 20, 20),
                          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          padding: EdgeInsets.all(15),
                          child: ListTile(
                            title: Text(
                              listSaldo[i]["jenis_simpanan"] == "wajib" ? "Simpanan Wajib" : "Simpanan Pokok",
                            ),
                            subtitle: Text(
                              '''${CurrencyFormat.convertToIdr(int.parse(listSaldo[i]['nominal']), 2).toString()}
Tanggal : ${listSaldo[i]["tgl_transaksi"]}''',
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                if (listSaldo[i]["batalkan"] != null) {
                                  alert.alertWarning(context: context, text: listSaldo[i]["alasan"]);
                                }
                              },
                              icon: Icon(
                                listSaldo[i]["batalkan"] == null
                                    ? Icons.check_circle_outline_rounded
                                    : Icons.remove_circle_outline_rounded,
                                color: listSaldo[i]["batalkan"] == null ? defGreen : defRed,
                              ),
                            ),
                          ),
                        ),
                      isLoading ? shimmerWidget.listTileShimmer(context: context) : Container(),
                      isLoading ? shimmerWidget.listTileShimmer(context: context) : Container(),
                      isLoading ? shimmerWidget.listTileShimmer(context: context) : Container(),
                      isLoading ? shimmerWidget.listTileShimmer(context: context) : Container(),
                      isLoading ? shimmerWidget.listTileShimmer(context: context) : Container(),
                      SizedBox(height: 5)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
