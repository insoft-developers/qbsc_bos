
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/utils/app_prefs.dart';
import 'package:qbsc_saas/app/utils/fungsi.dart';
import 'package:qbsc_saas/app/views/broadcast/broadcast_add.dart';
import 'package:qbsc_saas/app/views/broadcast/broadcast_controller.dart';
import 'package:qbsc_saas/app/views/broadcast/broadcast_detail.dart';
import 'package:qbsc_saas/app/views/broadcast/broadcast_model.dart';

class Broadcast extends StatefulWidget {
  const Broadcast({super.key});

  @override
  State<Broadcast> createState() => _BroadcastState();
}

class _BroadcastState extends State<Broadcast> {
  final BroadcastController controller = Get.put(BroadcastController());
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

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        controller.isMoreDataAvailable.value &&
        !controller.isLoading.value) {
      controller.fetchBroadcast(loadMore: true);
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
    DateTime? startDate;
    DateTime? endDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.fromLTRB(
            20,
            10,
            20,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(26),
            ),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HANDLE
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: blue.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.filter_alt_outlined,
                          color: blue,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Filter Broadcast',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: primary,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Pilih rentang tanggal',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // ==================================================
                  // DATE
                  // ==================================================

                  Row(
                    children: [
                      Expanded(
                        child: _dateButton(
                          label: 'Tanggal Mulai',
                          date: startDate,
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: startDate ?? DateTime.now(),
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
                          label: 'Tanggal Akhir',
                          date: endDate,
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: endDate ?? DateTime.now(),
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

                  const SizedBox(height: 20),

                  // ==================================================
                  // ACTION
                  // ==================================================

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
                              side: const BorderSide(
                                color: Color(0xFFE2E8F0),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                            ),
                            child: const Text(
                              'Reset',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF64748B),
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
                              );

                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
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
              );
            },
          ),
        );
      },
    );
  }

  // ==========================================================
  // DATE BUTTON
  // ==========================================================

  Widget _dateButton({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    final hasDate = date != null;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: hasDate
                    ? blue.withOpacity(0.08)
                    : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: hasDate
                    ? blue
                    : const Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 9,
                      color: Color(0xFF94A3B8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    hasDate
                        ? Fungsi.tanggalIndo(
                            date!.toIso8601String().substring(0, 10),
                          )
                        : 'Pilih tanggal',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: hasDate
                          ? primary
                          : const Color(0xFF64748B),
                      fontWeight: FontWeight.w700,
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
              Icons.campaign_outlined,
              color: Colors.white,
              size: 21,
            ),
            SizedBox(width: 10),
            Text(
              'Broadcast',
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
            icon: const Icon(
              Icons.filter_alt_outlined,
              size: 21,
            ),
          ),
          const SizedBox(width: 5),
        ],
      ),

      // ========================================================
      // FAB
      // ========================================================

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildFab(
            icon: Icons.refresh_rounded,
            color: green,
            tooltip: 'Refresh',
            onPressed: controller.refreshData,
          ),
          const SizedBox(height: 10),
          _buildFab(
            icon: Icons.add_rounded,
            color: blue,
            tooltip: 'Buat Broadcast',
            onPressed: () {
              Get.to(
                () => BroadcastAddPage(),
              );
            },
          ),
        ],
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: Obx(() {
        // ======================================================
        // LOADING
        // ======================================================

        if (controller.isLoading.value &&
            controller.broadcastList.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
            ),
          );
        }

        // ======================================================
        // EMPTY
        // ======================================================

        if (!controller.isLoading.value &&
            controller.broadcastList.isEmpty) {
          return _buildEmptyState();
        }

        // ======================================================
        // LIST
        // ======================================================

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
              controller.broadcastList.length +
              (controller.isMoreDataAvailable.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= controller.broadcastList.length) {
              return const Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              );
            }

            final BroadcastModel dataShow =
                controller.broadcastList[index];

            return _buildBroadcastCard(
              dataShow,
            );
          },
        );
      }),
    );
  }

  // ==========================================================
  // BROADCAST CARD
  // ==========================================================

  Widget _buildBroadcastCard(
    BroadcastModel data,
  ) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE8ECF2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            Get.to(
              () => BroadcastDetail(
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
                // HEADER
                // =================================================

                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF3B82F6),
                            Color(0xFF2563EB),
                          ],
                        ),
                        borderRadius:
                            BorderRadius.circular(13),
                      ),
                      child: const Icon(
                        Icons.campaign_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),

                    const SizedBox(width: 11),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.judul,
                            maxLines: 2,
                            overflow:
                                TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              color: primary,
                              fontWeight:
                                  FontWeight.w800,
                              height: 1.25,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Row(
                            children: [
                              const Icon(
                                Icons.access_time_rounded,
                                size: 12,
                                color: Color(0xFF94A3B8),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  Fungsi.formatDateTime(
                                    data.createdAt,
                                  ),
                                  maxLines: 1,
                                  overflow:
                                      TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 9.5,
                                    color: Color(0xFF94A3B8),
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

                    const SizedBox(width: 8),

                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 22,
                      color: Color(0xFFCBD5E1),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // =================================================
                // MESSAGE
                // =================================================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius:
                        BorderRadius.circular(13),
                  ),
                  child: Text(
                    limitWords(
                      data.pesan,
                      15,
                    ),
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF475569),
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // =================================================
                // FOOTER
                // =================================================

                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius:
                            BorderRadius.circular(9),
                      ),
                      child: const Icon(
                        Icons.person_outline_rounded,
                        size: 15,
                        color: Color(0xFF64748B),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Pengirim',
                            style: TextStyle(
                              fontSize: 8.5,
                              color: Color(0xFF94A3B8),
                              fontWeight:
                                  FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            data.senderName,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 10,
                              color: primary,
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: blue.withOpacity(0.07),
                        borderRadius:
                            BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.visibility_outlined,
                            size: 12,
                            color: blue,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Detail',
                            style: TextStyle(
                              fontSize: 8.5,
                              color: blue,
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),
                        ],
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

  // ==========================================================
  // FAB
  // ==========================================================

  Widget _buildFab({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return FloatingActionButton(
      heroTag: tooltip,
      mini: true,
      elevation: 5,
      backgroundColor: color,
      tooltip: tooltip,
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
                color: blue.withOpacity(0.07),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.campaign_outlined,
                size: 38,
                color: Color(0xFF94A3B8),
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Belum Ada Broadcast',
              style: TextStyle(
                fontSize: 16,
                color: primary,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 7),

            Text(
              'Belum ada pesan broadcast yang tersedia.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
                height: 1.5,
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
                'Muat Ulang',
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
                      BorderRadius.circular(11),
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
  final words = text.split(
    RegExp(r'\s+'),
  );

  if (words.length <= maxWords) {
    return text;
  }

  return '${words.take(maxWords).join(' ')}...';
}
