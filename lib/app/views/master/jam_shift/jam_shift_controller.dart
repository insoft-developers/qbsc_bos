
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:qbsc_saas/app/data/api_endpoint.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/app_prefs.dart';
import 'package:qbsc_saas/app/utils/snackbar_helper.dart';
import 'jam_shift_model.dart';

class JamShiftController extends GetxController {
  final ApiProvider api = Get.find<ApiProvider>();

  final formKey = GlobalKey<FormState>();

  final jamShiftList = <JamShiftModel>[].obs;

  final isLoading = false.obs;

  final isEdit = false.obs;

  String? jamShiftId;

  // ======================================================
  // FORM
  // ======================================================

  final nameController = TextEditingController();

  final jamMasukAwalController =
      TextEditingController();

  final jamMasukController =
      TextEditingController();

  final jamMasukAkhirController =
      TextEditingController();

  final jamPulangAwalController =
      TextEditingController();

  final jamPulangController =
      TextEditingController();

  final jamPulangAkhirController =
      TextEditingController();

  @override
  void onInit() {
    super.onInit();

    getData();
  }

  @override
  void onClose() {
    nameController.dispose();

    jamMasukAwalController.dispose();
    jamMasukController.dispose();
    jamMasukAkhirController.dispose();

    jamPulangAwalController.dispose();
    jamPulangController.dispose();
    jamPulangAkhirController.dispose();

    super.onClose();
  }

  // ======================================================
  // COMPANY ID
  // ======================================================

  int get comid {
    return AppPrefs.getIsUserArea() == '1'
        ? int.parse(
            AppPrefs.getMonComId() ?? '0',
          )
        : int.parse(
            AppPrefs.getComId() ?? '0',
          );
  }

  // ======================================================
  // GET DATA
  // ======================================================

  Future<void> getData() async {
    try {
      isLoading.value = true;

      final response = await api.get(
        ApiEndpoint.jamShift,
        query: {
          'comid': comid,
        },
      );

      final body = response.data;

      if (body['success'] == true) {
        final List<dynamic> data =
            body['data'] ?? [];

        jamShiftList.value = data
            .map(
              (json) =>
                  JamShiftModel.fromJson(json),
            )
            .toList();
      } else {
        SnackbarHelper.error(
          'Gagal',
          body['message']?.toString() ??
              'Gagal mengambil data.',
        );
      }
    } catch (e) {
      SnackbarHelper.error(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ======================================================
  // TAMBAH DATA
  // ======================================================

  Future<void> saveData() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;

      final formData = dio.FormData.fromMap({
        '_method': 'POST',

        'name': nameController.text.trim(),

        'jam_masuk_awal':
            jamMasukAwalController.text.trim(),

        'jam_masuk':
            jamMasukController.text.trim(),

        'jam_masuk_akhir':
            jamMasukAkhirController.text.trim(),

        'jam_pulang_awal':
            jamPulangAwalController.text.trim(),

        'jam_pulang':
            jamPulangController.text.trim(),

        'jam_pulang_akhir':
            jamPulangAkhirController.text.trim(),

        'comid': comid,
      });

      final response = await api.post(
        ApiEndpoint.jamShift,
        data: formData,
        options: dio.Options(
          contentType: 'multipart/form-data',
        ),
      );

      final body = response.data;

      if (body['success'] == true) {
        SnackbarHelper.success(
          'Berhasil',
          'Jam shift berhasil ditambahkan.',
        );

        await getData();

        resetForm();

        Get.back();
      } else {
        SnackbarHelper.error(
          'Gagal',
          body['message']?.toString() ??
              'Gagal menyimpan data.',
        );
      }
    } catch (e) {
      SnackbarHelper.error(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ======================================================
  // SET EDIT
  // ======================================================

  void setEditData(JamShiftModel data) {
    jamShiftId = data.id.toString();

    nameController.text = data.name;

    jamMasukAwalController.text =
        data.jamMasukAwal ?? '';

    jamMasukController.text =
        data.jamMasuk;

    jamMasukAkhirController.text =
        data.jamMasukAkhir ?? '';

    jamPulangAwalController.text =
        data.jamPulangAwal ?? '';

    jamPulangController.text =
        data.jamPulang;

    jamPulangAkhirController.text =
        data.jamPulangAkhir ?? '';

    isEdit.value = true;
  }

  // ======================================================
  // UPDATE
  // ======================================================

  Future<void> updateData() async {
    if (jamShiftId == null) {
      return;
    }

    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;

      final formData = dio.FormData.fromMap({
        '_method': 'PATCH',

        'name': nameController.text.trim(),

        'jam_masuk_awal':
            jamMasukAwalController.text.trim(),

        'jam_masuk':
            jamMasukController.text.trim(),

        'jam_masuk_akhir':
            jamMasukAkhirController.text.trim(),

        'jam_pulang_awal':
            jamPulangAwalController.text.trim(),

        'jam_pulang':
            jamPulangController.text.trim(),

        'jam_pulang_akhir':
            jamPulangAkhirController.text.trim(),

        'comid': comid,
      });

      final response = await api.post(
        '${ApiEndpoint.jamShift}/$jamShiftId',
        data: formData,
        options: dio.Options(
          contentType: 'multipart/form-data',
        ),
      );

      final body = response.data;

      if (body['success'] == true) {
        SnackbarHelper.success(
          'Berhasil',
          'Jam shift berhasil diperbarui.',
        );

        await getData();

        resetForm();

        Get.back();
      } else {
        SnackbarHelper.error(
          'Gagal',
          body['message']?.toString() ??
              'Gagal memperbarui data.',
        );
      }
    } catch (e) {
      SnackbarHelper.error(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ======================================================
  // DELETE
  // ======================================================

  Future<void> deleteData(int id) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text(
          'Hapus Jam Shift?',
        ),
        content: const Text(
          'Data jam shift yang dihapus tidak dapat '
          'dikembalikan.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: false);
            },
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(result: true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm != true) {
      return;
    }

    try {
      isLoading.value = true;

      final response = await api.delete(
        '${ApiEndpoint.jamShift}/$id',
      );

      final body = response.data;

      if (body['success'] == true) {
        SnackbarHelper.success(
          'Berhasil',
          'Jam shift berhasil dihapus.',
        );

        await getData();
      } else {
        SnackbarHelper.error(
          'Gagal',
          body['message']?.toString() ??
              'Gagal menghapus data.',
        );
      }
    } catch (e) {
      SnackbarHelper.error(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ======================================================
  // RESET
  // ======================================================

  void resetForm() {
    jamShiftId = null;

    nameController.clear();

    jamMasukAwalController.clear();
    jamMasukController.clear();
    jamMasukAkhirController.clear();

    jamPulangAwalController.clear();
    jamPulangController.clear();
    jamPulangAkhirController.clear();

    isEdit.value = false;

    formKey.currentState?.reset();
  }
}