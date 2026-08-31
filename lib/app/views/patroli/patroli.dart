
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/fungsi.dart';
import 'package:qbsc_saas/app/views/patroli/patroli_controller.dart';
import 'package:qbsc_saas/app/views/patroli/patroli_detail.dart';

class Patroli extends StatefulWidget {
  const Patroli({super.key});

  @override
  State<Patroli> createState() => _PatroliState();
}

class _PatroliState extends State<Patroli> {
  final PatroliController controller = Get.put(PatroliController());
  final ScrollController scrollController = ScrollController();

  static const Color primary = Color(0xFF2563EB);
  static const Color dark = Color(0xFF0F172A);
  static const Color background = Color(0xFFF6F8FC);
  static const Color textGrey = Color(0xFF64748B);

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
      controller.fetchPatroli(loadMore: true);
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
    int? selectedLocationId = controller.selectedLocationId.value;

    DateTime? startDate = controller.startDate.value != null
        ? DateTime.parse(controller.startDate.value!)
        : null;

    DateTime? endDate = controller.endDate.value != null
        ? DateTime.parse(controller.endDate.value!)
        : null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 30,
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
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // HANDLE
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

                      // HEADER
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
                              color: primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Filter Patroli',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: dark,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  'Tentukan data patroli yang ingin ditampilkan',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    color: textGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      _filterLabel('Rentang Tanggal'),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Expanded(
                            child: _dateButton(
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
                                  initialDate:
                                      startDate ?? DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime.now(),
                                );

                                if (date != null) {
                                  setState(() => startDate = date);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _dateButton(
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
                                  initialDate:
                                      endDate ?? DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime.now(),
                                );

                                if (date != null) {
                                  setState(() => endDate = date);
                                }
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      _filterLabel('Satpam'),

                      const SizedBox(height: 8),

                      Obx(() {
                        return DropdownButtonFormField<int?>(
                          value: selectedSatpamId,
                          isExpanded: true,
                          decoration: _inputDecoration(
                            Icons.person_outline_rounded,
                            'Semua Satpam',
                          ),
                          items: [
                            const DropdownMenuItem<int?>(
                              value: null,
                              child: Text(
                                'Semua Satpam',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            ...controller.satpamList.map(
                              (s) => DropdownMenuItem<int?>(
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

                      const SizedBox(height: 18),

                      _filterLabel('Lokasi'),

                      const SizedBox(height: 8),

                      Obx(() {
                        return DropdownButtonFormField<int?>(
                          value: selectedLocationId,
                          isExpanded: true,
                          decoration: _inputDecoration(
                            Icons.location_on_outlined,
                            'Semua Lokasi',
                          ),
                          items: [
                            const DropdownMenuItem<int?>(
                              value: null,
                              child: Text(
                                'Semua Lokasi',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            ...controller.lokasiList.map(
                              (l) => DropdownMenuItem<int?>(
                                value: l.id,
                                child: Text(
                                  l.locationName,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedLocationId = value;
                            });
                          },
                        );
                      }),

                      const SizedBox(height: 24),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                controller.clearFilter();
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                minimumSize:
                                    const Size(double.infinity, 50),
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
                                  locationId: selectedLocationId,
                                );

                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize:
                                    const Size(double.infinity, 50),
                                elevation: 0,
                                backgroundColor: primary,
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
                ),
              );
            },
          ),
        );
      },
    );
  }

  // =========================================================
  // LOGIC JAM RANGE
  // =========================================================

  bool _isJamDalamRange({
    required String? jam,
    required String? jamAwal,
    required String? jamAkhir,
  }) {
    if (jam == null ||
        jamAwal == null ||
        jamAkhir == null ||
        jam.isEmpty ||
        jamAwal.isEmpty ||
        jamAkhir.isEmpty) {
      return false;
    }

    DateTime? parse(String v) {
      final p = v.split(':');
      if (p.length < 2) return null;

      return DateTime(
        2000,
        1,
        1,
        int.parse(p[0]),
        int.parse(p[1]),
      );
    }

    final check = parse(jam);
    var start = parse(jamAwal);
    var end = parse(jamAkhir);

    if (check == null || start == null || end == null) {
      return false;
    }

    if (end.isBefore(start)) {
      end = end.add(const Duration(days: 1));

      if (check.isBefore(start)) {
        return check
            .add(const Duration(days: 1))
            .isBefore(end);
      }
    }

    return check.isAfter(start) &&
        check.isBefore(end);
  }

  // =========================================================
  // UI
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      // =====================================================
      // APP BAR
      // =====================================================

      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: dark,
        titleSpacing: 18,

        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monitoring Patroli',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Pantau aktivitas patroli secara realtime',
              style: TextStyle(
                color: Color(0xFFCBD5E1),
                fontSize: 10,
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
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
                size: 19,
              ),
            ),
          ),

          const SizedBox(width: 5),
        ],
      ),

      // =====================================================
      // REFRESH
      // =====================================================

      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 16,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: primary,
          onPressed: controller.refreshData,
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
        if (controller.isLoading.value &&
            controller.patroliList.isEmpty) {
          return const _LoadingView();
        }

        if (!controller.isLoading.value &&
            controller.patroliList.isEmpty) {
          return const _EmptyView();
        }

        return ListView.builder(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            16,
            18,
            16,
            100,
          ),
          itemCount:
              controller.patroliList.length +
              (controller.isMoreDataAvailable.value ? 1 : 0),
          itemBuilder: (context, i) {
            if (i >= controller.patroliList.length) {
              return const Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                  ),
                ),
              );
            }

            final p = controller.patroliList[i];

            final isOut = !_isJamDalamRange(
              jam: p.jam,
              jamAwal: p.jamAwal ?? '',
              jamAkhir: p.jamAkhir ?? '',
            );

            return _PatroliCard(
              data: p,
              isOut: isOut,
              onTap: () {
                Get.to(
                  () => PatroliDetail(data: p),
                );
              },
            );
          },
        );
      }),
    );
  }

  // =========================================================
  // FILTER LABEL
  // =========================================================

  Widget _filterLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Color(0xFF334155),
      ),
    );
  }

  // =========================================================
  // DATE BUTTON
  // =========================================================

  Widget _dateButton({
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
          vertical: 14,
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
              color: textGrey,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10.5,
                  color: textGrey,
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
  // INPUT DECORATION
  // =========================================================

  InputDecoration _inputDecoration(
    IconData icon,
    String label,
  ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(
        icon,
        size: 19,
        color: textGrey,
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
          color: primary,
          width: 1.3,
        ),
      ),
    );
  }
}

// =============================================================
// PATROLI CARD
// =============================================================

class _PatroliCard extends StatelessWidget {
  final dynamic data;
  final bool isOut;
  final VoidCallback onTap;

  const _PatroliCard({
    required this.data,
    required this.isOut,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(21),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(21),

              border: Border.all(
                color: isOut
                    ? const Color(0xFFFECACA)
                    : const Color(0xFFE8EDF3),
                width: isOut ? 1.3 : 1,
              ),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.035),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                // =================================================
                // FOTO
                // =================================================

                if (data.foto != null &&
                    data.foto!.isNotEmpty)
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        Image.network(
                          "${ApiProvider.imageUrl}/${data.foto!}",
                          height: 190,
                          width: double.infinity,
                          fit: BoxFit.cover,

                          errorBuilder:
                              (_, __, ___) {
                            return Container(
                              height: 190,
                              color:
                                  const Color(0xFFF1F5F9),
                              child: const Center(
                                child: Icon(
                                  Icons
                                      .image_not_supported_outlined,
                                  size: 38,
                                  color:
                                      Color(0xFF94A3B8),
                                ),
                              ),
                            );
                          },

                          loadingBuilder:
                              (context,
                                  child,
                                  progress) {
                            if (progress == null) {
                              return child;
                            }

                            return Container(
                              height: 190,
                              color:
                                  const Color(0xFFF8FAFC),
                              child: const Center(
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                        ),

                        // STATUS
                        Positioned(
                          top: 12,
                          right: 12,
                          child: _StatusBadge(
                            isOut: isOut,
                          ),
                        ),
                      ],
                    ),
                  ),

                if (data.foto != null &&
                    data.foto!.isNotEmpty)
                  const SizedBox(height: 15),

                // =================================================
                // HEADER
                // =================================================

                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: isOut
                            ? const Color(0xFFFEF2F2)
                            : const Color(0xFFECFDF5),
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                      child: Icon(
                        isOut
                            ? Icons
                                .warning_amber_rounded
                            : Icons
                                .verified_rounded,
                        size: 23,
                        color: isOut
                            ? const Color(0xFFDC2626)
                            : const Color(0xFF16A34A),
                      ),
                    ),

                    const SizedBox(width: 11),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.locationName,
                            maxLines: 2,
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
                                Icons.person_outline_rounded,
                                size: 13,
                                color:
                                    Color(0xFF94A3B8),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  data.satpamName,
                                  maxLines: 1,
                                  overflow:
                                      TextOverflow.ellipsis,
                                  style:
                                      const TextStyle(
                                    fontSize: 10.5,
                                    color:
                                        Color(0xFF64748B),
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    if (data.foto == null ||
                        data.foto!.isEmpty)
                      _StatusBadge(
                        isOut: isOut,
                      ),
                  ],
                ),

                const SizedBox(height: 15),

                // =================================================
                // DATE & TIME
                // =================================================

                Container(
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: isOut
                        ? const Color(0xFFFFF7F7)
                        : const Color(0xFFF8FAFC),
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _InfoItem(
                          icon:
                              Icons.calendar_today_outlined,
                          label: 'Tanggal',
                          value:
                              Fungsi.tanggalIndo(
                            data.tanggal,
                          ),
                        ),
                      ),

                      Container(
                        width: 1,
                        height: 35,
                        color:
                            const Color(0xFFE2E8F0),
                      ),

                      Expanded(
                        child: _InfoItem(
                          icon: Icons.access_time_rounded,
                          label: 'Jam Patroli',
                          value: data.jam ?? '-',
                          valueColor: isOut
                              ? const Color(0xFFDC2626)
                              : const Color(0xFF111827),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // =================================================
                // JADWAL
                // =================================================

                _DetailRow(
                  icon: Icons.schedule_outlined,
                  label: 'Jadwal',
                  value:
                      '${data.jamAwal ?? '-'} - ${data.jamAkhir ?? '-'}',
                ),

                const SizedBox(height: 8),

                _DetailRow(
                  icon: Icons.notes_outlined,
                  label: 'Catatan',
                  value: data.note ?? '-',
                ),

                const SizedBox(height: 13),

                // =================================================
                // FOOTER
                // =================================================

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.end,
                  children: [
                    Text(
                      'Lihat detail',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: isOut
                            ? const Color(0xFFDC2626)
                            : const Color(0xFF2563EB),
                      ),
                    ),

                    const SizedBox(width: 5),

                    Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        color: isOut
                            ? const Color(0xFFFEF2F2)
                            : const Color(0xFFEFF6FF),
                        borderRadius:
                            BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons
                            .arrow_forward_rounded,
                        size: 15,
                        color: isOut
                            ? const Color(0xFFDC2626)
                            : const Color(0xFF2563EB),
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
  final bool isOut;

  const _StatusBadge({
    required this.isOut,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: isOut
            ? const Color(0xFFFEE2E2)
            : const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isOut
                  ? const Color(0xFFDC2626)
                  : const Color(0xFF16A34A),
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 5),

          Text(
            isOut ? 'DI LUAR JADWAL' : 'SESUAI JADWAL',
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w800,
              color: isOut
                  ? const Color(0xFFB91C1C)
                  : const Color(0xFF15803D),
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
  final Color valueColor;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor = const Color(0xFF111827),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 17,
          color: const Color(0xFF64748B),
        ),

        const SizedBox(width: 9),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 9,
                  color: Color(0xFF94A3B8),
                ),
              ),

              const SizedBox(height: 3),

              Text(
                value,
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =============================================================
// DETAIL ROW
// =============================================================

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: const Color(0xFF94A3B8),
        ),

        const SizedBox(width: 9),

        SizedBox(
          width: 65,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF94A3B8),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Text(
            value,
            maxLines: 2,
            overflow:
                TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10.5,
              color: Color(0xFF475569),
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================
// LOADING
// =============================================================

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: List.generate(
        4,
        (index) {
          return Container(
            height: 300,
            margin:
                const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(21),
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

class _EmptyView extends StatelessWidget {
  const _EmptyView();

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
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius:
                    BorderRadius.circular(27),
              ),
              child: const Icon(
                Icons.route_outlined,
                size: 42,
                color: Color(0xFF2563EB),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Data Patroli Tidak Ditemukan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827),
              ),
            ),

            const SizedBox(height: 7),

            Text(
              'Belum ada data patroli yang sesuai '
              'dengan filter yang dipilih.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                height: 1.5,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
