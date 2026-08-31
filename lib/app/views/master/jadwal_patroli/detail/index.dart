import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:qbsc_saas/app/views/master/jadwal_patroli/detail/add.dart';
import 'package:qbsc_saas/app/views/master/jadwal_patroli/detail/edit.dart';
import 'package:qbsc_saas/app/views/master/jadwal_patroli/detail/jadwal_patroli_detail_controller.dart';

class JadwalPatroliDetailPage extends StatefulWidget {
  final int jadwalId;

  const JadwalPatroliDetailPage({super.key, required this.jadwalId});

  @override
  State<JadwalPatroliDetailPage> createState() =>
      _JadwalPatroliDetailPageState();
}

class _JadwalPatroliDetailPageState extends State<JadwalPatroliDetailPage> {
  final controller = Get.put(JadwalPatroliDetailController());

  @override
  void initState() {
    super.initState();

    controller.getJadwalDetail(widget.jadwalId);
  }

  Future<void> _onRefresh() async {
    await controller.getJadwalDetail(widget.jadwalId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      // =========================================================
      // APP BAR
      // =========================================================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF111827),
        foregroundColor: Colors.white,

        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detail Jadwal Patroli',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Daftar lokasi dan urutan patroli',
              style: TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ],
        ),

        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // =========================================================
      // BODY
      // =========================================================
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.jadwalPatroliDetailList.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 2.5),
          );
        }

        if (controller.jadwalPatroliDetailList.isEmpty) {
          return RefreshIndicator(
            color: const Color(0xFF2563EB),
            onRefresh: _onRefresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.28),
                _buildEmptyState(),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: const Color(0xFF2563EB),
          backgroundColor: Colors.white,
          onRefresh: _onRefresh,

          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),

            padding: const EdgeInsets.fromLTRB(16, 18, 16, 100),

            itemCount: controller.jadwalPatroliDetailList.length,

            itemBuilder: (context, index) {
              final lokasi = controller.jadwalPatroliDetailList[index];

              return _buildLocationCard(
                context,
                lokasi,
                index,
                controller.jadwalPatroliDetailList.length,
              );
            },
          ),
        );
      }),

      // =========================================================
      // FAB
      // =========================================================
      floatingActionButton: FloatingActionButton.extended(
        elevation: 4,
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,

        onPressed: () async {
          await Get.to(
            () => JadwalPatroliDetailAddPage(jadwalId: widget.jadwalId),
          );

          controller.getJadwalDetail(widget.jadwalId);
        },

        icon: const Icon(Icons.add_rounded, size: 21),

        label: const Text(
          'Tambah Lokasi',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  // =============================================================
  // LOCATION CARD
  // =============================================================

  Widget _buildLocationCard(
    BuildContext context,
    dynamic lokasi,
    int index,
    int total,
  ) {
    final int nomor = int.tryParse(lokasi.urutan.toString()) ?? (index + 1);

    final bool isFirst = index == 0;

    final bool isLast = index == total - 1;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        // =======================================================
        // TIMELINE
        // =======================================================
        SizedBox(
          width: 42,
          child: Column(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFBFDBFE), width: 2),
                ),
                child: Center(
                  child: Text(
                    '$nomor',
                    style: const TextStyle(
                      color: Color(0xFF2563EB),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

              if (!isLast)
                Container(
                  width: 2,
                  height: 115,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  color: const Color(0xFFDBEAFE),
                ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        // =======================================================
        // CARD
        // =======================================================
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 14),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),

              border: Border.all(color: const Color(0xFFE5E7EB)),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.035),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),

            child: Material(
              color: Colors.transparent,

              child: InkWell(
                borderRadius: BorderRadius.circular(18),

                onLongPress: () {},

                child: Padding(
                  padding: const EdgeInsets.all(15),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      // =========================================
                      // HEADER
                      // =========================================
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(
                                  lokasi.locationName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF111827),
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Row(
                                  children: [
                                    Icon(
                                      Icons.route_outlined,
                                      size: 13,
                                      color: Colors.grey.shade500,
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        lokasi.patroliName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 8),

                          // URUTAN BADGE
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0FDF4),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Stop $nomor',
                              style: const TextStyle(
                                color: Color(0xFF16A34A),
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // =========================================
                      // INFO ROW
                      // =========================================
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoItem(
                              icon: Icons.schedule_outlined,
                              label: 'Waktu',
                              value: '${lokasi.jamAwal} - ${lokasi.jamAkhir}',
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: _buildInfoItem(
                              icon: Icons.business_outlined,
                              label: 'Perusahaan',
                              value: lokasi.comName,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // =========================================
                      // DIVIDER
                      // =========================================
                      Container(height: 1, color: const Color(0xFFF0F1F3)),

                      const SizedBox(height: 12),

                      // =========================================
                      // ACTION
                      // =========================================
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.edit_outlined,
                              label: 'Edit',
                              color: const Color(0xFF2563EB),
                              onPressed: () async {
                                final result = await Get.to(
                                  () => JadwalPatroliDetailEditPage(
                                    detail: lokasi,
                                  ),
                                );

                                if (result == true) {
                                  await controller.getJadwalDetail(
                                    widget.jadwalId,
                                  );
                                }
                              },
                            ),
                          ),

                          const SizedBox(width: 8),

                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.delete_outline_rounded,
                              label: 'Hapus',
                              color: const Color(0xFFDC2626),
                              onPressed: () {
                                _showDeleteDialog(context, lokasi);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =============================================================
  // INFO ITEM
  // =============================================================

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(11),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Icon(icon, size: 16, color: const Color(0xFF64748B)),

          const SizedBox(width: 7),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF334155),
                    fontWeight: FontWeight.w700,
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
  // ACTION BUTTON
  // =============================================================

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 38,

      child: ElevatedButton(
        onPressed: onPressed,

        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: color.withOpacity(0.09),
          foregroundColor: color,

          padding: const EdgeInsets.symmetric(horizontal: 8),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(icon, size: 16),

            const SizedBox(width: 5),

            Text(
              label,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // DELETE DIALOG
  // =============================================================

  void _showDeleteDialog(BuildContext context, dynamic lokasi) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 10),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),

          // =====================================================
          // TITLE
          // =====================================================
          title: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red,
                  size: 22,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Text(
                  'Hapus Lokasi?',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
            ],
          ),

          // =====================================================
          // CONTENT
          // =====================================================
          content: Text(
            'Apakah Anda yakin ingin menghapus lokasi '
            '"${lokasi.locationName}" dari jadwal patroli?',
            style: TextStyle(
              fontSize: 12,
              height: 1.5,
              color: Colors.grey.shade700,
            ),
          ),

          // =====================================================
          // ACTION
          // =====================================================
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                'Batal',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogContext);

                await controller.deleteData(lokasi.id.toString());
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 11,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.delete_outline_rounded, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'Hapus',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
  // =============================================================
  // EMPTY STATE
  // =============================================================

  Widget _buildEmptyState() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,

          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(24),
          ),

          child: const Icon(
            Icons.route_outlined,
            size: 38,
            color: Color(0xFF2563EB),
          ),
        ),

        const SizedBox(height: 18),

        const Text(
          'Belum Ada Lokasi',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF111827),
          ),
        ),

        const SizedBox(height: 6),

        Text(
          'Belum ada lokasi patroli pada jadwal ini.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
