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
    fbmessaging.initFirebase(
      context: context,
    );
  }

  checkSplashScreen() async {
    try {
      await preference.initialization();
      var firstLogin = await preference.getData("first_login");
      if (firstLogin != "") {
        if (mounted) Navigator.pushNamed(context, "/login");
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
        backgroundColor: Colors.blueGrey.shade50,
        body: Stack(
          children: [],
        ),
      ),
    );
  }
}
