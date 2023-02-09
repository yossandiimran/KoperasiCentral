// ignore_for_file: file_names, prefer_const_constructors, avoid_print

part of '../header.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkSplashScreen();
    fbmessaging.initFirebase(context: context);
  }

  checkSplashScreen() async {
    try {
      await preference.initialization();
      var firstLogin = await preference.getData("first_login");
      var name = await preference.getData("name");
      if (firstLogin != null) {
        if (name != null) {
          if (mounted) Navigator.pushNamed(context, "/home");
        } else {
          if (mounted) Navigator.pushNamed(context, "/login");
        }
      }
    } catch (err) {
      // print(err);
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
        resizeToAvoidBottomInset: true,
        backgroundColor: defOrange,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("assets/splash2.png"), fit: BoxFit.cover),
                ),
                height: global.getHeight(context),
                child: Column(
                  children: [
                    Spacer(),
                    Text(
                      "Untuk Karyawan PT. Graha Seribusatujaya",
                      textAlign: TextAlign.center,
                      style: textStyling.defaultWhiteBold(25),
                    ),
                    SizedBox(height: 25),
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Text(
                        "Smart Koperasi Central untuk seluruh karyawan central springbed yang untuk lebih fleksibel dimanapun dan kapanpun",
                        textAlign: TextAlign.center,
                        style: textStyling.nunitoBold(14, defWhite),
                      ),
                    ),
                    SizedBox(height: 40),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Container(
                        width: global.getWidth(context),
                        height: kToolbarHeight,
                        decoration: widget.decCont2(defBlack1, 0, 0, 30, 30),
                        child: Row(
                          children: [
                            Spacer(),
                            Text(
                              "Mulai Sekarang",
                              style: textStyling.defaultWhiteBold(14),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
