// ignore_for_file: file_names, avoid_unnecessary_containers, prefer_const_constructors
part of "../../header.dart";

class Transaksi extends StatefulWidget {
  const Transaksi({super.key});
  @override
  TransaksiState createState() => TransaksiState();
}

class TransaksiState extends State<Transaksi> {
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
        body: Container(
          child: Center(
            child: Text("Transaksi"),
          ),
        ),
      ),
    );
  }
}
