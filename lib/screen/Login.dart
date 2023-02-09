// ignore_for_file: file_names, prefer_const_constructors, avoid_print

part of '../header.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
    checkLogin();
    fbmessaging.initFirebase(
      context: context,
    );
  }

  checkLogin() async {
    try {
      await preference.initialization();
      var email = await preference.getData("email");
      var firstLogin = await preference.getData("first_login");
      if (email != null) {
        if (firstLogin == "") {
          if (mounted) Navigator.pushNamed(context, "/changePass");
        } else {
          if (mounted) Navigator.pushNamed(context, "/home");
        }
      }
    } catch (err) {
      // print(err);
    }
  }

  bool obsText = true;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
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
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 80, left: 50, right: 50),
                    height: global.getHeight(context) / 1.5,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [defPurple, defPurple2, defPurple2],
                      ),
                    ),
                    child: Column(
                      children: [
                        Spacer(),
                        Row(
                          children: [
                            Spacer(),
                            Icon(Icons.menu_book_rounded, size: 50, color: Colors.blueGrey.shade50),
                            Text(
                              " Master Data",
                              textAlign: TextAlign.center,
                              style: textStyling.customColorBold(33, Colors.blueGrey.shade50),
                            ),
                            Spacer(),
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          width: global.getWidth(context) / 1,
                          height: 3,
                          color: Colors.blueGrey.shade50,
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Spacer(),
                            Text(
                              "Online Master Data Mobile Application",
                              textAlign: TextAlign.center,
                              style: textStyling.customColor(13, Colors.blueGrey.shade50),
                            ),
                            Spacer(),
                          ],
                        ),
                        Spacer(),
                        Spacer(),
                        Spacer(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              bottom: kToolbarHeight / 2,
              left: 0,
              right: 0,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Spacer(),
                        Container(
                          margin: const EdgeInsets.all(20),
                          padding: const EdgeInsets.all(20),
                          decoration: widget.decorationContainer1(Colors.white, 20.0),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Sign In",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(color: defBlack1, fontSize: 25, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: email,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Username / E-Mail',
                                    labelStyle: TextStyle(fontSize: 15),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextField(
                                  controller: password,
                                  obscureText: obsText,
                                  decoration: InputDecoration(
                                    border: const UnderlineInputBorder(),
                                    labelText: 'Password',
                                    labelStyle: const TextStyle(fontSize: 15),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          !obsText ? obsText = true : obsText = false;
                                        });
                                      },
                                      icon: Icon(!obsText ? Icons.visibility_off : Icons.visibility),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    top: 0,
                                    bottom: 5,
                                  ),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          var obj = {"user": email.text, "pass": password.text};
                                          await LoginService(context: context, objParam: obj).login();
                                        },
                                        child: Container(
                                          width: global.getWidth(context) / 1.5,
                                          padding: const EdgeInsets.all(15),
                                          decoration: widget.decorationContainerGradient(
                                            defPurple,
                                            defPurple2,
                                            20.0,
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Login",
                                              style: textStyling.defaultWhiteBold(18.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: global.getWidth(context),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Version $appVersion",
                                        style: textStyling.customColor(15, Colors.blueGrey.shade400),
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () => alert.alertSuccess(
                                          context: context,
                                          text: "Silahkan Hubungi Admin",
                                        ),
                                        child: Text(
                                          "Lupa Password ?",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: defRed, fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
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
    );
  }
}
