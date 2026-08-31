
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/fungsi.dart';
import 'package:qbsc_saas/app/views/kandang/suhu/suhu_controller.dart';
import 'package:qbsc_saas/app/views/kandang/suhu/suhu_detail.dart';
import 'package:qbsc_saas/app/views/kandang/suhu/suhu_model.dart';

class KandangSuhu extends StatefulWidget {
  const KandangSuhu({super.key});

  @override
  State<KandangSuhu> createState() => _KandangSuhuState();
}

class _KandangSuhuState extends State<KandangSuhu> {
  final SuhuController controller = Get.put(SuhuController());
  final ScrollController scrollController = ScrollController();

  static const Color primary = Color(0xFF0F172A);
  static const Color blue = Color(0xFF2563EB);
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
      controller.fetchSuhu(loadMore: true);
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
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    12,
                    20,
                    22,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 42,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2E8F0),
                            borderRadius:
                                BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius:
                                  BorderRadius.circular(13),
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
                                  fontWeight:
                                      FontWeight.w800,
                                  color: primary,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Sesuaikan data yang ingin ditampilkan',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF64748B),
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

                      Row(
                        children: [
                          Expanded(
                            child: _filterDateButton(
                              label: startDate == null
                                  ? 'Tanggal Mulai'
                                  : Fungsi.tanggalIndo(
                                      startDate!
                                          .toIso8601String()
                                          .substring(0, 10),
                                    ),
                              icon: Icons
                                  .calendar_month_outlined,
                              onTap: () async {
                                final date =
                                    await showDatePicker(
                                  context: context,
                                  initialDate:
                                      startDate ??
                                          DateTime.now(),
                                  firstDate:
                                      DateTime(2020),
                                  lastDate:
                                      DateTime.now(),
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
                              label: endDate == null
                                  ? 'Tanggal Akhir'
                                  : Fungsi.tanggalIndo(
                                      endDate!
                                          .toIso8601String()
                                          .substring(0, 10),
                                    ),
                              icon: Icons
                                  .event_available_outlined,
                              onTap: () async {
                                final date =
                                    await showDatePicker(
                                  context: context,
                                  initialDate:
                                      endDate ??
                                          DateTime.now(),
                                  firstDate:
                                      DateTime(2020),
                                  lastDate:
                                      DateTime.now(),
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

                      const SizedBox(height: 12),

                      // =================================================
                      // SATPAM
                      // =================================================

                      Obx(
                        () => _dropdownField<int>(
                          value: selectedSatpamId,
                          label: 'Satpam',
                          icon: Icons
                              .person_outline_rounded,
                          items: [
                            const DropdownMenuItem<int>(
                              value: null,
                              child: Text(
                                'Semua Satpam',
                              ),
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
                        ),
                      ),

                      const SizedBox(height: 12),

                      // =================================================
                      // KANDANG
                      // =================================================

                      Obx(
                        () => _dropdownField<int>(
                          value: selectedKandangId,
                          label: 'Kandang',
                          icon: Icons.home_work_outlined,
                          items: [
                            const DropdownMenuItem<int>(
                              value: null,
                              child: Text(
                                'Semua Kandang',
                              ),
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
                        ),
                      ),

                      const SizedBox(height: 20),

                      // =================================================
                      // ACTION
                      // =================================================

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                controller.clearFilter();
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.refresh_rounded,
                                size: 17,
                              ),
                              label: const Text(
                                'Reset',
                              ),
                              style: OutlinedButton
                                  .styleFrom(
                                foregroundColor:
                                    const Color(
                                      0xFF475569,
                                    ),
                                side: const BorderSide(
                                  color: Color(
                                    0xFFE2E8F0,
                                  ),
                                ),
                                minimumSize:
                                    const Size(
                                  0,
                                  48,
                                ),
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    13,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            flex: 2,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                controller.applyFilter(
                                  start: startDate
                                      ?.toIso8601String()
                                      .substring(
                                        0,
                                        10,
                                      ),
                                  end: endDate
                                      ?.toIso8601String()
                                      .substring(
                                        0,
                                        10,
                                      ),
                                  satpamId:
                                      selectedSatpamId,
                                  kandangId:
                                      selectedKandangId,
                                );

                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.check_rounded,
                                size: 18,
                              ),
                              label: const Text(
                                'Terapkan Filter',
                              ),
                              style: ElevatedButton
                                  .styleFrom(
                                backgroundColor:
                                    primary,
                                foregroundColor:
                                    Colors.white,
                                elevation: 0,
                                minimumSize:
                                    const Size(
                                  0,
                                  48,
                                ),
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    13,
                                  ),
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
  // BUILD
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
            background: primary,
            onPressed: _showFilterBottomSheet,
          ),

          const SizedBox(height: 10),

          _floatingButton(
            icon: Icons.refresh_rounded,
            background: const Color(0xFF16A34A),
            onPressed: controller.refreshData,
          ),
        ],
      ),

      body: Obx(() {
        // =====================================================
        // LOADING
        // =====================================================

        if (controller.isLoading.value &&
            controller.suhuList.isEmpty) {
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
            controller.suhuList.isEmpty) {
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
              controller.suhuList.length +
              (controller.isMoreDataAvailable.value
                  ? 1
                  : 0),
          itemBuilder: (context, index) {
            if (index >=
                controller.suhuList.length) {
              return const Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              );
            }

            final SuhuModel suhuData =
                controller.suhuList[index];

            return _buildSuhuCard(
              context,
              suhuData,
            );
          },
        );
      }),
    );
  }

  // =========================================================
  // SUHU CARD
  // =========================================================

  Widget _buildSuhuCard(
    BuildContext context,
    SuhuModel data,
  ) {
    final bool hasPhoto =
        data.foto != null &&
        data.foto!.trim().isNotEmpty;

    final double? temperature =
        double.tryParse(
      data.temperature.toString(),
    );

    return GestureDetector(
      onTap: () {
        Get.to(
          () => SuhuDetail(
            data: data,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 14,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(21),
          border: Border.all(
            color: const Color(0xFFE8EDF3),
          ),
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withOpacity(0.035),
              blurRadius: 18,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // =================================================
            // PHOTO
            // =================================================

            if (hasPhoto)
              SizedBox(
                height: 175,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      "${ApiProvider.imageUrl}/${data.foto!}",
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) =>
                              _photoPlaceholder(),
                      loadingBuilder:
                          (
                            context,
                            child,
                            progress,
                          ) {
                            if (progress == null) {
                              return child;
                            }

                            return Container(
                              color:
                                  const Color(
                                0xFFF1F5F9,
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

                    // Gradient
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration:
                            BoxDecoration(
                          gradient:
                              LinearGradient(
                            begin: Alignment
                                .topCenter,
                            end: Alignment
                                .bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black
                                  .withOpacity(
                                0.65,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // KANDANG
                    Positioned(
                      left: 14,
                      bottom: 13,
                      right: 14,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              data.kandangName,
                              maxLines: 1,
                              overflow:
                                  TextOverflow
                                      .ellipsis,
                              style:
                                  const TextStyle(
                                color:
                                    Colors.white,
                                fontSize: 16,
                                fontWeight:
                                    FontWeight
                                        .w800,
                              ),
                            ),
                          ),

                          Container(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 9,
                              vertical: 5,
                            ),
                            decoration:
                                BoxDecoration(
                              color: Colors.white
                                  .withOpacity(
                                0.16,
                              ),
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                20,
                              ),
                              border: Border.all(
                                color: Colors
                                    .white
                                    .withOpacity(
                                  0.22,
                                ),
                              ),
                            ),
                            child: const Row(
                              mainAxisSize:
                                  MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons
                                      .thermostat_rounded,
                                  color:
                                      Colors.white,
                                  size: 13,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'SUHU',
                                  style:
                                      TextStyle(
                                    color:
                                        Colors.white,
                                    fontSize: 8,
                                    fontWeight:
                                        FontWeight
                                            .w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // =================================================
            // CONTENT
            // =================================================

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // =================================================
                  // TOP
                  // =================================================

                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 34,
                                  height: 34,
                                  decoration:
                                      BoxDecoration(
                                    color:
                                        const Color(
                                      0xFFFFF7ED,
                                    ),
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      10,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons
                                        .thermostat_rounded,
                                    color:
                                        Color(
                                      0xFFEA580C,
                                    ),
                                    size: 19,
                                  ),
                                ),

                                const SizedBox(
                                  width: 9,
                                ),

                                const Text(
                                  'Temperatur',
                                  style:
                                      TextStyle(
                                    fontSize: 10,
                                    color:
                                        Color(
                                      0xFF94A3B8,
                                    ),
                                    fontWeight:
                                        FontWeight
                                            .w600,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 7,
                            ),

                            Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .end,
                              children: [
                                Text(
                                  data.temperature
                                      .toString(),
                                  style:
                                      const TextStyle(
                                    fontSize: 30,
                                    height: 1,
                                    fontWeight:
                                        FontWeight
                                            .w900,
                                    color:
                                        primary,
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                const Padding(
                                  padding:
                                      EdgeInsets
                                          .only(
                                    bottom: 3,
                                  ),
                                  child: Text(
                                    '°C',
                                    style:
                                        TextStyle(
                                      fontSize:
                                          13,
                                      color:
                                          Color(
                                        0xFF64748B,
                                      ),
                                      fontWeight:
                                          FontWeight
                                              .w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // STATUS
                      Container(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 9,
                          vertical: 6,
                        ),
                        decoration:
                            BoxDecoration(
                          color:
                              const Color(
                            0xFFECFDF5,
                          ),
                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),
                        ),
                        child: const Row(
                          mainAxisSize:
                              MainAxisSize.min,
                          children: [
                            Icon(
                              Icons
                                  .check_circle_rounded,
                              size: 13,
                              color:
                                  Color(
                                0xFF16A34A,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Tercatat',
                              style:
                                  TextStyle(
                                fontSize: 9,
                                color:
                                    Color(
                                  0xFF15803D,
                                ),
                                fontWeight:
                                    FontWeight
                                        .w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Container(
                    height: 1,
                    color:
                        const Color(
                      0xFFF1F5F9,
                    ),
                  ),

                  const SizedBox(height: 13),

                  // =================================================
                  // INFO
                  // =================================================

                  _infoItem(
                    Icons.calendar_today_outlined,
                    'Tanggal / Jam',
                    '${Fungsi.tanggalIndo(data.tanggal)} • ${data.jam}',
                  ),

                  const SizedBox(height: 10),

                  _infoItem(
                    Icons.home_work_outlined,
                    'Kandang',
                    data.kandangName,
                  ),

                  const SizedBox(height: 10),

                  _infoItem(
                    Icons.person_outline_rounded,
                    'Petugas',
                    data.satpamName,
                  ),

                  if (data.note != null &&
                      data.note!.trim().isNotEmpty) ...[
                    const SizedBox(height: 10),
                    _infoItem(
                      Icons.notes_rounded,
                      'Catatan',
                      data.note!,
                    ),
                  ],

                  const SizedBox(height: 14),

                  // =================================================
                  // DETAIL BUTTON
                  // =================================================

                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color:
                          const Color(0xFFF8FAFC),
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Text(
                          'Lihat detail monitoring',
                          style: TextStyle(
                            fontSize: 10,
                            color: blue,
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons
                              .arrow_forward_rounded,
                          size: 15,
                          color: blue,
                        ),
                      ],
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

  // =========================================================
  // INFO ITEM
  // =========================================================

  Widget _infoItem(
    IconData icon,
    String label,
    String value,
  ) {
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
          width: 82,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 9.5,
              color: Color(0xFF94A3B8),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const SizedBox(width: 6),

        Expanded(
          child: Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF334155),
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // FILTER DATE BUTTON
  // =========================================================

  Widget _filterDateButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(13),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius:
              BorderRadius.circular(13),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 17,
              color: blue,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF475569),
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
    required T? value,
    required String label,
    required IconData icon,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        size: 20,
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
          horizontal: 13,
          vertical: 4,
        ),
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(13),
          borderSide: BorderSide.none,
        ),
        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(13),
          borderSide: const BorderSide(
            color: Color(0xFFE2E8F0),
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
    required Color background,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: FloatingActionButton(
        heroTag: icon,
        mini: true,
        elevation: 0,
        backgroundColor: background,
        onPressed: onPressed,
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
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
                    const Color(0xFFEFF6FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.thermostat_outlined,
                size: 42,
                color: blue,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Data suhu tidak ditemukan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: primary,
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'Belum ada data monitoring suhu yang sesuai dengan filter.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                height: 1.5,
                color: Color(0xFF64748B),
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
              style: OutlinedButton
                  .styleFrom(
                foregroundColor: primary,
                side: const BorderSide(
                  color: Color(0xFFE2E8F0),
                ),
                shape:
                    RoundedRectangleBorder(
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
  // PHOTO PLACEHOLDER
  // =========================================================

  Widget _photoPlaceholder() {
    return Container(
      color: const Color(0xFFE2E8F0),
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 40,
          color: Color(0xFF94A3B8),
        ),
      ),
    );
  }
}
