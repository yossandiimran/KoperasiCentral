import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:koperasi_central/helper/global.dart';
import 'package:http/http.dart' as http;
import 'package:koperasi_central/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';

// Helper
part 'helper/firebaseMessagingHelper.dart';
part 'helper/preference.dart';
part 'widget/Alert.dart';
part 'widget/CustomWidget.dart';
part 'widget/ShimmerWidget.dart';
part 'widget/TextStyling.dart';

// Model ======================================
part 'model/LoginModel.dart';
part 'model/AnggotaModel.dart';

// Service ======================================
part 'service/HandleStatusCode.dart';
part 'service/AuthService.dart';
part 'service/MasterService.dart';
part 'service/PembelianService.dart';
part 'service/PemutakhiranDataService.dart';
part 'service/PengajuanPinjamanService.dart';
part 'service/PengajuanSimpananService.dart';

// Screen / View ======================================
part 'screen/Login.dart';
part 'screen/SplashScreen.dart';
part 'screen/Notification.dart';
part 'screen/Home.dart';
part 'screen/Dashboard.dart';
part 'screen/menu/profile/Profile.dart';
part 'screen/menu/profile/ProfileUser.dart';
part 'screen/menu/saldo/Saldo.dart';
part 'screen/menu/transaksi/TransaksiMain.dart';
part 'screen/menu/transaksi/TransaksiDetail.dart';
part 'screen/menu/katalog/Katalog.dart';
part 'screen/menu/katalog/Keranjang.dart';
part 'screen/menu/katalog/DetailBarang.dart';
part 'screen/menu/katalog/ListOrder.dart';
part 'screen/menu/katalog/ListOrderDetail.dart';
part 'screen/pemutakhiranData/PemutakhiranData.dart';
part 'screen/aggreement/Aggreement.dart';
part 'screen/aggreement/AggreementPdf.dart';
part 'screen/pengajuanPinjaman/PengajuanPinjamanForm.dart';
part 'screen/pengajuanSimpanan/PengajuanSimpananForm.dart';
