import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/views/patroli_summary/detail/lokasi_kunjungan_detail_page.dart';
import 'lokasi_kunjungan_controller.dart';
import 'lokasi_kunjungan_model.dart';

class LokasiKunjunganPage extends StatelessWidget {
  const LokasiKunjunganPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LokasiKunjunganController());

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        title: const Text(
          'Kunjungan Lokasi',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () {
              controller.refreshData();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      body: Column(
        children: [
          // ==========================================
          // FILTER
          // ==========================================
          _FilterSection(controller: controller),

          // ==========================================
          // LIST
          // ==========================================
          Expanded(
            child: Obx(() {
              // LOADING AWAL
              if (controller.isLoading.value && controller.lokasiList.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              // DATA KOSONG
              if (controller.lokasiList.isEmpty) {
                return RefreshIndicator(
                  onRefresh: controller.refreshData,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 150),

                      Center(
                        child: Icon(
                          Icons.location_off_outlined,
                          size: 60,
                          color: Colors.grey,
                        ),
                      ),

                      SizedBox(height: 15),

                      Center(
                        child: Text(
                          'Tidak ada data lokasi',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                );
              }

              // LIST DATA
              return RefreshIndicator(
                onRefresh: controller.refreshData,

                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification.metrics.pixels >=
                        notification.metrics.maxScrollExtent - 300) {
                      controller.loadMore();
                    }

                    return false;
                  },

                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),

                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),

                    itemCount:
                        controller.lokasiList.length +
                        (controller.isMoreDataAvailable.value ? 1 : 0),

                    itemBuilder: (context, index) {
                      // LOADING PAGINATION
                      if (index >= controller.lokasiList.length) {
                        return const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      }

                      final lokasi = controller.lokasiList[index];

                      return _LokasiCard(
                        lokasi: lokasi,
                        onTap: () {
                          Get.to(
                            () => const LokasiKunjunganDetailPage(),
                            arguments: {
                              'location_id': lokasi.id,
                              'nama_lokasi': lokasi.namaLokasi,
                              'qrcode': lokasi.qrcode,
                              'start_datetime': controller.startDate.value,
                              'end_datetime': controller.endDate.value,
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// FILTER SECTION
// ======================================================

class _FilterSection extends StatelessWidget {
  final LokasiKunjunganController controller;

  const _FilterSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,

      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),

      child: Column(
        children: [
          Row(
            children: [
              // ========================================
              // MULAI
              // ========================================
              Expanded(
                child: Obx(
                  () => _FilterBox(
                    label: 'Mulai',
                    value: controller.formatDisplay(controller.startDate.value),
                    icon: Icons.calendar_today_outlined,
                    onTap: () async {
                      await _selectDateTime(context, controller, true);
                    },
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // ========================================
              // SAMPAI
              // ========================================
              Expanded(
                child: Obx(
                  () => _FilterBox(
                    label: 'Sampai',
                    value: controller.formatDisplay(controller.endDate.value),
                    icon: Icons.event_outlined,
                    onTap: () async {
                      await _selectDateTime(context, controller, false);
                    },
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              // RESET
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    controller.resetFilter();
                  },
                  icon: const Icon(Icons.restart_alt, size: 18),
                  label: const Text('Reset'),
                ),
              ),

              const SizedBox(width: 10),

              // TERAPKAN
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    final start = controller.startDate.value;

                    final end = controller.endDate.value;

                    if (start == null || end == null) {
                      return;
                    }

                    controller.applyFilter(
                      start: DateTime.parse(start),
                      end: DateTime.parse(end),
                    );
                  },
                  icon: const Icon(Icons.filter_alt_outlined, size: 18),
                  label: const Text('Terapkan'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ====================================================
  // DATE TIME PICKER
  // ====================================================

  Future<void> _selectDateTime(
    BuildContext context,
    LokasiKunjunganController controller,
    bool isStart,
  ) async {
    final currentValue = isStart
        ? controller.startDate.value
        : controller.endDate.value;

    final initialDate = currentValue != null
        ? DateTime.parse(currentValue)
        : DateTime.now();

    // ================================================
    // PILIH TANGGAL
    // ================================================

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (selectedDate == null) {
      return;
    }

    // ================================================
    // PILIH JAM
    // ================================================

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: initialDate.hour,
        minute: initialDate.minute,
      ),
    );

    if (selectedTime == null) {
      return;
    }

    final result = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,

      // Start = detik 00
      // End   = detik 59
      isStart ? 0 : 59,
    );

    // ================================================
    // SIMPAN KE RX
    // ================================================

    if (isStart) {
      controller.startDate.value = _formatDateTime(result);
    } else {
      controller.endDate.value = _formatDateTime(result);
    }
  }

  String _formatDateTime(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');

    final month = date.month.toString().padLeft(2, '0');

    final day = date.day.toString().padLeft(2, '0');

    final hour = date.hour.toString().padLeft(2, '0');

    final minute = date.minute.toString().padLeft(2, '0');

    final second = date.second.toString().padLeft(2, '0');

    return '$year-$month-$day '
        '$hour:$minute:$second';
  }
}

// ======================================================
// FILTER BOX
// ======================================================

class _FilterBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  const _FilterBox({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),

        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),

        child: Row(
          children: [
            Icon(icon, size: 18, color: Theme.of(context).primaryColor),

            const SizedBox(width: 8),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
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

// ======================================================
// LOKASI CARD
// ======================================================

class _LokasiCard extends StatelessWidget {
  final LokasiKunjunganModel lokasi;
  final VoidCallback? onTap;

  const _LokasiCard({required this.lokasi, this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool belumDikunjungi = lokasi.jumlahKunjungan == 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: belumDikunjungi ? Colors.red.shade100 : Colors.grey.shade200,
        ),
      ),

      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),

          child: Padding(
            padding: const EdgeInsets.all(14),

            child: Row(
              children: [
                // =========================================
                // ICON
                // =========================================
                Container(
                  width: 48,
                  height: 48,

                  decoration: BoxDecoration(
                    color: belumDikunjungi
                        ? Colors.red.shade50
                        : Colors.green.shade50,

                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Icon(
                    belumDikunjungi
                        ? Icons.location_off_outlined
                        : Icons.location_on_outlined,

                    color: belumDikunjungi ? Colors.red : Colors.green,

                    size: 25,
                  ),
                ),

                const SizedBox(width: 12),

                // =========================================
                // NAMA LOKASI
                // =========================================
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        lokasi.namaLokasi,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        belumDikunjungi
                            ? 'Belum dikunjungi'
                            : 'Sudah dikunjungi',

                        style: TextStyle(
                          fontSize: 12,
                          color: belumDikunjungi ? Colors.red : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // =========================================
                // JUMLAH KUNJUNGAN
                // =========================================
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,

                  children: [
                    Text(
                      '${lokasi.jumlahKunjungan}',

                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: belumDikunjungi ? Colors.red : Colors.green,
                      ),
                    ),

                    Text(
                      'kunjungan',

                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 5),

                // =========================================
                // ARROW
                // =========================================
                Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
