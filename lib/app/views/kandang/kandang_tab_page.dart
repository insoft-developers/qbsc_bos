
import 'package:flutter/material.dart';
import 'package:qbsc_saas/app/views/kandang/alarm/alarm.dart';
import 'package:qbsc_saas/app/views/kandang/kipas/kipas.dart';
import 'package:qbsc_saas/app/views/kandang/lampu/lampu.dart';
import 'package:qbsc_saas/app/views/kandang/suhu/suhu.dart';

class KandangTabPage extends StatelessWidget {
  const KandangTabPage({super.key});

  static const Color primary = Color(0xFF0F172A);
  static const Color accent = Color(0xFF22C55E);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F8FC),

        // =====================================================
        // APP BAR
        // =====================================================

        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: primary,

          iconTheme: const IconThemeData(
            color: Colors.white,
          ),

          titleSpacing: 18,

          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Monitoring Kandang',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Pantau kondisi kandang secara realtime',
                style: TextStyle(
                  color: Color(0xFFCBD5E1),
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),

          // ===================================================
          // TAB BAR
          // ===================================================

          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(68),
            child: Container(
              margin: const EdgeInsets.fromLTRB(
                12,
                4,
                12,
                10,
              ),
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TabBar(
                padding: const EdgeInsets.all(5),

                indicatorSize: TabBarIndicatorSize.tab,

                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),

                labelColor: primary,
                unselectedLabelColor: Colors.white70,

                labelStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),

                unselectedLabelStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),

                dividerColor: Colors.transparent,

                tabs: const [
                  Tab(
                    icon: Icon(
                      Icons.thermostat_rounded,
                      size: 19,
                    ),
                    text: 'Suhu',
                  ),
                  Tab(
                    icon: Icon(
                      Icons.air_rounded,
                      size: 19,
                    ),
                    text: 'Kipas',
                  ),
                  Tab(
                    icon: Icon(
                      Icons.notifications_active_outlined,
                      size: 19,
                    ),
                    text: 'Alarm',
                  ),
                  Tab(
                    icon: Icon(
                      Icons.lightbulb_outline_rounded,
                      size: 19,
                    ),
                    text: 'Lampu',
                  ),
                ],
              ),
            ),
          ),
        ),

        // =====================================================
        // CONTENT
        // =====================================================

        body: const TabBarView(
          children: [
            KandangSuhu(),
            KandangKipas(),
            KandangAlarm(),
            KandangLampu(),
          ],
        ),
      ),
    );
  }
}