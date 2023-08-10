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
    PengajuanPinjamanService pps = PengajuanPinjamanService(context: context);
    Map dataPengajuan = await pps.getListPengajuan();
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
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
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
                          "Pengajuan Pinjaman\n",
                          style: textStyling.customColorBold(14, defOrange),
                        ),
                        subtitle: Text(
                          '''Nomor Transaksi : ${listPengajuan[i]['nomor_transaksi']}
Tanggal Transaksi :  ${listPengajuan[i]['tgl_transaksi']}
Besar Pinjaman :  ${CurrencyFormat.convertToIdr(int.parse(listPengajuan[i]['besar_pinjaman']), 2).toString()}
Tenor : ${listPengajuan[i]['tenor']} Bulan''',
                          style: textStyling.nunitoBold(13, defGrey),
                        ),
                      ),
                      Divider(thickness: 3),
                      Row(
                        children: [
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
                                )),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                    ]),
                  ),
                SizedBox(height: 10),
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
                child: Center(child: Text("\nDaftar Transaksi", style: textStyling.customColorBold(20, defWhite))),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
