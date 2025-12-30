import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/controllers/paket_controller.dart';
import 'package:qbsc_saas/app/data/api_endpoint.dart';
import 'package:qbsc_saas/app/utils/app_prefs.dart';
import 'package:qbsc_saas/app/views/absensi/absensi.dart';
import 'package:qbsc_saas/app/views/home/card_absensi.dart';
import 'package:qbsc_saas/app/views/home/card_satpam_detail.dart';
import 'package:qbsc_saas/app/views/laporan/resume_kandang.dart';
import 'package:qbsc_saas/app/views/patroli/patroli.dart';
import 'package:qbsc_saas/app/views/user_area/user_area_model.dart';

class UserArea extends StatelessWidget {
  final String menu;
  const UserArea({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PaketController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: const Text(
          'Pilih Perusahaan',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.refresh, color: Colors.white),
        onPressed: () {
          controller.refreshData();
        },
      ),

      backgroundColor: Colors.white,
      body: Obx(() {
        // 1️⃣ Loading pertama kali
        return controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.areaList.length,

                itemBuilder: (context, index) {
                  if (index < controller.areaList.length) {
                    final UserAreaModel dataShow = controller.areaList[index];

                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () async {
                        await AppPrefs.setMonComId(
                          dataShow.monitoringComId.toString(),
                        );

                        if (menu == 'absensi') {
                          Get.toNamed('/absensi');
                        } else if (menu == 'patroli') {
                          Get.toNamed('/patroli');
                        } else if (menu == 'kandang') {
                          Get.toNamed('/kandang');
                        } else if (menu == 'doc') {
                          Get.toNamed('/doc');
                        } else if (menu == 'situasi') {
                          Get.toNamed('/situasi');
                        } else if (menu == 'broadcast') {
                          Get.toNamed('/broadcast');
                        } else if (menu == 'tamu') {
                          Get.toNamed('/tamu');
                        } else if (menu == 'resume') {
                          String comid = AppPrefs.getMonComId().toString();
                          Get.to(
                            () => ResumeKandang(
                              url: '${ApiEndpoint.webviewResumeKandang}/$comid',
                              title: "Resume Kandang",
                            ),
                          );
                        } else if (menu == 'card-absensi') {
                          Get.to(() => CardAbsensi());
                        } else if (menu == 'card-satpam') {
                          Get.to(() => CardSatpamDetail());
                        }
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildRow(
                                id: dataShow.id.toString(),
                                name: dataShow.monitoringComName,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              );
      }),
    );
  }

  Widget _buildRow({required String id, required String name}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// NAMA + WHATSAPP
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
              ],
            ),
          ),

          /// STATUS
        ],
      ),
    );
  }
}
