import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import 'package:qbsc_saas/app/data/api_endpoint.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/app_prefs.dart';
import 'package:qbsc_saas/app/utils/snackbar_helper.dart';
import 'package:qbsc_saas/app/views/tracking/live/live_map_model.dart';

class LiveMapController extends GetxController {
  // ============================================================
  // STATE
  // ============================================================

  final isLoading = true.obs;

  /// Posisi terakhir setiap satpam
  final satpamMarkers = <int, LatLng>{}.obs;

  /// Nama satpam
  final satpamNames = <int, String>{}.obs;

  /// Waktu terakhir update
  final satpamLastSeen = <int, DateTime>{}.obs;

  /// Lokasi QR/patroli
  final patrolMarkers = <LatLng>[].obs;

  /// Jalur perjalanan masing-masing satpam
  final polylines = <int, List<LatLng>>{}.obs;

  /// Satpam yang sedang dipilih
  final selectedSatpamId = RxnInt();

  /// Apakah mode follow aktif
  final isFollowing = false.obs;

  /// Waktu refresh terakhir
  final lastRefresh = Rxn<DateTime>();

  final ApiProvider api = Get.find<ApiProvider>();

  late int _comid;

  Timer? _pollingTimer;

  bool _isRefreshing = false;

  // ============================================================
  // CONFIG
  // ============================================================

  /// Polling server setiap 10 detik
  static const int pollingSeconds = 10;

  /// Polyline hanya ditambah jika berpindah minimal 10 meter
  static const double minimumDistanceMeters = 10;

  /// Maksimal titik jalur yang disimpan di memory
  static const int maxPolylinePoints = 100;

  Timer? _statusTimer;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    fetchData();

    _statusTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      satpamLastSeen.refresh();
    });
  }

  // ============================================================
  // INITIAL LOAD
  // ============================================================

  Future<void> fetchData() async {
    _comid = AppPrefs.getIsUserArea() == '1'
        ? int.tryParse(AppPrefs.getMonComId() ?? '0') ?? 0
        : int.tryParse(AppPrefs.getComId() ?? '0') ?? 0;

    isLoading.value = true;

    try {
      final response = await api.post(
        ApiEndpoint.liveTracking,
        data: {'comid': _comid},
      );

      final body = response.data;

      if (body['success'] != true) {
        SnackbarHelper.error('Warning', 'Data tracking tidak ditemukan');

        return;
      }

      final List<dynamic> data = body['data'] ?? [];

      _processInitialData(data);

      lastRefresh.value = DateTime.now();

      startLiveTracking();
    } catch (e) {
      debugPrint('LIVE TRACKING INITIAL ERROR: $e');

      SnackbarHelper.error('Warning', 'Gagal mengambil data tracking');
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // INITIAL DATA
  // ============================================================

  void _processInitialData(List<dynamic> data) {
    satpamMarkers.clear();
    satpamNames.clear();
    satpamLastSeen.clear();
    patrolMarkers.clear();
    polylines.clear();

    for (final json in data) {
      try {
        final item = LiveMapModel.fromJson(json);

        final position = LatLng(item.latitude, item.longitude);

        // ======================================================
        // SATPAM
        // ======================================================

        if (item.type == 'satpam') {
          satpamMarkers[item.id] = position;

          satpamNames[item.id] = item.name;

          if (item.lastSeenAt != null) {
            satpamLastSeen[item.id] = item.lastSeenAt!;
          }

          // Jalur dimulai dari posisi pertama
          polylines[item.id] = [position];
        }
        // ======================================================
        // PATROLI
        // ======================================================
        else if (item.type == 'patroli') {
          patrolMarkers.add(position);
        }
      } catch (e) {
        debugPrint('PROCESS TRACKING ERROR: $e');
      }
    }
  }

  // ============================================================
  // START POLLING
  // ============================================================

  void startLiveTracking() {
    _pollingTimer?.cancel();

    _pollingTimer = Timer.periodic(const Duration(seconds: pollingSeconds), (
      _,
    ) {
      _refreshFromApi();
    });
  }

  // ============================================================
  // REFRESH API
  // ============================================================

  Future<void> _refreshFromApi() async {
    // ==========================================================
    // Jangan request jika request sebelumnya belum selesai
    // ==========================================================

    if (_isRefreshing) {
      return;
    }

    _isRefreshing = true;

    try {
      final response = await api.post(
        ApiEndpoint.liveTracking,
        data: {'comid': _comid},
      );

      final body = response.data;

      if (body['success'] != true) {
        return;
      }

      final List<dynamic> data = body['data'] ?? [];

      for (final json in data) {
        try {
          final item = LiveMapModel.fromJson(json);

          if (item.type != 'satpam') {
            continue;
          }

          final newPosition = LatLng(item.latitude, item.longitude);

          satpamNames[item.id] = item.name;

          if (item.lastSeenAt != null) {
            satpamLastSeen[item.id] = item.lastSeenAt!;
          }

          final oldPosition = satpamMarkers[item.id];

          // ====================================================
          // SATPAM BARU
          // ====================================================

          if (oldPosition == null) {
            satpamMarkers[item.id] = newPosition;

            polylines[item.id] = [newPosition];

            continue;
          }

          // ====================================================
          // HITUNG JARAK
          // ====================================================

          final distance = const Distance().as(
            LengthUnit.Meter,
            oldPosition,
            newPosition,
          );

          // ====================================================
          // TIDAK BERPINDAH
          // ====================================================

          if (distance < minimumDistanceMeters) {
            continue;
          }

          // ====================================================
          // UPDATE POLYLINE
          // ====================================================

          _addPolylinePoint(item.id, newPosition);

          // ====================================================
          // ANIMASI MARKER
          // ====================================================

          _animateMarker(item.id, oldPosition, newPosition);
        } catch (e) {
          debugPrint('PROCESS UPDATE ERROR: $e');
        }
      }

      lastRefresh.value = DateTime.now();
    } catch (e) {
      debugPrint('LIVE TRACKING REFRESH ERROR: $e');
    } finally {
      _isRefreshing = false;
    }
  }

  // ============================================================
  // POLYLINE
  // ============================================================

  void _addPolylinePoint(int satpamId, LatLng newPosition) {
    final route = List<LatLng>.from(polylines[satpamId] ?? []);

    if (route.isEmpty) {
      route.add(newPosition);

      polylines[satpamId] = route;

      return;
    }

    final lastPoint = route.last;

    final distance = const Distance().as(
      LengthUnit.Meter,
      lastPoint,
      newPosition,
    );

    // Hindari titik terlalu dekat
    if (distance < minimumDistanceMeters) {
      return;
    }

    route.add(newPosition);

    // ==========================================================
    // BATASI MEMORY
    // ==========================================================

    if (route.length > maxPolylinePoints) {
      route.removeAt(0);
    }

    polylines[satpamId] = route;
  }

  // ============================================================
  // ANIMATE MARKER
  // ============================================================

  void _animateMarker(int satpamId, LatLng from, LatLng to) {
    const totalSteps = 20;

    const duration = Duration(milliseconds: 75);

    int step = 0;

    Timer.periodic(duration, (timer) {
      step++;

      final progress = step / totalSteps;

      if (progress >= 1) {
        timer.cancel();

        satpamMarkers[satpamId] = to;

        return;
      }

      final lat = from.latitude + (to.latitude - from.latitude) * progress;

      final lng = from.longitude + (to.longitude - from.longitude) * progress;

      satpamMarkers[satpamId] = LatLng(lat, lng);
    });
  }

  // ============================================================
  // STATUS
  // ============================================================

  String getStatus(int satpamId) {
    final lastSeen = satpamLastSeen[satpamId];

    if (lastSeen == null) {
      return 'Tidak diketahui';
    }

    final seconds = DateTime.now().difference(lastSeen).inSeconds;

    if (seconds <= 30) {
      return 'Online';
    }

    if (seconds <= 120) {
      return 'Terakhir terlihat';
    }

    return 'Offline';
  }

  // ============================================================
  // SELECT SATPAM
  // ============================================================

  void selectSatpam(int satpamId) {
    selectedSatpamId.value = satpamId;
  }

  // ============================================================
  // FOLLOW
  // ============================================================

  void setFollowing(bool value) {
    isFollowing.value = value;
  }

  // ============================================================
  // CLEAR SELECTION
  // ============================================================

  void clearSelection() {
    selectedSatpamId.value = null;

    isFollowing.value = false;
  }

  // ============================================================
  // LAST REFRESH TEXT
  // ============================================================

  String getLastRefreshText() {
    final value = lastRefresh.value;

    if (value == null) {
      return '-';
    }

    final hour = value.hour.toString().padLeft(2, '0');

    final minute = value.minute.toString().padLeft(2, '0');

    final second = value.second.toString().padLeft(2, '0');

    return '$hour:$minute:$second';
  }

  // ============================================================
  // CLOSE
  // ============================================================

  @override
  void onClose() {
    _pollingTimer?.cancel();
    _statusTimer?.cancel();

    _pollingTimer = null;
    _statusTimer = null;

    super.onClose();
  }
}
