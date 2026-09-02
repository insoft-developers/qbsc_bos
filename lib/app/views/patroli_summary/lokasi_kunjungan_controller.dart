import 'package:get/get.dart';
import 'package:qbsc_saas/app/data/api_endpoint.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/app_prefs.dart';
import 'package:qbsc_saas/app/utils/snackbar_helper.dart';
import 'lokasi_kunjungan_model.dart';

class LokasiKunjunganController extends GetxController {
  final ApiProvider api = Get.find<ApiProvider>();

  // =========================
  // DATA
  // =========================

  var lokasiList = <LokasiKunjunganModel>[].obs;

  var isLoading = false.obs;

  var isMoreDataAvailable = true.obs;

  // =========================
  // FILTER
  // =========================

  var startDate = Rxn<String>();
  var endDate = Rxn<String>();

  // =========================
  // PAGINATION
  // =========================

  int _page = 1;

  final int _limit = 20;

  @override
  void onInit() {
    super.onInit();

    setDefaultFilter();

    fetchLokasiKunjungan();
  }

  // =========================
  // DEFAULT FILTER
  // =========================

  void setDefaultFilter() {
    final now = DateTime.now();

    final start = DateTime(
      now.year,
      now.month,
      now.day,
      0,
      0,
      0,
    );

    final end = DateTime(
      now.year,
      now.month,
      now.day,
      23,
      59,
      59,
    );

    startDate.value = _formatDateTime(start);
    endDate.value = _formatDateTime(end);
  }

  // =========================
  // COMID
  // =========================

  int getComid() {
    return AppPrefs.getIsUserArea() == '1'
        ? int.parse(
            AppPrefs.getMonComId() ?? '0',
          )
        : int.parse(
            AppPrefs.getComId() ?? '0',
          );
  }

  // =========================
  // FETCH
  // =========================

  Future<void> fetchLokasiKunjungan({
    bool loadMore = false,
  }) async {
    if (isLoading.value) return;

    if (!loadMore) {
      _page = 1;

      lokasiList.clear();

      isMoreDataAvailable.value = true;
    }

    if (!isMoreDataAvailable.value) return;

    isLoading.value = true;

    try {
      final response = await api.post(
        ApiEndpoint.lokasiKunjungan,
        data: {
          'comid': getComid(),

          'page': _page,

          'limit': _limit,

          'start_datetime':
              startDate.value,

          'end_datetime':
              endDate.value,
        },
      );

      final body = response.data;

      if (body['success'] == true) {
        final pagination = body['data'];

        final List<dynamic> listData =
            pagination['data'] ?? [];

        final int currentPage =
            pagination['current_page'] ?? _page;

        final int lastPage =
            pagination['last_page'] ?? _page;

        final fetchedData = listData
            .map(
              (json) =>
                  LokasiKunjunganModel.fromJson(
                json,
              ),
            )
            .toList();

        lokasiList.addAll(fetchedData);

        // =========================
        // PAGINATION
        // =========================

        if (currentPage >= lastPage) {
          isMoreDataAvailable.value = false;
        } else {
          _page++;
        }
      } else {
        SnackbarHelper.error(
          'Warning',
          body['message'] ??
              'Data tidak ditemukan',
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

  // =========================
  // APPLY FILTER
  // =========================

  Future<void> applyFilter({
    required DateTime start,
    required DateTime end,
  }) async {
    startDate.value =
        _formatDateTime(start);

    endDate.value =
        _formatDateTime(end);

    _page = 1;

    lokasiList.clear();

    isMoreDataAvailable.value = true;

    await fetchLokasiKunjungan();
  }

  // =========================
  // RESET FILTER
  // =========================

  Future<void> resetFilter() async {
    setDefaultFilter();

    _page = 1;

    lokasiList.clear();

    isMoreDataAvailable.value = true;

    await fetchLokasiKunjungan();
  }

  // =========================
  // LOAD MORE
  // =========================

  void loadMore() {
    if (!isLoading.value &&
        isMoreDataAvailable.value) {
      fetchLokasiKunjungan(
        loadMore: true,
      );
    }
  }

  // =========================
  // REFRESH
  // =========================

  Future<void> refreshData() async {
    await fetchLokasiKunjungan();
  }

  // =========================
  // FORMAT DATETIME API
  // =========================

  String _formatDateTime(DateTime date) {
    final year =
        date.year.toString().padLeft(4, '0');

    final month =
        date.month.toString().padLeft(2, '0');

    final day =
        date.day.toString().padLeft(2, '0');

    final hour =
        date.hour.toString().padLeft(2, '0');

    final minute =
        date.minute.toString().padLeft(2, '0');

    final second =
        date.second.toString().padLeft(2, '0');

    return '$year-$month-$day '
        '$hour:$minute:$second';
  }

  // =========================
  // FORMAT DATETIME DISPLAY
  // =========================

  String formatDisplay(String? value) {
    if (value == null || value.isEmpty) {
      return '-';
    }

    try {
      final date =
          DateTime.parse(value);

      final day =
          date.day.toString().padLeft(2, '0');

      final month =
          date.month.toString().padLeft(2, '0');

      final year =
          date.year.toString();

      final hour =
          date.hour.toString().padLeft(2, '0');

      final minute =
          date.minute.toString().padLeft(2, '0');

      return '$day/$month/$year '
          '$hour:$minute';
    } catch (e) {
      return value;
    }
  }
}