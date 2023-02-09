// ignore_for_file: file_names, prefer_const_constructors

part of '../header.dart';

class ChangePass extends StatefulWidget {
  const ChangePass({Key? key}) : super(key: key);

  @override
  ChangePassState createState() => ChangePassState();
}

class ChangePassState extends State<ChangePass> {
  @override
  void initState() {
    super.initState();
  }

  bool obsText = true;
  TextEditingController rePasswd = TextEditingController();
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
                    height: global.getHeight(context) / 2.3,
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
                                ListTile(
                                  leading: Icon(Icons.menu_book_rounded, size: 40, color: defPurple),
                                  title: Text(
                                    "Selamat Datang di Aplikasi Master Data Graha \n",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(color: defBlack1, fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  "Ini pertama kalinya anda masuk aplikasi Master Data silahkan untuk memasukkan password baru",
                                  textAlign: TextAlign.center,
                                  style: textStyling.customColor(14, defGrey),
                                ),
                                const SizedBox(height: 20),
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
                                TextField(
                                  controller: rePasswd,
                                  obscureText: obsText,
                                  decoration: InputDecoration(
                                    border: const UnderlineInputBorder(),
                                    labelText: 'Re-Password',
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
                                  padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          alert.alertLogout(context);
                                        },
                                        child: Container(
                                          width: global.getWidth(context) / 3,
                                          padding: const EdgeInsets.all(15),
                                          decoration: widget.decorationContainerGradient(defRed, defRed, 20.0),
                                          child: Center(
                                            child: Text("Logout", style: textStyling.defaultWhiteBold(16.0)),
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () async {
                                          var obj = {"password": password.text, "password_confirmation": rePasswd.text};
                                          await LoginService(context: context, objParam: obj).changePass();
                                        },
                                        child: Container(
                                          width: global.getWidth(context) / 3,
                                          padding: const EdgeInsets.all(15),
                                          decoration: widget.decorationContainerGradient(defPurple, defPurple2, 20.0),
                                          child: Center(
                                            child: Text("Simpan", style: textStyling.defaultWhiteBold(16.0)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Spacer(),
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
