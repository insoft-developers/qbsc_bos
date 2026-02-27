import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/controllers/paket_controller.dart';
import 'package:qbsc_saas/app/data/api_endpoint.dart';
import 'package:qbsc_saas/app/utils/app_prefs.dart';
import 'package:qbsc_saas/app/views/home/card_absensi.dart';
import 'package:qbsc_saas/app/views/home/card_satpam_detail.dart';
import 'package:qbsc_saas/app/views/kinerja/kinerja.dart';
import 'package:qbsc_saas/app/views/laporan/resume_kandang.dart';
import 'package:qbsc_saas/app/views/master/satpam/index.dart';
import 'package:qbsc_saas/app/views/tracking/live/live_map.dart';
import 'package:qbsc_saas/app/views/tracking/rute/rute.dart';
import 'package:qbsc_saas/app/views/user_area/user_area_model.dart';

class UserArea extends StatelessWidget {
  final String menu;
  const UserArea({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PaketController>();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: const Text(
          'Pilih Perusahaan',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),

        /// 🔄 REFRESH DI APPBAR (LEBIH PROFESIONAL)
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              controller.refreshData();
            },
          ),
        ],
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.areaList.length,
          itemBuilder: (context, index) {
            final UserAreaModel data = controller.areaList[index];

            return InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () async {
                await AppPrefs.setMonComId(data.monitoringComId.toString());

                if (menu == 'resume') {
                  final comid = AppPrefs.getMonComId().toString();
                  final token = AppPrefs.getToken().toString();
                  Get.to(
                    () => ResumeKandang(
                      url:
                          '${ApiEndpoint.webviewResumeKandang}/$comid?token=$token',
                      title: "Resume Kandang",
                    ),
                  );
                } else if (menu == 'card-absensi') {
                  Get.to(() => CardAbsensi());
                } else if (menu == 'card-satpam') {
                  Get.to(() => CardSatpamDetail());
                } else if (menu == 'laporan-kinerja') {
                  Get.to(() => Kinerja());
                } else if (menu == 'rute') {
                  Get.to(() => RutePage());
                } else if (menu == 'live-tracking') {
                  Get.to(() => LiveMapView());
                } else if (menu == 'master-satpam') {
                  Get.to(() => SatpamPage());
                } else {
                  Get.toNamed('/$menu');
                }
              },

              // =====================
              // CARD PERUSAHAAN
              // =====================
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      // ICON
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.apartment_rounded,
                          size: 28,
                          color: Color(0xFF0F172A),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // TEXT
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.monitoringComName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Tap untuk masuk',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 30,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
