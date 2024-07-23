// ignore_for_file: file_names, avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, no_logic_in_create_state, avoid_print, use_build_context_synchronously

part of '../../../header.dart';

class DetailBarang extends StatefulWidget {
  final obj;
  const DetailBarang({super.key, required this.obj});

  @override
  DetailBarangState createState() => DetailBarangState();
}

class DetailBarangState extends State<DetailBarang> {
  var listPengajuan = [], isLoading = true, obj = {}, cntCart = 0;

  @override
  void initState() {
    obj = widget.obj;
    cntCart = int.parse(obj["qty"] != null ? obj["qty"].toString() : "0");
    global.autoLogoutCheck(context);
    super.initState();
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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: ui.decCont2(defWhite, 5, 5, 5, 5),
              margin: EdgeInsets.all(10),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: defGrey,
              ),
            ),
          ),
          actions: [
            // GestureDetector(
            //   onTap: () {
            //     Navigator.pushNamed(context, '/keranjangBelanja');
            //   },
            //   child: Container(
            //     decoration: ui.decCont2(defWhite, 5, 5, 5, 5),
            //     margin: EdgeInsets.all(10),
            //     padding: EdgeInsets.all(5),
            //     child: Icon(
            //       Icons.shopping_cart_rounded,
            //       color: defGrey,
            //     ),
            //   ),
            // ),
          ],
        ),
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
                height: global.getHeight(context),
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("assets/bg2.png"), fit: BoxFit.cover),
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
          top: kToolbarHeight * 1.6,
          left: 15,
          bottom: 0,
          right: 15,
          child: Column(
            children: [
              Container(
                height: global.getHeight(context) / 3,
                width: global.getWidth(context),
                decoration: ui.decCont2(Colors.transparent, 25, 25, 25, 25),
                child: Image.network(
                  global.getImageUrl("barang/${widget.obj["foto_barang"]}").toString(),
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
          child: RefreshIndicator(
            onRefresh: () async {},
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          bottom: 0,
          right: 0,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: kToolbarHeight * 7),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: ui.decCont2(defWhite, 0, 0, 15, 15),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          widget.obj["nama"],
                          style: textStyling.mcLarenBold(18, defBlack1),
                        ),
                        subtitle: Text(
                          CurrencyFormat.convertToIdr(double.parse(widget.obj["harga_jual"]), 2),
                          style: textStyling.mcLarenBold(14, defGrey),
                        ),
                      ),
                      SizedBox(
                        width: global.getWidth(context),
                        child: Row(
                          children: [
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                if (cntCart != 0) {
                                  cntCart = cntCart - 1;
                                }
                                setState(() {});
                              },
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: ui.decCont(defWhite, 10, 10, 10, 10),
                                child: Icon(Icons.remove, color: defRed),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(cntCart.toString(), style: textStyling.customColorBold(20, defBlack1)),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                cntCart = cntCart + 1;
                                setState(() {});
                              },
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: ui.decCont(defWhite, 10, 10, 10, 10),
                                child: Icon(Icons.add_rounded, color: defBlue),
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: addToCart,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: ui.decCont(defWhite, 10, 10, 10, 10),
                                child: Row(
                                  children: [
                                    Icon(Icons.add_shopping_cart_rounded, color: defOrange),
                                    Text("Tambah ke keranjang", style: textStyling.mcLarenBold(12, defOrange)),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        visualDensity: VisualDensity(vertical: -4),
                        title: Text("Kode Barang"),
                        subtitle: Text(widget.obj["kode"]),
                      ),
                      ListTile(
                        visualDensity: VisualDensity(vertical: -4),
                        subtitle: Text("Harga per ${widget.obj["satuan"]}"),
                      ),
                      SizedBox(height: 10),
                      SizedBox(height: global.getHeight(context) - (kToolbarHeight * 5.8)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> addToCart() async {
    var checkCart = await preference.getData("cart"), msg = "menambahkan";
    widget.obj["qty"] = cntCart;
    if (cntCart < 1) return alert.alertWarning(context: context, text: "Barang tidak boleh kurang dari 1");
    Map tempCart;
    if (checkCart == null) {
      tempCart = {
        "cart": [widget.obj]
      };
    } else {
      tempCart = jsonDecode(utf8.decode(base64.decode(checkCart)));
      Map<String, dynamic>? targetElemen = tempCart['cart'].firstWhere(
        (elemen) => elemen['kode'] == widget.obj["kode"],
        orElse: () => null,
      );
      if (targetElemen != null) {
        targetElemen["qty"] = cntCart;
        msg = "mengupdate";
      } else {
        tempCart["cart"].add(widget.obj);
      }
    }
    preference.setString("cart", base64Encode(utf8.encode(jsonEncode(tempCart))));
    Navigator.pop(context);
    alert.alertSuccess(context: context, text: "Berhasil $msg ke keranjang");
  }
}
