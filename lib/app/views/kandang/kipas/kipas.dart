
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/fungsi.dart';
import 'package:qbsc_saas/app/views/kandang/kipas/kipas_controller.dart';
import 'package:qbsc_saas/app/views/kandang/kipas/kipas_detail.dart';
import 'package:qbsc_saas/app/views/kandang/kipas/kipas_model.dart';

class KandangKipas extends StatefulWidget {
  const KandangKipas({super.key});

  @override
  State<KandangKipas> createState() => _KandangKipasState();
}

class _KandangKipasState extends State<KandangKipas> {
  final KipasController controller = Get.put(KipasController());
  final ScrollController scrollController = ScrollController();

  static const Color primary = Color(0xFF0F172A);
  static const Color green = Color(0xFF16A34A);
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
      controller.fetchKipas(loadMore: true);
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
                      // HANDLE
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

                      // HEADER
                      Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius:
                                  BorderRadius.circular(13),
                            ),
                            child: const Icon(
                              Icons.tune_rounded,
                              color: green,
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
                              icon:
                                  Icons.calendar_month_outlined,
                              onTap: () async {
                                final date =
                                    await showDatePicker(
                                  context: context,
                                  initialDate:
                                      startDate ??
                                          DateTime.now(),
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
                              label: endDate == null
                                  ? 'Tanggal Akhir'
                                  : Fungsi.tanggalIndo(
                                      endDate!
                                          .toIso8601String()
                                          .substring(0, 10),
                                    ),
                              icon:
                                  Icons.event_available_outlined,
                              onTap: () async {
                                final date =
                                    await showDatePicker(
                                  context: context,
                                  initialDate:
                                      endDate ??
                                          DateTime.now(),
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

                      const SizedBox(height: 12),

                      // =================================================
                      // SATPAM
                      // =================================================

                      Obx(
                        () => _dropdownField<int>(
                          value: selectedSatpamId,
                          label: 'Satpam',
                          icon:
                              Icons.person_outline_rounded,
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
                          icon:
                              Icons.home_work_outlined,
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
                      // BUTTON
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
                              label: const Text('Reset'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor:
                                    const Color(0xFF475569),
                                side: const BorderSide(
                                  color: Color(0xFFE2E8F0),
                                ),
                                minimumSize:
                                    const Size(0, 48),
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
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
                                      .substring(0, 10),
                                  end: endDate
                                      ?.toIso8601String()
                                      .substring(0, 10),
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                minimumSize:
                                    const Size(0, 48),
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
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
  // PARSE KIPAS
  // =========================================================

  List<int> parseKipas(String data) {
    return data
        .split(',')
        .map((e) => int.tryParse(e) ?? 0)
        .toList();
  }

  // =========================================================
  // BUILD
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
            icon: Icons.tune_rounded,
            background: primary,
            onPressed: _showFilterBottomSheet,
          ),

          const SizedBox(height: 10),

          _floatingButton(
            icon: Icons.refresh_rounded,
            background: green,
            onPressed: controller.refreshData,
          ),
        ],
      ),

      body: Obx(() {
        // =====================================================
        // LOADING
        // =====================================================

        if (controller.isLoading.value &&
            controller.kipasList.isEmpty) {
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
            controller.kipasList.isEmpty) {
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
              controller.kipasList.length +
              (controller.isMoreDataAvailable.value
                  ? 1
                  : 0),
          itemBuilder: (context, index) {
            if (index >=
                controller.kipasList.length) {
              return const Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              );
            }

            final KipasModel kipasData =
                controller.kipasList[index];

            return _buildKipasCard(
              context,
              kipasData,
            );
          },
        );
      }),
    );
  }

  // =========================================================
  // KIPAS CARD
  // =========================================================

  Widget _buildKipasCard(
    BuildContext context,
    KipasModel data,
  ) {
    final bool hasPhoto =
        data.foto != null &&
        data.foto!.trim().isNotEmpty;

    final List<int> kipas =
        parseKipas(data.kipas);

    final int totalKipas = kipas.length;

    final int kipasOn = kipas
        .where((value) => value == 1)
        .length;

    final int kipasOff =
        totalKipas - kipasOn;

    return GestureDetector(
      onTap: () {
        Get.to(
          () => KipasDetail(
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
            // FOTO
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

                    // GRADIENT
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
                      right: 14,
                      bottom: 13,
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
                                      .air_rounded,
                                  color:
                                      Colors.white,
                                  size: 14,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'KIPAS',
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
                  // HEADER
                  // =================================================

                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFFECFDF5),
                          borderRadius:
                              BorderRadius.circular(
                            11,
                          ),
                        ),
                        child: const Icon(
                          Icons.air_rounded,
                          color: green,
                          size: 21,
                        ),
                      ),

                      const SizedBox(width: 10),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              'Monitoring Kipas',
                              style:
                                  TextStyle(
                                fontSize: 13,
                                color: primary,
                                fontWeight:
                                    FontWeight
                                        .w800,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Status perangkat kandang',
                              style:
                                  TextStyle(
                                fontSize: 9,
                                color:
                                    Color(
                                  0xFF94A3B8,
                                ),
                                fontWeight:
                                    FontWeight
                                        .w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // STATUS ON
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
                        child: Row(
                          mainAxisSize:
                              MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration:
                                  const BoxDecoration(
                                color: green,
                                shape:
                                    BoxShape.circle,
                              ),
                            ),
                            const SizedBox(
                                width: 5),
                            Text(
                              '$kipasOn ON',
                              style:
                                  const TextStyle(
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

                  // =================================================
                  // SUMMARY
                  // =================================================

                  Row(
                    children: [
                      Expanded(
                        child: _summaryBox(
                          icon:
                              Icons.air_rounded,
                          label: 'TOTAL',
                          value:
                              totalKipas.toString(),
                          iconColor: blue,
                          background:
                              const Color(
                            0xFFEFF6FF,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: _summaryBox(
                          icon:
                              Icons.power_rounded,
                          label: 'MENYALA',
                          value:
                              kipasOn.toString(),
                          iconColor: green,
                          background:
                              const Color(
                            0xFFECFDF5,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: _summaryBox(
                          icon:
                              Icons.power_off_rounded,
                          label: 'MATI',
                          value:
                              kipasOff.toString(),
                          iconColor:
                              const Color(
                            0xFF64748B,
                          ),
                          background:
                              const Color(
                            0xFFF1F5F9,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Container(
                    height: 1,
                    color:
                        const Color(0xFFF1F5F9),
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
                  // DETAIL
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
  // SUMMARY BOX
  // =========================================================

  Widget _summaryBox({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
    required Color background,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 11,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius:
            BorderRadius.circular(13),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 17,
            color: iconColor,
          ),

          const SizedBox(height: 4),

          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              height: 1,
              fontWeight: FontWeight.w900,
              color: iconColor,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            label,
            style: TextStyle(
              fontSize: 7.5,
              fontWeight: FontWeight.w800,
              color: iconColor,
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
  // FILTER DATE
  // =========================================================

  Widget _filterDateButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(13),
      child: Container(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color:
              const Color(0xFFF8FAFC),
          borderRadius:
              BorderRadius.circular(13),
          border: Border.all(
            color:
                const Color(0xFFE2E8F0),
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
                  fontWeight:
                      FontWeight.w600,
                  color:
                      Color(0xFF475569),
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
          color:
              const Color(0xFF64748B),
        ),
        filled: true,
        fillColor:
            const Color(0xFFF8FAFC),
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
                    const Color(0xFFECFDF5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.air_rounded,
                size: 42,
                color: green,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Data kipas tidak ditemukan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: primary,
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'Belum ada data monitoring kipas yang sesuai dengan filter.',
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
              style: OutlinedButton.styleFrom(
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
