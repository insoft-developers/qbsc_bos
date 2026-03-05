import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:qbsc_saas/app/data/api_endpoint.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/app_prefs.dart';
import 'package:qbsc_saas/app/utils/snackbar_helper.dart';
import 'package:qbsc_saas/app/views/master/jadwal_patroli/detail/jadwal_patroli_detail_model.dart';

class JadwalPatroliDetailController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final ApiProvider api = Get.find<ApiProvider>();
  var jadwalPatroliDetailList = <JadwalPatroliDetailModel>[].obs;
  var isLoading = false.obs;
  var isEdit = false.obs;
  String? jadwalDetailId;

  RxInt jadwalId = 0.obs;
  RxInt locationId = 0.obs;
  RxInt urutan = 0.obs;
  RxString jamAwal = ''.obs;
  RxString jamAkhir = ''.obs;

  bool validateForm() {
    final isValid = formKey.currentState!.validate();
    return isValid;
  }

  Future<void> getJadwalDetail(int id) async {
    isLoading.value = true;
    int comid = AppPrefs.getIsUserArea() == '1'
        ? int.parse(AppPrefs.getMonComId() ?? '0')
        : int.parse(AppPrefs.getComId() ?? '0');

    try {
      final response = await api.post(
        ApiEndpoint.jadwalPatroliDetail,
        data: {'comid': comid, "id": id},
      );

      var body = response.data;
      if (body['success']) {
        final List<dynamic> listData = body['data'];
        jadwalPatroliDetailList.value = listData
            .map((json) => JadwalPatroliDetailModel.fromJson(json))
            .toList();
      } else {}
    } catch (e) {
      SnackbarHelper.error('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> saveData() async {
  //   isLoading.value = true;
  //   int comid = AppPrefs.getIsUserArea() == '1'
  //       ? int.parse(AppPrefs.getMonComId() ?? '0')
  //       : int.parse(AppPrefs.getComId() ?? '0');

  //   try {
  //     // ====== Convert ke FormData ======
  //     final formData = dio.FormData.fromMap({
  //       '_method': 'POST',
  //       'name': name.value,
  //       'description': description.value,
  //       'comid': comid,
  //     });

  //     final response = await api.post(
  //       ApiEndpoint.masterJadwal,
  //       data: formData,
  //       options: dio.Options(contentType: 'multipart/form-data'),
  //     );

  //     var body = response.data;

  //     if (body['success']) {
  //       getJadwalDetail();
  //       resetForm();
  //       Get.back();
  //     } else {
  //       SnackbarHelper.error('Warning', body['message'].toString());
  //     }
  //   } catch (e) {
  //     SnackbarHelper.error('Warning', e.toString());
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // String toTitleCase(String text) {
  //   if (text.isEmpty) return text;
  //   return text
  //       .split(' ')
  //       .map((word) {
  //         if (word.isEmpty) return word;
  //         return word[0].toUpperCase() + word.substring(1).toLowerCase();
  //       })
  //       .join(' ');
  // }

  // void setNamaJadwal(String v) {
  //   name.value = toTitleCase(v);
  // }

  // void setDescription(String v) {
  //   description.value = toTitleCase(v);
  // }

  // void resetForm() {
  //   name.value = '';
  //   description.value = '';

  //   formKey.currentState?.reset();
  // }

  // void setEditData(JadwalPatroliDetailModel data) {
  //   jadwalDetailId = data.id.toString(); // simpan id untuk update
  //   nameController.text = data.name;
  //   descriptionController.text = data.description ?? '';

  //   isEdit(true);
  // }

  // Future<void> updateData() async {
  //   if (jadwalDetailId == null) return;

  //   isLoading.value = true;

  //   int comid = AppPrefs.getIsUserArea() == '1'
  //       ? int.parse(AppPrefs.getMonComId() ?? '0')
  //       : int.parse(AppPrefs.getComId() ?? '0');

  //   try {
  //     final formData = dio.FormData.fromMap({
  //       '_method': 'PATCH',
  //       'name': nameController.text,
  //       'description': descriptionController.text,
  //       'comid': comid,
  //     });

  //     final response = await api.post(
  //       "${ApiEndpoint.masterJadwal}/$jadwalDetailId",
  //       data: formData,
  //       options: dio.Options(contentType: 'multipart/form-data'),
  //     );

  //     var body = response.data;

  //     if (body['success']) {
  //       getJadwalDetail();
  //       resetForm();
  //       Get.back();
  //     } else {
  //       SnackbarHelper.error('Warning', body['message'].toString());
  //     }
  //   } catch (e) {
  //     SnackbarHelper.error('Error', e.toString());
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // Future<void> deleteData(String id) async {
  //   int comid = AppPrefs.getIsUserArea() == '1'
  //       ? int.parse(AppPrefs.getMonComId() ?? '0')
  //       : int.parse(AppPrefs.getComId() ?? '0');
  //   isLoading.value = true;

  //   try {
  //     final response = await api.delete(
  //       "${ApiEndpoint.masterJadwal}/$id",
  //       query: {'comid': comid},
  //     );

  //     var body = response.data;

  //     if (body['success']) {
  //       SnackbarHelper.success('Sukses', 'Data berhasil dihapus');
  //       getJadwalDetail();
  //     } else {
  //       SnackbarHelper.error('Warning', body['message'].toString());
  //     }
  //   } catch (e) {
  //     SnackbarHelper.error('Error', e.toString());
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // Future<void> ubahStatusJadwal(int jadwalDetailId, int stat) async {
  //   int comid = AppPrefs.getIsUserArea() == '1'
  //       ? int.parse(AppPrefs.getMonComId() ?? '0')
  //       : int.parse(AppPrefs.getComId() ?? '0');

  //   isLoading.value = true;

  //   try {
  //     final response = await api.post(
  //       ApiEndpoint.ubahStatusJadwal,
  //       data: {"id": jadwalDetailId, "stat": stat, "comid": comid},
  //     );

  //     var body = response.data;
  //     if (body['success']) {
  //       getJadwalDetail();
  //     } else {
  //       SnackbarHelper.error('Error', body['message'].toString());
  //     }
  //   } catch (e) {
  //     SnackbarHelper.error('Error', e.toString());
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
}
