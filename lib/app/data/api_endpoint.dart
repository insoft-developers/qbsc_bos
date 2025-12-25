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

  static const String absenActive = '/absen_active';
  static const String locationData = '/location_data';
  static const String getDataLocation = '/get_data_location';
  static const String updateLocationCoordinates =
      '/update_location_coordinates';

  static const String checkPaket = '/check_paket';
  static const String emergency = '/darurat';
  static const String getNotifList = '/get_notif_list';
  static const String getProfileData = '/get_profile_data';
  static const String updateSatpamProfile = '/update_satpam_profile';
  static const String changePassword = '/ubah_password_satpam';
}
