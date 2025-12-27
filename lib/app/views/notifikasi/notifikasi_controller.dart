import 'package:get/get.dart';
import 'package:qbsc_saas/app/data/api_endpoint.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/app_prefs.dart';
import 'package:qbsc_saas/app/utils/snackbar_helper.dart';
import 'package:qbsc_saas/app/views/notifikasi/notifikasi_model.dart';

class NotifikasiController extends GetxController {
  var isLoading = false.obs;
  var notifikasiList = <NotifikasiModel>[].obs;
  var isMoreDataAvailable = true.obs;

  final ApiProvider api = Get.find<ApiProvider>();

  int _page = 1;
  final int _limit = 20;

  @override
  void onInit() {
    super.onInit();

    featchNotifikasi();
  }

  // =========================
  // APPLY FILTER (WAJIB DIPAKAI)
  // =========================
  void applyFilter() {
    _page = 1;
    notifikasiList.clear();
    isMoreDataAvailable.value = true;

    featchNotifikasi();
  }

  // =========================
  // CLEAR FILTER
  // =========================
  void clearFilter() {
    _page = 1;
    notifikasiList.clear();
    isMoreDataAvailable.value = true;

    featchNotifikasi();
  }

  Future<void> featchNotifikasi({bool loadMore = false}) async {
    if (isLoading.value) return;

    if (!loadMore) {
      _page = 1;
      notifikasiList.clear();
      isMoreDataAvailable.value = true;
    }

    if (!isMoreDataAvailable.value) return;

    isLoading.value = true;
    int comid = int.parse(AppPrefs.getComId() ?? '0');

    try {
      final response = await api.post(
        ApiEndpoint.notifikasi,
        data: {'comid': comid, 'page': _page, 'limit': _limit},
      );

      final body = response.data;

      if (body['success'] == true) {
        final pagination = body['data'];

        final List<dynamic> listData = pagination['data'];
        final int currentPage = pagination['current_page'];
        final int lastPage = pagination['last_page'];

        final fetchedData = listData
            .map((json) => NotifikasiModel.fromJson(json))
            .toList();

        notifikasiList.addAll(fetchedData);

        // 🔥 STOP INFINITE SCROLL
        if (currentPage >= lastPage) {
          isMoreDataAvailable.value = false;
        } else {
          _page++;
        }
      } else {
        SnackbarHelper.error('Warning', 'Data tidak ditemukan');
      }
    } catch (e) {
      SnackbarHelper.error('Warning', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void refreshData() {
    _page = 1;
    notifikasiList.clear();
    isMoreDataAvailable.value = true;

    featchNotifikasi();
  }
}
