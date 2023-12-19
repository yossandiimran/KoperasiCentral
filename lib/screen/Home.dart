// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_key_in_widget_constructors, no_logic_in_create_state, avoid_print, avoid_unnecessary_containers, unnecessary_null_comparison, invalid_use_of_visible_for_testing_member, use_build_context_synchronously
part of '../../header.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  var firstLogin = "false";
  @override
  void initState() {
    super.initState();
    getStatusPernyataan();
  }

  Future<void> getStatusPernyataan() async {
    var pernyataan = await preference.getData('tanggalPernyataan');
    print(pernyataan);
    if (pernyataan == '-') {
      Navigator.pushNamed(context, '/aggreement');
    }
    firstLogin = await preference.getData("first_login");
    print(firstLogin);
    if (firstLogin == "false") {
      return global.successResponseNavigate(
        context,
        "Selamat datang di SmartKoperasi Central, silahkan melengkapi form berikut ini! \n ",
        '/mutakhirData',
      );
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
        backgroundColor: defWhite,
        extendBodyBehindAppBar: true,
        bottomNavigationBar: navBarApp(),
        body: getMenuWidget(),
      ),
    );
  }

  getMenuWidget() {
    switch (isMenuActive) {
      case 0:
        return Dashboard();
      case 1:
        return Saldo();
      case 2:
        return Transaksi();
      case 3:
        return Profile();
    }
  }

  navBarApp() {
    return GNav(
        color: defWhite,
        haptic: true,
        tabBorderRadius: 15,
        curve: Curves.linear,
        duration: Duration(milliseconds: 100),
        gap: 8,
        activeColor: defWhite,
        iconSize: 24,
        backgroundColor: defBlack1,
        tabBackgroundColor: defblue2,
        tabMargin: EdgeInsets.only(left: 3, right: 3, top: 4, bottom: 4),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        onTabChange: (value) {
          isMenuActive = value;
          setState(() {});
        },
        tabs: const [
          GButton(
            icon: Icons.home_rounded,
            text: 'Dashboard',
          ),
          GButton(
            icon: Icons.card_giftcard_rounded,
            text: 'Saldo',
          ),
          GButton(
            icon: Icons.receipt_long_rounded,
            text: 'Transaksi',
          ),
          GButton(
            icon: Icons.person_rounded,
            text: 'Akun',
          )
        ]);
  }
}
