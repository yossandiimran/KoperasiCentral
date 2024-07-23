// ignore_for_file: file_names, prefer_const_constructors, avoid_print
part of '../header.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  NotificationViewState createState() => NotificationViewState();
}

class NotificationViewState extends State<NotificationView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade100,
        appBar: AppBar(
          backgroundColor: defOrange,
          elevation: 0,
          title: Text(
            "Notifikasi",
            style: textStyling.mcLaren(global.getWidth(context) / 20, defWhite),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: defWhite),
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                child: Container(
                  decoration: ui.decCont(defOrange, 20, 20, 0, 0),
                  height: global.getHeight(context) / 3,
                ),
              ),
              Positioned(
                child: Container(
                  decoration: ui.decCont(defWhite, 0, 0, 15, 15),
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  height: global.getHeight(context),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        for (var i = 0; i < 2; i++)
                          ListTile(
                            leading: Icon(Icons.mark_email_read_rounded, color: defBlue),
                            horizontalTitleGap: 0,
                            title: Text(
                              "Acc Pengajuan Pinjaman",
                              style: textStyling.defaultBlackBold(global.getWidth(context) / 28),
                            ),
                            subtitle: Text(
                              "Pengajuan Pinjaman anda disetujui pada tanggal 2$i-08-2024 pukul 09:2$i wib oleh bagian administrasi koperasi terkait.",
                              textAlign: TextAlign.justify,
                              style: textStyling.defaultBlack(global.getWidth(context) / 32),
                            ),
                          ),
                        for (var j = 0; j < 3; j++)
                          ListTile(
                            leading: Icon(Icons.mail_outline_outlined, color: defRed),
                            horizontalTitleGap: 0,
                            title: Text(
                              "Penolakan Pengajuan Pinjaman",
                              style: textStyling.defaultBlackBold(global.getWidth(context) / 28),
                            ),
                            subtitle: Text(
                              "Pengajuan Pinjaman anda ditolak pada tanggal 1$j-08-2024 pukul 09:2$j wib, Alasan : Tidak sesuai ketentuan.",
                              textAlign: TextAlign.justify,
                              style: textStyling.defaultBlack(global.getWidth(context) / 32),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
