// ignore_for_file: file_names, avoid_unnecessary_containers, prefer_const_constructors

part of '../../../header.dart';

class ListOrder extends StatefulWidget {
  const ListOrder({super.key});
  @override
  ListOrderState createState() => ListOrderState();
}

class ListOrderState extends State<ListOrder> {
  List listOrder = [];
  bool isLoading = true;
  @override
  void initState() {
    global.autoLogoutCheck(context);
    super.initState();
    getDashboardData();
  }

  Future<void> getDashboardData() async {
    isLoading = true;
    listOrder.clear();
    setState(() {});
    try {
      Map obj = {"url": "transaksi/order/list"};
      PembelianService pps = PembelianService(context: context, objParam: obj);
      Map rawDataOrder = await pps.getKatalog();
      var dataOrder = rawDataOrder["data"]["data"];
      for (int i = 0; i < dataOrder.length; i++) {
        listOrder.add(dataOrder[i]);
      }
      isLoading = false;
      listOrder = listOrder.reversed.toList();
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
        Navigator.pop(context);
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.blueGrey.shade50,
          extendBodyBehindAppBar: true,
          body: getBodyView(),
        ),
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
                        SizedBox(height: 10),
                        SizedBox(height: kToolbarHeight),
                        for (var i = 0; i < listOrder.length; i++)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                            decoration: ui.decCont(defWhite, 10, 10, 10, 10),
                            child: Column(children: [
                              Row(
                                children: [
                                  getIconStatus(listOrder[i]),
                                  gettextStatus(listOrder[i]),
                                  Spacer(),
                                  Text(
                                    "${listOrder[i]["id"].toString()} - ${listOrder[i]["kode_anggota"]}",
                                    style: textStyling.customColorBold(14, defBlack1),
                                  ),
                                ],
                              ),
                              SizedBox(height: 3),
                              Row(
                                children: [
                                  Text("Tanggal", style: textStyling.customColor(12, defBlack1)),
                                  Spacer(),
                                  Text(
                                    listOrder[i]["tgl_order"].toString(),
                                    style: textStyling.customColor(12, defGrey),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Text("Keterangan", style: textStyling.customColor(12, defBlack1)),
                                  Spacer(),
                                  Text(
                                    listOrder[i]["keterangan"],
                                    style: textStyling.customColor(12, defGrey),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      Map objParam = {
                                        'id': listOrder[i]["id"],
                                        "keterangan": listOrder[i]["keterangan"],
                                        "info": listOrder[i],
                                      };
                                      Navigator.pushNamed(context, '/listOrderDetail', arguments: objParam);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      decoration: ui.decCont(defWhite, 10, 10, 10, 10),
                                      child: Row(
                                        children: [
                                          Text("Detail    ", style: textStyling.customColor(12, defBlack1)),
                                          Icon(Icons.arrow_forward_ios_rounded, color: defBlack1, size: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
                height: kToolbarHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                  image: DecorationImage(image: AssetImage("assets/bgbg2.png"), fit: BoxFit.cover),
                  color: defBlack2,
                ),
                child: Center(child: Text("Daftar Order Barang", style: textStyling.customColorBold(18, defWhite))),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Icon getIconStatus(data) {
    Icon icon = Icon(Icons.access_time_rounded, color: defOrange, size: 14);
    if (data["status"] == 1) return Icon(Icons.access_time_rounded, color: defPurple, size: 14);
    if (data["status"] == 2) return Icon(Icons.local_shipping_rounded, color: defOrange, size: 14);
    if (data["status"] == 3) return Icon(Icons.check_circle, color: defGreen, size: 14);
    if (data["status"] == 4) return Icon(Icons.close, color: defRed, size: 14);
    return icon;
  }

  Text gettextStatus(data) {
    Text text = Text("  Menunggu", style: textStyling.customColorBold(14, defOrange));
    if (data["status"] == 1) return Text("  Menunggu", style: textStyling.customColorBold(14, defPurple));
    if (data["status"] == 2) return Text("  Diproses", style: textStyling.customColorBold(14, defOrange));
    if (data["status"] == 3) return Text("  Selesai", style: textStyling.customColorBold(14, defGreen));
    if (data["status"] == 4) return Text("  Dibatalkan", style: textStyling.customColorBold(14, defRed));
    return text;
  }
}
