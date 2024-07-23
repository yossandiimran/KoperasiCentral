// ignore_for_file: file_names, avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

part of '../../../header.dart';

class Katalog extends StatefulWidget {
  const Katalog({super.key});
  @override
  KatalogState createState() => KatalogState();
}

class KatalogState extends State<Katalog> {
  List listBarang = [];
  bool isLoading = true;
  int cntCart = 0;
  TextEditingController searchController = TextEditingController(text: "");
  @override
  void initState() {
    global.autoLogoutCheck(context);
    super.initState();
    getDashboardData();
    countCart();
  }

  Future<void> getDashboardData() async {
    isLoading = true;
    listBarang.clear();
    setState(() {});
    try {
      Map obj = {"url": "barang/list?search=${searchController.text}"};
      PembelianService ks = PembelianService(context: context, objParam: obj);
      Map dataBarang = await ks.getKatalog();

      var datBar = dataBarang["data"];

      for (var i = 0; i < datBar["data"].length; i++) {
        listBarang.add(datBar["data"][i]);
      }
      isLoading = false;

      setState(() {});
    } catch (err) {
      Navigator.pushNamed(context, '/home');
      setState(() {});
    }
  }

  Future<void> countCart() async {
    var checkCart = await preference.getData("cart");
    if (checkCart != null) {
      var tempCart = jsonDecode(utf8.decode(base64.decode(checkCart)));
      cntCart = tempCart["cart"].length;
    } else {
      cntCart = 0;
    }
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
        backgroundColor: Colors.blueGrey.shade100,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Icon(
            Icons.shopify_rounded,
            color: defOrange,
            size: 35,
          ),
          title: Text(
            "Katalog Barang",
            style: textStyling.customColor(18, defWhite),
          ),
          actions: [
            BadgeIconNotif(
              onTap: () {
                Navigator.pushNamed(context, '/keranjangBelanja').then((value) => countCart());
              },
              iconData: Icons.shopping_cart_rounded,
              notificationCount: cntCart,
            )
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
                height: kToolbarHeight * 2.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
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
          top: 0,
          left: 0,
          bottom: 0,
          right: 0,
          child: RefreshIndicator(
            onRefresh: () async => getDashboardData(),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [],
              ),
            ),
          ),
        ),
        Positioned(
          top: kToolbarHeight * 2.3,
          left: 5,
          bottom: 0,
          right: 5,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Divider(),
                // Text("   Kategori", style: textStyling.customColor(14, defBlack2)),
                // SingleChildScrollView(
                //   physics: BouncingScrollPhysics(),
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       Container(
                //         margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                //         height: 80,
                //         width: 80,
                //         child: Column(
                //           children: [
                //             Spacer(),
                //             CircleAvatar(
                //               backgroundColor: defOrange,
                //               child: Icon(Icons.shopping_cart_rounded, color: defWhite),
                //             ),
                //             SizedBox(height: 5),
                //             Text("Rumah Tangga", style: textStyling.customColor(12, defGrey)),
                //             Spacer(),
                //           ],
                //         ),
                //       ),
                //       Container(
                //         margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                //         height: 80,
                //         width: 80,
                //         child: Column(
                //           children: [
                //             Spacer(),
                //             CircleAvatar(
                //               backgroundColor: defBlue,
                //               child: Icon(Icons.phone_android_rounded, color: defWhite),
                //             ),
                //             SizedBox(height: 5),
                //             Text("Elektronik", style: textStyling.customColor(12, defGrey)),
                //             Spacer(),
                //           ],
                //         ),
                //       ),
                //       Container(
                //         margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                //         height: 80,
                //         width: 80,
                //         child: Column(
                //           children: [
                //             Spacer(),
                //             CircleAvatar(
                //               backgroundColor: Colors.pink,
                //               child: Icon(Icons.accessibility_rounded, color: defWhite),
                //             ),
                //             SizedBox(height: 5),
                //             Text("Apparel", style: textStyling.customColor(12, defGrey)),
                //             Spacer(),
                //           ],
                //         ),
                //       ),
                //       Container(
                //         margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                //         height: 80,
                //         width: 80,
                //         child: Column(
                //           children: [
                //             Spacer(),
                //             CircleAvatar(
                //               backgroundColor: defPurple,
                //               child: Icon(Icons.home_rounded, color: defWhite),
                //             ),
                //             SizedBox(height: 5),
                //             Text("Properti", style: textStyling.customColor(12, defGrey)),
                //             Spacer(),
                //           ],
                //         ),
                //       ),
                //       Container(
                //         margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                //         height: 80,
                //         width: 80,
                //         child: Column(
                //           children: [
                //             Spacer(),
                //             CircleAvatar(
                //               backgroundColor: defGreen,
                //               child: Icon(Icons.food_bank_rounded, color: defWhite),
                //             ),
                //             SizedBox(height: 5),
                //             Text("Pokok", style: textStyling.customColor(12, defGrey)),
                //             Spacer(),
                //           ],
                //         ),
                //       ),
                //       Container(
                //         margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                //         height: 80,
                //         width: 80,
                //         child: Column(
                //           children: [
                //             Spacer(),
                //             CircleAvatar(
                //               backgroundColor: defRed,
                //               child: Icon(Icons.no_crash_rounded, color: defWhite),
                //             ),
                //             SizedBox(height: 5),
                //             Text("Kendaraan", style: textStyling.customColor(12, defGrey)),
                //             Spacer(),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(height: 20),
                !isLoading
                    ? GridView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: listBarang.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/detailBarang', arguments: listBarang[index]).then((value) {
                                countCart();
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              decoration: ui.decCont(defWhite, 25, 25, 25, 25),
                              height: 100,
                              child: AspectRatio(
                                aspectRatio: 1 / 1,
                                child: Column(
                                  children: [
                                    Spacer(),
                                    Container(
                                      child: Image.network(
                                        global.getImageUrl("barang/${listBarang[index]["foto_barang"]}").toString(),
                                        width: global.getWidth(context) / 4,
                                      ),
                                    ),
                                    Spacer(),
                                    ListTile(
                                      title: Text(
                                        listBarang[index]["nama"],
                                        style: textStyling.customColorBold(13, defBlack1),
                                      ),
                                      subtitle: Text(
                                        CurrencyFormat.convertToIdr(double.parse(listBarang[index]["harga_jual"]), 2),
                                        style: textStyling.customColorBold(13, defGrey),
                                      ),
                                      trailing: GestureDetector(
                                        onTap: () async {
                                          await global.addToCart(listBarang[index], context, 1);
                                          await countCart();
                                        },
                                        child: Icon(Icons.add_shopping_cart_rounded, color: defBlue),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : GridView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 8,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 15,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            decoration: ui.decCont(defWhite, 8, 8, 8, 8),
                            height: 100,
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Column(
                                children: [
                                  Spacer(),
                                  Container(
                                    child: shimmerWidget.defaultShimmer(width: 90, height: 90),
                                  ),
                                  Spacer(),
                                  ListTile(
                                    title: shimmerWidget.defaultShimmer(width: 50, height: 10),
                                    subtitle: shimmerWidget.defaultShimmer(width: 50, height: 10),
                                    trailing: shimmerWidget.defaultShimmer(width: 25, height: 25),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
        Positioned(
          top: kToolbarHeight * 1.35,
          left: 10,
          bottom: 0,
          right: 10,
          child: Column(
            children: [
              Container(
                decoration: ui.decCont2(defWhite.withOpacity(0.1), 15, 15, 15, 15),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(children: [
                  SizedBox(
                    width: global.getWidth(context) / 1.4,
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Cari Produk ... ",
                        hintStyle: textStyling.defaultWhite(14),
                      ),
                      onSubmitted: (value) => getDashboardData(),
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.search_rounded, color: defWhite),
                    onPressed: () => getDashboardData(),
                  )
                ]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
