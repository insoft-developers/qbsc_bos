import 'package:qbsc_saas/app/data/api_provider.dart';

class ApiEndpoint {
  // Auth
  static const apiPrefix = "/bos";

  static const String login = "$apiPrefix/login";
  static const String absensi = "$apiPrefix/absensi";
  static const String satpamList = "$apiPrefix/satpam";

  static const String patroli = "$apiPrefix/patroli";
  static const String locationList = "$apiPrefix/lokasi";
  static const String kandangList = "$apiPrefix/kandang";
  static const String kandangSuhu = "$apiPrefix/kandang_suhu";
  static const String kandangKipas = "$apiPrefix/kandang_kipas";
  static const String kandangAlarm = "$apiPrefix/kandang_alarm";
  static const String kandangLampu = "$apiPrefix/kandang_lampu";
  static const String doc = "$apiPrefix/doc";
  static const String ekspedisi = "$apiPrefix/ekspedisi";
  static const String broadcast = "$apiPrefix/broadcast";
  static const String broadcastAdd = "$apiPrefix/broadcast_add";
  static const String broadcastDelete = "$apiPrefix/broadcast_delete";

  static const String laporanSituasi = "$apiPrefix/situasi";
  static const String slider = "$apiPrefix/slider";
  static const String tamu = "$apiPrefix/tamu";
  static const String user = "$apiPrefix/user";
  static const String tamuDelete = "$apiPrefix/tamu_delete";
  static const String tamuAdd = "$apiPrefix/tamu_add";
  static const String notifikasi = "$apiPrefix/notifikasi";
  static const String getProfileData = "$apiPrefix/profile";
  static const String updateUserProfile = "$apiPrefix/profile_update";

  static const String webviewResumeKandang =
      "${ApiProvider.rootUrl}/api$apiPrefix/kandang_resume";

  static const String checkPaket = '/check_paket';
  static const String changePassword = "$apiPrefix/user_password_change";
  static const String cardSatpam = "$apiPrefix/card_satpam";
  static const String cekUserArea = "$apiPrefix/check_user_area";
}
