import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:qbsc_saas/app/views/master/jadwal_patroli/add.dart';
import 'package:qbsc_saas/app/views/master/jadwal_patroli/detail/index.dart';
import 'package:qbsc_saas/app/views/master/jadwal_patroli/edit.dart';
import 'package:qbsc_saas/app/views/master/jadwal_patroli/jadwal_patroli_controller.dart';

class JadwalPatroliPage extends StatefulWidget {
  const JadwalPatroliPage({super.key});

  @override
  State<JadwalPatroliPage> createState() =>
      _JadwalPatroliPageState();
}

class _JadwalPatroliPageState
    extends State<JadwalPatroliPage> {
  final controller =
      Get.put(JadwalPatroliController());

  @override
  void initState() {
    super.initState();
    controller.getDataJadwal();
  }

  Future<void> _onRefresh() async {
    await controller.getDataJadwal();
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
        centerTitle: false,

        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jadwal Patroli',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Kelola jadwal patroli security',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white70,
              ),
            ),
          ],
        ),

        actions: [
          Obx(
            () => controller.jadwalPatroliList.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(
                      right: 16,
                    ),
                    child: Center(
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white
                              .withOpacity(0.12),
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize:
                              MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.calendar_month_outlined,
                              size: 14,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${controller.jadwalPatroliList.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight:
                                    FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: Obx(
        () {
          if (controller.isLoading.value &&
              controller.jadwalPatroliList.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
              ),
            );
          }

          return RefreshIndicator(
            color: const Color(0xFF2563EB),
            backgroundColor: Colors.white,
            onRefresh: _onRefresh,

            child: controller.jadwalPatroliList.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      16,
                      16,
                      100,
                    ),
                    physics:
                        const AlwaysScrollableScrollPhysics(),
                    itemCount:
                        controller.jadwalPatroliList.length,
                    itemBuilder: (context, index) {
                      final jadwal =
                          controller
                              .jadwalPatroliList[index];

                      return _buildJadwalCard(
                        context,
                        jadwal,
                      );
                    },
                  ),
          );
        },
      ),

      // =========================================================
      // FAB
      // =========================================================

      floatingActionButton: FloatingActionButton.extended(
        elevation: 4,
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        onPressed: () async {
          await Get.to(
            () => JadwalPatroliAddPage(),
          );

          controller.getDataJadwal();
        },
        icon: const Icon(
          Icons.add_rounded,
          size: 21,
        ),
        label: const Text(
          'Tambah Jadwal',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  // =============================================================
  // JADWAL CARD
  // =============================================================

  Widget _buildJadwalCard(
    BuildContext context,
    dynamic jadwal,
  ) {
    final bool isActive =
        jadwal.isActive == 1;

    final Color statusColor = isActive
        ? const Color(0xFF16A34A)
        : const Color(0xFFDC2626);

    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
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
          borderRadius:
              BorderRadius.circular(18),

          onLongPress: () {
            Get.to(
              () => JadwalPatroliDetailPage(
                jadwalId: jadwal.id,
              ),
            );
          },

          child: Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                // =================================================
                // HEADER
                // =================================================

                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    // ICON
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(
                                0xFFEFF6FF,
                              )
                            : const Color(
                                0xFFF3F4F6,
                              ),
                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),

                      child: Icon(
                        Icons.route_rounded,
                        color: isActive
                            ? const Color(
                                0xFF2563EB,
                              )
                            : Colors.grey.shade500,
                        size: 23,
                      ),
                    ),

                    const SizedBox(width: 12),

                    // TITLE
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [
                          Text(
                            jadwal.name,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight:
                                  FontWeight.w800,
                              color:
                                  Color(0xFF111827),
                            ),
                          ),

                          const SizedBox(height: 5),

                          Row(
                            children: [
                              Icon(
                                Icons.business_outlined,
                                size: 13,
                                color:
                                    Colors.grey.shade500,
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  jadwal.comName,
                                  maxLines: 1,
                                  overflow:
                                      TextOverflow
                                          .ellipsis,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors
                                        .grey
                                        .shade600,
                                    fontWeight:
                                        FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // STATUS
                    _buildStatusBadge(
                      isActive,
                      statusColor,
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // =================================================
                // DESCRIPTION
                // =================================================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius:
                        BorderRadius.circular(12),
                  ),

                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 16,
                        color:
                            Colors.grey.shade500,
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: Text(
                          jadwal.description
                                  .toString()
                                  .trim()
                                  .isEmpty
                              ? 'Tidak ada deskripsi'
                              : jadwal.description,
                          maxLines: 2,
                          overflow:
                              TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            height: 1.4,
                            color:
                                Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // =================================================
                // DIVIDER
                // =================================================

                Container(
                  height: 1,
                  color:
                      const Color(0xFFF0F1F3),
                ),

                const SizedBox(height: 12),

                // =================================================
                // ACTION BUTTONS
                // =================================================

                Row(
                  children: [
                    // STATUS
                    Expanded(
                      child: _buildActionButton(
                        icon: isActive
                            ? Icons.pause_circle_outline
                            : Icons.play_circle_outline,
                        label: isActive
                            ? 'Nonaktif'
                            : 'Aktifkan',
                        color: isActive
                            ? const Color(
                                0xFFF59E0B,
                              )
                            : const Color(
                                0xFF16A34A,
                              ),
                        onPressed: () async {
                          await controller
                              .ubahStatusJadwal(
                            jadwal.id,
                            isActive ? 0 : 1,
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 8),

                    // EDIT
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.edit_outlined,
                        label: 'Edit',
                        color: const Color(
                          0xFF2563EB,
                        ),
                        onPressed: () async {
                          await Get.to(
                            () => JadwalPatroliEditPage(
                              jadwalPatroli: jadwal,
                            ),
                          );

                          controller
                              .getDataJadwal();
                        },
                      ),
                    ),

                    const SizedBox(width: 8),

                    // DELETE
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.delete_outline_rounded,
                        label: 'Hapus',
                        color: const Color(
                          0xFFDC2626,
                        ),
                        onPressed: () {
                          _showDeleteDialog(
                            context,
                            jadwal,
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // =================================================
                // DETAIL HINT
                // =================================================

                Center(
                  child: Text(
                    'Tekan lama untuk melihat detail',
                    style: TextStyle(
                      fontSize: 9,
                      color:
                          Colors.grey.shade400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =============================================================
  // STATUS BADGE
  // =============================================================

  Widget _buildStatusBadge(
    bool isActive,
    Color color,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            isActive
                ? 'Aktif'
                : 'Nonaktif',
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight:
                  FontWeight.w700,
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
          backgroundColor:
              color.withOpacity(0.09),
          foregroundColor: color,
          padding:
              const EdgeInsets.symmetric(
            horizontal: 8,
          ),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(11),
          ),
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                label,
                overflow:
                    TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // DELETE DIALOG
  // =============================================================

  void _showDeleteDialog(
    BuildContext context,
    dynamic jadwal,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20),
          ),

          titlePadding:
              const EdgeInsets.fromLTRB(
            24,
            24,
            24,
            8,
          ),

          contentPadding:
              const EdgeInsets.fromLTRB(
            24,
            8,
            24,
            10,
          ),

          actionsPadding:
              const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            16,
          ),

          title: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.red
                      .withOpacity(0.10),
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
                  'Hapus Jadwal?',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          content: Text(
            'Apakah Anda yakin ingin menghapus jadwal "${jadwal.name}"? Data yang sudah dihapus tidak dapat dikembalikan.',
            style: TextStyle(
              fontSize: 12,
              height: 1.5,
              color:
                  Colors.grey.shade700,
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child: Text(
                'Batal',
                style: TextStyle(
                  color:
                      Colors.grey.shade600,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () async {
                Navigator.pop(
                  dialogContext,
                );

                await controller
                    .deleteData(
                  jadwal.id.toString(),
                );
              },
              style:
                  ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor:
                    const Color(
                  0xFFDC2626,
                ),
                foregroundColor:
                    Colors.white,
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    10,
                  ),
                ),
              ),
              child: const Text(
                'Hapus',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight:
                      FontWeight.w700,
                ),
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
    return ListView(
      physics:
          const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height:
              MediaQuery.of(context).size.height *
                  0.28,
        ),

        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(
                0xFFEFF6FF,
              ),
              borderRadius:
                  BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.route_outlined,
              size: 38,
              color: Color(
                0xFF2563EB,
              ),
            ),
          ),
        ),

        const SizedBox(height: 18),

        const Center(
          child: Text(
            'Belum Ada Jadwal',
            style: TextStyle(
              fontSize: 16,
              fontWeight:
                  FontWeight.w800,
              color:
                  Color(0xFF111827),
            ),
          ),
        ),

        const SizedBox(height: 6),

        Center(
          child: Text(
            'Belum ada jadwal patroli yang tersedia.',
            style: TextStyle(
              fontSize: 11,
              color:
                  Colors.grey.shade600,
            ),
          ),
        ),

        const SizedBox(height: 18),

        Center(
          child: OutlinedButton.icon(
            onPressed: () async {
              await Get.to(
                () => JadwalPatroliAddPage(),
              );

              controller
                  .getDataJadwal();
            },
            icon: const Icon(
              Icons.add_rounded,
              size: 18,
            ),
            label: const Text(
              'Buat Jadwal',
              style: TextStyle(
                fontSize: 11,
                fontWeight:
                    FontWeight.w700,
              ),
            ),
            style:
                OutlinedButton.styleFrom(
              foregroundColor:
                  const Color(
                0xFF2563EB,
              ),
              side:
                  const BorderSide(
                color: Color(
                  0xFF2563EB,
                ),
              ),
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  11,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
