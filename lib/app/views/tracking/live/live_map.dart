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

  @override
  void initState() {
    super.initState();
    controller = Get.put(LiveMapController());
  }

  @override
  void dispose() {
    Get.delete<LiveMapController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Tracking')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.satpamMarkers.isEmpty &&
            controller.patrolMarkers.isEmpty) {
          return const Center(child: Text('Data tidak tersedia'));
        }

        final LatLng center = controller.satpamMarkers.isNotEmpty
            ? controller.satpamMarkers.values.first
            : controller.patrolMarkers.first;

        return FlutterMap(
          options: MapOptions(initialCenter: center, initialZoom: 17),
          children: [
            // ================= SATELLITE TILE =================
            TileLayer(
              urlTemplate:
                  'https://server.arcgisonline.com/ArcGIS/rest/services/'
                  'World_Imagery/MapServer/tile/{z}/{y}/{x}',
              userAgentPackageName: 'com.qbsc.monitoring',
            ),

            // ================= POLYLINE (JALUR SATPAM) =================
            Obx(
              () => PolylineLayer(
                polylines: controller.polylines.entries.map((e) {
                  return Polyline(
                    points: e.value,
                    strokeWidth: 3,
                    color: Colors.blueAccent,
                  );
                }).toList(),
              ),
            ),

            // ================= MARKER PATROLI =================
            Obx(
              () => MarkerLayer(
                markers: controller.patrolMarkers.map((latlng) {
                  return Marker(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    point: latlng,
                    child: const Icon(
                      Icons.circle,
                      size: 14,
                      color: Colors.red,
                    ),
                  );
                }).toList(),
              ),
            ),

            // ================= MARKER SATPAM + NAMA =================
            Obx(
              () => MarkerLayer(
                markers: controller.satpamMarkers.entries.map((entry) {
                  return Marker(
                    width: 140,
                    height: 90,
                    alignment: Alignment.bottomCenter,
                    point: entry.value,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ===== NAMA SATPAM =====
                        Container(
                          constraints: const BoxConstraints(maxWidth: 130),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: const [
                              BoxShadow(color: Colors.black26, blurRadius: 4),
                            ],
                          ),
                          child: Text(
                            controller.satpamNames[entry.key] ??
                                'Satpam ${entry.key}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Icon(
                          Icons.person_pin,
                          size: 36,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      }),
    );
  }
}
