
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/fungsi.dart';
import 'package:qbsc_saas/app/views/situasi/situasi_controller.dart';
import 'package:qbsc_saas/app/views/situasi/situasi_detail.dart';
import 'package:qbsc_saas/app/views/situasi/situasi_model.dart';

class SituasiPage extends StatefulWidget {
  const SituasiPage({super.key});

  @override
  State<SituasiPage> createState() => _SituasiPageState();
}

class _SituasiPageState extends State<SituasiPage> {
  final SituasiController controller = Get.put(
    SituasiController(),
  );

  final ScrollController scrollController =
      ScrollController();

  static const Color primary = Color(0xFF0F172A);
  static const Color blue = Color(0xFF2563EB);
  static const Color background = Color(0xFFF6F8FC);

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  // ==========================================================
  // PAGINATION
  // ==========================================================

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        controller.isMoreDataAvailable.value &&
        !controller.isLoading.value) {
      controller.fetchSituasi(
        loadMore: true,
      );
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  // ==========================================================
  // FILTER
  // ==========================================================

  void _showFilterBottomSheet() {
    int? selectedSatpamId =
        controller.selectedSatpamId.value;

    DateTime? startDate;
    DateTime? endDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context)
                .viewInsets
                .bottom,
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
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      // HANDLE
                      Center(
                        child: Container(
                          width: 42,
                          height: 4,
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFFE2E8F0),
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
                              color:
                                  blue.withOpacity(0.08),
                              borderRadius:
                                  BorderRadius.circular(
                                13,
                              ),
                            ),
                            child: const Icon(
                              Icons.filter_alt_outlined,
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
                                'Filter Laporan',
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
                                  color:
                                      Color(0xFF94A3B8),
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
                              icon: Icons
                                  .calendar_today_outlined,
                              label: startDate == null
                                  ? 'Tanggal Mulai'
                                  : Fungsi.tanggalIndo(
                                      startDate!
                                          .toIso8601String()
                                          .substring(
                                            0,
                                            10,
                                          ),
                                    ),
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
                            child: _dateButton(
                              icon: Icons
                                  .event_available_outlined,
                              label: endDate == null
                                  ? 'Tanggal Akhir'
                                  : Fungsi.tanggalIndo(
                                      endDate!
                                          .toIso8601String()
                                          .substring(
                                            0,
                                            10,
                                          ),
                                    ),
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

                      const SizedBox(height: 18),

                      // =================================================
                      // SATPAM
                      // =================================================

                      const Text(
                        'Petugas',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: primary,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Obx(
                        () {
                          return DropdownButtonFormField<int>(
                            value: selectedSatpamId,
                            isExpanded: true,
                            icon: const Icon(
                              Icons
                                  .keyboard_arrow_down_rounded,
                            ),
                            decoration:
                                InputDecoration(
                              hintText: 'Semua Satpam',
                              prefixIcon: const Icon(
                                Icons
                                    .person_outline_rounded,
                                size: 19,
                              ),
                              filled: true,
                              fillColor:
                                  const Color(0xFFF8FAFC),
                              contentPadding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 14,
                                vertical: 13,
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                  13,
                                ),
                                borderSide:
                                    BorderSide.none,
                              ),
                              enabledBorder:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                  13,
                                ),
                                borderSide:
                                    const BorderSide(
                                  color:
                                      Color(0xFFE8ECF2),
                                ),
                              ),
                              focusedBorder:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                  13,
                                ),
                                borderSide:
                                    const BorderSide(
                                  color: blue,
                                ),
                              ),
                            ),
                            items: [
                              const DropdownMenuItem<int>(
                                value: null,
                                child: Text(
                                  'Semua Satpam',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                              ),
                              ...controller.satpamList
                                  .map(
                                (s) =>
                                    DropdownMenuItem<int>(
                                  value: s.id,
                                  child: Text(
                                    s.name,
                                    overflow:
                                        TextOverflow
                                            .ellipsis,
                                    style:
                                        const TextStyle(
                                      fontSize: 12,
                                      fontWeight:
                                          FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedSatpamId =
                                    value;
                              });
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 22),

                      // =================================================
                      // ACTION
                      // =================================================

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                controller
                                    .clearFilter();
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons
                                    .restart_alt_rounded,
                                size: 17,
                              ),
                              label: const Text(
                                'Reset',
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
                                  0xFF64748B,
                                ),
                                side:
                                    const BorderSide(
                                  color:
                                      Color(0xFFE2E8F0),
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
                            child:
                                ElevatedButton.icon(
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
                                );

                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons
                                    .check_circle_outline,
                                size: 17,
                              ),
                              label: const Text(
                                'Terapkan',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight:
                                      FontWeight.w700,
                                ),
                              ),
                              style:
                                  ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor:
                                    primary,
                                foregroundColor:
                                    Colors.white,
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
                ),
              );
            },
          ),
        );
      },
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        titleSpacing: 18,
        title: const Row(
          children: [
            Icon(
              Icons.assignment_outlined,
              color: Colors.white,
              size: 21,
            ),
            SizedBox(width: 10),
            Text(
              'Laporan Situasi',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(
            tooltip: 'Filter',
            onPressed: _showFilterBottomSheet,
            icon: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.filter_alt_outlined,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),

      // ========================================================
      // FAB
      // ========================================================

      floatingActionButton:
          FloatingActionButton(
        elevation: 4,
        backgroundColor: primary,
        foregroundColor: Colors.white,
        onPressed: controller.refreshData,
        child: const Icon(
          Icons.refresh_rounded,
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: Obx(
        () {
          // LOADING
          if (controller.isLoading.value &&
              controller.situasiList.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
              ),
            );
          }

          // EMPTY
          if (!controller.isLoading.value &&
              controller.situasiList.isEmpty) {
            return _emptyState();
          }

          // LIST
          return RefreshIndicator(
            color: primary,
            onRefresh: () async {
              controller.refreshData();
            },
            child: ListView.builder(
              controller: scrollController,
              physics:
                  const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.fromLTRB(
                14,
                14,
                14,
                90,
              ),
              itemCount:
                  controller.situasiList.length +
                      (controller
                              .isMoreDataAvailable
                              .value
                          ? 1
                          : 0),
              itemBuilder: (context, index) {
                if (index >=
                    controller.situasiList.length) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  );
                }

                final SituasiModel data =
                    controller.situasiList[index];

                return _buildSituasiCard(data);
              },
            ),
          );
        },
      ),
    );
  }

  // ==========================================================
  // SITUASI CARD
  // ==========================================================

  Widget _buildSituasiCard(
    SituasiModel data,
  ) {
    final bool hasImage =
        data.foto != null &&
        data.foto!.trim().isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(
        bottom: 13,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE8ECF2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.035,
            ),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius:
              BorderRadius.circular(18),
          onTap: () {
            Get.to(
              () => SituasiDetail(
                data: data,
              ),
            );
          },
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // =================================================
              // FOTO
              // =================================================

              if (hasImage)
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  child: Stack(
                    children: [
                      Image.network(
                        '${ApiProvider.imageUrl}/${data.foto!}',
                        height: 190,
                        width: double.infinity,
                        fit: BoxFit.cover,
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
                            height: 190,
                            color:
                                const Color(
                              0xFFF1F5F9,
                            ),
                            child:
                                const Center(
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                        errorBuilder:
                            (_, __, ___) {
                          return _imageError();
                        },
                      ),

                      // GRADIENT OVERLAY
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        height: 70,
                        child: IgnorePointer(
                          child: DecoratedBox(
                            decoration:
                                BoxDecoration(
                              gradient:
                                  LinearGradient(
                                begin:
                                    Alignment
                                        .topCenter,
                                end:
                                    Alignment
                                        .bottomCenter,
                                colors: [
                                  Colors
                                      .transparent,
                                  Colors.black
                                      .withOpacity(
                                    0.45,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // PHOTO LABEL
                      Positioned(
                        top: 12,
                        left: 12,
                        child: _imageBadge(),
                      ),
                    ],
                  ),
                ),

              Padding(
                padding: const EdgeInsets.all(
                  15,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    // =================================================
                    // SATPAM HEADER
                    // =================================================

                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration:
                              BoxDecoration(
                            color: blue
                                .withOpacity(
                              0.08,
                            ),
                            borderRadius:
                                BorderRadius
                                    .circular(
                              12,
                            ),
                          ),
                          child: const Icon(
                            Icons
                                .person_outline_rounded,
                            color: blue,
                            size: 19,
                          ),
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              const Text(
                                'Petugas',
                                style:
                                    TextStyle(
                                  fontSize: 9.5,
                                  color: Color(
                                    0xFF94A3B8,
                                  ),
                                  fontWeight:
                                      FontWeight
                                          .w600,
                                ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                data.satpamName,
                                maxLines: 1,
                                overflow:
                                    TextOverflow
                                        .ellipsis,
                                style:
                                    const TextStyle(
                                  fontSize: 13,
                                  color: primary,
                                  fontWeight:
                                      FontWeight
                                          .w800,
                                ),
                              ),
                            ],
                          ),
                        ),

                        _statusBadge(),
                      ],
                    ),

                    const SizedBox(
                      height: 14,
                    ),

                    // =================================================
                    // DATE
                    // =================================================

                    _infoLine(
                      icon: Icons
                          .calendar_today_outlined,
                      label: 'Tanggal / Jam',
                      value:
                          '${Fungsi.tanggalIndo(data.tanggal)} • ${Fungsi.formatToTime(data.tanggal)}',
                    ),

                    const SizedBox(
                      height: 9,
                    ),

                    // =================================================
                    // REPORT
                    // =================================================

                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.all(
                        13,
                      ),
                      decoration:
                          BoxDecoration(
                        color: const Color(
                          0xFFF8FAFC,
                        ),
                        borderRadius:
                            BorderRadius
                                .circular(
                          13,
                        ),
                        border: Border.all(
                          color: const Color(
                            0xFFF1F5F9,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons
                                    .description_outlined,
                                size: 15,
                                color: Color(
                                  0xFF64748B,
                                ),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              const Text(
                                'Laporan',
                                style:
                                    TextStyle(
                                  fontSize: 10,
                                  color: Color(
                                    0xFF64748B,
                                  ),
                                  fontWeight:
                                      FontWeight
                                          .w700,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 7,
                          ),

                          Text(
                            limitWords(
                              data.laporan,
                              25,
                            ),
                            maxLines: 4,
                            overflow:
                                TextOverflow
                                    .ellipsis,
                            style:
                                const TextStyle(
                              fontSize: 12,
                              color: Color(
                                0xFF475569,
                              ),
                              fontWeight:
                                  FontWeight
                                      .w500,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 13,
                    ),

                    // =================================================
                    // DETAIL BUTTON
                    // =================================================

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .end,
                      children: [
                        const Text(
                          'Lihat detail',
                          style: TextStyle(
                            fontSize: 10,
                            color: blue,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Container(
                          width: 25,
                          height: 25,
                          decoration:
                              BoxDecoration(
                            color: blue
                                .withOpacity(
                              0.07,
                            ),
                            shape:
                                BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons
                                .arrow_forward_rounded,
                            size: 14,
                            color: blue,
                          ),
                        ),
                      ],
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

  // ==========================================================
  // INFO LINE
  // ==========================================================

  Widget _infoLine({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius:
                BorderRadius.circular(9),
          ),
          child: Icon(
            icon,
            size: 14,
            color: const Color(0xFF64748B),
          ),
        ),
        const SizedBox(width: 9),
        Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 9,
                color: Color(0xFF94A3B8),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 11,
                color: primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================================
  // DATE BUTTON
  // ==========================================================

  Widget _dateButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius:
          BorderRadius.circular(13),
      onTap: onTap,
      child: Container(
        height: 48,
        padding:
            const EdgeInsets.symmetric(
          horizontal: 11,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius:
              BorderRadius.circular(13),
          border: Border.all(
            color: const Color(0xFFE8ECF2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 17,
              color: const Color(
                0xFF64748B,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // STATUS BADGE
  // ==========================================================

  Widget _statusBadge() {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(
          0.08,
        ),
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 12,
            color: Colors.green,
          ),
          SizedBox(width: 4),
          Text(
            'Laporan',
            style: TextStyle(
              fontSize: 9,
              color: Colors.green,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // IMAGE BADGE
  // ==========================================================

  Widget _imageBadge() {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(
          0.45,
        ),
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.photo_camera_outlined,
            size: 12,
            color: Colors.white,
          ),
          SizedBox(width: 5),
          Text(
            'Foto',
            style: TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // IMAGE ERROR
  // ==========================================================

  Widget _imageError() {
    return Container(
      height: 190,
      width: double.infinity,
      color: const Color(0xFFF1F5F9),
      child: const Center(
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Icon(
              Icons
                  .image_not_supported_outlined,
              size: 35,
              color: Color(0xFF94A3B8),
            ),
            SizedBox(height: 7),
            Text(
              'Foto tidak tersedia',
              style: TextStyle(
                fontSize: 10,
                color: Color(
                  0xFF94A3B8,
                ),
                fontWeight:
                    FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // EMPTY STATE
  // ==========================================================

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                color: blue.withOpacity(
                  0.07,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons
                    .assignment_outlined,
                size: 35,
                color: blue,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Belum Ada Laporan',
              style: TextStyle(
                fontSize: 16,
                color: primary,
                fontWeight:
                    FontWeight.w800,
              ),
            ),

            const SizedBox(height: 7),

            Text(
              'Data laporan situasi tidak ditemukan.\n'
              'Coba ubah filter atau rentang tanggal.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: Color(
                  0xFF94A3B8,
                ),
                height: 1.5,
              ),
            ),

            const SizedBox(height: 18),

            OutlinedButton.icon(
              onPressed: _showFilterBottomSheet,
              icon: const Icon(
                Icons.filter_alt_outlined,
                size: 16,
              ),
              label: const Text(
                'Ubah Filter',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
              style:
                  OutlinedButton.styleFrom(
                foregroundColor: blue,
                side: const BorderSide(
                  color: Color(
                    0xFFBFDBFE,
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
          ],
        ),
      ),
    );
  }
}

// ============================================================
// LIMIT WORDS
// ============================================================

String limitWords(
  String text,
  int maxWords,
) {
  final words =
      text.split(RegExp(r'\s+'));

  if (words.length <= maxWords) {
    return text;
  }

  return '${words.take(maxWords).join(' ')}...';
}