import 'package:get/get.dart';
import 'package:qbsc_saas/app/data/api_endpoint.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';


import 'package:qbsc_saas/app/utils/app_prefs.dart';
import 'package:qbsc_saas/app/utils/snackbar_helper.dart';
import 'package:qbsc_saas/app/views/patroli_summary/detail/lokasi_kunjungan_detail_model.dart';

class LokasiKunjunganDetailController extends GetxController {
  final ApiProvider api = Get.find<ApiProvider>();

  final lokasiId = 0.obs;
  final namaLokasi = ''.obs;
  final qrcode = ''.obs;

  final startDate = ''.obs;
  final endDate = ''.obs;

  final detailList = <LokasiKunjunganDetailModel>[].obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args != null) {
      lokasiId.value = args['location_id'] ?? 0;
      namaLokasi.value = args['nama_lokasi'] ?? '-';
      qrcode.value = args['qrcode'] ?? '-';

      startDate.value = args['start_datetime'] ?? '';
      endDate.value = args['end_datetime'] ?? '';
    }

    fetchDetail();
  }

  int getComid() {
    return AppPrefs.getIsUserArea() == '1'
        ? int.parse(AppPrefs.getMonComId() ?? '0')
        : int.parse(AppPrefs.getComId() ?? '0');
  }

  Future<void> fetchDetail() async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final response = await api.post(
        ApiEndpoint.lokasiKunjunganDetail,
        data: {
          'comid': getComid(),
          'location_id': lokasiId.value,
          'start_datetime': startDate.value,
          'end_datetime': endDate.value,
        },
      );

      final body = response.data;

      if (body['success'] == true) {
        final List<dynamic> data = body['data'] ?? [];

        detailList.assignAll(
          data
              .map(
                (json) =>
                    LokasiKunjunganDetailModel.fromJson(json),
              )
              .toList(),
        );
      } else {
        detailList.clear();

        SnackbarHelper.error(
          'Warning',
          body['message'] ?? 'Data tidak ditemukan',
        );
      }
    } catch (e) {
      SnackbarHelper.error(
        'Warning',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await fetchDetail();
  }

  String formatTanggal(String tanggal) {
    if (tanggal.isEmpty) return '-';

    try {
      final date = DateTime.parse(tanggal);

      const bulan = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ];

      return '${date.day.toString().padLeft(2, '0')} '
          '${bulan[date.month - 1]} '
          '${date.year}';
    } catch (_) {
      return tanggal;
    }
  }

  String formatJam(String jam) {
    if (jam.isEmpty) return '-';

    // API biasanya mengembalikan HH:mm:ss
    if (jam.length >= 5) {
      return jam.substring(0, 5);
    }

    return jam;
  }

  int get totalKunjungan => detailList.length;
}