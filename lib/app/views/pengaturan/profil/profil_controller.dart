import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/data/api_endpoint.dart';
import 'package:qbsc_saas/app/utils/app_prefs.dart';
import 'package:qbsc_saas/app/utils/snackbar_helper.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var profileData = <String, dynamic>{}.obs;
  var imagePath = ''.obs;

  final api = Get.find<ApiProvider>();

  // ===== FOTO =====
  Rx<File?> foto = Rx<File?>(null);
  final picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    getProfileData();
  }

  Future pickFoto() async {
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      foto.value = File(img.path);
    }
  }

  Future<void> getProfileData() async {
    isLoading.value = true;
    int userid = int.parse(AppPrefs.getUserId() ?? '0');

    try {
      final response = await api.post(
        ApiEndpoint.getProfileData,
        data: {"userid": userid},
      );

      if (response.data['success']) {
        profileData.value = response.data['data'];
      } else {
        SnackbarHelper.error("Warning", "Data tidak ditemukan");
      }
    } catch (e) {
      SnackbarHelper.error("Warning", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveProfile(String name, String whatsapp) async {
    if (name.isEmpty) {
      SnackbarHelper.error("warning", "nama lengkap tidak boleh kosong!");
      return;
    }
    if (whatsapp.isEmpty) {
      SnackbarHelper.error("warning", "nomor whatsapp tidak boleh kosong!");
      return;
    }
    isLoading.value = true;
    try {
      final FormData formData = FormData.fromMap({
        "userid": profileData['id'],
        "name": name,
        "whatsapp": whatsapp,
        if (foto.value != null)
          'image': await dio.MultipartFile.fromFile(
            foto.value!.path,
            filename: foto.value!.path.split('/').last,
          ),
      });

      final response = await api.post(
        ApiEndpoint.updateUserProfile,
        data: formData,
      );

      if (response.data['success']) {
        SnackbarHelper.success("Sukses", "Profil berhasil diperbarui");
        getProfileData();
      } else {
        SnackbarHelper.error("Gagal", response.data['message']);
      }
    } catch (e) {
      SnackbarHelper.error("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
