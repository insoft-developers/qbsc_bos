import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/controllers/paket_controller.dart';
import 'package:qbsc_saas/app/data/api_endpoint.dart';
import 'package:qbsc_saas/app/utils/app_prefs.dart';
import 'package:qbsc_saas/app/views/home/card_absensi.dart';
import 'package:qbsc_saas/app/views/home/card_satpam_detail.dart';
import 'package:qbsc_saas/app/views/kinerja/kinerja.dart';
import 'package:qbsc_saas/app/views/laporan/resume_kandang.dart';
import 'package:qbsc_saas/app/views/master/jadwal_patroli/index.dart';
import 'package:qbsc_saas/app/views/master/lokasi/index.dart';
import 'package:qbsc_saas/app/views/master/satpam/index.dart';
import 'package:qbsc_saas/app/views/master/user/index.dart';
import 'package:qbsc_saas/app/views/tracking/live/live_map.dart';
import 'package:qbsc_saas/app/views/tracking/rute/rute.dart';
import 'package:qbsc_saas/app/views/user_area/user_area_model.dart';

class UserArea extends StatelessWidget {
  final String menu;

  const UserArea({
    super.key,
    required this.menu,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PaketController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),

      // =====================================================
      // APP BAR
      // =====================================================
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xFF0F172A),

        titleSpacing: 20,

        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih Perusahaan',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Pilih perusahaan untuk melanjutkan',
              style: TextStyle(
                color: Color(0xFFCBD5E1),
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),

        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: IconButton(
              tooltip: 'Refresh',
              onPressed: () {
                controller.refreshData();
              },
              icon: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
                child: const Icon(
                  Icons.refresh_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),

      // =====================================================
      // BODY
      // =====================================================
      body: Obx(() {
        // ===================================================
        // LOADING
        // ===================================================
        if (controller.isLoading.value) {
          return const _LoadingView();
        }

        // ===================================================
        // EMPTY
        // ===================================================
        if (controller.areaList.isEmpty) {
          return const _EmptyView();
        }

        return RefreshIndicator(
          color: const Color(0xFF2563EB),
          backgroundColor: Colors.white,
          strokeWidth: 2.5,
          onRefresh: () async {
            controller.refreshData();
          },

          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              18,
              20,
              18,
              30,
            ),
            children: [
              // =============================================
              // HEADER INFO
              // =============================================
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF0F172A),
                      Color(0xFF1E293B),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // ICON
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.10),
                        ),
                      ),
                      child: const Icon(
                        Icons.business_rounded,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),

                    const SizedBox(width: 14),

                    // TEXT
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Perusahaan Anda',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            '${controller.areaList.length} perusahaan tersedia',
                            style: const TextStyle(
                              color: Color(0xFFCBD5E1),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // BADGE
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${controller.areaList.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // =============================================
              // SECTION TITLE
              // =============================================
              const Padding(
                padding: EdgeInsets.only(left: 2),
                child: Text(
                  'Daftar Perusahaan',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),

              const SizedBox(height: 4),

              const Padding(
                padding: EdgeInsets.only(left: 2),
                child: Text(
                  'Pilih perusahaan yang ingin Anda kelola',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // =============================================
              // COMPANY LIST
              // =============================================
              ...List.generate(
                controller.areaList.length,
                (index) {
                  final UserAreaModel data =
                      controller.areaList[index];

                  return _CompanyCard(
                    data: data,
                    index: index,
                    onTap: () async {
                      await AppPrefs.setMonComId(
                        data.monitoringComId.toString(),
                      );

                      if (menu == 'resume') {
                        final comid =
                            AppPrefs.getMonComId().toString();

                        final token =
                            AppPrefs.getToken().toString();

                        Get.to(
                          () => ResumeKandang(
                            url:
                                '${ApiEndpoint.webviewResumeKandang}/$comid?token=$token',
                            title: 'Resume Kandang',
                          ),
                        );
                      } else if (menu == 'card-absensi') {
                        Get.to(
                          () => CardAbsensi(),
                        );
                      } else if (menu == 'card-satpam') {
                        Get.to(
                          () => CardSatpamDetail(),
                        );
                      } else if (menu == 'laporan-kinerja') {
                        Get.to(
                          () => Kinerja(),
                        );
                      } else if (menu == 'rute') {
                        Get.to(
                          () => RutePage(),
                        );
                      } else if (menu == 'live-tracking') {
                        Get.to(
                          () => LiveMapView(),
                        );
                      } else if (menu == 'master-satpam') {
                        Get.to(
                          () => SatpamPage(),
                        );
                      } else if (menu == 'master-user') {
                        Get.to(
                          () => UserPage(),
                        );
                      } else if (menu == 'master-lokasi') {
                        Get.to(
                          () => LokasiPage(),
                        );
                      } else if (menu == 'master-jadwal') {
                        Get.to(
                          () => JadwalPatroliPage(),
                        );
                      } else {
                        Get.toNamed(
                          '/$menu',
                        );
                      }
                    },
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}

// =========================================================
// COMPANY CARD
// =========================================================

class _CompanyCard extends StatelessWidget {
  final UserAreaModel data;
  final int index;
  final VoidCallback onTap;

  const _CompanyCard({
    required this.data,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        elevation: 0,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),

          child: Container(
            padding: const EdgeInsets.all(15),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFFE5E7EB),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.035),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),

            child: Row(
              children: [
                // =========================================
                // COMPANY ICON
                // =========================================
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF2563EB),
                        Color(0xFF1D4ED8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2563EB)
                            .withOpacity(0.20),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.apartment_rounded,
                    color: Colors.white,
                    size: 27,
                  ),
                ),

                const SizedBox(width: 15),

                // =========================================
                // COMPANY INFO
                // =========================================
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.monitoringComName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.25,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111827),
                        ),
                      ),

                      const SizedBox(height: 7),

                      Row(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: Color(0xFF22C55E),
                              shape: BoxShape.circle,
                            ),
                          ),

                          const SizedBox(width: 6),

                          const Text(
                            'Perusahaan tersedia',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // =========================================
                // ARROW
                // =========================================
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: Color(0xFF475569),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =========================================================
// LOADING VIEW
// =========================================================

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(18),
      children: [
        Container(
          height: 82,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),

        const SizedBox(height: 24),

        ...List.generate(
          5,
          (index) {
            return Container(
              height: 86,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
            );
          },
        ),
      ],
    );
  }
}

// =========================================================
// EMPTY VIEW
// =========================================================

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.business_outlined,
                size: 38,
                color: Color(0xFF2563EB),
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Belum Ada Perusahaan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827),
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'Tidak ada perusahaan yang tersedia untuk akun Anda.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
