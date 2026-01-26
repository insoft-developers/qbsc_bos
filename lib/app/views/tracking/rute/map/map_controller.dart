import 'package:get/get.dart';
import 'package:qbsc_saas/app/data/api_endpoint.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/app_prefs.dart';
import 'package:qbsc_saas/app/utils/snackbar_helper.dart';
import 'package:qbsc_saas/app/views/tracking/rute/map/map_model.dart';

class TrackingMapController extends GetxController {
  var isLoading = false.obs;
  var mapList = <TrackingMapModel>[].obs;

  final ApiProvider api = Get.find<ApiProvider>();

  Future<void> fetchData(int absensiId) async {
    isLoading.value = true;
    int comid = AppPrefs.getIsUserArea() == '1'
        ? int.parse(AppPrefs.getMonComId() ?? '0')
        : int.parse(AppPrefs.getComId() ?? '0');

    try {
      final response = await api.post(
        ApiEndpoint.trackingMap,
        data: {'comid': comid, 'id': absensiId},
      );

      final body = response.data;

      if (body['success'] == true) {
        final List<dynamic> listData = body['data'];

        final fetchedData = listData
            .map((json) => TrackingMapModel.fromJson(json))
            .toList();

        mapList.addAll(fetchedData);
      } else {
        SnackbarHelper.error('Warning', 'Data tidak ditemukan');
      }
    } catch (e) {
      SnackbarHelper.error('Warning', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
