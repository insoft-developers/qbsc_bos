import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';
import 'package:qbsc_saas/app/data/api_endpoint.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/app_prefs.dart';
import 'package:qbsc_saas/app/utils/snackbar_helper.dart';
import 'package:qbsc_saas/app/views/master/lokasi/lokasi_model.dart';

class LokasiController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final ApiProvider api = Get.find<ApiProvider>();
  var lokasiList = <LokasiModel>[].obs;
  var isLoading = false.obs;
  var isEdit = false.obs;
  String? lokasiId;

  RxString namaLokasi = ''.obs;
  RxString latitude = ''.obs;
  RxString longitude = ''.obs;

  // untuk edit
  final namaLokasiController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();

  bool validateForm() {
    final isValid = formKey.currentState!.validate();
    return isValid;
  }

  Future<void> getDataLokasi() async {
    isLoading.value = true;
    int comid = AppPrefs.getIsUserArea() == '1'
        ? int.parse(AppPrefs.getMonComId() ?? '0')
        : int.parse(AppPrefs.getComId() ?? '0');

    try {
      final response = await api.get(
        ApiEndpoint.masterLokasi,
        query: {'comid': comid},
      );

      var body = response.data;
      if (body['success']) {
        final List<dynamic> listData = body['data'];
        lokasiList.value = listData
            .map((json) => LokasiModel.fromJson(json))
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
        'nama_lokasi': namaLokasi.value,
        'latitude': latitude.value,
        'longitude': longitude.value,
        'comid': comid,
      });

      final response = await api.post(
        ApiEndpoint.masterLokasi,
        data: formData,
        options: dio.Options(contentType: 'multipart/form-data'),
      );

      var body = response.data;

      if (body['success']) {
        getDataLokasi();
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

  void setNamaLokasi(String v) {
    namaLokasi.value = toTitleCase(v);
  }

  void setLatitude(String v) {
    latitude.value = v;
  }

  void setLongitude(String v) {
    longitude.value = v;
  }

  void resetForm() {
    namaLokasi.value = '';
    latitude.value = '';
    longitude.value = '';
    formKey.currentState?.reset();
  }

  void setEditData(LokasiModel data) {
    lokasiId = data.id.toString(); // simpan id untuk update
    namaLokasiController.text = data.namaLokasi;
    latitudeController.text = data.latitude.toString();
    longitudeController.text = data.longitude.toString();
    isEdit(true);
  }

  Future<void> updateData() async {
    if (lokasiId == null) return;

    isLoading.value = true;

    int comid = AppPrefs.getIsUserArea() == '1'
        ? int.parse(AppPrefs.getMonComId() ?? '0')
        : int.parse(AppPrefs.getComId() ?? '0');

    try {
      final formData = dio.FormData.fromMap({
        '_method': 'PATCH',
        'nama_lokasi': namaLokasiController.text,
        'latitude': latitudeController.text,
        'longitude': longitudeController.text,
        'comid': comid,
      });

      final response = await api.post(
        "${ApiEndpoint.masterLokasi}/$lokasiId",
        data: formData,
        options: dio.Options(contentType: 'multipart/form-data'),
      );

      var body = response.data;

      if (body['success']) {
        getDataLokasi();
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
    isLoading.value = true;

    try {
      final response = await api.delete("${ApiEndpoint.masterLokasi}/$id");

      var body = response.data;

      if (body['success']) {
        SnackbarHelper.success('Sukses', 'Data berhasil dihapus');
        getDataLokasi();
      } else {
        SnackbarHelper.error('Warning', body['message'].toString());
      }
    } catch (e) {
      SnackbarHelper.error('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> ubahStatusLokasi(int lokasiId, int stat) async {
    isLoading.value = true;

    try {
      final response = await api.post(
        ApiEndpoint.ubahStatusLokasi,
        data: {"id": lokasiId, "stat": stat},
      );

      var body = response.data;
      if (body['success']) {
        getDataLokasi();
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
