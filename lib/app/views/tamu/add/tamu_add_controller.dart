import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qbsc_saas/app/data/api_endpoint.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/app_prefs.dart';
import 'package:qbsc_saas/app/utils/snackbar_helper.dart';

class TamuAddController extends GetxController {
  final RxBool isLoading = false.obs;
  final ApiProvider api = Get.find<ApiProvider>();

  RxString namaTamu = ''.obs;
  RxString jumlahTamu = ''.obs;
  RxString tujuan = ''.obs;
  RxString whatsapp = ''.obs;
  RxString catatan = ''.obs;

  // ===== FOTO =====
  Rx<File?> foto = Rx<File?>(null);
  final picker = ImagePicker();

  final formKey = GlobalKey<FormState>();

  bool validateForm() {
    return formKey.currentState!.validate();
  }

  Future<void> saveData() async {
    isLoading.value = true;
    int comid = AppPrefs.getIsUserArea() == '1'
        ? int.parse(AppPrefs.getMonComId() ?? '0')
        : int.parse(AppPrefs.getComId() ?? '0');
    int userid = int.parse(AppPrefs.getUserId() ?? '0');

    try {
      // ====== Convert ke FormData ======
      final formData = dio.FormData.fromMap({
        'nama_tamu': namaTamu.value,
        'jumlah_tamu': jumlahTamu.value,
        'tujuan': tujuan.value,
        'whatsapp': whatsapp.value,
        'created_by': userid,
        'comid': comid,
        if (foto.value != null)
          'foto': await dio.MultipartFile.fromFile(
            foto.value!.path,
            filename: foto.value!.path.split('/').last,
          ),
      });

      final response = await api.post(
        ApiEndpoint.tamuAdd,
        data: formData,
        options: dio.Options(contentType: 'multipart/form-data'),
      );

      var body = response.data;

      if (body['success']) {
        resetForm();
        SnackbarHelper.success('sukses', 'Sukses Tambah Data');
      } else {
        SnackbarHelper.error('Warning', body['message'].toString());
      }
    } catch (e) {
      SnackbarHelper.error('Warning', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void setNamaTamu(String v) {
    namaTamu.value = toTitleCase(v);
  }

  void setJumlahTamu(String v) {
    jumlahTamu.value = toTitleCase(v);
  }

  void setTujuan(String v) {
    tujuan.value = toTitleCase(v);
  }

  void setWhatsapp(String v) {
    whatsapp.value = v;
  }

  void setCatatan(String v) {
    catatan.value = toTitleCase(v);
  }

  // Foto
  Future pickFoto() async {
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      foto.value = File(img.path);
    }
  }

  Future pickFotoCamera() async {
    final img = await picker.pickImage(source: ImageSource.camera);
    if (img != null) {
      foto.value = File(img.path);
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

  void resetForm() {
    namaTamu.value = '';
    jumlahTamu.value = '';
    tujuan.value = '';
    whatsapp.value = '';
    catatan.value = '';
    foto.value = null;

    formKey.currentState?.reset();
  }
}
