// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, prefer_interpolation_to_compose_strings
part of '../header.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    // fbmessaging.initFirebase(
    //   context: context,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => alert.alertConfirmExit(context),
      child: Scaffold(
        backgroundColor: defWhite,
        body: Stack(children: [
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.only(top: kToolbarHeight, left: 20, right: 20),
                  height: global.getHeight(context) / 1.5,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(100),
                      bottomLeft: Radius.circular(100),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [defPurple, defPurple2, defPurple2],
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: global.getWidth(context),
                        child: Row(
                          children: [
                            Image.asset("assets/logo.png", width: global.getWidth(context) / 7),
                            SizedBox(width: 10),
                            Text(
                              "Master Data Graha",
                              style: textStyling.customColorBold(global.getWidth(context) / 20, defWhite),
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
                      widget.getBoxNamed(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
          widget.getImageBgSugar(context),
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
                  margin: EdgeInsets.only(top: 0, left: 15, right: 15),
                  padding: EdgeInsets.only(top: 10),
                  height: global.getHeight(context) / 2,
                  decoration: widget.decCont(Colors.blueGrey.shade50, 0, 0, 30, 30),
                  child: ScrollConfiguration(
                    behavior: const ScrollBehavior().copyWith(overscroll: false),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Text(global.getWidth(context).toString()),
                          // Text(global.getHeight(context).toString()),
                          widget.getWidgetMenu2(
                            context: context,
                            routeName: "/homeVendor",
                            title: "Master Data Vendor",
                            color: defGreen,
                            colorIcon: defBlue,
                            image: AssetImage("assets/vendor.png"),
                          ),
                          widget.getWidgetMenu2(
                            context: context,
                            routeName: "/inputTglSpk",
                            title: "Master Data Customer",
                            color: defBlue,
                            colorIcon: defBlue,
                            image: AssetImage("assets/customer.png"),
                          ),
                          widget.getWidgetMenu2(
                            context: context,
                            routeName: "/inputTglSpk",
                            title: "Master Data Shipment",
                            color: defOrange,
                            colorIcon: defBlue,
                            image: AssetImage("assets/shipment.png"),
                          ),
                          widget.getWidgetMenu2(
                            context: context,
                            routeName: "/inputTglSpk",
                            title: "Master Data Barang",
                            color: defRed,
                            colorIcon: defBlue,
                            image: AssetImage("assets/barang.png"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
