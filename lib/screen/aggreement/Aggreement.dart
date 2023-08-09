// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_key_in_widget_constructors, no_logic_in_create_state, avoid_print, avoid_unnecessary_containers, unnecessary_null_comparison, invalid_use_of_visible_for_testing_member, prefer_interpolation_to_compose_strings
part of '../../header.dart';

class Aggreement extends StatefulWidget {
  @override
  AggreementState createState() => AggreementState();
}

class AggreementState extends State<Aggreement> {
  bool isLoading = true;
  bool cek1 = false;
  bool cek2 = false;
  Map data = {};
  late File pFile;

  @override
  void initState() {
    super.initState();
    getAggreementFile();
  }

  Future<void> getAggreementFile() async {
    MasterService masterService = MasterService(context: context);
    data = await masterService.getUserAggreement();

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
        alert.alertLogout(context);
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("User Aggreement", style: textStyling.defaultWhite(20)),
          actions: [
            IconButton(
              onPressed: () {
                alert.alertLogout(context);
              },
              icon: Icon(Icons.exit_to_app_rounded, color: defRed),
            ),
          ],
          elevation: 0,
          centerTitle: true,
          backgroundColor: defGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
        ),
        backgroundColor: Colors.blueGrey.shade50,
        extendBodyBehindAppBar: true,
        body: getBody(),
      ),
    );
  }

  getBody() => SafeArea(
        child: !isLoading
            ? Column(
                children: [
                  Container(
                    decoration: widget.decCont(defGrey, 10, 10, 10, 10),
                    margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                    padding: EdgeInsets.all(10),
                    height: global.getHeight(context) / 1.5,
                    child: Center(
                      child: PDFView(
                        filePath: pFile.path,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                    decoration: widget.decCont(defWhite, 10, 10, 10, 10),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            cek1 ? cek1 = false : cek1 = true;
                            setState(() {});
                          },
                          child: ListTile(
                            leading: Icon(
                              cek1 ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                              color: !cek1 ? defRed : defGreen,
                            ),
                            subtitle: Text(
                              "Saya telah menyetujui kebijakan privasi & persetujuan ketentuan penggunaan aplikasi",
                              style: textStyling.nunitoBold(12, defGrey),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            cek2 ? cek2 = false : cek2 = true;
                            setState(() {});
                          },
                          child: ListTile(
                            leading: Icon(
                              cek2 ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                              color: !cek2 ? defRed : defGreen,
                            ),
                            subtitle: Text(
                              "Saya telah menyetujui peraturan dan kebijakan yang dikeluarkan oleh PT Graha Seribusatu jaya",
                              style: textStyling.nunitoBold(12, defGrey),
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        GestureDetector(
                          onTap: () {
                            submitAggreement();
                          },
                          child: Container(
                            decoration: widget.decCont(defGreen, 10, 10, 10, 10),
                            padding: EdgeInsets.all(10),
                            child: Text("   Submit   ", style: textStyling.defaultWhiteBold(14)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      );

  Future<void> submitAggreement() async {
    if (!cek1 || !cek2) return alert.alertWarning(context: context, text: "Periksa kembali kolom isian !");
    MasterService(context: context).postUserAggreement();
  }
}
