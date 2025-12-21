class ApiEndpoint {
  // Auth
  static const apiPrefix = "/bos";

  static const String login = "$apiPrefix/login";

  static const String register = "/auth/register";
  static const String verifyFace = '/verify_face';
  static const String absenActive = '/absen_active';
  static const String locationData = '/location_data';
  static const String getDataLocation = '/get_data_location';
  static const String updateLocationCoordinates =
      '/update_location_coordinates';

  static const String getListTamu = '/get_list_tamu';
  static const String updateStatusTamu = '/update_status_tamu';
  static const String checkPaket = '/check_paket';
  static const String emergency = '/darurat';
  static const String getNotifList = '/get_notif_list';
  static const String getProfileData = '/get_profile_data';
  static const String updateSatpamProfile = '/update_satpam_profile';
  static const String changePassword = '/ubah_password_satpam';

  // User
  static const String profile = "/user/profile";
  static const String updateProfile = "/user/update";

  // Quiz, Leaderboard, dst (sesuai project kamu)
  static const String leaderboard = "/quiz/leaderboard";
}
