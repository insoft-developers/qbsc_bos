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

  // =========================
  // FILTER BOTTOM SHEET
  // =========================
  void _showFilterBottomSheet() {
    // 🔥 ambil state awal dari controller
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter Patroli',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // ===== FILTER TANGGAL =====
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: startDate ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) {
                              setState(() => startDate = date);
                            }
                          },
                          child: Text(
                            startDate == null
                                ? 'Tanggal Mulai'
                                : Fungsi.tanggalIndo(
                                    startDate!.toIso8601String().substring(
                                      0,
                                      10,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: endDate ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) {
                              setState(() => endDate = date);
                            }
                          },
                          child: Text(
                            endDate == null
                                ? 'Tanggal Akhir'
                                : Fungsi.tanggalIndo(
                                    endDate!.toIso8601String().substring(0, 10),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ===== FILTER SATPAM =====
                  Obx(() {
                    return DropdownButtonFormField<int?>(
                      value: selectedSatpamId,
                      decoration: const InputDecoration(
                        labelText: 'Satpam',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem<int?>(
                          value: null,
                          child: Text('Semua Satpam'),
                        ),
                        ...controller.satpamList.map(
                          (s) => DropdownMenuItem<int?>(
                            value: s.id,
                            child: Text(s.name),
                          ),
                        ),
                      ],
                      onChanged: (val) {
                        setState(() => selectedSatpamId = val);
                      },
                    );
                  }),

                  const SizedBox(height: 12),

                  // ===== FILTER LOKASI =====
                  Obx(() {
                    return DropdownButtonFormField<int?>(
                      value: selectedLocationId,
                      decoration: const InputDecoration(
                        labelText: 'Lokasi',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem<int?>(
                          value: null,
                          child: Text('Semua Lokasi'),
                        ),
                        ...controller.lokasiList.map(
                          (l) => DropdownMenuItem<int?>(
                            value: l.id,
                            child: Text(l.locationName),
                          ),
                        ),
                      ],
                      onChanged: (val) {
                        setState(() => selectedLocationId = val);
                      },
                    );
                  }),

                  const SizedBox(height: 16),

                  // ===== ACTION BUTTON =====
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            controller.clearFilter();
                            Navigator.pop(context);
                          },
                          child: const Text('Reset'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            controller.applyFilter(
                              start: startDate?.toIso8601String().substring(
                                0,
                                10,
                              ),
                              end: endDate?.toIso8601String().substring(0, 10),
                              satpamId: selectedSatpamId,
                              locationId: selectedLocationId,
                            );
                            Navigator.pop(context);
                          },
                          child: const Text('Terapkan'),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  // =========================
  // LOGIC JAM RANGE
  // =========================
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
        jamAkhir.isEmpty)
      return false;

    DateTime? parse(String v) {
      final p = v.split(':');
      if (p.length < 2) return null;
      return DateTime(2000, 1, 1, int.parse(p[0]), int.parse(p[1]));
    }

    final check = parse(jam);
    var start = parse(jamAwal);
    var end = parse(jamAkhir);

    if (check == null || start == null || end == null) return false;

    if (end.isBefore(start)) {
      end = end.add(const Duration(days: 1));
      if (check.isBefore(start)) {
        return check.add(const Duration(days: 1)).isBefore(end);
      }
    }

    return check.isAfter(start) && check.isBefore(end);
  }

  // =========================
  // UI
  // =========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: const Text(
          'Monitoring Patroli',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.refresh, color: Colors.white),
        onPressed: controller.refreshData,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.patroliList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!controller.isLoading.value && controller.patroliList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 12),
                Text(
                  'Data patroli tidak ditemukan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Coba ubah filter atau rentang tanggal',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.all(16),
          itemCount:
              controller.patroliList.length +
              (controller.isMoreDataAvailable.value ? 1 : 0),
          itemBuilder: (context, i) {
            if (i >= controller.patroliList.length) {
              return const Center(child: CircularProgressIndicator());
            }

            final p = controller.patroliList[i];
            final isOut = !_isJamDalamRange(
              jam: p.jam,
              jamAwal: p.jamAwal ?? '',
              jamAkhir: p.jamAkhir ?? '',
            );

            return InkWell(
              onTap: () => Get.to(() => PatroliDetail(data: p)),
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isOut ? Colors.red : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (p.foto != null && p.foto!.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            "${ApiProvider.imageUrl}/${p.foto!}",
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      if (p.foto != null && p.foto!.isNotEmpty)
                        const SizedBox(height: 12),
                      _buildRow(
                        "Tanggal / Jam",
                        "${Fungsi.tanggalIndo(p.tanggal)} - ${p.jam}",
                        valueColor: isOut ? Colors.red : Colors.black87,
                      ),
                      _buildRow(
                        "Jadwal Patroli",
                        "${p.jamAwal ?? ''} - ${p.jamAkhir ?? ''}",
                        valueColor: isOut ? Colors.red : Colors.black87,
                      ),
                      _buildRow(
                        "Lokasi / Satpam",
                        "${p.locationName} - ${p.satpamName}",
                      ),
                      _buildRow("Catatan", p.note ?? '-'),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildRow(String l, String v, {Color valueColor = Colors.black87}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            v,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 6),
          Divider(height: 1, color: Colors.grey.shade300),
        ],
      ),
    );
  }
}
