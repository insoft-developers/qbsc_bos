
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/fungsi.dart';
import 'package:qbsc_saas/app/views/absensi/absensi_controller.dart';
import 'package:qbsc_saas/app/views/absensi/absensi_detail.dart';
import 'package:qbsc_saas/app/views/absensi/absensi_model.dart';

class Absensi extends StatefulWidget {
  const Absensi({super.key});

  @override
  State<Absensi> createState() => _AbsensiState();
}

class _AbsensiState extends State<Absensi> {
  final AbsensiController controller = Get.put(AbsensiController());
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        controller.isMoreDataAvailable.value &&
        !controller.isLoading.value) {
      controller.getDataAbsensi(loadMore: true);
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  // =========================================================
  // FILTER
  // =========================================================

  void _showFilterBottomSheet() {
    int? selectedSatpamId = controller.selectedSatpamId.value;
    String? selectedStatus = controller.status.value;
    DateTime? startDate;
    DateTime? endDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 30,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  12,
                  20,
                  20,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // =====================================================
                    // HANDLE
                    // =====================================================

                    Center(
                      child: Container(
                        width: 42,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // =====================================================
                    // HEADER
                    // =====================================================

                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.tune_rounded,
                            color: Color(0xFF2563EB),
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Filter Absensi',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Sesuaikan data yang ingin ditampilkan',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // =====================================================
                    // TANGGAL
                    // =====================================================

                    const Text(
                      'Rentang Tanggal',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF334155),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Expanded(
                          child: _filterDateButton(
                            icon: Icons.calendar_today_outlined,
                            label: startDate == null
                                ? 'Tanggal Mulai'
                                : Fungsi.tanggalIndo(
                                    startDate!
                                        .toIso8601String()
                                        .substring(0, 10),
                                  ),
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime.now(),
                              );

                              if (date != null) {
                                setState(() {
                                  startDate = date;
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _filterDateButton(
                            icon: Icons.event_outlined,
                            label: endDate == null
                                ? 'Tanggal Akhir'
                                : Fungsi.tanggalIndo(
                                    endDate!
                                        .toIso8601String()
                                        .substring(0, 10),
                                  ),
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime.now(),
                              );

                              if (date != null) {
                                setState(() {
                                  endDate = date;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // =====================================================
                    // SATPAM
                    // =====================================================

                    const Text(
                      'Satpam',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF334155),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Obx(() {
                      return DropdownButtonFormField<int>(
                        value: selectedSatpamId,
                        isExpanded: true,
                        decoration: _filterDecoration(
                          Icons.person_outline_rounded,
                          'Pilih Satpam',
                        ),
                        items: [
                          const DropdownMenuItem<int>(
                            value: null,
                            child: Text(
                              'Semua Satpam',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          ...controller.satpamList.map(
                            (s) => DropdownMenuItem<int>(
                              value: s.id,
                              child: Text(
                                s.name,
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedSatpamId = value;
                          });
                        },
                      );
                    }),

                    const SizedBox(height: 16),

                    // =====================================================
                    // STATUS
                    // =====================================================

                    const Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF334155),
                      ),
                    ),

                    const SizedBox(height: 8),

                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      decoration: _filterDecoration(
                        Icons.verified_outlined,
                        'Pilih Status',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: '1',
                          child: Text(
                            'Masuk',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        DropdownMenuItem(
                          value: '2',
                          child: Text(
                            'Pulang',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedStatus = value;
                        });
                      },
                    ),

                    const SizedBox(height: 24),

                    // =====================================================
                    // ACTION
                    // =====================================================

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              controller.clearFilter();
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(
                                double.infinity,
                                50,
                              ),
                              side: const BorderSide(
                                color: Color(0xFFE2E8F0),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              'Reset',
                              style: TextStyle(
                                color: Color(0xFF475569),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.applyFilter(
                                start: startDate
                                    ?.toIso8601String()
                                    .substring(0, 10),
                                end: endDate
                                    ?.toIso8601String()
                                    .substring(0, 10),
                                satpamId: selectedSatpamId,
                                statusValue: selectedStatus,
                              );

                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(
                                double.infinity,
                                50,
                              ),
                              elevation: 0,
                              backgroundColor:
                                  const Color(0xFF2563EB),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              'Terapkan Filter',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),

      // =====================================================
      // APP BAR
      // =====================================================

      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xFF0F172A),
        titleSpacing: 18,

        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monitoring Absensi',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Pantau aktivitas kehadiran satpam',
              style: TextStyle(
                color: Color(0xFFCBD5E1),
                fontSize: 10,
              ),
            ),
          ],
        ),

        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              tooltip: 'Filter',
              onPressed: _showFilterBottomSheet,
              icon: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),

      // =====================================================
      // REFRESH BUTTON
      // =====================================================

      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: const Color(0xFF2563EB),
          onPressed: () {
            controller.refreshData();
          },
          child: const Icon(
            Icons.refresh_rounded,
            color: Colors.white,
          ),
        ),
      ),

      // =====================================================
      // BODY
      // =====================================================

      body: Obx(() {
        // ===================================================
        // LOADING
        // ===================================================

        if (controller.isLoading.value &&
            controller.absensiList.isEmpty) {
          return const _LoadingAbsensi();
        }

        // ===================================================
        // EMPTY
        // ===================================================

        if (!controller.isLoading.value &&
            controller.absensiList.isEmpty) {
          return const _EmptyAbsensi();
        }

        // ===================================================
        // LIST
        // ===================================================

        return ListView.builder(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            16,
            18,
            16,
            90,
          ),
          itemCount:
              controller.absensiList.length +
              (controller.isMoreDataAvailable.value ? 1 : 0),
          itemBuilder: (context, index) {
            // =================================================
            // LOADING MORE
            // =================================================

            if (index >= controller.absensiList.length) {
              return const Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                  ),
                ),
              );
            }

            final AbsensiModel absensi =
                controller.absensiList[index];

            return _AbsensiCard(
              absensi: absensi,
              onTap: () {
                Get.to(
                  () => AbsensiDetail(
                    data: absensi,
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }

  // =========================================================
  // FILTER DATE BUTTON
  // =========================================================

  Widget _filterDateButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 17,
              color: const Color(0xFF64748B),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF475569),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // FILTER DECORATION
  // =========================================================

  InputDecoration _filterDecoration(
    IconData icon,
    String label,
  ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(
        icon,
        size: 19,
        color: const Color(0xFF64748B),
      ),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFFE2E8F0),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFF2563EB),
          width: 1.4,
        ),
      ),
    );
  }
}

// =============================================================
// ABSENSI CARD
// =============================================================

class _AbsensiCard extends StatelessWidget {
  final AbsensiModel absensi;
  final VoidCallback onTap;

  const _AbsensiCard({
    required this.absensi,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMasuk = absensi.status == 1;

    final String statusText =
        isMasuk ? 'MASUK' : 'PULANG';

    final String tanggal =
        Fungsi.tanggalIndo(absensi.tanggal);

    final String jamMasuk =
        Fungsi.formatToTime(
      absensi.jamMasuk,
    );

    final String jamKeluar =
        Fungsi.formatToTime(
      absensi.jamKeluar ?? '',
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFE8EDF3),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.035),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
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
                    // AVATAR
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isMasuk
                              ? const [
                                  Color(0xFF2563EB),
                                  Color(0xFF1D4ED8),
                                ]
                              : const [
                                  Color(0xFF7C3AED),
                                  Color(0xFF6D28D9),
                                ],
                        ),
                        borderRadius:
                            BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),

                    const SizedBox(width: 13),

                    // NAME
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            absensi.namaSatpam,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight:
                                  FontWeight.w800,
                              color:
                                  Color(0xFF111827),
                            ),
                          ),

                          const SizedBox(height: 5),

                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 12,
                                color:
                                    Color(0xFF94A3B8),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                tanggal,
                                style:
                                    const TextStyle(
                                  fontSize: 10,
                                  color:
                                      Color(0xFF64748B),
                                  fontWeight:
                                      FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // STATUS
                    _StatusBadge(
                      text: statusText,
                      isMasuk: isMasuk,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // =================================================
                // INFO GRID
                // =================================================

                Container(
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _InfoItem(
                          icon:
                              Icons.work_history_outlined,
                          label: 'Shift',
                          value:
                              absensi.shiftName ?? '',
                        ),
                      ),

                      Container(
                        width: 1,
                        height: 34,
                        color:
                            const Color(0xFFE2E8F0),
                      ),

                      Expanded(
                        child: _InfoItem(
                          icon:
                              Icons.login_rounded,
                          label: 'Masuk',
                          value: jamMasuk,
                        ),
                      ),

                      Container(
                        width: 1,
                        height: 34,
                        color:
                            const Color(0xFFE2E8F0),
                      ),

                      Expanded(
                        child: _InfoItem(
                          icon:
                              Icons.logout_rounded,
                          label: 'Pulang',
                          value: jamKeluar.isEmpty
                              ? '-'
                              : jamKeluar,
                        ),
                      ),
                    ],
                  ),
                ),

                // =================================================
                // CATATAN
                // =================================================

                if ((absensi.catatanMasuk
                            ?.isNotEmpty ??
                        false) ||
                    (absensi.catatanKeluar
                            ?.isNotEmpty ??
                        false)) ...[
                  const SizedBox(height: 12),

                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.notes_rounded,
                        size: 17,
                        color: Color(0xFF94A3B8),
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: Text(
                          '${absensi.catatanMasuk ?? '-'}'
                          ' | '
                          '${absensi.catatanKeluar ?? '-'}',
                          maxLines: 2,
                          overflow:
                              TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10.5,
                            height: 1.4,
                            color:
                                Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                // =================================================
                // FOTO
                // =================================================

                if ((absensi.fotoMasuk
                            ?.isNotEmpty ??
                        false) ||
                    (absensi.fotoKeluar
                            ?.isNotEmpty ??
                        false)) ...[
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      if (absensi.fotoMasuk
                              ?.isNotEmpty ??
                          false)
                        Expanded(
                          child: _PhotoPreview(
                            url:
                                '${ApiProvider.imageUrl}/${absensi.fotoMasuk}',
                            label: 'MASUK',
                          ),
                        ),

                      if ((absensi.fotoMasuk
                                  ?.isNotEmpty ??
                              false) &&
                          (absensi.fotoKeluar
                                  ?.isNotEmpty ??
                              false))
                        const SizedBox(width: 9),

                      if (absensi.fotoKeluar
                              ?.isNotEmpty ??
                          false)
                        Expanded(
                          child: _PhotoPreview(
                            url:
                                '${ApiProvider.imageUrl}/${absensi.fotoKeluar}',
                            label: 'PULANG',
                          ),
                        ),
                    ],
                  ),
                ],

                const SizedBox(height: 14),

                // =================================================
                // DETAIL
                // =================================================

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.end,
                  children: [
                    const Text(
                      'Lihat detail',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      width: 23,
                      height: 23,
                      decoration: BoxDecoration(
                        color:
                            const Color(0xFFEFF6FF),
                        borderRadius:
                            BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color:
                            Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================
// STATUS BADGE
// =============================================================

class _StatusBadge extends StatelessWidget {
  final String text;
  final bool isMasuk;

  const _StatusBadge({
    required this.text,
    required this.isMasuk,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: isMasuk
            ? const Color(0xFFECFDF5)
            : const Color(0xFFF5F3FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isMasuk
                  ? const Color(0xFF16A34A)
                  : const Color(0xFF7C3AED),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              color: isMasuk
                  ? const Color(0xFF15803D)
                  : const Color(0xFF6D28D9),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// INFO ITEM
// =============================================================

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 16,
          color: const Color(0xFF64748B),
        ),

        const SizedBox(height: 5),

        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            color: Color(0xFF94A3B8),
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 2),

        Text(
          value.isEmpty ? '-' : value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Color(0xFF334155),
          ),
        ),
      ],
    );
  }
}

// =============================================================
// PHOTO PREVIEW
// =============================================================

class _PhotoPreview extends StatelessWidget {
  final String url;
  final String label;

  const _PhotoPreview({
    required this.url,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            color: Color(0xFF64748B),
            letterSpacing: 0.4,
          ),
        ),

        const SizedBox(height: 6),

        ClipRRect(
          borderRadius:
              BorderRadius.circular(12),
          child: Image.network(
            url,
            width: double.infinity,
            height: 115,
            fit: BoxFit.cover,

            errorBuilder:
                (_, __, ___) {
              return Container(
                height: 115,
                decoration: BoxDecoration(
                  color:
                      const Color(0xFFF1F5F9),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(
                    Icons
                        .image_not_supported_outlined,
                    color:
                        Color(0xFF94A3B8),
                    size: 28,
                  ),
                ),
              );
            },

            loadingBuilder:
                (context, child, progress) {
              if (progress == null) {
                return child;
              }

              return Container(
                height: 115,
                decoration: BoxDecoration(
                  color:
                      const Color(0xFFF1F5F9),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: const Center(
                  child:
                      CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// =============================================================
// LOADING
// =============================================================

class _LoadingAbsensi extends StatelessWidget {
  const _LoadingAbsensi();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: List.generate(
        5,
        (index) {
          return Container(
            height: 220,
            margin:
                const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(20),
            ),
            child: const Center(
              child:
                  CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          );
        },
      ),
    );
  }
}

// =============================================================
// EMPTY
// =============================================================

class _EmptyAbsensi extends StatelessWidget {
  const _EmptyAbsensi();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(35),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color:
                    const Color(0xFFEFF6FF),
                borderRadius:
                    BorderRadius.circular(26),
              ),
              child: const Icon(
                Icons
                    .event_busy_rounded,
                size: 40,
                color:
                    Color(0xFF2563EB),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Data Absensi Tidak Ditemukan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color:
                    Color(0xFF111827),
              ),
            ),

            const SizedBox(height: 7),

            Text(
              'Belum ada data yang sesuai dengan '
              'filter atau rentang tanggal yang dipilih.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                height: 1.5,
                color:
                    Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
