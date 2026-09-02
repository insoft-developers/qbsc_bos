import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'lokasi_kunjungan_detail_controller.dart';

class LokasiKunjunganDetailPage extends StatelessWidget {
  const LokasiKunjunganDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.put(LokasiKunjunganDetailController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        title: const Text(
          'Detail Kunjungan',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshData,
        child: Obx(
          () {
            if (controller.isLoading.value &&
                controller.detailList.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                _LocationHeader(controller: controller),

                const SizedBox(height: 16),

                _FilterInfo(controller: controller),

                const SizedBox(height: 20),

                Row(
                  children: [
                    const Text(
                      'Riwayat Kunjungan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${controller.totalKunjungan}',
                        style: const TextStyle(
                          color: Color(0xFF2563EB),
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                if (controller.detailList.isEmpty)
                  _EmptyState()
                else
                  ...List.generate(
                    controller.detailList.length,
                    (index) {
                      final item =
                          controller.detailList[index];

                      return _VisitCard(
                        controller: controller,
                        item: item,
                        index: index,
                      );
                    },
                  ),

                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _LocationHeader extends StatelessWidget {
  final LokasiKunjunganDetailController controller;

  const _LocationHeader({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2563EB),
            Color(0xFF1D4ED8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.18),
            blurRadius: 15,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Obx(
        () => Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.location_on_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Lokasi Patroli',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    controller.namaLokasi.value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'QR: ${controller.qrcode.value}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterInfo extends StatelessWidget {
  final LokasiKunjunganDetailController controller;

  const _FilterInfo({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
      ),
      child: Obx(
        () => Row(
          children: [
            const Icon(
              Icons.date_range_rounded,
              color: Color(0xFF64748B),
              size: 20,
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Periode',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${controller.startDate.value}'
                    ' - '
                    '${controller.endDate.value}',
                    style: const TextStyle(
                      color: Color(0xFF334155),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VisitCard extends StatelessWidget {
  final LokasiKunjunganDetailController controller;
  final dynamic item;
  final int index;

  const _VisitCard({
    required this.controller,
    required this.item,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final isLast =
        index == controller.detailList.length - 1;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 52,
          child: Column(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF86EFAC),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Color(0xFF16A34A),
                  size: 21,
                ),
              ),

              if (!isLast)
                Container(
                  width: 2,
                  height: 90,
                  color: const Color(0xFFDCFCE7),
                ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Container(
            margin: const EdgeInsets.only(
              bottom: 12,
            ),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.025),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        controller.formatTanggal(
                          item.tanggal,
                        ),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    Text(
                      controller.formatJam(
                        item.jam,
                      ),
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF0F172A),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius:
                            BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: Color(0xFF2563EB),
                        size: 19,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Satpam',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.namaSatpam,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF1E293B),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                if (item.note != null &&
                    item.note.toString().trim().isNotEmpty) ...[
                  const SizedBox(height: 12),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.notes_rounded,
                          size: 17,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.note.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF475569),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 45,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.location_off_rounded,
            size: 55,
            color: Color(0xFFCBD5E1),
          ),
          SizedBox(height: 12),
          Text(
            'Belum ada kunjungan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF475569),
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Tidak ada patroli pada periode yang dipilih.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}