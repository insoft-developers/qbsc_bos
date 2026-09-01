import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/data/api_endpoint.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/app_prefs.dart';
import 'package:qbsc_saas/app/utils/snackbar_helper.dart';

import 'running_text_model.dart';

class RunningTextController extends GetxController {
  final ApiProvider api = Get.find<ApiProvider>();

  final formKey = GlobalKey<FormState>();

  final textController = TextEditingController();

  final isLoading = false.obs;

  final hasData = false.obs;

  RunningTextModel? runningText;

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
    textController.dispose();

    super.onClose();
  }

  // ======================================================
  // GET DATA
  // ======================================================

  Future<void> getData() async {
    try {
      isLoading.value = true;

      final response = await api.get(
        ApiEndpoint.runningText,
        query: {
          'comid': comid,
        },
      );

      final body = response.data;

      if (body['success'] == true) {
        final data = body['data'];

        if (data != null) {
          runningText =
              RunningTextModel.fromJson(data);

          textController.text =
              runningText?.text ?? '';

          hasData.value = true;
        } else {
          runningText = null;
          textController.clear();
          hasData.value = false;
        }
      } else {
        SnackbarHelper.error(
          'Gagal',
          body['message']?.toString() ??
              'Gagal mengambil running text.',
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
  // SAVE / UPDATE
  // ======================================================

  Future<void> saveData() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;

      final response = await api.post(
        ApiEndpoint.runningText,
        data: {
          'text': textController.text.trim(),
          'comid': comid,
        },
      );

      final body = response.data;

      if (body['success'] == true) {
        SnackbarHelper.success(
          'Berhasil',
          hasData.value
              ? 'Running text berhasil diperbarui.'
              : 'Running text berhasil disimpan.',
        );

        await getData();
      } else {
        SnackbarHelper.error(
          'Gagal',
          body['message']?.toString() ??
              'Gagal menyimpan running text.',
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

  Future<void> deleteData() async {
    if (!hasData.value || runningText == null) {
      return;
    }

    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text(
          'Hapus Running Text?',
        ),
        content: const Text(
          'Running text akan dihapus dari perusahaan ini.',
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
        '${ApiEndpoint.runningText}/${runningText!.id}',
      );

      final body = response.data;

      if (body['success'] == true) {
        SnackbarHelper.success(
          'Berhasil',
          'Running text berhasil dihapus.',
        );

        runningText = null;
        textController.clear();
        hasData.value = false;
      } else {
        SnackbarHelper.error(
          'Gagal',
          body['message']?.toString() ??
              'Gagal menghapus running text.',
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
}