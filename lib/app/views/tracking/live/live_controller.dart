import 'dart:async';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:qbsc_saas/app/data/api_endpoint.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/app_prefs.dart';
import 'package:qbsc_saas/app/utils/snackbar_helper.dart';
import 'package:qbsc_saas/app/views/tracking/live/live_map_model.dart';

class LiveMapController extends GetxController {
  final isLoading = true.obs;

  final satpamMarkers = <int, LatLng>{}.obs;
  final satpamNames = <int, String>{}.obs;

  final patrolMarkers = <LatLng>[].obs;
  final polylines = <int, List<LatLng>>{}.obs;

  final ApiProvider api = Get.find<ApiProvider>();
  Timer? timer;

  late int _comid;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  // ================= INIT =================
  Future<void> fetchData() async {
    _comid = AppPrefs.getIsUserArea() == '1'
        ? int.parse(AppPrefs.getMonComId() ?? '0')
        : int.parse(AppPrefs.getComId() ?? '0');

    isLoading.value = true;

    try {
      final response = await api.post(
        ApiEndpoint.liveTracking,
        data: {'comid': _comid},
      );

      final body = response.data;

      if (body['success'] != true) {
        SnackbarHelper.error('Warning', 'Data tidak ditemukan');
        return;
      }

      _processInitialData(body['data']);
      startLiveTracking();
    } catch (e) {
      SnackbarHelper.error('Warning', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ================= PROCESS INIT =================
  void _processInitialData(List<dynamic> data) {
    satpamMarkers.clear();
    patrolMarkers.clear();
    polylines.clear();

    for (var json in data) {
      final item = LiveMapModel.fromJson(json);
      final latlng = LatLng(item.latitude, item.longitude);

      if (item.type == 'satpam') {
        satpamMarkers[item.id] = latlng;
        polylines[item.id] = [latlng];
        satpamNames[item.id] = item.name;
      } else if (item.type == 'patroli') {
        patrolMarkers.add(latlng);
      }
    }
  }

  // ================= LIVE UPDATE =================
  void startLiveTracking() {
    timer?.cancel();
    timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _refreshFromApi(),
    );
  }

  Future<void> _refreshFromApi() async {
    try {
      final response = await api.post(
        ApiEndpoint.liveTracking,
        data: {'comid': _comid},
      );

      final List<dynamic> data = response.data['data'];

      for (var json in data) {
        final item = LiveMapModel.fromJson(json);

        if (item.type != 'satpam') continue;

        final latlng = LatLng(item.latitude, item.longitude);

        satpamMarkers[item.id] = latlng;
        satpamNames[item.id] = item.name;

        polylines.putIfAbsent(item.id, () => []);
        polylines[item.id]!.add(latlng);

        if (polylines[item.id]!.length > 100) {
          polylines[item.id]!.removeAt(0);
        }
      }
    } catch (_) {}
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
