import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:qbsc_saas/app/data/api_endpoint.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/app_prefs.dart';
import 'package:qbsc_saas/app/utils/snackbar_helper.dart';
import 'package:qbsc_saas/app/views/master/jadwal_patroli/detail/jadwal_patroli_detail_model.dart';
import 'package:qbsc_saas/app/views/patroli/lokasi_model.dart';

class JadwalPatroliDetailController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final ApiProvider api = Get.find<ApiProvider>();

  // =========================================================
  // DATA DETAIL
  // =========================================================

  final jadwalPatroliDetailList = <JadwalPatroliDetailModel>[].obs;

  final locationList = <LokasiModel>[].obs;

  // =========================================================
  // LOADING
  // =========================================================

  final isLoading = false.obs;

  final isLocationLoading = false.obs;

  // =========================================================
  // FORM
  // =========================================================

  final jadwalId = 0.obs;

  final locationId = 0.obs;

  final urutan = 0.obs;

  final jamAwal = ''.obs;

  final jamAkhir = ''.obs;

  // =========================================================
  // EDIT
  // =========================================================

  final isEdit = false.obs;

  String? jadwalDetailId;

  // =========================================================
  // CONTROLLER INPUT URUTAN
  // =========================================================

  final TextEditingController urutanController = TextEditingController();

  // =========================================================
  // COMID
  // =========================================================

  int get comid {
    return AppPrefs.getIsUserArea() == '1'
        ? int.parse(AppPrefs.getMonComId() ?? '0')
        : int.parse(AppPrefs.getComId() ?? '0');
  }

  // =========================================================
  // VALIDATE
  // =========================================================

  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  // =========================================================
  // SET LOCATION
  // =========================================================

  void setLocation(int? value) {
    locationId.value = value ?? 0;
  }

  // =========================================================
  // SET URUTAN
  // =========================================================

  void setUrutan(String value) {
    final number = int.tryParse(value.trim());

    urutan.value = number ?? 0;
  }

  // =========================================================
  // PILIH JAM AWAL
  // =========================================================

  Future<void> pilihJamAwal(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    jamAwal.value =
        '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}:00';
  }

  // =========================================================
  // PILIH JAM AKHIR
  // =========================================================

  Future<void> pilihJamAkhir(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    jamAkhir.value =
        '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}:00';
  }

  // =========================================================
  // RESET FORM
  // =========================================================

  void resetForm() {
    jadwalId.value = 0;

    locationId.value = 0;

    urutan.value = 0;

    jamAwal.value = '';

    jamAkhir.value = '';

    isEdit.value = false;

    jadwalDetailId = null;

    urutanController.clear();
  }

  // =========================================================
  // GET JADWAL DETAIL
  // =========================================================

  Future<void> getJadwalDetail(int id) async {
    jadwalId.value = id;
    try {
      isLoading.value = true;

      final response = await api.post(
        ApiEndpoint.jadwalPatroliDetail,
        data: {'comid': comid, 'id': id},
      );

      final body = response.data;

      if (body['success'] == true) {
        final List<dynamic> listData = body['data'] ?? [];

        jadwalPatroliDetailList.value = listData
            .map((json) => JadwalPatroliDetailModel.fromJson(json))
            .toList();
      } else {
        jadwalPatroliDetailList.clear();
      }
    } catch (e) {
      jadwalPatroliDetailList.clear();

      SnackbarHelper.error('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // =========================================================
  // GET LOCATION
  // =========================================================

  Future<void> getLocation() async {
    try {
      isLocationLoading.value = true;

      final response = await api.post(
        ApiEndpoint.locationList,
        data: {'comid': comid},
      );

      final body = response.data;

      if (body['success'] == true) {
        final List<dynamic> listData = body['data'] ?? [];

        locationList.value = listData
            .map((json) => LokasiModel.fromJson(json))
            .toList();
      } else {
        locationList.clear();
      }
    } catch (e) {
      locationList.clear();

      SnackbarHelper.error('Error', e.toString());
    } finally {
      isLocationLoading.value = false;
    }
  }

  // =========================================================
  // PREPARE ADD
  //
  // ADD:
  // Urutan otomatis = urutan terbesar + 1
  // =========================================================

  Future<void> prepareAddData(int id) async {
    resetForm();

    jadwalId.value = id;

    await getLocation();

    await getJadwalDetail(id);

    int maxUrutan = 0;

    for (final item in jadwalPatroliDetailList) {
      final currentUrutan = int.tryParse(item.urutan.toString()) ?? 0;

      if (currentUrutan > maxUrutan) {
        maxUrutan = currentUrutan;
      }
    }

    urutan.value = maxUrutan + 1;

    // Untuk ADD, tampilkan urutan
    // otomatis di TextField jika UI menggunakan
    // urutanController.
    urutanController.text = urutan.value.toString();

    debugPrint('JADWAL ID : ${jadwalId.value}');

    debugPrint('DETAIL COUNT : ${jadwalPatroliDetailList.length}');

    debugPrint('URUTAN BARU : ${urutan.value}');
  }

  // =========================================================
  // PREPARE EDIT
  //
  // EDIT:
  // Urutan mengambil data lama
  // dan BOLEH diubah user.
  // =========================================================

  Future<void> setEditData(JadwalPatroliDetailModel data) async {
    isEdit.value = true;

    jadwalDetailId = data.id.toString();

    jadwalId.value = int.tryParse(data.patroliId.toString()) ?? 0;

    locationId.value = int.tryParse(data.locationId.toString()) ?? 0;

    urutan.value = int.tryParse(data.urutan.toString()) ?? 1;

    // Masukkan urutan lama ke TextField
    urutanController.text = urutan.value.toString();

    jamAwal.value = data.jamAwal.toString();

    jamAkhir.value = data.jamAkhir.toString();

    // Pastikan pilihan lokasi tersedia
    await getLocation();

    debugPrint('EDIT DETAIL ID : $jadwalDetailId');

    debugPrint('JADWAL ID : ${jadwalId.value}');

    debugPrint('LOCATION ID : ${locationId.value}');

    debugPrint('URUTAN LAMA : ${urutan.value}');
  }

  // =========================================================
  // SAVE DATA
  //
  // ADD
  // =========================================================

  Future<void> saveData() async {
    if (!validateForm()) {
      SnackbarHelper.error(
        'Data Belum Lengkap',
        'Silakan lengkapi data terlebih dahulu.',
      );
      return;
    }

    if (jadwalId.value == 0) {
      SnackbarHelper.error('Gagal', 'Jadwal patroli tidak ditemukan.');
      return;
    }

    if (locationId.value == 0) {
      SnackbarHelper.error('Gagal', 'Silakan pilih lokasi patroli.');
      return;
    }

    if (urutan.value <= 0) {
      SnackbarHelper.error('Gagal', 'Urutan patroli belum ditentukan.');
      return;
    }

    if (jamAwal.value.isEmpty) {
      SnackbarHelper.error('Gagal', 'Silakan pilih jam awal.');
      return;
    }

    if (jamAkhir.value.isEmpty) {
      SnackbarHelper.error('Gagal', 'Silakan pilih jam akhir.');
      return;
    }

    try {
      isLoading.value = true;

      final response = await api.post(
        ApiEndpoint.jadwalDetailStore,
        data: {
          'comid': comid,
          'patroli_id': jadwalId.value,
          'location_id': locationId.value,
          'urutan': urutan.value,
          'jam_awal': jamAwal.value,
          'jam_akhir': jamAkhir.value,
        },
      );

      debugPrint(
        'SAVE JADWAL DETAIL RESPONSE: '
        '${response.data}',
      );

      final body = response.data;

      if (body['success'] == true) {
        SnackbarHelper.success(
          'Berhasil',
          body['message'] ?? 'Lokasi patroli berhasil ditambahkan.',
        );

        Get.back(result: true);
      } else {
        SnackbarHelper.error(
          'Gagal',
          body['message'] ?? 'Gagal menyimpan lokasi patroli.',
        );
      }
    } catch (e) {
      debugPrint('SAVE JADWAL DETAIL ERROR: $e');

      SnackbarHelper.error('Gagal', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // =========================================================
  // UPDATE DATA
  //
  // EDIT
  // =========================================================

  Future<void> updateData() async {
    if (!validateForm()) {
      SnackbarHelper.error(
        'Data Belum Lengkap',
        'Silakan lengkapi data terlebih dahulu.',
      );
      return;
    }

    if (jadwalDetailId == null || jadwalDetailId!.isEmpty) {
      SnackbarHelper.error('Gagal', 'ID detail jadwal tidak ditemukan.');
      return;
    }

    if (jadwalId.value == 0) {
      SnackbarHelper.error('Gagal', 'Jadwal patroli tidak ditemukan.');
      return;
    }

    if (locationId.value == 0) {
      SnackbarHelper.error('Gagal', 'Silakan pilih lokasi patroli.');
      return;
    }

    // Ambil urutan TERBARU dari input user
    final newUrutan = int.tryParse(urutanController.text.trim());

    if (newUrutan == null || newUrutan < 1) {
      SnackbarHelper.error('Gagal', 'Urutan harus berupa angka minimal 1.');
      return;
    }

    if (jamAwal.value.isEmpty) {
      SnackbarHelper.error('Gagal', 'Silakan pilih jam awal.');
      return;
    }

    if (jamAkhir.value.isEmpty) {
      SnackbarHelper.error('Gagal', 'Silakan pilih jam akhir.');
      return;
    }

    try {
      isLoading.value = true;

      final response = await api.post(
        ApiEndpoint.jadwalDetailUpdate,
        data: {
          'id': int.parse(jadwalDetailId!),

          'comid': comid,

          'patroli_id': jadwalId.value,

          'location_id': locationId.value,

          // URUTAN HASIL EDIT
          'urutan': newUrutan,

          'jam_awal': jamAwal.value,

          'jam_akhir': jamAkhir.value,
        },
      );

      debugPrint(
        'UPDATE JADWAL DETAIL RESPONSE: '
        '${response.data}',
      );

      final body = response.data;

      if (body['success'] == true) {
        SnackbarHelper.success(
          'Berhasil',
          body['message'] ?? 'Data berhasil diperbarui.',
        );

        // Kembali ke halaman detail
        Get.back(result: true);
      } else {
        SnackbarHelper.error(
          'Gagal',
          body['message'] ?? 'Gagal memperbarui data.',
        );
      }
    } catch (e) {
      debugPrint('UPDATE JADWAL DETAIL ERROR: $e');

      SnackbarHelper.error('Gagal', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteData(String id) async {
    if (id.isEmpty) {
      SnackbarHelper.error('Gagal', 'ID data tidak ditemukan.');
      return;
    }

    if (jadwalId.value == 0) {
      SnackbarHelper.error('Gagal', 'Jadwal patroli tidak ditemukan.');
      return;
    }

    try {
      isLoading.value = true;

      final response = await api.post(
        ApiEndpoint.jadwalDetailDelete,
        data: {
          'id': int.parse(id),
          'comid': comid,
          'patroli_id': jadwalId.value,
        },
      );

      debugPrint(
        'DELETE JADWAL DETAIL RESPONSE: '
        '${response.data}',
      );

      final body = response.data;

      if (body['success'] == true) {
        SnackbarHelper.success(
          'Berhasil',
          body['message'] ?? 'Data berhasil dihapus.',
        );

        // Refresh daftar detail
        await getJadwalDetail(jadwalId.value);
      } else {
        SnackbarHelper.error(
          'Gagal',
          body['message'] ?? 'Gagal menghapus data.',
        );
      }
    } catch (e) {
      debugPrint('DELETE JADWAL DETAIL ERROR: $e');

      SnackbarHelper.error('Gagal', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // =========================================================
  // CLEAR
  // =========================================================

  void clearData() {
    resetForm();
  }

  // =========================================================
  // DISPOSE
  // =========================================================

  @override
  void onClose() {
    urutanController.dispose();

    super.onClose();
  }
}
