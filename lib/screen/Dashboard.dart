// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_key_in_widget_constructors, no_logic_in_create_state, avoid_print, avoid_unnecessary_containers, unnecessary_null_comparison, invalid_use_of_visible_for_testing_member
part of '../../header.dart';

class Dashboard extends StatefulWidget {
  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: defWhite,
        extendBodyBehindAppBar: true,
        appBar: widget.appBarTitle(context, "Smart Koperasi Central", Colors.transparent),
        body: Stack(children: [
          widget.bgAppbar(context),
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
                  padding: EdgeInsets.only(top: 15, left: 10, right: 10),
                  height: global.getHeight(context) - (kToolbarHeight * 2.5),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
                    image: DecorationImage(image: AssetImage("assets/bgbg2.png"), fit: BoxFit.cover),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: global.getWidth(context),
                        child: Row(
                          children: [
                            SizedBox(width: 15),
                            Text(
                              "Selamat datang, \nYossandi Imran Prihartanto",
                              style: textStyling.customColor(global.getWidth(context) / 20, defWhite),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
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
                  padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                  height: global.getHeight(context) - (kToolbarHeight * 5),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(40), topLeft: Radius.circular(40)),
                    color: Colors.blueGrey.shade50,
                  ),
                  child: ScrollConfiguration(
                    behavior: const ScrollBehavior().copyWith(overscroll: false),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: kToolbarHeight * 3),
                Container(
                  padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                  margin: EdgeInsets.only(left: 10, right: 10),
                  height: (kToolbarHeight * 2.7),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    image: DecorationImage(image: AssetImage("assets/bgcard-o.png"), fit: BoxFit.cover),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ScrollConfiguration(
                    behavior: const ScrollBehavior().copyWith(overscroll: false),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.monetization_on,
                            color: defOrange,
                            size: 36,
                          ),
                          trailing: Text("22D055", style: textStyling.customColorBold(15, defBlack1)),
                        ),
                        Spacer(),
                        ListTile(
                          title: Text("Total Saldo", style: textStyling.customColorBold(16, defOrange)),
                          subtitle: Text("Rp. 10.000.000", style: textStyling.customColorBold(20, defBlack1)),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Spacer(),
                    Container(
                      width: global.getWidth(context) / 2.3,
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        color: defRed,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Text("Tarik ", style: textStyling.customColorBold(16, defWhite)),
                          Spacer(),
                          Icon(Icons.download_rounded, color: Colors.white),
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: global.getWidth(context) / 2.3,
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        color: defblue2,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Text("Setor", style: textStyling.customColorBold(16, defWhite)),
                          Spacer(),
                          Icon(Icons.upload_rounded, color: Colors.white),
                        ],
                      ),
                    ),
                    Spacer(),
                  ],
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
