import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qbsc_saas/app/data/api_endpoint.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/app_prefs.dart';
import 'package:qbsc_saas/app/utils/snackbar_helper.dart';
import 'package:qbsc_saas/app/views/master/user/user_model.dart';

class UserController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final ApiProvider api = Get.find<ApiProvider>();
  var userList = <UserModel>[].obs;
  var isLoading = false.obs;
  var isEdit = false.obs;
  String? userId;

  RxString name = ''.obs;
  RxString email = ''.obs;
  RxString whatsapp = ''.obs;
  RxString password = ''.obs;

  // untuk edit
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final whatsappController = TextEditingController();
  final passwordController = TextEditingController();

  Rx<File?> foto = Rx<File?>(null);
  RxString fotoUrl = ''.obs;
  final picker = ImagePicker();

  bool validateForm() {
    final isValid = formKey.currentState!.validate();
    return isValid;
  }

  Future<void> getDataUser() async {
    isLoading.value = true;
    int comid = AppPrefs.getIsUserArea() == '1'
        ? int.parse(AppPrefs.getMonComId() ?? '0')
        : int.parse(AppPrefs.getComId() ?? '0');

    try {
      final response = await api.get(
        ApiEndpoint.masterUser,
        query: {'comid': comid},
      );

      var body = response.data;
      if (body['success']) {
        final List<dynamic> listData = body['data'];
        userList.value = listData
            .map((json) => UserModel.fromJson(json))
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
        'whatsapp': whatsapp.value,
        'email': email.value,
        'password': password.value,
        'comid': comid,

        'is_mobile_admin': 0,
        'is_area': 0,
        if (foto.value != null)
          'profile_image': await dio.MultipartFile.fromFile(
            foto.value!.path,
            filename: foto.value!.path.split('/').last,
          ),
      });

      final response = await api.post(
        ApiEndpoint.masterUser,
        data: formData,
        options: dio.Options(contentType: 'multipart/form-data'),
      );

      var body = response.data;

      if (body['success']) {
        getDataUser();
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
    name.value = toTitleCase(v);
  }

  void setWhatsapp(String v) {
    whatsapp.value = toTitleCase(v);
  }

  void setPassword(String v) {
    password.value = v;
  }

  void setEmail(String v) {
    email.value = v;
  }

  void resetForm() {
    foto.value = null;
    name.value = '';
    whatsapp.value = '';
    password.value = '';
    formKey.currentState?.reset();
  }

  void setEditData(UserModel data) {
    userId = data.id.toString(); // simpan id untuk update
    nameController.text = data.name;
    whatsappController.text = data.whatsapp;
    emailController.text = data.email;
    fotoUrl.value = data.profileImage ?? ''; // URL dari API
    foto.value = null; // reset file baru
    isEdit(true);
  }

  Future<void> updateData() async {
    if (userId == null) return;

    isLoading.value = true;

    int comid = AppPrefs.getIsUserArea() == '1'
        ? int.parse(AppPrefs.getMonComId() ?? '0')
        : int.parse(AppPrefs.getComId() ?? '0');

    try {
      final formData = dio.FormData.fromMap({
        '_method': 'PATCH',
        'name': nameController.text,
        'whatsapp': whatsappController.text,
        'email': emailController.text,
        'comid': comid,

        // password hanya kirim kalau diisi
        if (passwordController.text.isNotEmpty)
          'password': passwordController.text,

        // foto hanya kirim kalau ada file baru
        if (foto.value != null)
          'profile_image': await dio.MultipartFile.fromFile(
            foto.value!.path,
            filename: foto.value!.path.split('/').last,
          ),
      });

      final response = await api.post(
        "${ApiEndpoint.masterUser}/$userId",
        data: formData,
        options: dio.Options(contentType: 'multipart/form-data'),
      );

      var body = response.data;

      if (body['success']) {
        getDataUser();
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
      final response = await api.delete("${ApiEndpoint.masterUser}/$id");

      var body = response.data;

      if (body['success']) {
        SnackbarHelper.success('Sukses', 'Data berhasil dihapus');
        getDataUser();
      } else {
        SnackbarHelper.error('Warning', body['message'].toString());
      }
    } catch (e) {
      SnackbarHelper.error('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> ubahStatusUser(int userId, int stat) async {
    isLoading.value = true;

    try {
      final response = await api.post(
        ApiEndpoint.ubahStatusUser,
        data: {"id": userId, "stat": stat},
      );

      var body = response.data;
      if (body['success']) {
        getDataUser();
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
