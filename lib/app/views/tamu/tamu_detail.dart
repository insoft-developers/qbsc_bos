import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/app_prefs.dart';
import 'package:qbsc_saas/app/utils/fungsi.dart';
import 'package:qbsc_saas/app/views/patroli/patroli_foto_preview.dart';
import 'package:qbsc_saas/app/views/tamu/tamu_controller.dart';
import 'package:qbsc_saas/app/views/tamu/tamu_model.dart';

class TamuDetail extends StatelessWidget {
  final TamuModel data;

  const TamuDetail({
    super.key,
    required this.data,
  });

  static const Color primary = Color(0xFF0F172A);
  static const Color blue = Color(0xFF2563EB);
  static const Color green = Color(0xFF16A34A);
  static const Color orange = Color(0xFFF59E0B);
  static const Color red = Color(0xFFDC2626);
  static const Color background = Color(0xFFF6F8FC);

  // ==========================================================
  // DELETE CONFIRMATION
  // ==========================================================

  void _confirmDelete(
    BuildContext context,
    TamuController controller,
    int id,
  ) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: red.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: red,
                  size: 28,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Hapus Data Tamu?',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: primary,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Data tamu yang sudah dihapus tidak dapat dikembalikan.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  height: 1.5,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 22),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor:
                            const Color(0xFF475569),
                        side: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        controller.deleteTamu(id);
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: red,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Hapus',
                        style: TextStyle(
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
      ),
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TamuController>();
    final userId =
        int.parse(AppPrefs.getUserId() ?? '0');

    final status = _getStatus(data.isStatus);

    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        titleSpacing: 18,
        title: const Row(
          children: [
            Icon(
              Icons.badge_outlined,
              color: Colors.white,
              size: 21,
            ),
            SizedBox(width: 10),
            Text(
              'Detail Tamu',
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
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ==================================================
            // HERO HEADER
            // ==================================================

            Container(
              width: double.infinity,
              color: primary,
              padding: const EdgeInsets.fromLTRB(
                16,
                4,
                16,
                24,
              ),
              child: Column(
                children: [
                  _fotoTamu(
                    context,
                    data.foto,
                  ),

                  const SizedBox(height: 16),

                  // NAMA + STATUS
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.namaTamu,
                              maxLines: 2,
                              overflow:
                                  TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight:
                                    FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Row(
                              children: [
                                Icon(
                                  Icons
                                      .schedule_outlined,
                                  size: 13,
                                  color: Colors.white
                                      .withOpacity(
                                    0.65,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '${Fungsi.tanggalIndo(data.createdAt)} • ${Fungsi.formatToTime(data.createdAt)}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white
                                        .withOpacity(
                                      0.65,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      _statusBadge(
                        status.text,
                        status.color,
                        status.icon,
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // JUMLAH TAMU
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(0.08),
                        borderRadius:
                            BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white
                              .withOpacity(0.10),
                        ),
                      ),
                      child: Row(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons
                                .groups_outlined,
                            size: 17,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 7),
                          Text(
                            '${data.jumlahTamu} Orang',
                            style:
                                const TextStyle(
                              fontSize: 11,
                              fontWeight:
                                  FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ==================================================
            // CONTENT
            // ==================================================

            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  _sectionCard(
                    icon: Icons.person_outline_rounded,
                    iconColor: blue,
                    title: 'Informasi Tamu',
                    children: [
                      _infoRow(
                        Icons.badge_outlined,
                        'Nama Tamu',
                        data.namaTamu,
                      ),
                      _infoRow(
                        Icons.groups_outlined,
                        'Jumlah Tamu',
                        '${data.jumlahTamu} orang',
                      ),
                      _infoRow(
                        Icons.location_on_outlined,
                        'Tujuan',
                        _safeText(data.tujuan),
                      ),
                      _infoRow(
                        Icons.phone_outlined,
                        'Whatsapp',
                        _safeText(data.whatsapp),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  _sectionCard(
                    icon: Icons.access_time_rounded,
                    iconColor: orange,
                    title: 'Aktivitas Tamu',
                    children: [
                      _infoRow(
                        Icons.login_rounded,
                        'Datang',
                        _safeText(
                          data.arriveAt,
                        ),
                      ),
                      _infoRow(
                        Icons.logout_rounded,
                        'Pulang',
                        _safeText(
                          data.leaveAt,
                        ),
                      ),
                      _infoRow(
                        Icons.verified_outlined,
                        'Status',
                        status.text,
                        valueColor:
                            status.color,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  _sectionCard(
                    icon: Icons.info_outline_rounded,
                    iconColor: green,
                    title: 'Metadata',
                    children: [
                      _infoRow(
                        Icons.calendar_today_outlined,
                        'Dibuat',
                        Fungsi.formatDateTime(
                          data.createdAt,
                        ),
                      ),
                      _infoRow(
                        Icons.business_outlined,
                        'Perusahaan',
                        data.comName,
                      ),
                    ],
                  ),

                  // ==================================================
                  // ACTION
                  // ==================================================

                  if (data.createdBy == userId &&
                      data.isStatus == 1) ...[
                    const SizedBox(height: 20),

                    _actionButton(
                      icon:
                          Icons.qr_code_2_rounded,
                      label:
                          'Salin Link QR Tamu',
                      color: green,
                      onPressed: () {
                        copyLink(
                          context,
                          '${ApiProvider.rootUrl}/copy_link_tamu/${data.uuid}',
                        );
                      },
                    ),
                  ],

                  if (data.createdBy == userId) ...[
                    const SizedBox(height: 10),

                    _actionButton(
                      icon:
                          Icons.delete_outline_rounded,
                      label: 'Hapus Data Tamu',
                      color: red,
                      onPressed: () {
                        _confirmDelete(
                          context,
                          controller,
                          data.id,
                        );
                      },
                    ),
                  ],

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // FOTO
  // ==========================================================

  Widget _fotoTamu(
    BuildContext context,
    String? foto,
  ) {
    final hasImage =
        foto != null &&
        foto.trim().isNotEmpty;

    final imageUrl = hasImage
        ? '${ApiProvider.imageUrl}/$foto'
        : null;

    return GestureDetector(
      onTap: hasImage
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      PatroliFotoPreview(
                    imageUrl: imageUrl!,
                  ),
                ),
              );
            }
          : null,
      child: Hero(
        tag: imageUrl ?? 'tamu-no-image',
        child: Container(
          width: double.infinity,
          height: 205,
          decoration: BoxDecoration(
            color:
                const Color(0xFF1E293B),
            borderRadius:
                BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white
                  .withOpacity(0.08),
            ),
          ),
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(18),
            child: hasImage
                ? Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    loadingBuilder:
                        (_, child, progress) {
                      if (progress == null) {
                        return child;
                      }

                      return const Center(
                        child:
                            CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      );
                    },
                    errorBuilder:
                        (_, __, ___) =>
                            _photoPlaceholder(),
                  )
                : _photoPlaceholder(),
          ),
        ),
      ),
    );
  }

  Widget _photoPlaceholder() {
    return Column(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: Colors.white
                .withOpacity(0.06),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons
                .image_not_supported_outlined,
            size: 28,
            color: Colors.white54,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Tidak ada foto tamu',
          style: TextStyle(
            fontSize: 11,
            color: Colors.white54,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // SECTION CARD
  // ==========================================================

  Widget _sectionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color:
              const Color(0xFFE8ECF2),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(
              0.025,
            ),
            blurRadius: 12,
            offset:
                const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconColor
                      .withOpacity(0.08),
                  borderRadius:
                      BorderRadius.circular(
                    11,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: iconColor,
                ),
              ),

              const SizedBox(width: 10),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight:
                      FontWeight.w800,
                  color: primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 13),

          ...children,
        ],
      ),
    );
  }

  // ==========================================================
  // INFO ROW
  // ==========================================================

  Widget _infoRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        vertical: 9,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color:
                const Color(0xFFF1F5F9),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color:
                const Color(0xFF94A3B8),
          ),

          const SizedBox(width: 9),

          SizedBox(
            width: 82,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 10.5,
                color:
                    Color(0xFF94A3B8),
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight:
                    FontWeight.w600,
                color: valueColor ??
                    const Color(
                      0xFF334155,
                    ),
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // STATUS
  // ==========================================================

  Widget _statusBadge(
    String text,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius:
            BorderRadius.circular(11),
        border: Border.all(
          color:
              color.withOpacity(0.25),
        ),
      ),
      child: Row(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: color,
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: 9.5,
              fontWeight:
                  FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // ACTION BUTTON
  // ==========================================================

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 20,
        ),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight:
                FontWeight.w700,
          ),
        ),
        style:
            ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor:
              Colors.white,
          elevation: 0,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              14,
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // STATUS HELPER
  // ==========================================================

  _StatusData _getStatus(int status) {
    switch (status) {
      case 1:
        return const _StatusData(
          'Appointment',
          blue,
          Icons.event_available_outlined,
        );

      case 2:
        return const _StatusData(
          'Datang',
          green,
          Icons.login_rounded,
        );

      case 3:
        return const _StatusData(
          'Pulang',
          orange,
          Icons.logout_rounded,
        );

      default:
        return const _StatusData(
          'Tidak Diketahui',
          Colors.grey,
          Icons.help_outline_rounded,
        );
    }
  }

  // ==========================================================
  // SAFE TEXT
  // ==========================================================

  String _safeText(String? value) {
    if (value == null ||
        value.trim().isEmpty) {
      return '-';
    }

    return value;
  }

  // ==========================================================
  // COPY QR LINK
  // ==========================================================

  void copyLink(
    BuildContext context,
    String link,
  ) {
    Clipboard.setData(
      ClipboardData(text: link),
    );

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        behavior:
            SnackBarBehavior.floating,
        backgroundColor: primary,
        margin: const EdgeInsets.all(14),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(12),
        ),
        content: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: green
                    .withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: green,
                size: 18,
              ),
            ),

            const SizedBox(width: 10),

            const Expanded(
              child: Text(
                'Link QR berhasil disalin!',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        duration:
            const Duration(
          milliseconds: 1800,
        ),
      ),
    );
  }
}

// ============================================================
// STATUS MODEL
// ============================================================

class _StatusData {
  final String text;
  final Color color;
  final IconData icon;

  const _StatusData(
    this.text,
    this.color,
    this.icon,
  );
}
