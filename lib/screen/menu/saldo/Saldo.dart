// ignore_for_file: file_names, avoid_unnecessary_containers, prefer_const_constructors
part of '../../../header.dart';

class Saldo extends StatefulWidget {
  const Saldo({super.key});
  @override
  SaldoState createState() => SaldoState();
}

class SaldoState extends State<Saldo> {
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
        backgroundColor: Colors.blueGrey.shade50,
        extendBodyBehindAppBar: true,
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
                height: kToolbarHeight * 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
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
          child: Column(
            children: [
              SizedBox(height: kToolbarHeight),
              Center(child: Text("Saldo Kas Anggota", style: textStyling.defaultWhiteBold(20))),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(thickness: 3, color: defOrange),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Spacer(),
                  Container(
                    width: global.getWidth(context) / 2.3,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      image: DecorationImage(image: AssetImage("assets/bgbg2.png"), fit: BoxFit.cover),
                    ),
                    child: ListTile(
                      title: Text(
                        "Simpanan Wajib",
                        style: textStyling.defaultWhiteBold(15),
                      ),
                      subtitle: Text(
                        "Rp. 0,00",
                        style: textStyling.nunitoBold(13, defBlack1),
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: global.getWidth(context) / 2.3,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      image: DecorationImage(image: AssetImage("assets/bgbg2.png"), fit: BoxFit.cover),
                    ),
                    child: ListTile(
                      title: Text(
                        "Simpanan Pokok",
                        style: textStyling.defaultWhiteBold(15),
                      ),
                      subtitle: Text(
                        "Rp. 0,00",
                        style: textStyling.nunitoBold(13, defBlack1),
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
              Container(
                child: Text("\n\n\n\nDalam Pengembangan"),
              )
            ],
          ),
        ),
      ],
    );
  }
}
