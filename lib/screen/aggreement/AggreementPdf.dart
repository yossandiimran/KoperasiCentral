// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_key_in_widget_constructors, no_logic_in_create_state, avoid_print, avoid_unnecessary_containers, unnecessary_null_comparison, invalid_use_of_visible_for_testing_member, prefer_interpolation_to_compose_strings, avoid_returning_null_for_void
part of '../../header.dart';

class AggreementPdf extends StatefulWidget {
  final obj;
  const AggreementPdf({Key? key, required this.obj});
  @override
  AggreementPdfState createState() => AggreementPdfState(obj);
}

class AggreementPdfState extends State<AggreementPdf> {
  bool isLoading = true;

  Map data = {};
  late File pFile;
  final obj;

  AggreementPdfState(this.obj);

  @override
  void initState() {
    super.initState();
    getAggreementFile();
  }

  Future<void> getAggreementFile() async {
    MasterService masterService = MasterService(context: context);
    data = await masterService.getUserAggreement(obj["jenis"]);

    var url = global.basePath + 'user-aggrement/${data['data']}';
    createFileOfPdfUrl(url);
    setState(() {});
  }

  Future<File> createFileOfPdfUrl(url) async {
    Completer<File> completer = Completer();
    print("Start download file from internet!");
    try {
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      print("Download files");
      print("${dir.path}/$filename");
      pFile = File("${dir.path}/$filename");
      await pFile.writeAsBytes(bytes, flush: true);
      completer.complete(pFile);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }
    isLoading = false;
    setState(() {});
    print(pFile);
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("User Agreement", style: textStyling.defaultWhiteBold(16)),
          elevation: 0,
          centerTitle: true,
          backgroundColor: defBlack2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
        ),
        backgroundColor: defWhite,
        // backgroundColor: Colors.blueGrey.shade50,
        extendBodyBehindAppBar: true,
        body: getBody(),
      ),
    );
  }

  getBody() => SafeArea(
        child: !isLoading
            ? Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: ui.decCont(defWhite, 10, 10, 10, 10),
                    height: global.getHeight(context) / 1.3,
                    child: Center(
                      child: PDFView(
                        filePath: pFile.path,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          if (obj["jenis"] == 'A') {
                            cek2 = false;
                          } else {
                            cek1 = false;
                          }
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: ui.decCont(
                            defOrange,
                            10,
                            0,
                            10,
                            0,
                          ),
                          padding: EdgeInsets.all(10),
                          child: Text("     Batalkan     ", style: textStyling.defaultWhiteBold(14)),
                        ),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          if (obj["jenis"] == 'A') {
                            cek2 = true;
                          } else {
                            cek1 = true;
                          }
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: ui.decCont(
                            defBlue,
                            0,
                            10,
                            0,
                            10,
                          ),
                          padding: EdgeInsets.all(10),
                          child: Text("          Setuju          ", style: textStyling.defaultWhiteBold(14)),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(height: 15),
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      );

  Future<void> submitAggreement() async {
    if (!cek1 || !cek2) return null;
    MasterService(context: context).postUserAggreement();
  }

  Future<void> openModalSheet() async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: Container(
            padding: EdgeInsets.only(top: 10),
            child: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: ui.decCont(defWhite, 10, 10, 10, 10),
                  height: global.getHeight(context) / 1.3,
                  child: Center(
                    child: PDFView(
                      filePath: pFile.path,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        cek2 = false;
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: ui.decCont(
                          defOrange,
                          10,
                          0,
                          10,
                          0,
                        ),
                        padding: EdgeInsets.all(10),
                        child: Text("     Batalkan     ", style: textStyling.defaultWhiteBold(14)),
                      ),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        cek2 = true;
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: ui.decCont(
                          defBlue,
                          0,
                          10,
                          0,
                          10,
                        ),
                        padding: EdgeInsets.all(10),
                        child: Text("          Setuju          ", style: textStyling.defaultWhiteBold(14)),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }

  // Future<void> openModalSheetPrivacy() async {
  //   return showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     isDismissible: false,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(10.0),
  //         topRight: Radius.circular(10.0),
  //       ),
  //     ),
  //     builder: (BuildContext context) {
  //       return FractionallySizedBox(
  //         heightFactor: 0.9,
  //         child: Container(
  //           padding: EdgeInsets.only(top: 10, left: 25, right: 25),
  //           child: ListView(
  //             physics: BouncingScrollPhysics(),
  //             children: <Widget>[
  //               Divider(thickness: 3),
  //               RichText(
  //                 textAlign: TextAlign.justify,
  //                 text: TextSpan(
  //                   children: [
  //                     TextSpan(
  //                       text: 'Kebijakan Privasi : \n\n',
  //                       style: textStyling.defaultBlackBold(13),
  //                     ),
  //                     TextSpan(
  //                       text:
  //                           'Selamat datang di Aplikasi Koperasi Kami. Aplikasi ini disediakan oleh PT Graha Seribusatu Jaya sebagai alat untuk anggota koperasi kami. Kami sangat menghargai privasi Anda dan berkomitmen untuk melindungi informasi pribadi yang Anda berikan kepada kami. Kebijakan Privasi ini menjelaskan bagaimana kami mengumpulkan, menggunakan, dan melindungi data pribadi Anda.',
  //                       style: textStyling.defaultBlack(13),
  //                     ),
  //                     TextSpan(
  //                       text: '\n\n1. Informasi yang Kami Kumpulkan:',
  //                       style: textStyling.defaultBlackBold(13),
  //                     ),
  //                     TextSpan(
  //                       text: "\n- ",
  //                       style: textStyling.defaultBlackBold(13),
  //                     ),
  //                     TextSpan(
  //                       text:
  //                           'Kami dapat mengumpulkan informasi pribadi seperti nama, alamat email, nomor telepon, dan informasi keuangan yang Anda berikan kepada kami saat mendaftar atau menggunakan aplikasi.',
  //                       style: textStyling.defaultBlack(13),
  //                     ),
  //                     TextSpan(
  //                       text: "\n- ",
  //                       style: textStyling.defaultBlackBold(13),
  //                     ),
  //                     TextSpan(
  //                       text:
  //                           'Kami juga dapat mengumpulkan informasi yang dihasilkan secara otomatis, seperti alamat IP, data perangkat, dan aktivitas pengguna dalam aplikasi.',
  //                       style: textStyling.defaultBlack(13),
  //                     ),
  //                     TextSpan(
  //                       text: '\n\n2. Penggunaan Informasi:',
  //                       style: textStyling.defaultBlackBold(13),
  //                     ),
  //                     TextSpan(
  //                       text: "\n- ",
  //                       style: textStyling.defaultBlackBold(13),
  //                     ),
  //                     TextSpan(
  //                       text:
  //                           'Kami menggunakan informasi pribadi Anda untuk menyediakan layanan koperasi kami, memproses transaksi, memberi Anda akses ke informasi keanggotaan, dan menghubungi Anda terkait layanan kami.',
  //                       style: textStyling.defaultBlack(13),
  //                     ),
  //                     TextSpan(
  //                       text: "\n- ",
  //                       style: textStyling.defaultBlackBold(13),
  //                     ),
  //                     TextSpan(
  //                       text: 'Kami dapat menggunakan informasi anonim untuk tujuan analisis dan perbaikan aplikasi.',
  //                       style: textStyling.defaultBlack(13),
  //                     ),
  //                     TextSpan(
  //                       text: '\n\n3. Berbagi Informasi:',
  //                       style: textStyling.defaultBlackBold(13),
  //                     ),
  //                     TextSpan(
  //                       text: "\n- ",
  //                       style: textStyling.defaultBlackBold(13),
  //                     ),
  //                     TextSpan(
  //                       text:
  //                           'Kami tidak akan menjual, menyewakan, atau menukar informasi pribadi Anda dengan pihak ketiga tanpa izin Anda, kecuali jika diperlukan untuk tujuan layanan koperasi.',
  //                       style: textStyling.defaultBlack(13),
  //                     ),
  //                     TextSpan(
  //                       text: "\n- ",
  //                       style: textStyling.defaultBlackBold(13),
  //                     ),
  //                     TextSpan(
  //                       text:
  //                           'Informasi pribadi Anda dapat dibagikan dengan mitra atau penyedia layanan kami yang membantu kami menyediakan layanan aplikasi.',
  //                       style: textStyling.defaultBlack(13),
  //                     ),
  //                     TextSpan(
  //                       text: '\n\n4. Keamanan:',
  //                       style: textStyling.defaultBlackBold(13),
  //                     ),
  //                     TextSpan(
  //                       text: "\n- ",
  //                       style: textStyling.defaultBlackBold(13),
  //                     ),
  //                     TextSpan(
  //                       text:
  //                           'Kami memiliki langkah-langkah keamanan yang diterapkan untuk melindungi informasi pribadi Anda dari akses yang tidak sah atau pengungkapan.',
  //                       style: textStyling.defaultBlack(13),
  //                     ),
  //                     TextSpan(
  //                       text: '\n\n5. Perubahan pada Kebijakan Privasi:',
  //                       style: textStyling.defaultBlackBold(13),
  //                     ),
  //                     TextSpan(
  //                       text: "\n- ",
  //                       style: textStyling.defaultBlackBold(13),
  //                     ),
  //                     TextSpan(
  //                       text:
  //                           'Kebijakan Privasi ini dapat berubah dari waktu ke waktu. Kami akan memberitahu Anda tentang perubahan signifikan melalui pembaruan di aplikasi kami.',
  //                       style: textStyling.defaultBlack(13),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               SizedBox(height: 10),
  //               Divider(thickness: 3),
  //               SizedBox(height: 10),
  //               RichText(
  //                 textAlign: TextAlign.justify,
  //                 text: TextSpan(
  //                   children: [
  //                     TextSpan(
  //                       text: 'Kebijakan Pengguna (Terms of Service): \n\n',
  //                       style: textStyling.defaultBlackBold(13),
  //                     ),
  //                     TextSpan(
  //                       text: '1. Penggunaan Aplikasi:',
  //                       style: textStyling.defaultBlackBold(13),
  //                     ),
  //                     TextSpan(
  //                       text: "\n- ",
  //                       style: textStyling.defaultBlackBold(13),
  //                     ),
  //                     TextSpan(
  //                       text:
  //                           'Dengan menggunakan aplikasi koperasi kami, Anda setuju untuk mematuhi syarat dan ketentuan dalam Kebijakan Pengguna ini.',
  //                       style: textStyling.defaultBlack(13),
  //                     ),
  //                     TextSpan(
  //                       text: '\n\n2. Akun Pengguna:',
  //                       style: textStyling.defaultBlackBold(13),
  //                     ),
  //                     TextSpan(
  //                       text: "\n- ",
  //                       style: textStyling.defaultBlackBold(13),
  //                     ),
  //                     TextSpan(
  //                       text:
  //                           'Anda bertanggung jawab untuk menjaga keamanan akun pengguna Anda. Anda setuju untuk tidak memberikan akses ke akun Anda kepada orang lain.',
  //                       style: textStyling.defaultBlack(13),
  //                     ),
  //                     TextSpan(
  //                       text: '\n\n3. Keterbatasan Tanggung Jawab:',
  //                       style: textStyling.defaultBlackBold(13),
  //                     ),
  //                     TextSpan(
  //                       text: "\n- ",
  //                       style: textStyling.defaultBlackBold(13),
  //                     ),
  //                     TextSpan(
  //                       text:
  //                           'Kami tidak bertanggung jawab atas kerugian atau kerusakan yang timbul akibat penggunaan atau ketidakmampuan menggunakan aplikasi kami.',
  //                       style: textStyling.defaultBlack(13),
  //                     ),
  //                     TextSpan(
  //                       text: '\n\n4. Pengakhiran Akses:',
  //                       style: textStyling.defaultBlackBold(13),
  //                     ),
  //                     TextSpan(
  //                       text: "\n- ",
  //                       style: textStyling.defaultBlackBold(13),
  //                     ),
  //                     TextSpan(
  //                       text:
  //                           'Kami berhak untuk mengakhiri atau menangguhkan akses Anda ke aplikasi jika Anda melanggar Kebijakan Pengguna ini.',
  //                       style: textStyling.defaultBlack(13),
  //                     ),
  //                     TextSpan(
  //                       text: '\n\n5. Perubahan pada Syarat dan Ketentuan:',
  //                       style: textStyling.defaultBlackBold(13),
  //                     ),
  //                     TextSpan(
  //                       text: "\n- ",
  //                       style: textStyling.defaultBlackBold(13),
  //                     ),
  //                     TextSpan(
  //                       text:
  //                           'Syarat dan Ketentuan ini dapat berubah dari waktu ke waktu. Anda akan diberitahu tentang perubahan signifikan.',
  //                       style: textStyling.defaultBlack(13),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               Divider(thickness: 3),
  //               Row(
  //                 children: [
  //                   Spacer(),
  //                   GestureDetector(
  //                     onTap: () {
  //                       cek1 = false;
  //                       Navigator.pop(context);
  //                     },
  //                     child: Container(
  //                       decoration: ui.decCont(
  //                         defOrange,
  //                         10,
  //                         0,
  //                         10,
  //                         0,
  //                       ),
  //                       padding: EdgeInsets.all(10),
  //                       child: Text("     Batalkan     ", style: textStyling.defaultWhiteBold(14)),
  //                     ),
  //                   ),
  //                   SizedBox(width: 8),
  //                   GestureDetector(
  //                     onTap: () {
  //                       cek1 = true;
  //                       Navigator.pop(context);
  //                     },
  //                     child: Container(
  //                       decoration: ui.decCont(
  //                         defBlue,
  //                         0,
  //                         10,
  //                         0,
  //                         10,
  //                       ),
  //                       padding: EdgeInsets.all(10),
  //                       child: Text("          Setuju          ", style: textStyling.defaultWhiteBold(14)),
  //                     ),
  //                   ),
  //                   Spacer(),
  //                 ],
  //               ),
  //               SizedBox(height: 15),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

}
