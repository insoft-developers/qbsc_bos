import 'package:get/get.dart';
import 'package:qbsc_saas/app/data/api_endpoint.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/app_prefs.dart';
import 'package:qbsc_saas/app/utils/snackbar_helper.dart';
import 'package:qbsc_saas/app/views/paket.dart';

class HomeController extends GetxController {
  final RxBool isLoading = false.obs;
  RxInt unreadCount = 0.obs;

  final ApiProvider api = Get.find<ApiProvider>();

  @override
  void onInit() {
    super.onInit();
    _initAndLoad();
  }

  void setCount(int count) {
    unreadCount.value = count;
  }

  void increment() {
    unreadCount.value++;
  }

  void clear() {
    unreadCount.value = 0;
  }

  Future<void> _initAndLoad() async {
    await checkPaket();
    // panggil setelah ambil data
  }

  // Fetch dari server

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
