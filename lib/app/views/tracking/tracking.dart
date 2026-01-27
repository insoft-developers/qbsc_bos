import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/utils/app_prefs.dart';
import 'package:qbsc_saas/app/views/tracking/live/live_map.dart';
import 'package:qbsc_saas/app/views/tracking/rute/rute.dart';
import 'package:qbsc_saas/app/views/user_area/user_area.dart';

class Tracking extends StatelessWidget {
  const Tracking({super.key});

  final List<Map<String, dynamic>> menuItems = const [
    {'icon': Icons.my_location, 'label': 'Live Tracking'},
    {'icon': Icons.location_pin, 'label': 'Tracking Rute Patroli'},
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
          'Tracking',
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
              if (item['label'] == 'Live Tracking') {
                isArea == '1'
                    ? Get.to(() => UserArea(menu: 'live-tracking'))
                    : Get.to(() => LiveMapView());
              } else if (item['label'] == 'Tracking Rute Patroli') {
                isArea == '1'
                    ? Get.to(() => UserArea(menu: 'rute'))
                    : Get.to(() => RutePage());
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
    case 'Live Tracking':
      return 'Pantau lokasi satpam yang sedang bertugas secara live';
    case 'Tracking Rute Patroli':
      return 'Pantau Riwayat Rute patroli satpam yang selesai bertugas';

    default:
      return '';
  }
}
