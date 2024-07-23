// ignore_for_file: prefer_const_constructors
part of 'main.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => Login());
      case '/mutakhirData':
        return MaterialPageRoute(builder: (_) => PemutakhiranData());

      case '/aggreement':
        return MaterialPageRoute(builder: (_) => Aggreement());
      case '/aggreementPdf':
        return MaterialPageRoute(builder: (_) => AggreementPdf());
      case '/formPengajuanPinjaman':
        return MaterialPageRoute(builder: (_) => PengajuanPinjamanForm());
      case '/formPengajuanSimpanan':
        return MaterialPageRoute(builder: (_) => PengajuanSimpananForm());
      case '/home':
        return MaterialPageRoute(builder: (_) => Home());
      case '/detailTransaksi':
        return MaterialPageRoute(builder: (_) => TransaksiDetail(obj: settings.arguments));
      case '/profileUser':
        return MaterialPageRoute(builder: (_) => ProfileUser());
      case '/keranjangBelanja':
        return MaterialPageRoute(builder: (_) => Keranjang());
      case '/detailBarang':
        return MaterialPageRoute(builder: (_) => DetailBarang(obj: settings.arguments));
      case '/listOrder':
        return MaterialPageRoute(builder: (_) => ListOrder());
      case '/listOrderDetail':
        return MaterialPageRoute(builder: (_) => ListOrderDetail(obj: settings.arguments));
      case '/notification':
        return MaterialPageRoute(builder: (_) => NotificationView());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(child: Text('Error page')),
      );
    });
  }
}
