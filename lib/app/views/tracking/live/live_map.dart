import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import 'package:qbsc_saas/app/views/tracking/live/live_controller.dart';

class LiveMapView extends StatefulWidget {
  const LiveMapView({Key? key}) : super(key: key);

  @override
  State<LiveMapView> createState() => _LiveMapViewState();
}

class _LiveMapViewState extends State<LiveMapView> {
  late final LiveMapController controller;

  final MapController mapController = MapController();

  bool _initialFitDone = false;

  @override
  void initState() {
    super.initState();

    controller = Get.put(LiveMapController());
  }

  @override
  void dispose() {
    if (Get.isRegistered<LiveMapController>()) {
      Get.delete<LiveMapController>();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.satpamMarkers.isEmpty &&
            controller.patrolMarkers.isEmpty) {
          return _buildEmptyState();
        }

        if (!_initialFitDone) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _fitAllMarkers();
              _initialFitDone = true;
            }
          });
        }

        return Stack(
          children: [
            // =====================================================
            // MAP
            // =====================================================
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: _getInitialCenter(),
                initialZoom: 16,

                onMapEvent: (event) {
                  if (controller.isFollowing.value) {
                    if (event is MapEventMove) {
                      controller.setFollowing(false);
                    }
                  }
                },
              ),

              children: [
                // =================================================
                // SATELLITE MAP
                // =================================================
                TileLayer(
                  urlTemplate:
                      'https://server.arcgisonline.com/'
                      'ArcGIS/rest/services/'
                      'World_Imagery/'
                      'MapServer/tile/{z}/{y}/{x}',
                  userAgentPackageName: 'com.qbsc.monitoring',
                ),

                // =================================================
                // PATROLI
                // =================================================
                Obx(
                  () => MarkerLayer(
                    markers: controller.patrolMarkers.map((point) {
                      return Marker(
                        point: point,
                        width: 36,
                        height: 36,
                        alignment: Alignment.center,
                        child: _buildPatroliMarker(),
                      );
                    }).toList(),
                  ),
                ),

                // =================================================
                // POLYLINE
                //
                // HANYA tampil ketika SATPAM dipilih
                // =================================================
                Obx(() {
                  final selectedId = controller.selectedSatpamId.value;

                  if (selectedId == null) {
                    return PolylineLayer(polylines: <Polyline<Object>>[]);
                  }

                  final points = controller.polylines[selectedId] ?? [];

                  if (points.length < 2) {
                    return PolylineLayer(polylines: <Polyline<Object>>[]);
                  }

                  return PolylineLayer(
                    polylines: [
                      Polyline<Object>(
                        points: points,
                        strokeWidth: 5,
                        color: Colors.blueAccent,
                        borderStrokeWidth: 2,
                        borderColor: Colors.white,
                      ),
                    ],
                  );
                }),

                // =================================================
                // SATPAM MARKER
                // =================================================
                Obx(
                  () => MarkerLayer(
                    markers: controller.satpamMarkers.entries.map((entry) {
                      final id = entry.key;
                      final position = entry.value;

                      final name = controller.satpamNames[id] ?? 'Satpam';

                      final status = controller.getStatus(id);

                      final selected = controller.selectedSatpamId.value == id;

                      return Marker(
                        point: position,
                        width: selected ? 180 : 120,
                        height: selected ? 100 : 75,
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onTap: () {
                            _selectSatpam(id, position);
                          },
                          child: _buildSatpamMarker(
                            name: name,
                            status: status,
                            selected: selected,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),

            // =====================================================
            // TOP HEADER
            // =====================================================
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 10),
                    _buildStatistics(),
                  ],
                ),
              ),
            ),

            // =====================================================
            // SELECTED SATPAM DETAIL
            // =====================================================
            Obx(() {
              final id = controller.selectedSatpamId.value;

              if (id == null) {
                return const SizedBox();
              }

              return Positioned(
                left: 14,
                right: 14,
                bottom: 18,
                child: SafeArea(child: _buildSelectedSatpamCard(id)),
              );
            }),

            // =====================================================
            // MAP CONTROL
            // =====================================================
            Positioned(
              right: 14,
              bottom: controller.selectedSatpamId.value != null ? 145 : 25,
              child: _buildMapControls(),
            ),
          ],
        );
      }),
    );
  }

  // =============================================================
  // HEADER
  // =============================================================

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.location_searching,
              color: Colors.white,
              size: 22,
            ),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Live Tracking',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 2),
                Text(
                  'Monitoring posisi security',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),

          // LIVE
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.10),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                const Text(
                  'LIVE',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // STATISTICS
  // =============================================================

  Widget _buildStatistics() {
    return Obx(() {
      int online = 0;
      int lastSeen = 0;
      int offline = 0;

      for (final id in controller.satpamMarkers.keys) {
        final status = controller.getStatus(id);

        if (status == 'Online') {
          online++;
        } else if (status == 'Terakhir terlihat') {
          lastSeen++;
        } else {
          offline++;
        }
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildStat(
                icon: Icons.circle,
                color: Colors.green,
                value: online,
                label: 'Online',
              ),
            ),
            _buildDivider(),
            Expanded(
              child: _buildStat(
                icon: Icons.circle,
                color: Colors.orange,
                value: lastSeen,
                label: 'Last Seen',
              ),
            ),
            _buildDivider(),
            Expanded(
              child: _buildStat(
                icon: Icons.circle,
                color: Colors.red,
                value: offline,
                label: 'Offline',
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStat({
    required IconData icon,
    required Color color,
    required int value,
    required String label,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 10),
        const SizedBox(width: 6),
        Column(
          children: [
            Text(
              '$value',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 9, color: Colors.grey.shade600),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 30, color: Colors.grey.shade300);
  }

  // =============================================================
  // SATPAM MARKER
  // =============================================================

  Widget _buildSatpamMarker({
    required String name,
    required String status,
    required bool selected,
  }) {
    final online = status == 'Online';
    final lastSeen = status == 'Terakhir terlihat';

    final Color mainColor;

    if (online) {
      mainColor = Colors.green.shade600;
    } else if (lastSeen) {
      mainColor = Colors.orange.shade600;
    } else {
      mainColor = Colors.grey.shade500;
    }

    // ===========================================================
    // ONLINE / SELECTED
    // ===========================================================

    if (online || selected) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 150),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: selected ? Colors.blue.shade700 : Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.black87,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: mainColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      status,
                      style: TextStyle(
                        color: selected ? Colors.white : mainColor,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 3),

          // ICON BESAR
          Container(
            width: selected ? 52 : 46,
            height: selected ? 52 : 46,
            decoration: BoxDecoration(
              color: mainColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 28),
          ),
        ],
      );
    }

    // ===========================================================
    // OFFLINE / LAST SEEN
    // ===========================================================

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 100),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.88),
            borderRadius: BorderRadius.circular(7),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: mainColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 2),

        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: mainColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.person, color: Colors.white, size: 16),
        ),
      ],
    );
  }

  // =============================================================
  // PATROLI MARKER
  // =============================================================

  Widget _buildPatroliMarker() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.red.shade600,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5)],
        ),
        child: const Icon(Icons.location_on, color: Colors.white, size: 15),
      ),
    );
  }

  // =============================================================
  // SELECT SATPAM
  // =============================================================

  void _selectSatpam(int id, LatLng position) {
    controller.selectSatpam(id);

    controller.setFollowing(true);

    mapController.move(position, 18);
  }

  // =============================================================
  // SELECTED CARD
  // =============================================================

  Widget _buildSelectedSatpamCard(int id) {
    final name = controller.satpamNames[id] ?? 'Satpam';

    final status = controller.getStatus(id);

    final position = controller.satpamMarkers[id];

    if (position == null) {
      return const SizedBox();
    }

    final online = status == 'Online';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 18,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: online ? Colors.green.shade600 : Colors.orange.shade600,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 25),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: online ? Colors.green : Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      status,
                      style: TextStyle(
                        color: online ? Colors.green : Colors.orange,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  '${position.latitude.toStringAsFixed(6)}, '
                  '${position.longitude.toStringAsFixed(6)}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 9),
                ),
              ],
            ),
          ),

          // FOLLOW
          Obx(
            () => IconButton(
              tooltip: controller.isFollowing.value
                  ? 'Berhenti mengikuti'
                  : 'Ikuti satpam',
              onPressed: () {
                final currentPosition = controller.satpamMarkers[id];

                if (currentPosition == null) {
                  return;
                }

                final following = !controller.isFollowing.value;

                controller.setFollowing(following);

                if (following) {
                  mapController.move(currentPosition, 18);
                }
              },
              icon: Icon(
                controller.isFollowing.value
                    ? Icons.gps_fixed
                    : Icons.gps_not_fixed,
                color: controller.isFollowing.value ? Colors.blue : Colors.grey,
              ),
            ),
          ),

          // CLOSE
          IconButton(
            tooltip: 'Tutup',
            onPressed: () {
              controller.clearSelection();

              _fitAllMarkers();
            },
            icon: const Icon(Icons.close, size: 20),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // MAP CONTROLS
  // =============================================================

  Widget _buildMapControls() {
    return Column(
      children: [
        // FIT ALL
        FloatingActionButton.small(
          heroTag: 'fit_all',
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          onPressed: () {
            controller.clearSelection();

            _fitAllMarkers();
          },
          child: const Icon(Icons.fit_screen),
        ),

        const SizedBox(height: 8),

        // CURRENT SELECTED
        Obx(() {
          final id = controller.selectedSatpamId.value;

          if (id == null) {
            return const SizedBox();
          }

          return FloatingActionButton.small(
            heroTag: 'selected_position',
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            onPressed: () {
              final position = controller.satpamMarkers[id];

              if (position == null) {
                return;
              }

              mapController.move(position, 18);
            },
            child: const Icon(Icons.my_location),
          );
        }),
      ],
    );
  }

  // =============================================================
  // FIT ALL MARKERS
  // =============================================================

  void _fitAllMarkers() {
    final points = <LatLng>[];

    points.addAll(controller.satpamMarkers.values);

    points.addAll(controller.patrolMarkers);

    if (points.isEmpty) {
      return;
    }

    if (points.length == 1) {
      mapController.move(points.first, 17);

      return;
    }

    final bounds = LatLngBounds.fromPoints(points);

    mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.fromLTRB(45, 190, 45, 120),
        maxZoom: 17,
      ),
    );
  }

  // =============================================================
  // INITIAL CENTER
  // =============================================================

  LatLng _getInitialCenter() {
    if (controller.satpamMarkers.isNotEmpty) {
      return controller.satpamMarkers.values.first;
    }

    if (controller.patrolMarkers.isNotEmpty) {
      return controller.patrolMarkers.first;
    }

    return const LatLng(-2.95, 99.06);
  }

  // =============================================================
  // EMPTY
  // =============================================================

  Widget _buildEmptyState() {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_off_outlined, size: 50, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'Tidak ada data tracking',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
