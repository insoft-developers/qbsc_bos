import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/fungsi.dart';
import 'package:qbsc_saas/app/views/kandang/alarm/alarm_controller.dart';
import 'package:qbsc_saas/app/views/kandang/alarm/alarm_detail.dart';
import 'package:qbsc_saas/app/views/kandang/alarm/alarm_model.dart';

class KandangAlarm extends StatefulWidget {
  const KandangAlarm({super.key});

  @override
  State<KandangAlarm> createState() => _KandangAlarmState();
}

class _KandangAlarmState extends State<KandangAlarm> {
  final AlarmController controller = Get.put(AlarmController());
  final ScrollController scrollController = ScrollController();

  static const Color primary = Color(0xFF0F172A);
  static const Color background = Color(0xFFF6F8FC);
  static const Color danger = Color(0xFFDC2626);
  static const Color success = Color(0xFF16A34A);
  static const Color blue = Color(0xFF2563EB);

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
      controller.fetchAlarm(loadMore: true);
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  // =========================================================
  // FILTER BOTTOM SHEET
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
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(26),
              ),
            ),
            child: StatefulBuilder(
              builder: (context, setState) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    10,
                    20,
                    20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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

                      const SizedBox(height: 18),

                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.tune_rounded,
                              color: primary,
                              size: 20,
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
                                'Atur data alarm yang ingin ditampilkan',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // =================================================
                      // TANGGAL
                      // =================================================

                      const Text(
                        'Periode',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
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
                                  setState(() => startDate = date);
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
                                  setState(() => endDate = date);
                                }
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // =================================================
                      // SATPAM
                      // =================================================

                      _dropdown(
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
                          setState(() => selectedSatpamId = val);
                        },
                      ),

                      const SizedBox(height: 12),

                      // =================================================
                      // KANDANG
                      // =================================================

                      _dropdown(
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
                          setState(() => selectedKandangId = val);
                        },
                      ),

                      const SizedBox(height: 20),

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
                                  color: Color(0xFF475569),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
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
                                elevation: 0,
                                minimumSize:
                                    const Size.fromHeight(50),
                                backgroundColor: primary,
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
                );
              },
            ),
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

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _floatingButton(
            icon: Icons.tune_rounded,
            color: primary,
            onPressed: _showFilterBottomSheet,
          ),

          const SizedBox(height: 10),

          _floatingButton(
            icon: Icons.refresh_rounded,
            color: success,
            onPressed: controller.refreshData,
          ),
        ],
      ),

      body: Obx(() {
        // =====================================================
        // LOADING
        // =====================================================

        if (controller.isLoading.value &&
            controller.alarmList.isEmpty) {
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
            controller.alarmList.isEmpty) {
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
              controller.alarmList.length +
              (controller.isMoreDataAvailable.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= controller.alarmList.length) {
              return const Padding(
                padding: EdgeInsets.all(18),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              );
            }

            final AlarmModel alarmData =
                controller.alarmList[index];

            return _buildAlarmCard(alarmData);
          },
        );
      }),
    );
  }

  // =========================================================
  // ALARM CARD
  // =========================================================

  Widget _buildAlarmCard(AlarmModel data) {
    final bool isOn = data.isAlarmOn == 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isOn
              ? const Color(0xFFFECACA)
              : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Get.to(
            () => AlarmDetail(data: data),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // ===================================================
              // FOTO
              // ===================================================

              if (data.foto != null &&
                  data.foto!.isNotEmpty)
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(15),
                  child: Stack(
                    children: [
                      Image.network(
                        "${ApiProvider.imageUrl}/${data.foto!}",
                        height: 190,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) {
                          return _imageError();
                        },
                        loadingBuilder:
                            (context, child, loading) {
                          if (loading == null) {
                            return child;
                          }

                          return Container(
                            height: 190,
                            width: double.infinity,
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

                      // ALARM BADGE
                      Positioned(
                        top: 10,
                        right: 10,
                        child: _alarmBadge(isOn),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 12),

              // ===================================================
              // HEADER
              // ===================================================

              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isOn
                          ? const Color(0xFFFEF2F2)
                          : const Color(0xFFF1F5F9),
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isOn
                          ? Icons.notifications_active_rounded
                          : Icons.notifications_off_outlined,
                      color: isOn
                          ? danger
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
                          data.kandangName,
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

                        Row(
                          children: [
                            const Icon(
                              Icons.person_outline_rounded,
                              size: 12,
                              color:
                                  Color(0xFF94A3B8),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                data.satpamName,
                                maxLines: 1,
                                overflow:
                                    TextOverflow.ellipsis,
                                style:
                                    const TextStyle(
                                  fontSize: 10,
                                  color:
                                      Color(0xFF94A3B8),
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

                  _alarmBadge(isOn),
                ],
              ),

              const SizedBox(height: 14),

              // ===================================================
              // INFO
              // ===================================================

              _infoItem(
                icon: Icons.calendar_today_outlined,
                label: 'Tanggal / Jam',
                value:
                    '${Fungsi.tanggalIndo(data.tanggal)} - ${data.jam}',
              ),

              _infoItem(
                icon: Icons.notifications_none_rounded,
                label: 'Status Alarm',
                value: isOn
                    ? 'Alarm Menyala'
                    : 'Alarm Mati',
                valueColor:
                    isOn ? danger : const Color(0xFF64748B),
              ),

              _infoItem(
                icon: Icons.notes_outlined,
                label: 'Catatan',
                value: data.note == null ||
                        data.note!.isEmpty
                    ? 'Tidak ada catatan'
                    : data.note!,
              ),

              const SizedBox(height: 4),

              // ===================================================
              // FOOTER
              // ===================================================

              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color:
                      const Color(0xFFF8FAFC),
                  borderRadius:
                      BorderRadius.circular(11),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.touch_app_outlined,
                      size: 14,
                      color:
                          const Color(0xFF94A3B8),
                    ),
                    const SizedBox(width: 6),
                    const Expanded(
                      child: Text(
                        'Tap untuk melihat detail',
                        style: TextStyle(
                          fontSize: 9,
                          color:
                              Color(0xFF94A3B8),
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 11,
                      color:
                          Color(0xFF94A3B8),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // ALARM BADGE
  // =========================================================

  Widget _alarmBadge(bool isOn) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: isOn
            ? const Color(0xFFDC2626)
            : const Color(0xFF64748B),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOn
                ? Icons.notifications_active_rounded
                : Icons.notifications_off_outlined,
            size: 12,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            isOn ? 'ALARM ON' : 'ALARM OFF',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.3,
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
    Color valueColor = const Color(0xFF334155),
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 9,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color:
                  const Color(0xFFF8FAFC),
              borderRadius:
                  BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 14,
              color:
                  const Color(0xFF64748B),
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
                    color:
                        Color(0xFF94A3B8),
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  value,
                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: valueColor,
                    fontWeight:
                        FontWeight.w700,
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
  // DATE BUTTON
  // =========================================================

  Widget _dateButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 11,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color:
              const Color(0xFFF8FAFC),
          borderRadius:
              BorderRadius.circular(12),
          border: Border.all(
            color:
                const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color:
                  const Color(0xFF64748B),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                text,
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  color:
                      Color(0xFF475569),
                  fontWeight:
                      FontWeight.w600,
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

  Widget _dropdown({
    required String label,
    required IconData icon,
    required int? value,
    required List<DropdownMenuItem<int>> items,
    required ValueChanged<int?> onChanged,
  }) {
    return DropdownButtonFormField<int>(
      value: value,
      isExpanded: true,
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          size: 19,
        ),
        filled: true,
        fillColor:
            const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12),
          borderSide: const BorderSide(
            color:
                Color(0xFFE2E8F0),
          ),
        ),
        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12),
          borderSide: const BorderSide(
            color:
                Color(0xFFE2E8F0),
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
    required VoidCallback onPressed,
  }) {
    return Material(
      elevation: 7,
      shadowColor:
          Colors.black.withOpacity(0.2),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder:
            const CircleBorder(),
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
            size: 22,
          ),
        ),
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
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color:
                    const Color(0xFFF1F5F9),
                borderRadius:
                    BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                size: 42,
                color:
                    Color(0xFF94A3B8),
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Data alarm tidak ditemukan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: primary,
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'Belum ada data monitoring alarm\nsesuai filter yang dipilih.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                height: 1.5,
                color:
                    Color(0xFF94A3B8),
              ),
            ),

            const SizedBox(height: 18),

            OutlinedButton.icon(
              onPressed:
                  controller.refreshData,
              icon: const Icon(
                Icons.refresh_rounded,
                size: 17,
              ),
              label: const Text(
                'Muat Ulang',
              ),
              style:
                  OutlinedButton.styleFrom(
                foregroundColor:
                    primary,
                side: const BorderSide(
                  color:
                      Color(0xFFE2E8F0),
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // IMAGE ERROR
  // =========================================================

  Widget _imageError() {
    return Container(
      height: 190,
      width: double.infinity,
      color: const Color(0xFFF1F5F9),
      child: const Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: 38,
            color:
                Color(0xFF94A3B8),
          ),
          SizedBox(height: 7),
          Text(
            'Foto tidak tersedia',
            style: TextStyle(
              fontSize: 10,
              color:
                  Color(0xFF94A3B8),
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
