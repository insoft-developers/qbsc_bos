import 'package:get/get.dart';
import 'package:qbsc_saas/app/data/api_endpoint.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/app_prefs.dart';
import 'package:qbsc_saas/app/utils/snackbar_helper.dart';
import 'package:qbsc_saas/app/views/paket.dart';
import 'package:qbsc_saas/app/views/user_area/user_area_model.dart';

class PaketController extends GetxController {
  var isLoading = false.obs;
  var isArea = ''.obs;
  var areaList = <UserAreaModel>[].obs;
  var isMobileApp = 0.obs;
  var expiredDate = ''.obs;
  var paketAktif = <String, dynamic>{}.obs;

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
        isMobileApp.value = body['is_mobile_app'];
        expiredDate.value = body['expired_date'];
        paketAktif.value = body['data'];

        if (isMobileApp.value != 1) {
          SnackbarHelper.error(
            'warning',
            'Paket anda tidak mendukung untuk penggunaan Mobile Apps. Silahkan upgrade paket anda.',
          );
          Get.to(() => Paket());
        }
      } else {
        Get.to(() => Paket());
      }
    } catch (e) {
      // SnackbarHelper.error('Error', 'Offline');
    } finally {}
  }

  Future<void> checkUserArea() async {
    isLoading(true);
    String userid = AppPrefs.getUserId().toString();

    if (userid.isEmpty) {
      SnackbarHelper.error('Error', 'User id tidak ditemukan');
      return;
    }

    try {
      final response = await api.post(
        ApiEndpoint.cekUserArea,
        data: {'userid': userid},
      );
      var body = response.data;
      if (body['success']) {
        areaList.value = (response.data['data'] as List)
            .map((e) => UserAreaModel.fromJson(e))
            .toList();
        isArea.value = body['is_area'].toString();
        await AppPrefs.setIsUserArea(isArea.value);
      } else {
        isArea.value = body['is_area'].toString();
        await AppPrefs.setIsUserArea(isArea.value);
        // SnackbarHelper.error('Warning', body['message'].toString());
      }
    } catch (e) {
      // SnackbarHelper.error('Warning', e.toString());
    } finally {
      isLoading(false);
    }
  }

  void refreshData() {
    areaList.clear();
    checkUserArea();
  }
}
