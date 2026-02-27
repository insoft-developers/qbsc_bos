import 'package:get/get.dart';
import 'package:qbsc_saas/app/data/api_endpoint.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/app_prefs.dart';
import 'package:qbsc_saas/app/utils/snackbar_helper.dart';
import 'package:qbsc_saas/app/views/home/satpam_absensi_model.dart';
import 'package:qbsc_saas/app/views/home/satpam_model.dart';
import 'package:url_launcher/url_launcher.dart';

class CardController extends GetxController {
  var isLoading = false.obs;
  var satpamList = <SatpamModel>[].obs;
  var absensiList = <SatpamAbsensiModel>[].obs;
  var jumlahSatpamAktif = 0.obs;
  var jumlahAbsensi = 0.obs;

  final ApiProvider api = Get.find<ApiProvider>();

  @override
  void onInit() {
    // AppPrefs.setMonComId(AppPrefs.getComId() ?? '0');
    fetchSatpam();

    super.onInit();
  }

  Future<void> fetchSatpam() async {
    satpamList.clear();
    isLoading(true);
    int comid = AppPrefs.getIsUserArea() == '1'
        ? int.parse(AppPrefs.getMonComId() ?? '0')
        : int.parse(AppPrefs.getComId() ?? '0');

    final res = await api.post(ApiEndpoint.cardSatpam, data: {'comid': comid});

    if (res.data['success']) {
      satpamList.value = (res.data['satpams'] as List)
          .map((e) => SatpamModel.fromJson(e))
          .toList();

      jumlahSatpamAktif.value = res.data['active'];
      jumlahAbsensi.value = res.data['absensi_jumlah'];

      absensiList.value = (res.data['absensi'] as List)
          .map((e) => SatpamAbsensiModel.fromJson(e))
          .toList();

      isLoading(false);
    } else {
      SnackbarHelper.error("Opps", "Data tidak ditemukan ");
      isLoading(false);
    }
  }

  void refreshData() {
    fetchSatpam();
  }

  Future<void> openWhatsApp(String phone, String name) async {
    /// ambil angka saja
    String cleaned = phone.replaceAll(RegExp(r'[^0-9]'), '');

    /// ganti 0 -> 62
    if (cleaned.startsWith('0')) {
      cleaned = cleaned.replaceFirst('0', '62');
    }

    final message = Uri.encodeComponent('Pak $name, apakah situasi aman?.');

    final uri = Uri.parse('https://wa.me/$cleaned?text=$message');

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Tidak bisa membuka WhatsApp';
    }
  }

  Future<void> lupaPulang(int id) async {
    isLoading.value = true;

    try {
      final response = await api.post(
        ApiEndpoint.satpamLupaPulang,
        data: {"id": id},
      );

      var body = response.data;
      if (body['success']) {
        fetchSatpam();
      } else {
        SnackbarHelper.error('Error', body['message'].toString());
      }
    } catch (e) {
      SnackbarHelper.error('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
