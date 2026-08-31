
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/fungsi.dart';
import 'package:qbsc_saas/app/views/doc/doc_controller.dart';
import 'package:qbsc_saas/app/views/doc/doc_detail.dart';
import 'package:qbsc_saas/app/views/doc/doc_model.dart';

class DocPage extends StatefulWidget {
  const DocPage({super.key});

  @override
  State<DocPage> createState() => _DocPageState();
}

class _DocPageState extends State<DocPage> {
  final DocController controller = Get.put(DocController());
  final ScrollController scrollController = ScrollController();

  static const Color primary = Color(0xFF0F172A);
  static const Color blue = Color(0xFF2563EB);
  static const Color green = Color(0xFF16A34A);
  static const Color orange = Color(0xFFF59E0B);
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
      controller.fetchDoc(loadMore: true);
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
    int? selectedEkspedisiId = controller.selectedEkspedisiId.value;

    DateTime? startDate;
    DateTime? endDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              10,
              20,
              MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: StatefulBuilder(
              builder: (context, setState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // HANDLE
                      Center(
                        child: Container(
                          width: 42,
                          height: 4,
                          margin: const EdgeInsets.only(
                            bottom: 20,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      // HEADER
                      Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: blue.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(13),
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
                                'Filter Catatan DOC',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: primary,
                                ),
                              ),
                              SizedBox(height: 3),
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
                              label: startDate == null
                                  ? 'Tanggal Mulai'
                                  : Fungsi.tanggalIndo(
                                      startDate!
                                          .toIso8601String()
                                          .substring(0, 10),
                                    ),
                              icon: Icons.calendar_today_outlined,
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
                              label: endDate == null
                                  ? 'Tanggal Akhir'
                                  : Fungsi.tanggalIndo(
                                      endDate!
                                          .toIso8601String()
                                          .substring(0, 10),
                                    ),
                              icon: Icons.event_outlined,
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

                      const SizedBox(height: 16),

                      // =================================================
                      // SATPAM
                      // =================================================

                      _buildDropdown(
                        label: 'Satpam',
                        icon: Icons.person_outline_rounded,
                        value: selectedSatpamId,
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
                        onChanged: (value) {
                          setState(() {
                            selectedSatpamId = value;
                          });
                        },
                      ),

                      const SizedBox(height: 14),

                      // =================================================
                      // EKSPEDISI
                      // =================================================

                      _buildDropdown(
                        label: 'Ekspedisi',
                        icon: Icons.local_shipping_outlined,
                        value: selectedEkspedisiId,
                        items: [
                          const DropdownMenuItem<int>(
                            value: null,
                            child: Text(
                              'Semua Ekspedisi',
                            ),
                          ),
                          ...controller.ekspedisiList.map(
                            (s) => DropdownMenuItem<int>(
                              value: s.id,
                              child: Text(s.name),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedEkspedisiId = value;
                          });
                        },
                      ),

                      const SizedBox(height: 22),

                      // =================================================
                      // BUTTON
                      // =================================================

                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: OutlinedButton(
                                onPressed: () {
                                  controller.clearFilter();
                                  Navigator.pop(context);
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(
                                    0xFF475569,
                                  ),
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
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: SizedBox(
                              height: 48,
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
                                    ekspedisiId:
                                        selectedEkspedisiId,
                                  );

                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primary,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(13),
                                  ),
                                ),
                                child: const Text(
                                  'Terapkan Filter',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
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

      // =======================================================
      // APP BAR
      // =======================================================

      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        titleSpacing: 18,
        title: const Text(
          'Catatan DOC',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
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
                color: Colors.white.withOpacity(0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.filter_alt_outlined,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      // =======================================================
      // REFRESH
      // =======================================================

      floatingActionButton: FloatingActionButton(
        heroTag: 'doc-refresh',
        mini: true,
        elevation: 4,
        backgroundColor: primary,
        onPressed: controller.refreshData,
        child: const Icon(
          Icons.refresh_rounded,
          color: Colors.white,
          size: 21,
        ),
      ),

      // =======================================================
      // BODY
      // =======================================================

      body: Obx(() {
        // LOADING AWAL
        if (controller.isLoading.value &&
            controller.docList.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
            ),
          );
        }

        // DATA KOSONG
        if (!controller.isLoading.value &&
            controller.docList.isEmpty) {
          return _buildEmptyState();
        }

        // DATA
        return ListView.builder(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            14,
            14,
            14,
            80,
          ),
          itemCount:
              controller.docList.length +
              (controller.isMoreDataAvailable.value
                  ? 1
                  : 0),
          itemBuilder: (context, index) {
            if (index >= controller.docList.length) {
              return const Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              );
            }

            final DocModel dataShow =
                controller.docList[index];

            final fotos =
                parseFotoDynamic(dataShow.foto);

            final boxOptions =
                parseDocBoxOption(
              dataShow.docBoxOptionJson,
            );

            return _buildDocCard(
              dataShow,
              fotos,
              boxOptions,
            );
          },
        );
      }),
    );
  }

  // =========================================================
  // DOC CARD
  // =========================================================

  Widget _buildDocCard(
    DocModel data,
    List<String> fotos,
    List<Map<String, dynamic>> boxOptions,
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
              () => DocDetail(
                data: data,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                // =================================================
                // HEADER CARD
                // =================================================

                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
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
                        Icons.inventory_2_outlined,
                        color: blue,
                        size: 21,
                      ),
                    ),

                    const SizedBox(width: 11),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            Fungsi.tanggalIndo(
                              data.tanggal,
                            ),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight:
                                  FontWeight.w800,
                              color: primary,
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            data.jam,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF94A3B8),
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: Color(0xFF94A3B8),
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
                        icon: Icons.inventory_2_outlined,
                        label: 'Jumlah Box',
                        value:
                            '${data.jumlah} Box',
                        color: blue,
                      ),
                    ),

                    const SizedBox(width: 9),

                    Expanded(
                      child: _summaryBox(
                        icon: Icons.egg_alt_outlined,
                        label: 'Total Ekor',
                        value:
                            '${data.totalEkor}',
                        color: green,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // =================================================
                // INFO
                // =================================================

                _infoLine(
                  icon: Icons.local_shipping_outlined,
                  label: 'Ekspedisi',
                  value:
                      data.ekspedisiName,
                ),

                _infoLine(
                  icon: Icons.person_outline_rounded,
                  label: 'Satpam',
                  value:
                      data.satpamName,
                ),

                _infoLine(
                  icon: Icons.directions_car_outlined,
                  label: 'No Polisi',
                  value:
                      data.noPolisi ?? '',
                ),

                _infoLine(
                  icon: Icons.location_on_outlined,
                  label: 'Tujuan',
                  value:
                      data.tujuan ?? '',
                  isLast: true,
                ),

                // =================================================
                // DETAIL BOX
                // =================================================

                if (boxOptions.isNotEmpty) ...[
                  const SizedBox(height: 14),

                  _sectionTitle(
                    icon: Icons.inventory_2_outlined,
                    title: 'Detail Box',
                  ),

                  const SizedBox(height: 8),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius:
                          BorderRadius.circular(13),
                    ),
                    child: Column(
                      children:
                          boxOptions.map((opt) {
                        return _buildBoxItem(
                          opt,
                        );
                      }).toList(),
                    ),
                  ),
                ],

                // =================================================
                // FOTO
                // =================================================

                if (fotos.isNotEmpty) ...[
                  const SizedBox(height: 14),

                  _sectionTitle(
                    icon: Icons.photo_library_outlined,
                    title:
                        'Dokumentasi',
                  ),

                  const SizedBox(height: 8),

                  SizedBox(
                    height: 70,
                    child: ListView.separated(
                      scrollDirection:
                          Axis.horizontal,
                      itemCount: fotos.length,
                      separatorBuilder:
                          (_, __) =>
                              const SizedBox(
                                width: 8,
                              ),
                      itemBuilder:
                          (context, i) {
                        return _buildPhoto(
                          fotos[i],
                        );
                      },
                    ),
                  ),
                ],

                // =================================================
                // CATATAN
                // =================================================

                if (data.note != null &&
                    data.note!.isNotEmpty) ...[
                  const SizedBox(height: 14),

                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(
                        0xFFFFFBEB,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        13,
                      ),
                      border: Border.all(
                        color: const Color(
                          0xFFFDE68A,
                        ),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons
                              .sticky_note_2_outlined,
                          size: 16,
                          color: orange,
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: Text(
                            data.note!,
                            style:
                                const TextStyle(
                              fontSize: 10,
                              height: 1.4,
                              color: Color(
                                0xFF78350F,
                              ),
                              fontWeight:
                                  FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
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
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: color.withOpacity(0.12),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 31,
            height: 31,
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              icon,
              size: 16,
              color: color,
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 8,
                    color: Color(0xFF94A3B8),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    color: color,
                    fontWeight: FontWeight.w800,
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
  // INFO LINE
  // =========================================================

  Widget _infoLine({
    required IconData icon,
    required String label,
    required String value,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: isLast ? 0 : 9,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: const Color(0xFF64748B),
          ),

          const SizedBox(width: 9),

          SizedBox(
            width: 72,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 9,
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
                color: Color(0xFF334155),
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // SECTION TITLE
  // =========================================================

  Widget _sectionTitle({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 15,
          color: const Color(0xFF64748B),
        ),

        const SizedBox(width: 6),

        Text(
          title,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: primary,
          ),
        ),
      ],
    );
  }

  // =========================================================
  // DETAIL BOX
  // =========================================================

  Widget _buildBoxItem(
    Map<String, dynamic> opt,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              size: 14,
              color: blue,
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              '${opt['option_name']}',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: primary,
              ),
            ),
          ),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(8),
            ),
            child: Text(
              '${opt['jumlah_box']} box',
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: blue,
              ),
            ),
          ),

          const SizedBox(width: 5),

          Text(
            '× ${opt['isi']}',
            style: const TextStyle(
              fontSize: 9,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(width: 6),

          Text(
            '${opt['total_ekor']} ekor',
            style: const TextStyle(
              fontSize: 9,
              color: green,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // FOTO
  // =========================================================

  Widget _buildPhoto(
    String foto,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        "${ApiProvider.imageUrl}/$foto",
        width: 70,
        height: 70,
        fit: BoxFit.cover,
        errorBuilder:
            (_, __, ___) {
          return Container(
            width: 70,
            height: 70,
            color: const Color(
              0xFFF1F5F9,
            ),
            child: const Icon(
              Icons.broken_image_outlined,
              size: 20,
              color: Color(
                0xFF94A3B8,
              ),
            ),
          );
        },
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
            width: 70,
            height: 70,
            color: const Color(
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
      ),
    );
  }

  // =========================================================
  // EMPTY STATE
  // =========================================================

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: blue.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                size: 38,
                color: Color(0xFF94A3B8),
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Data DOC tidak ditemukan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: primary,
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'Belum ada catatan DOC yang sesuai dengan filter yang dipilih.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                height: 1.5,
                color: Color(0xFF94A3B8),
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
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(13),
      onTap: onTap,
      child: Container(
        height: 52,
        padding:
            const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius:
              BorderRadius.circular(13),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
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
                overflow:
                    TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color(
                    0xFF475569,
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
  // DROPDOWN
  // =========================================================

  Widget _buildDropdown({
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
          color: const Color(
            0xFF64748B,
          ),
        ),
        filled: true,
        fillColor: const Color(
          0xFFF8FAFC,
        ),
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 15,
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
            color: Color(0xFFE5E7EB),
          ),
        ),
        focusedBorder:
            OutlineInputBorder(
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
}

// =============================================================
// FOTO PARSER
// =============================================================

List<String> parseFotoDynamic(
  dynamic foto,
) {
  if (foto == null) return [];

  if (foto is List) {
    return foto
        .map((e) => e.toString())
        .toList();
  }

  if (foto is String &&
      foto.isNotEmpty) {
    if (foto.trim().startsWith('[')) {
      try {
        final List list =
            jsonDecode(foto);

        return list
            .map((e) => e.toString())
            .toList();
      } catch (_) {}
    }

    return [foto];
  }

  return [];
}

// =============================================================
// DETAIL BOX PARSER
// =============================================================

List<Map<String, dynamic>>
    parseDocBoxOption(
  String? jsonStr,
) {
  if (jsonStr == null ||
      jsonStr.isEmpty) {
    return [];
  }

  try {
    final List list =
        jsonDecode(jsonStr);

    return list
        .cast<Map<String, dynamic>>();
  } catch (_) {
    return [];
  }
}
