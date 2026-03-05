import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:qbsc_saas/app/data/api_endpoint.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/app_prefs.dart';
import 'package:qbsc_saas/app/utils/snackbar_helper.dart';
import 'package:qbsc_saas/app/views/master/jadwal_patroli/jadwal_patroli_model.dart';

class JadwalPatroliController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final ApiProvider api = Get.find<ApiProvider>();
  var jadwalPatroliList = <JadwalPatroliModel>[].obs;
  var isLoading = false.obs;
  var isEdit = false.obs;
  String? jadwalId;

  RxString name = ''.obs;
  RxString description = ''.obs;

  // untuk edit
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  bool validateForm() {
    final isValid = formKey.currentState!.validate();
    return isValid;
  }

  Future<void> getDataJadwal() async {
    isLoading.value = true;
    int comid = AppPrefs.getIsUserArea() == '1'
        ? int.parse(AppPrefs.getMonComId() ?? '0')
        : int.parse(AppPrefs.getComId() ?? '0');

    try {
      final response = await api.get(
        ApiEndpoint.masterJadwal,
        query: {'comid': comid},
      );

      var body = response.data;
      if (body['success']) {
        final List<dynamic> listData = body['data'];
        jadwalPatroliList.value = listData
            .map((json) => JadwalPatroliModel.fromJson(json))
            .toList();
      } else {}
    } catch (e) {
      SnackbarHelper.error('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveData() async {
    isLoading.value = true;
    int comid = AppPrefs.getIsUserArea() == '1'
        ? int.parse(AppPrefs.getMonComId() ?? '0')
        : int.parse(AppPrefs.getComId() ?? '0');

    try {
      // ====== Convert ke FormData ======
      final formData = dio.FormData.fromMap({
        '_method': 'POST',
        'name': name.value,
        'description': description.value,
        'comid': comid,
      });

      final response = await api.post(
        ApiEndpoint.masterJadwal,
        data: formData,
        options: dio.Options(contentType: 'multipart/form-data'),
      );

      var body = response.data;

      if (body['success']) {
        getDataJadwal();
        resetForm();
        Get.back();
      } else {
        SnackbarHelper.error('Warning', body['message'].toString());
      }
    } catch (e) {
      SnackbarHelper.error('Warning', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  String toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  void setNamaJadwal(String v) {
    name.value = toTitleCase(v);
  }

  void setDescription(String v) {
    description.value = toTitleCase(v);
  }

  void resetForm() {
    name.value = '';
    description.value = '';

    formKey.currentState?.reset();
  }

  void setEditData(JadwalPatroliModel data) {
    jadwalId = data.id.toString(); // simpan id untuk update
    nameController.text = data.name;
    descriptionController.text = data.description ?? '';

    isEdit(true);
  }

  Future<void> updateData() async {
    if (jadwalId == null) return;

    isLoading.value = true;

    int comid = AppPrefs.getIsUserArea() == '1'
        ? int.parse(AppPrefs.getMonComId() ?? '0')
        : int.parse(AppPrefs.getComId() ?? '0');

    try {
      final formData = dio.FormData.fromMap({
        '_method': 'PATCH',
        'name': nameController.text,
        'description': descriptionController.text,
        'comid': comid,
      });

      final response = await api.post(
        "${ApiEndpoint.masterJadwal}/$jadwalId",
        data: formData,
        options: dio.Options(contentType: 'multipart/form-data'),
      );

      var body = response.data;

      if (body['success']) {
        getDataJadwal();
        resetForm();
        Get.back();
      } else {
        SnackbarHelper.error('Warning', body['message'].toString());
      }
    } catch (e) {
      SnackbarHelper.error('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteData(String id) async {
    int comid = AppPrefs.getIsUserArea() == '1'
        ? int.parse(AppPrefs.getMonComId() ?? '0')
        : int.parse(AppPrefs.getComId() ?? '0');
    isLoading.value = true;

    try {
      final response = await api.delete(
        "${ApiEndpoint.masterJadwal}/$id",
        query: {'comid': comid},
      );

      var body = response.data;

      if (body['success']) {
        SnackbarHelper.success('Sukses', 'Data berhasil dihapus');
        getDataJadwal();
      } else {
        SnackbarHelper.error('Warning', body['message'].toString());
      }
    } catch (e) {
      SnackbarHelper.error('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> ubahStatusJadwal(int jadwalId, int stat) async {
    int comid = AppPrefs.getIsUserArea() == '1'
        ? int.parse(AppPrefs.getMonComId() ?? '0')
        : int.parse(AppPrefs.getComId() ?? '0');

    isLoading.value = true;

    try {
      final response = await api.post(
        ApiEndpoint.ubahStatusJadwal,
        data: {"id": jadwalId, "stat": stat, "comid": comid},
      );

      var body = response.data;
      if (body['success']) {
        getDataJadwal();
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
