// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_key_in_widget_constructors, no_logic_in_create_state, avoid_print, avoid_unnecessary_containers, unnecessary_null_comparison, invalid_use_of_visible_for_testing_member, prefer_interpolation_to_compose_strings
part of '../../header.dart';

class Dashboard extends StatefulWidget {
  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  List listPengajuan = ["pengajuan1"];
  @override
  void initState() {
    super.initState();
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
                              "Selamat datang, \n" + preference.getData("name"),
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
                    color: Colors.white,
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
                SizedBox(height: kToolbarHeight * 2.8),
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
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/formPengajuanPinjaman');
                      },
                      child: Container(
                        width: global.getWidth(context) / 2.3,
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
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
                            Text("Pengajuan", style: textStyling.customColorBold(16, defWhite)),
                            Spacer(),
                            Icon(Icons.download_rounded, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: global.getWidth(context) / 2.3,
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        color: defBlue,
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
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: widget.decCont2(defWhite, 20, 20, 20, 20),
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              ListTile(
                                dense: true,
                                visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                leading: Icon(Icons.payment_rounded, color: defblue2),
                                title: Text(
                                  "Rp. 5.250.000,-",
                                  style: textStyling.nunitoBold(15, defBlack2),
                                ),
                                subtitle: Text(
                                  "Jumlah Pokok Pinjaman",
                                  style: textStyling.nunitoBold(14, defGrey),
                                ),
                              ),
                              ListTile(
                                dense: true,
                                leading: Icon(Icons.calendar_month_rounded, color: defRed),
                                title: Text(
                                  "Rp. 250.000,-",
                                  style: textStyling.nunitoBold(15, defBlack2),
                                ),
                                subtitle: Text(
                                  "Tagihan Mendatang + Denda | 14/06/2023",
                                  style: textStyling.nunitoBold(14, defGrey),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: global.getWidth(context) / 5,
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.only(left: 10, right: 5, bottom: 10),
                                    decoration: widget.decCont2(defOrange, 19, 19, 19, 19),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Jumlah Cicilan",
                                          style: textStyling.customColorBold(12, defWhite),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text("4", style: textStyling.customColorBold(20, defWhite)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: global.getWidth(context) / 5,
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.only(left: 5, right: 5, bottom: 10),
                                    decoration: widget.decCont2(defblue2, 19, 19, 19, 19),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Pinjaman Aktif",
                                          style: textStyling.customColorBold(12, defWhite),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text("1", style: textStyling.customColorBold(20, defWhite)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: global.getWidth(context) / 5,
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.only(left: 5, right: 5, bottom: 10),
                                    decoration: widget.decCont2(defPurple, 19, 19, 19, 19),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Pinjaman Lunas",
                                          style: textStyling.customColorBold(12, defWhite),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text("2", style: textStyling.customColorBold(20, defWhite)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: global.getWidth(context) / 5,
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.only(left: 5, right: 10, bottom: 10),
                                    decoration: widget.decCont2(getStatPembayaran("l"), 19, 19, 19, 19),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Pembayaran Lancar",
                                          // "Pembayaran Tidak Lancar",
                                          style: textStyling.customColorBold(10, defWhite),
                                          textAlign: TextAlign.center,
                                        ),
                                        Icon(
                                          getStatPembayaranIcon("l"),
                                          color: defWhite,
                                          size: 28,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        // Badge Status Pengajuan Pinjaman / Tracking
                        for (var i = 0; i < listPengajuan.length; i++)
                          Dismissible(
                            key: Key(listPengajuan[i]),
                            onDismissed: (direction) {
                              setState(() {
                                listPengajuan.removeAt(i);
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                              // decoration: widget.decCont(Colors.orange[100], 15, 15, 15, 15),
                              // decoration: widget.decCont(Colors.lightGreenAccent[100], 15, 15, 15, 15),
                              decoration: widget.decCont(defred2, 15, 15, 15, 15),
                              child: ListTile(
                                dense: true,
                                visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                // leading: Icon(Icons.access_time_filled_sharp, color: defOrange, size: 30),
                                // leading: Icon(Icons.check_circle_outline_outlined, color: defGreen, size: 30),
                                leading: Icon(Icons.remove_circle_outline_rounded, color: defRed, size: 30),
                                title: Text(
                                  // "Menunggu Persetujuan",
                                  // "Pengajuan Disetujui",
                                  "Pengajuan Ditolak",
                                  style: textStyling.nunitoBold(14, defBlack2),
                                ),
                                subtitle: Text(
                                  "Pengajuan Pinjaman Mutakhir: 24 Februari 2023 jam 08:29 Nominal: 20,000,000",
                                  style: textStyling.nunitoBold(13, defGrey),
                                ),
                              ),
                            ),
                          ),

                        SizedBox(height: 10),
                      ],
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

  getStatPembayaran(stat) {
    if (stat == "tl") {
      return defRed;
    } else {
      return defGreen;
    }
  }

  getStatPembayaranIcon(stat) {
    if (stat == "tl") {
      return Icons.remove_circle_outline_rounded;
    } else {
      return Icons.check_circle_outline_rounded;
    }
  }
}
