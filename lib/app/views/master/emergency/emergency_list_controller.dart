import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:qbsc_saas/app/data/api_endpoint.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/app_prefs.dart';
import 'package:qbsc_saas/app/utils/snackbar_helper.dart';

import 'emergency_list_model.dart';

class EmergencyListController extends GetxController {
  final ApiProvider api = Get.find<ApiProvider>();

  final formKey = GlobalKey<FormState>();

  final emergencyList =
      <EmergencyListModel>[].obs;

  final isLoading = false.obs;

  final isEdit = false.obs;

  String? emergencyId;

  // ======================================================
  // FORM CONTROLLER
  // ======================================================

  final nameController =
      TextEditingController();

  final whatsappController =
      TextEditingController();

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
  // INIT
  // ======================================================

  @override
  void onInit() {
    super.onInit();

    getData();
  }

  @override
  void onClose() {
    nameController.dispose();
    whatsappController.dispose();

    super.onClose();
  }

  // ======================================================
  // GET DATA
  // ======================================================

  Future<void> getData() async {
    try {
      isLoading.value = true;

      final response = await api.get(
        ApiEndpoint.emergencyList,
        query: {
          'comid': comid,
        },
      );

      final body = response.data;

      if (body['success'] == true) {
        final List<dynamic> data =
            body['data'] ?? [];

        emergencyList.value = data
            .map(
              (json) =>
                  EmergencyListModel.fromJson(json),
            )
            .toList();
      } else {
        SnackbarHelper.error(
          'Gagal',
          body['message']?.toString() ??
              'Gagal mengambil data emergency.',
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
  // SAVE
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
        'whatsapp':
            whatsappController.text.trim(),
        'comid': comid,
      });

      final response = await api.post(
        ApiEndpoint.emergencyList,
        data: formData,
        options: dio.Options(
          contentType: 'multipart/form-data',
        ),
      );

      final body = response.data;

      if (body['success'] == true) {
        SnackbarHelper.success(
          'Berhasil',
          'Kontak emergency berhasil ditambahkan.',
        );

        await getData();

        resetForm();

        Get.back();
      } else {
        SnackbarHelper.error(
          'Gagal',
          body['message']?.toString() ??
              'Gagal menyimpan kontak emergency.',
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

  void setEditData(
    EmergencyListModel data,
  ) {
    emergencyId = data.id.toString();

    nameController.text = data.name;
    whatsappController.text = data.whatsapp;

    isEdit.value = true;
  }

  // ======================================================
  // UPDATE
  // ======================================================

  Future<void> updateData() async {
    if (emergencyId == null) {
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
        'whatsapp':
            whatsappController.text.trim(),
        'comid': comid,
      });

      final response = await api.post(
        '${ApiEndpoint.emergencyList}/$emergencyId',
        data: formData,
        options: dio.Options(
          contentType: 'multipart/form-data',
        ),
      );

      final body = response.data;

      if (body['success'] == true) {
        SnackbarHelper.success(
          'Berhasil',
          'Kontak emergency berhasil diperbarui.',
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
          'Hapus Kontak?',
        ),
        content: const Text(
          'Kontak emergency ini akan dihapus.',
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
        '${ApiEndpoint.emergencyList}/$id',
      );

      final body = response.data;

      if (body['success'] == true) {
        SnackbarHelper.success(
          'Berhasil',
          'Kontak emergency berhasil dihapus.',
        );

        await getData();
      } else {
        SnackbarHelper.error(
          'Gagal',
          body['message']?.toString() ??
              'Gagal menghapus kontak.',
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
  // RESET FORM
  // ======================================================

  void resetForm() {
    emergencyId = null;

    nameController.clear();
    whatsappController.clear();

    isEdit.value = false;

    formKey.currentState?.reset();
  }
}