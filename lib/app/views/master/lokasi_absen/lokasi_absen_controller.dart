import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/data/api_endpoint.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/app_prefs.dart';
import 'package:qbsc_saas/app/utils/snackbar_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class LokasiAbsenController extends GetxController {
  final ApiProvider api = Get.find<ApiProvider>();

  final isLoading = false.obs;
  final latitude = ''.obs;
  final longitude = ''.obs;

 
  Future<void> getLokasi() async {
    try {
      isLoading.value = true;
      int comid = AppPrefs.getIsUserArea() == '1'
          ? int.parse(AppPrefs.getMonComId() ?? '0')
          : int.parse(AppPrefs.getComId() ?? '0');

      final response = await api.post(
        ApiEndpoint.getCurrentAbsenLocation,
        data: {'comid': comid},
      );
      final body = response.data;
      if (body['success'] == true) {
        final data = body['data'];
        latitude.value = data['latitude']?.toString() ?? '';
        longitude.value = data['longitude']?.toString() ?? '';
      } else {
        SnackbarHelper.error(
          'Gagal',
          body['message']?.toString() ?? 'Gagal mengambil lokasi.',
        );
      }
    } catch (e) {
      SnackbarHelper.error('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> aturLokasiSaatIni() async {
    // =========================
    // KONFIRMASI
    // =========================

    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Atur Lokasi Absen'),
        content: const Text(
          'Apakah Anda ingin mengatur lokasi saat ini sebagai lokasi absen?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: false);
            },
            child: const Text('Tidak'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(result: true);
            },
            child: const Text('Ya'),
          ),
        ],
      ),
    );

    if (result != true) return;

    try {
      isLoading.value = true;
      int comid = AppPrefs.getIsUserArea() == '1'
          ? int.parse(AppPrefs.getMonComId() ?? '0')
          : int.parse(AppPrefs.getComId() ?? '0');

      // =========================
      // CEK GPS
      // =========================

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        SnackbarHelper.error(
          'GPS Tidak Aktif',
          'Silakan aktifkan lokasi/GPS terlebih dahulu.',
        );
        return;
      }

      // =========================
      // CEK PERMISSION
      // =========================

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          SnackbarHelper.error('Permission Ditolak', 'Izin lokasi diperlukan.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        SnackbarHelper.error(
          'Permission Ditolak',
          'Izin lokasi ditolak secara permanen. '
              'Silakan aktifkan dari Settings.',
        );
        return;
      }

      // =========================
      // AMBIL LOKASI
      // =========================

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final latitude = position.latitude;
      final longitude = position.longitude;

      // =========================
      // KIRIM KE API
      // =========================

      final response = await api.post(
        ApiEndpoint.lokasiAbsenUpdate,
        data: {'latitude': latitude, 'longitude': longitude, 'comid': comid},
      );

      final body = response.data;

      if (body['success'] == true) {
        getLokasi();
        SnackbarHelper.success('Berhasil', 'Lokasi absen berhasil diatur.');
      } else {
        SnackbarHelper.error(
          'Gagal',
          body['message']?.toString() ?? 'Gagal mengatur lokasi absen.',
        );
      }
    } catch (e) {
      SnackbarHelper.error('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> bukaGoogleMaps() async {
    if (latitude.value.isEmpty || longitude.value.isEmpty) {
      SnackbarHelper.error('Gagal', 'Koordinat lokasi belum tersedia.');
      return;
    }
    final lat = latitude.value;
    final lng = longitude.value;
    final Uri url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );
    try {
      final opened = await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!opened) {
        SnackbarHelper.error('Gagal', 'Tidak dapat membuka Google Maps.');
      }
    } catch (e) {
      SnackbarHelper.error('Error', e.toString());
    }
  }
}
