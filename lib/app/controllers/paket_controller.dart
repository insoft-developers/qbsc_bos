import 'package:get/get.dart';
import 'package:qbsc_saas/app/data/api_endpoint.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/app_prefs.dart';
import 'package:qbsc_saas/app/utils/snackbar_helper.dart';
import 'package:qbsc_saas/app/views/paket.dart';

class PaketController extends GetxController {
  final ApiProvider api = Get.find<ApiProvider>();

  Future<void> checkPaket() async {
    String comid = AppPrefs.getComId().toString();

    if (comid.isEmpty) {
      SnackbarHelper.error('Error', 'Com id tidak ditemukan');
      return;
    }

    try {
      final response = await api.post(
        ApiEndpoint.checkPaket,
        data: {'comid': comid},
      );

      var body = response.data;
      if (body['success']) {
      } else {
        Get.to(() => Paket());
      }
    } catch (e) {
      // SnackbarHelper.error('Error', 'Offline');
    } finally {}
  }
}
