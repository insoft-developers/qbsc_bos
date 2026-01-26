import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:qbsc_saas/app/views/tracking/rute/map/map_controller.dart';

class TrackingMap extends StatefulWidget {
  final int absensiId;
  const TrackingMap({super.key, required this.absensiId});

  @override
  State<TrackingMap> createState() => _TrackingMapState();
}

class _TrackingMapState extends State<TrackingMap>
    with SingleTickerProviderStateMixin {
  final controller = Get.put(TrackingMapController());

  late AnimationController animController;
  Animation<LatLng>? animation;

  int index = 0;
  bool isPlaying = false;
  double speed = 2.0;

  LatLng? movingPos;

  @override
  void initState() {
    super.initState();
    animController = AnimationController(vsync: this);

    controller.fetchData(widget.absensiId).then((_) {
      if (controller.mapList.isNotEmpty) {
        movingPos = latlngs.first;
        setState(() {});
      }
    });
  }

  List<LatLng> get latlngs =>
      controller.mapList.map((e) => LatLng(e.lat, e.lng)).toList();

  void play() {
    if (index >= latlngs.length - 1) return;

    animController.duration = Duration(milliseconds: (speed * 1000).toInt());

    animation =
        LatLngTween(
          begin: latlngs[index],
          end: latlngs[index + 1],
        ).animate(animController)..addListener(() {
          setState(() {
            movingPos = animation!.value;
          });
        });

    animController.forward(from: 0).whenComplete(() {
      index++;
      if (isPlaying) play();
    });
  }

  @override
  void dispose() {
    animController.dispose();
    Get.delete<TrackingMapController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracking Map'),
        backgroundColor: const Color(0xFF0F172A),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.mapList.isEmpty) {
          return const Center(child: Text('Data tidak ditemukan'));
        }

        final current = controller.mapList[index];

        return Column(
          children: [
            // ================= CONTROLS =================
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      isPlaying = true;
                      play();
                    },
                    child: const Text('▶ Play'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => isPlaying = false,
                    child: const Text('⏸ Pause'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      isPlaying = false;
                      index = 0;
                      movingPos = latlngs.first;
                      setState(() {});
                    },
                    child: const Text('🔁 Replay'),
                  ),
                ],
              ),
            ),

            // ================= SLIDER =================
            Slider(
              min: 0,
              max: latlngs.length.toDouble() - 1,
              value: index.toDouble(),
              onChanged: (v) {
                isPlaying = false;
                setState(() {
                  index = v.toInt();
                  movingPos = latlngs[index];
                });
              },
            ),

            // ================= MAP =================
            Expanded(
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: latlngs.first,
                  initialZoom: 17,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                    userAgentPackageName: 'com.qbsc.saas',
                  ),

                  // ===== ROUTE =====
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: latlngs,
                        color: Colors.grey.shade400,
                        strokeWidth: 3,
                      ),
                      Polyline(
                        points: latlngs.sublist(0, index + 1),
                        color: Colors.blue,
                        strokeWidth: 4,
                      ),
                    ],
                  ),

                  // ===== MARKER + LABEL =====
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: movingPos!,
                        width: 160,
                        height: 60,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.location_pin,
                              color: Colors.red,
                              size: 36,
                            ),
                            const SizedBox(width: 4),

                            /// ===== LABEL =====
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    current.keterangan,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    current.tanggal,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

/// ================= HELPER =================
class LatLngTween extends Tween<LatLng> {
  LatLngTween({required LatLng begin, required LatLng end})
    : super(begin: begin, end: end);

  @override
  LatLng lerp(double t) => LatLng(
    begin!.latitude + (end!.latitude - begin!.latitude) * t,
    begin!.longitude + (end!.longitude - begin!.longitude) * t,
  );
}
