// ignore_for_file: prefer_const_constructors, file_names

part of '../header.dart';

class Alert {
  alertWarning({required context, required text}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: const EdgeInsets.only(top: 10.0),
          content: SizedBox(
            height: global.getWidth(context) / 3,
            child: Column(
              children: [
                const Spacer(),
                Icon(
                  Icons.warning_amber_rounded,
                  color: defOrange,
                  size: global.getWidth(context) / 8,
                ),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Text(
                    "$text",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: global.getWidth(context) / 20),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }

  alertSuccess({required context, required text}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: const EdgeInsets.only(top: 10.0),
          content: SizedBox(
            height: global.getWidth(context) / 3,
            child: Column(
              children: [
                const Spacer(),
                Icon(
                  Icons.check_circle_outline_rounded,
                  color: defGreen,
                  size: global.getWidth(context) / 8,
                ),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Text(
                    "$text",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: global.getWidth(context) / 20),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }

  loadingAlert({required context, required text, required isPop}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          child: AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
            contentPadding: const EdgeInsets.only(top: 10.0),
            content: Container(
              height: global.getWidth(context) / 3,
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const Spacer(),
                  const CircularProgressIndicator(),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Text(
                      "$text",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: global.getWidth(context) / 20),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
          onWillPop: () => isPop,
        );
      },
    );
  }

  alertConfirmExit(context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: const EdgeInsets.only(top: 10.0),
          content: SizedBox(
            height: global.getWidth(context) / 3,
            child: Column(
              children: [
                Spacer(),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Text(
                    "Keluar dari Aplikasi ?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: global.getWidth(context) / 20),
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    Spacer(),
                    GestureDetector(
                      onTap: () => exit(0),
                      child: Container(
                        decoration: widget.decCont2(defRed, 10, 10, 10, 10),
                        padding: EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
                        child: Text("   Ya   ", style: textStyling.customColor(14, defWhite)),
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        decoration: widget.decCont2(defBlue, 10, 10, 10, 10),
                        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                        child: Text("Tidak", style: textStyling.customColor(14, defWhite)),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }

  alertLogout(context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: const EdgeInsets.only(top: 10.0),
          content: SizedBox(
            height: global.getWidth(context) / 3,
            child: Column(
              children: [
                Spacer(),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Text(
                    "Keluar dari akun anda ?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: global.getWidth(context) / 20),
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    Spacer(),
                    GestureDetector(
                      onTap: () async {
                        preference.clearPreference();
                        Navigator.pushReplacementNamed(context, '/');
                        // await SapLogoutService(context: context).sapCall();
                      },
                      child: Container(
                        decoration: widget.decCont2(defRed, 10, 10, 10, 10),
                        padding: EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
                        child: Text("   Ya   ", style: textStyling.customColor(14, defWhite)),
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        decoration: widget.decCont2(defBlue, 10, 10, 10, 10),
                        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                        child: Text("Tidak", style: textStyling.customColor(14, defWhite)),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }
}
