import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/utils/app_prefs.dart';
import 'package:qbsc_saas/app/utils/fungsi.dart';
import 'package:qbsc_saas/app/views/tamu/add/tamu_add.dart';
import 'package:qbsc_saas/app/views/tamu/tamu_controller.dart';
import 'package:qbsc_saas/app/views/tamu/tamu_detail.dart';
import 'package:qbsc_saas/app/views/tamu/tamu_model.dart';

class TamuPage extends StatefulWidget {
  const TamuPage({super.key});

  @override
  State<TamuPage> createState() => _TamuPageState();
}

class _TamuPageState extends State<TamuPage> {
  final TamuController controller = Get.put(TamuController());
  final ScrollController scrollController = ScrollController();

  final myComId = AppPrefs.getComId();
  final selectedComId = AppPrefs.getMonComId();

  static const Color primary = Color(0xFF0F172A);
  static const Color blue = Color(0xFF2563EB);
  static const Color green = Color(0xFF16A34A);
  static const Color background = Color(0xFFF6F8FC);

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  // ==========================================================
  // PAGINATION
  // ==========================================================

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        controller.isMoreDataAvailable.value &&
        !controller.isLoading.value) {
      controller.fetchTamu(loadMore: true);
    }
  }

  // ==========================================================
  // FILTER
  // ==========================================================

  void _showFilterBottomSheet() {
    int? selectedSatpamId =
        controller.selectedSatpamId.value;

    int? selectedUserId =
        controller.selectedUserId.value;

    DateTime? startDate;
    DateTime? endDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: EdgeInsets.fromLTRB(
                18,
                10,
                18,
                MediaQuery.of(context).viewInsets.bottom + 18,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(26),
                ),
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
                        color: Colors.grey.shade300,
                        borderRadius:
                            BorderRadius.circular(20),
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
                              BorderRadius.circular(13),
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
                            'Filter Tamu',
                            style: TextStyle(
                              fontSize: 16,
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
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ==================================================
                  // TANGGAL
                  // ==================================================

                  const Text(
                    'Periode',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF475569),
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
                                      .substring(0, 10),
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
                              setSheetState(
                                () => startDate = date,
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _dateButton(
                          icon: Icons
                              .calendar_month_outlined,
                          label: endDate == null
                              ? 'Tanggal Akhir'
                              : Fungsi.tanggalIndo(
                                  endDate!
                                      .toIso8601String()
                                      .substring(0, 10),
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
                              setSheetState(
                                () => endDate = date,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // ==================================================
                  // SATPAM
                  // ==================================================

                  Obx(
                    () => _dropdown<int>(
                      label: 'Satpam',
                      icon:
                          Icons.person_outline_rounded,
                      value: selectedSatpamId,
                      items: [
                        const DropdownMenuItem<int>(
                          value: null,
                          child:
                              Text('Semua Satpam'),
                        ),
                        ...controller.satpamList.map(
                          (s) => DropdownMenuItem<int>(
                            value: s.id,
                            child: Text(s.name),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setSheetState(
                          () => selectedSatpamId =
                              value,
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ==================================================
                  // USER
                  // ==================================================

                  Obx(
                    () => _dropdown<int>(
                      label: 'Dibuat Oleh',
                      icon:
                          Icons.admin_panel_settings_outlined,
                      value: selectedUserId,
                      items: [
                        const DropdownMenuItem<int>(
                          value: null,
                          child: Text('Semua'),
                        ),
                        ...controller.userList.map(
                          (s) => DropdownMenuItem<int>(
                            value: s.id,
                            child: Text(s.name),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setSheetState(
                          () => selectedUserId =
                              value,
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ==================================================
                  // BUTTON
                  // ==================================================

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            controller.clearFilter();
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.restart_alt_rounded,
                            size: 18,
                          ),
                          label:
                              const Text('Reset'),
                          style:
                              OutlinedButton.styleFrom(
                            foregroundColor:
                                const Color(
                              0xFF475569,
                            ),
                            side: BorderSide(
                              color:
                                  Colors.grey.shade300,
                            ),
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              vertical: 13,
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
                              userId: selectedUserId,
                            );

                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.check_rounded,
                            size: 18,
                          ),
                          label:
                              const Text('Terapkan Filter'),
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            foregroundColor:
                                Colors.white,
                            elevation: 0,
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              vertical: 13,
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
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
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
              Icons.groups_outlined,
              color: Colors.white,
              size: 21,
            ),
            SizedBox(width: 10),
            Text(
              'Monitoring Tamu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
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
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.10),
                borderRadius:
                    BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.tune_rounded,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      // ========================================================
      // FAB
      // ========================================================

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _fab(
            icon: Icons.refresh_rounded,
            color: green,
            tooltip: 'Refresh',
            onPressed: controller.refreshData,
          ),
          const SizedBox(height: 12),
          _fab(
            icon: Icons.person_add_alt_1_rounded,
            color: blue,
            tooltip: 'Tambah Tamu',
            onPressed: () {
              Get.to(() => TamuAddPage());
            },
          ),
        ],
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: Obx(() {
        // LOADING
        if (controller.isLoading.value &&
            controller.tamuList.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
            ),
          );
        }

        // EMPTY
        if (!controller.isLoading.value &&
            controller.tamuList.isEmpty) {
          return _emptyState();
        }

        // LIST
        return ListView.builder(
          controller: scrollController,
          physics:
              const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            14,
            14,
            14,
            100,
          ),
          itemCount:
              controller.tamuList.length +
              (controller.isMoreDataAvailable.value
                  ? 1
                  : 0),
          itemBuilder: (context, index) {
            if (index >=
                controller.tamuList.length) {
              return const Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              );
            }

            final TamuModel tamu =
                controller.tamuList[index];

            return _tamuCard(tamu);
          },
        );
      }),
    );
  }

  // ==========================================================
  // TAMU CARD
  // ==========================================================

  Widget _tamuCard(TamuModel tamu) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        child: InkWell(
          borderRadius:
              BorderRadius.circular(18),
          onTap: () {
            Get.to(
              () => TamuDetail(
                data: tamu,
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(18),
              border: Border.all(
                color:
                    const Color(0xFFE8ECF2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(0.035),
                  blurRadius: 12,
                  offset:
                      const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                // =================================================
                // HEADER CARD
                // =================================================

                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color:
                            blue.withOpacity(
                          0.08,
                        ),
                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),
                      child: const Icon(
                        Icons
                            .person_outline_rounded,
                        color: blue,
                        size: 23,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            tamu.namaTamu,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style:
                                const TextStyle(
                              fontSize: 14,
                              fontWeight:
                                  FontWeight.w800,
                              color: primary,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                Icons
                                    .schedule_outlined,
                                size: 13,
                                color: Colors
                                    .grey
                                    .shade500,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  '${Fungsi.tanggalIndo(tamu.createdAt)} • ${Fungsi.formatToTime(tamu.createdAt)}',
                                  style:
                                      TextStyle(
                                    fontSize: 10,
                                    color: Colors
                                        .grey
                                        .shade500,
                                    fontWeight:
                                        FontWeight
                                            .w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // JUMLAH TAMU
                    Container(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 9,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color:
                            green.withOpacity(
                          0.08,
                        ),
                        borderRadius:
                            BorderRadius.circular(
                          10,
                        ),
                      ),
                      child: Row(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons
                                .groups_outlined,
                            size: 14,
                            color: green,
                          ),
                          const SizedBox(
                              width: 4),
                          Text(
                            '${tamu.jumlahTamu}',
                            style:
                                const TextStyle(
                              fontSize: 11,
                              fontWeight:
                                  FontWeight.w800,
                              color: green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // =================================================
                // DETAIL
                // =================================================

                _detailItem(
                  icon:
                      Icons.location_on_outlined,
                  label: 'Tujuan',
                  value:
                      tamu.tujuan?.trim().isEmpty ??
                              true
                          ? '-'
                          : tamu.tujuan!,
                ),

                _detailItem(
                  icon:
                      Icons.notes_outlined,
                  label: 'Catatan',
                  value:
                      tamu.catatan?.trim().isEmpty ??
                              true
                          ? '-'
                          : tamu.catatan!,
                ),

                _detailItem(
                  icon:
                      Icons.admin_panel_settings_outlined,
                  label: 'Dibuat Oleh',
                  value:
                      tamu.createdName
                              ?.trim()
                              .isEmpty ??
                          true
                      ? '-'
                      : tamu.createdName!,
                ),

                const SizedBox(height: 5),

                // =================================================
                // FOOTER
                // =================================================

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.end,
                  children: [
                    Text(
                      'Lihat detail',
                      style:
                          TextStyle(
                        fontSize: 10,
                        fontWeight:
                            FontWeight.w700,
                        color: blue,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons
                          .arrow_forward_ios_rounded,
                      size: 10,
                      color: blue,
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

  // ==========================================================
  // DETAIL ITEM
  // ==========================================================

  Widget _detailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 10),
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
          SizedBox(
            width: 75,
            child: Padding(
              padding:
                  const EdgeInsets.only(
                top: 5,
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  color:
                      Color(0xFF94A3B8),
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(
                top: 4,
              ),
              child: Text(
                value,
                maxLines: 2,
                overflow:
                    TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11.5,
                  color:
                      Color(0xFF334155),
                  fontWeight:
                      FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ),
          ),
        ],
      ),
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
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(12),
      child: Container(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 11,
          vertical: 12,
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
                  fontSize: 10.5,
                  fontWeight:
                      FontWeight.w600,
                  color:
                      Color(0xFF334155),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // DROPDOWN
  // ==========================================================

  Widget _dropdown<T>({
    required String label,
    required IconData icon,
    required T? value,
    required List<DropdownMenuItem<T>>
        items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          size: 19,
          color: blue,
        ),
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor:
            const Color(0xFFF8FAFC),
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12),
          borderSide: BorderSide(
            color:
                Colors.grey.shade200,
          ),
        ),
        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12),
          borderSide: BorderSide(
            color:
                Colors.grey.shade200,
          ),
        ),
        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12),
          borderSide:
              const BorderSide(
            color: blue,
            width: 1.2,
          ),
        ),
      ),
      items: items,
      onChanged: onChanged,
    );
  }

  // ==========================================================
  // FAB
  // ==========================================================

  Widget _fab({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return FloatingActionButton(
      heroTag: tooltip,
      tooltip: tooltip,
      backgroundColor: color,
      elevation: 5,
      onPressed: onPressed,
      child: Icon(
        icon,
        color: Colors.white,
        size: 21,
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
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color:
                    blue.withOpacity(0.07),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons
                    .person_search_outlined,
                size: 39,
                color: blue,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Belum Ada Data Tamu',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight:
                    FontWeight.w800,
                color: primary,
              ),
            ),

            const SizedBox(height: 7),

            Text(
              'Data tamu yang sesuai dengan filter\nakan ditampilkan di sini.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                height: 1.5,
                color:
                    Colors.grey.shade500,
              ),
            ),

            const SizedBox(height: 18),

            OutlinedButton.icon(
              onPressed:
                  _showFilterBottomSheet,
              icon: const Icon(
                Icons.filter_alt_outlined,
                size: 17,
              ),
              label:
                  const Text('Atur Filter'),
              style:
                  OutlinedButton.styleFrom(
                foregroundColor: blue,
                side: BorderSide(
                  color:
                      blue.withOpacity(0.25),
                ),
                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 18,
                  vertical: 11,
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
}