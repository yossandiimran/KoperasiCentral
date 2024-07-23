// ignore_for_file: file_names, avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, prefer_typing_uninitialized_variables

part of '../../../header.dart';

class ListOrderDetail extends StatefulWidget {
  final obj;
  const ListOrderDetail({super.key, this.obj});
  @override
  ListOrderDetailState createState() => ListOrderDetailState();
}

class ListOrderDetailState extends State<ListOrderDetail> {
  List listCart = [];
  bool isLoading = true;
  num grandTotal = 0;
  TextEditingController ketController = TextEditingController(text: "");
  @override
  void initState() {
    global.autoLogoutCheck(context);
    super.initState();
    getDashboardData();
  }

  Future<void> getDashboardData() async {
    isLoading = true;
    listCart.clear();
    setState(() {});
    try {
      Map obj = {"url": "transaksi/order/detail/${widget.obj["id"]}"};
      PembelianService pps = PembelianService(context: context, objParam: obj);
      Map rawDataOrder = await pps.getKatalog();
      var dataOrder = rawDataOrder["data"];
      for (int i = 0; i < dataOrder.length; i++) {
        listCart.add(dataOrder[i]);
      }
      print(dataOrder);
      ketController.text = widget.obj["keterangan"] != "" ? widget.obj["keterangan"] : "-";
      isLoading = false;
      setState(() {});
      countTotal();
    } catch (err) {
      Navigator.pushNamed(context, '/home');
      setState(() {});
      // alert.alertWarning(context: context, text: "Koneksi tidak stabil");
    }
  }

  countTotal() {
    grandTotal = 0;
    for (var i = 0; i < listCart.length; i++) {
      grandTotal = grandTotal + (double.parse(listCart[i]["detail_barang"]["harga_jual"]) * listCart[i]["qty"]);
    }
    setState(() {});
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
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: defWhite,
                size: 25,
              ),
            ),
            title: Text(
              "Detail Order",
              style: textStyling.customColor(18, defWhite),
            ),
            centerTitle: true,
          ),
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
          child: Column(
            children: [
              Container(
                height: kToolbarHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(8)),
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
              ),
            ],
          ),
        ),
        Positioned(
          top: kToolbarHeight,
          left: 0,
          bottom: 0,
          right: 0,
          child: RefreshIndicator(
            onRefresh: () async => getDashboardData(),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    decoration: ui.decCont(defWhite, 15, 15, 15, 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text("ID Order", style: textStyling.customColorBold(12, defBlack1)),
                            Spacer(),
                            Text(
                              "${widget.obj["info"]["id"].toString()} - ${widget.obj["info"]["kode_anggota"]}",
                              style: textStyling.customColor(12, defGrey),
                            ),
                          ],
                        ),
                        SizedBox(height: 7),
                        Row(
                          children: [
                            Text("Tanggal", style: textStyling.customColorBold(12, defBlack1)),
                            Spacer(),
                            Text(
                              widget.obj["info"]["tgl_order"].toString(),
                              style: textStyling.customColor(12, defGrey),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Text("Status Order", style: textStyling.customColorBold(12, defBlack1)),
                            Spacer(),
                            getIconStatus(widget.obj["info"]),
                            gettextStatus(widget.obj["info"]),
                          ],
                        ),
                        SizedBox(height: 3),
                        Row(
                          children: [
                            Text("Keterangan", style: textStyling.customColorBold(12, defBlack1)),
                            Spacer(),
                            Text(
                              widget.obj["keterangan"],
                              style: textStyling.customColor(12, defGrey),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  for (var i = 0; i < listCart.length; i++)
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/detailBarang', arguments: listCart[i]["detail_barang"]).then(
                          (value) {
                            countTotal();
                            setState(() {});
                          },
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        decoration: ui.decCont(defWhite, 0, 0, i == 0 ? 15 : 0, i == 0 ? 15 : 0),
                        child: ListTile(
                          leading: Image.network(
                            global.getImageUrl("barang/${listCart[i]['detail_barang']["foto_barang"]}").toString(),
                          ),
                          title: Text(listCart[i]['detail_barang']["nama"], style: textStyling.defaultBlackBold(13)),
                          subtitle: Row(
                            children: [
                              Text("${listCart[i]["qty"]}", style: textStyling.nunitoBold(13, defGrey)),
                              Text(" x ", style: textStyling.nunitoBold(13, defGrey)),
                              Text(
                                // listCart[i]['detail_barang']["harga_jual"],
                                listCart[i]['harga_satuan'].toString(),
                                style: textStyling.nunitoBold(13, defGrey),
                              ),
                              Spacer(),
                              Text(
                                CurrencyFormat.convertToIdr(
                                  // double.parse(listCart[i]['detail_barang']["harga_jual"]) * listCart[i]["qty"],
                                  double.parse(listCart[i]['harga_satuan'].toString()) * listCart[i]["qty"],
                                  2,
                                ),
                                style: textStyling.nunitoBold(13, defBlack1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    decoration: ui.decCont(defWhite, 15, 15, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text("Total Belanja", style: TextStyle(fontStyle: FontStyle.italic)),
                          ],
                        ),
                        Divider(thickness: 3),
                        Row(
                          children: [
                            Spacer(),
                            Text(
                              CurrencyFormat.convertToIdr(grandTotal, 2),
                              style: textStyling.defaultBlackBold(14),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    decoration: ui.decCont(defWhite, 15, 15, 15, 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text("ID Order", style: textStyling.customColorBold(12, defBlack1)),
                            Spacer(),
                            Text(
                              "${widget.obj["info"]["id"].toString()} - ${widget.obj["info"]["kode_anggota"]}",
                              style: textStyling.customColor(12, defGrey),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Icon getIconStatus(data) {
    Icon icon = Icon(Icons.access_time_rounded, color: defOrange, size: 18);
    if (data["status"] == 1) return Icon(Icons.access_time_rounded, color: defPurple, size: 18);
    if (data["status"] == 2) return Icon(Icons.local_shipping_rounded, color: defOrange, size: 18);
    if (data["status"] == 3) return Icon(Icons.check_circle, color: defGreen, size: 18);
    if (data["status"] == 4) return Icon(Icons.close, color: defRed, size: 18);
    return icon;
  }

  Text gettextStatus(data) {
    Text text = Text("  Menunggu", style: textStyling.customColorBold(14, defOrange));
    if (data["status"] == 1) return Text("  Menunggu", style: textStyling.customColorBold(12, defPurple));
    if (data["status"] == 2) return Text("  Diproses", style: textStyling.customColorBold(12, defOrange));
    if (data["status"] == 3) return Text("  Selesai", style: textStyling.customColorBold(12, defGreen));
    if (data["status"] == 4) return Text("  Dibatalkan", style: textStyling.customColorBold(12, defRed));
    return text;
  }
}
