import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/controllers/paket_controller.dart';
import 'package:qbsc_saas/app/utils/app_prefs.dart';
import 'package:qbsc_saas/app/views/absensi/absensi.dart';
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
                          Get.to((Absensi()));
                        } else if (menu == 'patroli') {
                          Get.to((Patroli()));
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
                  name,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 14,
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
