// ignore_for_file: file_names, avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

part of '../../../header.dart';

class Keranjang extends StatefulWidget {
  const Keranjang({super.key});
  @override
  KeranjangState createState() => KeranjangState();
}

class KeranjangState extends State<Keranjang> {
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
    var tempCart = await preference.getData("cart");
    if (tempCart != null) {
      listCart = jsonDecode(utf8.decode(base64.decode(tempCart)))["cart"];
    }

    countTotal();

    setState(() {});
  }

  countTotal() {
    grandTotal = 0;
    for (var i = 0; i < listCart.length; i++) {
      grandTotal = grandTotal + (double.parse(listCart[i]["harga_jual"]) * listCart[i]["qty"]);
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
              "Keranjang",
              style: textStyling.customColor(18, defWhite),
            ),
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
                  for (var i = 0; i < listCart.length; i++)
                    Dismissible(
                      key: Key(listCart[i]['kode']),
                      onDismissed: (direction) {
                        grandTotal = grandTotal - (double.parse(listCart[i]["harga_jual"]) * listCart[i]["qty"]);
                        global.addToCart(listCart[i], context, 0);
                        setState(() => listCart.removeAt(i));
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/detailBarang', arguments: listCart[i]).then(
                            (value) {
                              countTotal();
                              setState(() {});
                            },
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          decoration: ui.decCont(defWhite, 0, 0, 0, 0),
                          child: ListTile(
                            leading: Image.network(
                              global.getImageUrl("barang/${listCart[i]["foto_barang"]}").toString(),
                            ),
                            title: Text(listCart[i]["nama"], style: textStyling.defaultBlackBold(13)),
                            subtitle: Row(
                              children: [
                                Text("${listCart[i]["qty"]}", style: textStyling.nunitoBold(13, defGrey)),
                                Text(" x ", style: textStyling.nunitoBold(13, defGrey)),
                                Text(listCart[i]["harga_jual"], style: textStyling.nunitoBold(13, defGrey)),
                                Spacer(),
                                Text(
                                  CurrencyFormat.convertToIdr(
                                    double.parse(listCart[i]["harga_jual"]) * listCart[i]["qty"],
                                    2,
                                  ),
                                  style: textStyling.nunitoBold(13, defBlack1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    decoration: ui.decCont(defWhite, 10, 10, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              "*) Swipe barang untuk menghapus",
                              style: TextStyle(fontStyle: FontStyle.italic, color: defRed, fontSize: 11),
                            ),
                            Spacer(),
                            Text("Total Harga", style: TextStyle(fontStyle: FontStyle.italic)),
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
                        Container(
                          child: TextField(
                            textInputAction: TextInputAction.done,
                            controller: ketController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                              hintText: 'Keterangan',
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                alert.alertConfirmation(
                                    context: context,
                                    action: () {
                                      preference.remove("cart");
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      alert.alertSuccess(context: context, text: "Keranjang berhasil dihapus");
                                    },
                                    message: "Hapus semua barang yang ada di keranjang ?");
                              },
                              child: Container(
                                width: global.getWidth(context) / 3,
                                padding: EdgeInsets.all(5),
                                decoration: ui.decCont2(defRed, 10, 10, 10, 10),
                                child: Row(
                                  children: [
                                    Spacer(),
                                    Icon(Icons.delete, color: defWhite),
                                    SizedBox(width: 10),
                                    Text("Kosongkan", style: textStyling.mcLarenBold(12, defWhite)),
                                    Spacer(),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                alert.alertConfirmation(
                                  context: context,
                                  action: orderAction,
                                  message:
                                      "Setelah data tersimpan, transaksi tidak dapat dibatalkan, apakah data yang anda masukan sudah benar?",
                                );
                              },
                              child: Container(
                                width: global.getWidth(context) / 3,
                                padding: EdgeInsets.all(5),
                                decoration: ui.decCont2(defGreen, 10, 10, 10, 10),
                                child: Row(
                                  children: [
                                    Spacer(),
                                    Text("Checkout", style: textStyling.mcLarenBold(12, defWhite)),
                                    SizedBox(width: 10),
                                    Icon(Icons.shopping_cart_checkout_rounded, color: defWhite),
                                    Spacer(),
                                  ],
                                ),
                              ),
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

  Future<void> orderAction() async {
    Navigator.pop(context);
    alert.loadingAlert(context: context, text: "Mohon tunggu ... ", isPop: false);
    Map obj = {'url': "transaksi/order/create"};
    try {
      obj["tgl_order"] = "${global.formatDate2(DateTime.now())} ${global.formatTime(DateTime.now())}";
      obj["kode_anggota"] = preference.getData("kodeAnggota");
      obj["kode_wilayah"] = preference.getData("kodeWilayah") ?? "BDG";
      obj["keterangan"] = ketController.text != "" ? ketController.text : "-";
      obj["kode_barang"] = [];
      obj["qty"] = [];
      obj["harga_jual"] = [];
      for (var i = 0; i < listCart.length; i++) {
        obj["kode_barang"].add(listCart[i]["kode"]);
        obj["harga_jual"].add(listCart[i]["harga_jual"]);
        obj["qty"].add(listCart[i]["qty"]);
      }

      PembelianService(context: context, objParam: obj).orderCart();
    } catch (err) {
      print(err);
    }
  }
}
