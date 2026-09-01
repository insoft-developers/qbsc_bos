import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/utils/app_prefs.dart';
import 'package:qbsc_saas/app/views/master/emergency/index.dart';
import 'package:qbsc_saas/app/views/master/jadwal_patroli/index.dart';
import 'package:qbsc_saas/app/views/master/jam_shift/index.dart';
import 'package:qbsc_saas/app/views/master/lokasi/index.dart';
import 'package:qbsc_saas/app/views/master/lokasi_absen/index.dart';
import 'package:qbsc_saas/app/views/master/lokasi_absen/lokasi_absen_controller.dart';
import 'package:qbsc_saas/app/views/master/running_text/index.dart';
import 'package:qbsc_saas/app/views/master/satpam/index.dart';
import 'package:qbsc_saas/app/views/master/user/index.dart';
import 'package:qbsc_saas/app/views/user_area/user_area.dart';

class Master extends StatelessWidget {
  Master({super.key});

  final con = Get.put(LokasiAbsenController());

  final List<Map<String, dynamic>> menuItems = const [
    {'icon': Icons.people, 'label': 'Data Satpam'},
    {'icon': Icons.location_on, 'label': 'Data Lokasi'},
    {'icon': Icons.person, 'label': 'Data User'},
    {'icon': Icons.schedule, 'label': 'Jadwal Patroli'},
    {'icon': Icons.location_history, 'label': 'Lokasi Absen'},
    {'icon': Icons.work_history, 'label': 'Jam Shift'},
    {'icon': Icons.text_rotation_none, 'label': 'Running Text'},
    {'icon': Icons.contact_emergency_sharp, 'label': 'Kontak Darurat'},
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600;
    final iconSize = isTablet ? 48.0 : 36.0;
    final fontSize = isTablet ? 18.0 : 14.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 60, 53, 53),
        title: const Text(
          'Master Data',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // warna back button
        ),
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 32 : 18,
          vertical: 24,
        ),
        itemCount: menuItems.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final item = menuItems[index];

          return InkWell(
            borderRadius: BorderRadius.circular(18),

            onTap: () {
              final isArea = AppPrefs.getIsUserArea() ?? '0';
              final isMobileAdmin = AppPrefs.getIsMobileAdmin() ?? '0';

              // ==================================================
              // CEK AKSES MOBILE ADMIN
              // ==================================================

              if (isMobileAdmin != '1') {
                Get.dialog(
                  AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: const Row(
                      children: [
                        Icon(Icons.lock_outline_rounded, color: Colors.orange),
                        SizedBox(width: 10),
                        Text(
                          'Akses Ditolak',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    content: const Text(
                      'Maaf, anda tidak punya akses untuk membuka menu ini.',
                      style: TextStyle(fontSize: 14, height: 1.5),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );

                return;
              }

              // ==================================================
              // MENU
              // ==================================================

              if (item['label'] == 'Data Satpam') {
                isArea == '1'
                    ? Get.to(() => UserArea(menu: 'master-satpam'))
                    : Get.to(() => SatpamPage());
              } else if (item['label'] == 'Data User') {
                isArea == '1'
                    ? Get.to(() => UserArea(menu: 'master-user'))
                    : Get.to(() => UserPage());
              } else if (item['label'] == 'Data Lokasi') {
                isArea == '1'
                    ? Get.to(() => UserArea(menu: 'master-lokasi'))
                    : Get.to(() => LokasiPage());
              } else if (item['label'] == 'Jadwal Patroli') {
                isArea == '1'
                    ? Get.to(() => UserArea(menu: 'master-jadwal'))
                    : Get.to(() => JadwalPatroliPage());
              } else if (item['label'] == 'Lokasi Absen') {
                isArea == '1'
                    ? Get.to(() => UserArea(menu: 'lokasi-absen'))
                    : Get.to(() => AturLokasiPage());
              } else if (item['label'] == 'Running Text') {
                isArea == '1'
                    ? Get.to(() => UserArea(menu: 'running-text'))
                    : Get.to(() => RunningTextPage());
              } else if (item['label'] == 'Kontak Darurat') {
                isArea == '1'
                    ? Get.to(() => UserArea(menu: 'darurat'))
                    : Get.to(() => EmergencyListPage());
              } else if (item['label'] == 'Jam Shift') {
                isArea == '1'
                    ? Get.to(() => UserArea(menu: 'jam-shift'))
                    : Get.to(() => JamShiftPage());
              }
            },
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    // ================= ICON BADGE =================
                    Container(
                      width: iconSize + 20,
                      height: iconSize + 20,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black12, Colors.black87],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        item['icon'],
                        color: Colors.white,
                        size: iconSize,
                      ),
                    ),

                    const SizedBox(width: 16),

                    // ================= TEXT =================
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['label'],
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getPengaturanSubtitle(item['label']),
                            style: TextStyle(
                              fontSize: fontSize - 2,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ================= ARROW =================
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
      ),
    );
  }
}

String _getPengaturanSubtitle(String label) {
  switch (label) {
    case 'Data Satpam':
      return 'Kelola Data Satpam Anda';
    case 'Data Lokasi':
      return 'Kelola Data Lokasi Anda';
    case 'Data User':
      return 'Kelola Data User Anda';

    case 'Jadwal Patroli':
      return 'Kelola Jadwal Patroli Anda';
    case 'Lokasi Absen':
      return 'Atur Lokasi Titik Absen Satpam Anda';
    case 'Jam Shift':
      return 'Kelola Jam Shift Satpam Anda';

    case 'Running Text':
      return 'Kelola Running Text Anda';

    case 'Kontak Darurat':
      return 'Kelola Kontak Darurat Anda';

    default:
      return '';
  }
}
