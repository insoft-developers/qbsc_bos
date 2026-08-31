import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/fungsi.dart';
import 'package:qbsc_saas/app/views/kandang/lampu/lampu_controller.dart';
import 'package:qbsc_saas/app/views/kandang/lampu/lampu_detail.dart';
import 'package:qbsc_saas/app/views/kandang/lampu/lampu_model.dart';

class KandangLampu extends StatefulWidget {
  const KandangLampu({super.key});

  @override
  State<KandangLampu> createState() => _KandangLampuState();
}

class _KandangLampuState extends State<KandangLampu> {
  final LampuController controller = Get.put(LampuController());
  final ScrollController scrollController = ScrollController();

  static const Color primary = Color(0xFF0F172A);
  static const Color blue = Color(0xFF2563EB);
  static const Color green = Color(0xFF16A34A);
  static const Color background = Color(0xFFF6F8FC);

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
      controller.fetchLampu(loadMore: true);
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
    int? selectedKandangId = controller.selectedKandangId.value;
    DateTime? startDate;
    DateTime? endDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(26),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    12,
                    20,
                    24,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // =================================================
                      // HANDLE
                      // =================================================

                      Center(
                        child: Container(
                          width: 42,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // =================================================
                      // TITLE
                      // =================================================

                      Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: const Icon(
                              Icons.tune_rounded,
                              color: blue,
                              size: 21,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Filter Monitoring',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: primary,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Sesuaikan data yang ingin ditampilkan',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      // =================================================
                      // TANGGAL
                      // =================================================

                      const Text(
                        'Periode Tanggal',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: primary,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Expanded(
                            child: _dateButton(
                              icon: Icons.calendar_today_outlined,
                              text: startDate == null
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
                                  setState(() {
                                    startDate = date;
                                  });
                                }
                              },
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: _dateButton(
                              icon: Icons.event_outlined,
                              text: endDate == null
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

                      // =================================================
                      // SATPAM
                      // =================================================

                      Obx(() {
                        return _dropdownField<int>(
                          label: 'Satpam',
                          icon: Icons.person_outline_rounded,
                          value: selectedSatpamId,
                          items: [
                            const DropdownMenuItem<int>(
                              value: null,
                              child: Text('Semua Satpam'),
                            ),
                            ...controller.satpamList.map(
                              (s) => DropdownMenuItem<int>(
                                value: s.id,
                                child: Text(s.name),
                              ),
                            ),
                          ],
                          onChanged: (val) {
                            setState(() {
                              selectedSatpamId = val;
                            });
                          },
                        );
                      }),

                      const SizedBox(height: 14),

                      // =================================================
                      // KANDANG
                      // =================================================

                      Obx(() {
                        return _dropdownField<int>(
                          label: 'Kandang',
                          icon: Icons.home_work_outlined,
                          value: selectedKandangId,
                          items: [
                            const DropdownMenuItem<int>(
                              value: null,
                              child: Text('Semua Kandang'),
                            ),
                            ...controller.kandangList.map(
                              (s) => DropdownMenuItem<int>(
                                value: s.id,
                                child: Text(s.name),
                              ),
                            ),
                          ],
                          onChanged: (val) {
                            setState(() {
                              selectedKandangId = val;
                            });
                          },
                        );
                      }),

                      const SizedBox(height: 22),

                      // =================================================
                      // BUTTON
                      // =================================================

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
                                    const Size.fromHeight(50),
                                side: const BorderSide(
                                  color: Color(0xFFE2E8F0),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(13),
                                ),
                              ),
                              child: const Text(
                                'Reset',
                                style: TextStyle(
                                  color: Color(0xFF64748B),
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
                                  kandangId: selectedKandangId,
                                );

                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize:
                                    const Size.fromHeight(50),
                                backgroundColor: primary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(13),
                                ),
                              ),
                              child: const Text(
                                'Terapkan Filter',
                                style: TextStyle(
                                  color: Colors.white,
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
  // UI
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      // =======================================================
      // FLOATING BUTTON
      // =======================================================

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _floatingButton(
            icon: Icons.filter_alt_outlined,
            color: primary,
            tooltip: 'Filter',
            onPressed: _showFilterBottomSheet,
          ),

          const SizedBox(height: 10),

          _floatingButton(
            icon: Icons.refresh_rounded,
            color: green,
            tooltip: 'Refresh',
            onPressed: controller.refreshData,
          ),
        ],
      ),

      // =======================================================
      // BODY
      // =======================================================

      body: Obx(() {
        // =====================================================
        // LOADING
        // =====================================================

        if (controller.isLoading.value &&
            controller.lampuList.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
            ),
          );
        }

        // =====================================================
        // EMPTY
        // =====================================================

        if (!controller.isLoading.value &&
            controller.lampuList.isEmpty) {
          return _emptyState();
        }

        // =====================================================
        // LIST
        // =====================================================

        return ListView.builder(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            14,
            14,
            14,
            100,
          ),
          itemCount:
              controller.lampuList.length +
              (controller.isMoreDataAvailable.value ? 1 : 0),

          itemBuilder: (context, index) {
            // =================================================
            // LOAD MORE
            // =================================================

            if (index >= controller.lampuList.length) {
              return const Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              );
            }

            final LampuModel lampuData =
                controller.lampuList[index];

            final bool isOn =
                lampuData.isLampOn == 1;

            return _lampuCard(
              lampuData,
              isOn,
            );
          },
        );
      }),
    );
  }

  // =========================================================
  // CARD LAMPU
  // =========================================================

  Widget _lampuCard(
    LampuModel lampuData,
    bool isOn,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Get.to(
              () => LampuDetail(
                data: lampuData,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(13),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                // =============================================
                // FOTO
                // =============================================

                if (lampuData.foto != null &&
                    lampuData.foto!.isNotEmpty)
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(15),
                    child: Stack(
                      children: [
                        Image.network(
                          "${ApiProvider.imageUrl}/${lampuData.foto!}",
                          height: 185,
                          width: double.infinity,
                          fit: BoxFit.cover,

                          errorBuilder:
                              (context, error, stackTrace) {
                            return _imagePlaceholder();
                          },

                          loadingBuilder:
                              (context, child, progress) {
                            if (progress == null) {
                              return child;
                            }

                            return Container(
                              height: 185,
                              color:
                                  const Color(0xFFF1F5F9),
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
                          top: 10,
                          right: 10,
                          child: _statusBadge(isOn),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 13),

                // =============================================
                // HEADER INFO
                // =============================================

                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isOn
                            ? const Color(0xFFDCFCE7)
                            : const Color(0xFFF1F5F9),
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isOn
                            ? Icons.lightbulb_rounded
                            : Icons.lightbulb_outline_rounded,
                        color: isOn
                            ? green
                            : const Color(0xFF64748B),
                        size: 21,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            lampuData.kandangName,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight:
                                  FontWeight.w800,
                              color: primary,
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            lampuData.satpamName,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 10,
                              color:
                                  Color(0xFF64748B),
                              fontWeight:
                                  FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFF94A3B8),
                      size: 23,
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // =============================================
                // INFORMATION
                // =============================================

                _infoItem(
                  icon: Icons.calendar_today_outlined,
                  label: 'Tanggal / Jam',
                  value:
                      "${Fungsi.tanggalIndo(lampuData.tanggal)} - ${lampuData.jam}",
                ),

                _infoItem(
                  icon: Icons.lightbulb_outline_rounded,
                  label: 'Status Lampu',
                  value: isOn
                      ? 'LAMPU MENYALA'
                      : 'LAMPU MATI',
                  valueColor:
                      isOn ? green : const Color(0xFF64748B),
                ),

                _infoItem(
                  icon: Icons.notes_outlined,
                  label: 'Catatan',
                  value: lampuData.note == null ||
                          lampuData.note!.isEmpty
                      ? '-'
                      : lampuData.note!,
                  isLast: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // STATUS BADGE
  // =========================================================

  Widget _statusBadge(bool isOn) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: isOn
            ? const Color(0xFF16A34A)
            : const Color(0xFF475569),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOn
                ? Icons.power_settings_new_rounded
                : Icons.power_off_rounded,
            color: Colors.white,
            size: 12,
          ),

          const SizedBox(width: 5),

          Text(
            isOn ? 'ON' : 'OFF',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // INFO ITEM
  // =========================================================

  Widget _infoItem({
    required IconData icon,
    required String label,
    required String value,
    Color valueColor =
        const Color(0xFF334155),
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: isLast ? 0 : 10,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 29,
            height: 29,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius:
                  BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 14,
              color: const Color(0xFF64748B),
            ),
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
                    fontSize: 8.5,
                    color: Color(0xFF94A3B8),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  value,
                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: valueColor,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // IMAGE PLACEHOLDER
  // =========================================================

  Widget _imagePlaceholder() {
    return Container(
      height: 185,
      width: double.infinity,
      color: const Color(0xFFF1F5F9),
      child: const Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: 38,
            color: Color(0xFF94A3B8),
          ),
          SizedBox(height: 7),
          Text(
            'Foto tidak tersedia',
            style: TextStyle(
              fontSize: 10,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // EMPTY STATE
  // =========================================================

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius:
                    BorderRadius.circular(26),
              ),
              child: const Icon(
                Icons.lightbulb_outline_rounded,
                size: 42,
                color: Color(0xFF94A3B8),
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Data Lampu Tidak Ditemukan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: primary,
              ),
            ),

            const SizedBox(height: 7),

            Text(
              'Belum ada data monitoring lampu untuk filter yang dipilih.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                height: 1.5,
                color: Colors.grey.shade500,
              ),
            ),

            const SizedBox(height: 18),

            OutlinedButton.icon(
              onPressed: controller.refreshData,
              icon: const Icon(
                Icons.refresh_rounded,
                size: 17,
              ),
              label: const Text(
                'Refresh Data',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: primary,
                side: const BorderSide(
                  color: Color(0xFFE2E8F0),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // DATE BUTTON
  // =========================================================

  Widget _dateButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(13),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: const Color(0xFF64748B),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: Text(
                text,
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF334155),
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
  // DROPDOWN
  // =========================================================

  Widget _dropdownField<T>({
    required String label,
    required IconData icon,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Color(0xFF64748B),
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          size: 19,
          color: const Color(0xFF64748B),
        ),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(13),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(13),
          borderSide: const BorderSide(
            color: Color(0xFFE5E7EB),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(13),
          borderSide: const BorderSide(
            color: blue,
            width: 1.2,
          ),
        ),
      ),
      items: items,
      onChanged: onChanged,
    );
  }

  // =========================================================
  // FLOATING BUTTON
  // =========================================================

  Widget _floatingButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Material(
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.20),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 21,
          ),
        ),
      ),
    );
  }
}