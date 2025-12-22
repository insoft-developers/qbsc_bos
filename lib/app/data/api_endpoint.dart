class ApiEndpoint {
  // Auth
  static const apiPrefix = "/bos";

  static const String login = "$apiPrefix/login";
  static const String absensi = "$apiPrefix/absensi";
  static const String satpamList = "$apiPrefix/satpam";

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
