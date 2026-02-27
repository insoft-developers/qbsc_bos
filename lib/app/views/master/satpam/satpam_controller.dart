import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';
import 'package:qbsc_saas/app/data/api_endpoint.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/app_prefs.dart';
import 'package:qbsc_saas/app/utils/snackbar_helper.dart';
import 'package:qbsc_saas/app/views/master/satpam/satpam_model.dart';

class SatpamController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final ApiProvider api = Get.find<ApiProvider>();
  var satpamList = <SatpamModel>[].obs;
  var isLoading = false.obs;
  var isEdit = false.obs;
  String? satpamId;

  RxString satpamName = ''.obs;
  RxString whatsapp = ''.obs;
  RxString jabatan = ''.obs;
  RxString password = ''.obs;

  // untuk edit
  final nameController = TextEditingController();
  final whatsappController = TextEditingController();
  final passwordController = TextEditingController();

  Rx<File?> foto = Rx<File?>(null);
  RxString fotoUrl = ''.obs;
  final picker = ImagePicker();

  bool validateForm() {
    final isValid = formKey.currentState!.validate();

    // Foto wajib hanya saat create
    if (!isEdit.value && foto.value == null) {
      SnackbarHelper.error('Gagal', 'Foto wajib diisi');
      return false;
    }

    return isValid;
  }

  Future<void> getDataSatpam() async {
    isLoading.value = true;
    int comid = AppPrefs.getIsUserArea() == '1'
        ? int.parse(AppPrefs.getMonComId() ?? '0')
        : int.parse(AppPrefs.getComId() ?? '0');

    try {
      final response = await api.get(
        ApiEndpoint.masterSatpam,
        query: {'comid': comid},
      );

      var body = response.data;
      if (body['success']) {
        final List<dynamic> listData = body['data'];
        satpamList.value = listData
            .map((json) => SatpamModel.fromJson(json))
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
        'name': satpamName.value,
        'whatsapp': whatsapp.value,
        'password': password.value,
        'comid': comid,
        'is_danru': jabatan.value,
        if (foto.value != null)
          'foto': await dio.MultipartFile.fromFile(
            foto.value!.path,
            filename: foto.value!.path.split('/').last,
          ),
      });

      final response = await api.post(
        ApiEndpoint.masterSatpam,
        data: formData,
        options: dio.Options(contentType: 'multipart/form-data'),
      );

      var body = response.data;

      if (body['success']) {
        getDataSatpam();
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

  void setName(String v) {
    satpamName.value = toTitleCase(v);
  }

  void setWhatsapp(String v) {
    whatsapp.value = toTitleCase(v);
  }

  void setPassword(String v) {
    password.value = v;
  }

  void setJabatan(String? value) {
    if (value != null) {
      jabatan.value = value;
      debugPrint("jabatan: ${jabatan.toString()}");
    }
  }

  void resetForm() {
    foto.value = null;
    satpamName.value = '';
    whatsapp.value = '';
    password.value = '';
    jabatan.value = '';
    formKey.currentState?.reset();
  }

  void setEditData(SatpamModel data) {
    satpamId = data.id.toString(); // simpan id untuk update
    nameController.text = data.name;
    whatsappController.text = data.whatsapp;
    jabatan.value = data.isDanru ? "1" : "0";
    fotoUrl.value = data.foto ?? ''; // URL dari API
    foto.value = null; // reset file baru
    isEdit(true);

    debugPrint("jabatan di data ${data.isDanru}");
  }

  Future<void> updateData() async {
    if (satpamId == null) return;

    isLoading.value = true;

    int comid = AppPrefs.getIsUserArea() == '1'
        ? int.parse(AppPrefs.getMonComId() ?? '0')
        : int.parse(AppPrefs.getComId() ?? '0');

    try {
      final formData = dio.FormData.fromMap({
        '_method': 'PATCH',
        'name': nameController.text,
        'whatsapp': whatsappController.text,
        'comid': comid,
        'is_danru': jabatan.value,

        // password hanya kirim kalau diisi
        if (passwordController.text.isNotEmpty)
          'password': passwordController.text,

        // foto hanya kirim kalau ada file baru
        if (foto.value != null)
          'foto': await dio.MultipartFile.fromFile(
            foto.value!.path,
            filename: foto.value!.path.split('/').last,
          ),
      });

      final response = await api.post(
        "${ApiEndpoint.masterSatpam}/$satpamId",
        data: formData,
        options: dio.Options(contentType: 'multipart/form-data'),
      );

      var body = response.data;

      if (body['success']) {
        getDataSatpam();
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
      final response = await api.delete("${ApiEndpoint.masterSatpam}/$id");

      var body = response.data;

      if (body['success']) {
        SnackbarHelper.success('Sukses', 'Data berhasil dihapus');
        getDataSatpam();
      } else {
        SnackbarHelper.error('Warning', body['message'].toString());
      }
    } catch (e) {
      SnackbarHelper.error('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> ubahStatusSatpam(int satpamId, int stat) async {
    isLoading.value = true;

    try {
      final response = await api.post(
        ApiEndpoint.ubahStatusSatpam,
        data: {"id": satpamId, "stat": stat},
      );

      var body = response.data;
      if (body['success']) {
        getDataSatpam();
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
