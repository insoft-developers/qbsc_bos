import 'package:flutter/material.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/fungsi.dart';
import 'package:qbsc_saas/app/views/patroli/patroli_foto_preview.dart';
import 'package:qbsc_saas/app/views/situasi/situasi_model.dart';

class SituasiDetail extends StatelessWidget {
  final SituasiModel data;

  const SituasiDetail({
    super.key,
    required this.data,
  });

  static const Color primary = Color(0xFF0F172A);
  static const Color blue = Color(0xFF2563EB);
  static const Color background = Color(0xFFF6F8FC);

  @override
  Widget build(BuildContext context) {
    final bool hasImage =
        data.foto != null &&
        data.foto!.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: background,

      // ==========================================================
      // APP BAR
      // ==========================================================

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
              'Detail Laporan Situasi',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),

      // ==========================================================
      // BODY
      // ==========================================================

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ======================================================
            // HEADER
            // ======================================================

            Container(
              width: double.infinity,
              color: primary,
              padding: const EdgeInsets.fromLTRB(
                16,
                4,
                16,
                26,
              ),
              child: Column(
                children: [
                  // FOTO
                  _buildPhoto(
                    context,
                    hasImage
                        ? '${ApiProvider.imageUrl}/${data.foto!}'
                        : null,
                  ),

                  const SizedBox(height: 16),

                  // PETUGAS
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color:
                              Colors.white.withOpacity(
                            0.10,
                          ),
                          borderRadius:
                              BorderRadius.circular(
                            11,
                          ),
                        ),
                        child: const Icon(
                          Icons.person_outline_rounded,
                          color: Colors.white,
                          size: 19,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dilaporkan oleh',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.white
                                  .withOpacity(0.55),
                              fontWeight:
                                  FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            data.satpamName,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight:
                                  FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ======================================================
            // CONTENT
            // ======================================================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                14,
                14,
                14,
                30,
              ),
              child: Column(
                children: [
                  // =================================================
                  // INFORMASI
                  // =================================================

                  _sectionCard(
                    icon: Icons.info_outline_rounded,
                    title: 'Informasi Laporan',
                    child: Column(
                      children: [
                        _infoRow(
                          icon: Icons.tag_outlined,
                          label: 'ID Laporan',
                          value: data.id.toString(),
                        ),
                        _divider(),
                        _infoRow(
                          icon:
                              Icons.calendar_today_outlined,
                          label: 'Tanggal',
                          value:
                              Fungsi.tanggalIndo(
                            data.tanggal,
                          ),
                        ),
                        _divider(),
                        _infoRow(
                          icon:
                              Icons.access_time_rounded,
                          label: 'Jam',
                          value:
                              Fungsi.formatToTime(
                            data.tanggal,
                          ),
                        ),
                        _divider(),
                        _infoRow(
                          icon:
                              Icons.person_outline_rounded,
                          label: 'Satpam',
                          value: data.satpamName,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // =================================================
                  // LAPORAN
                  // =================================================

                  _sectionCard(
                    icon:
                        Icons.description_outlined,
                    title: 'Isi Laporan',
                    child: Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color:
                            const Color(0xFFF8FAFC),
                        borderRadius:
                            BorderRadius.circular(
                          13,
                        ),
                        border: Border.all(
                          color:
                              const Color(0xFFE8ECF2),
                        ),
                      ),
                      child: Text(
                        data.laporan.trim().isEmpty
                            ? 'Tidak ada laporan.'
                            : data.laporan,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF334155),
                          fontWeight: FontWeight.w500,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // =================================================
                  // METADATA
                  // =================================================

                  _sectionCard(
                    icon:
                        Icons.data_object_rounded,
                    title: 'Metadata',
                    child: Column(
                      children: [
                        _infoRow(
                          icon:
                              Icons.access_time_outlined,
                          label: 'Dibuat',
                          value:
                              Fungsi.formatDateTime(
                            data.createdAt,
                          ),
                        ),
                        _divider(),
                        _infoRow(
                          icon:
                              Icons.business_outlined,
                          label: 'Perusahaan',
                          value: data.comName,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // =================================================
                  // FOOTER
                  // =================================================

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.verified_outlined,
                        size: 14,
                        color:
                            Colors.grey.shade500,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Laporan Situasi • QBSC',
                        style: TextStyle(
                          fontSize: 9,
                          color:
                              Colors.grey.shade500,
                          fontWeight:
                              FontWeight.w600,
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
    );
  }

  // ==========================================================
  // PHOTO
  // ==========================================================

  Widget _buildPhoto(
    BuildContext context,
    String? imageUrl,
  ) {
    final bool hasImage =
        imageUrl != null &&
        imageUrl.trim().isNotEmpty;

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
        tag: imageUrl ?? 'situasi-no-image',
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius:
                BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withOpacity(
                0.12,
              ),
            ),
          ),
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(18),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: hasImage
                  ? Image.network(
                      imageUrl!,
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

                        return const Center(
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color: blue,
                          ),
                        );
                      },
                      errorBuilder:
                          (_, __, ___) {
                        return _photoPlaceholder();
                      },
                    )
                  : _photoPlaceholder(),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // PHOTO PLACEHOLDER
  // ==========================================================

  Widget _photoPlaceholder() {
    return Container(
      color: const Color(0xFFF1F5F9),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons
                  .image_not_supported_outlined,
              size: 38,
              color: Color(0xFF94A3B8),
            ),
            SizedBox(height: 8),
            Text(
              'Foto tidak tersedia',
              style: TextStyle(
                fontSize: 10,
                color: Color(0xFF94A3B8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // SECTION CARD
  // ==========================================================

  Widget _sectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFFE8ECF2),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.035),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // HEADER SECTION
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color:
                      blue.withOpacity(0.08),
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 17,
                  color: blue,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF0F172A),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          child,
        ],
      ),
    );
  }

  // ==========================================================
  // INFO ROW
  // ==========================================================

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color:
                  const Color(0xFFF8FAFC),
              borderRadius:
                  BorderRadius.circular(9),
            ),
            child: Icon(
              icon,
              size: 14,
              color:
                  const Color(0xFF64748B),
            ),
          ),

          const SizedBox(width: 10),

          SizedBox(
            width: 88,
            child: Padding(
              padding:
                  const EdgeInsets.only(
                top: 6,
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
                top: 5,
              ),
              child: Text(
                value.trim().isEmpty
                    ? '-'
                    : value,
                style: const TextStyle(
                  fontSize: 11.5,
                  color:
                      Color(0xFF1E293B),
                  fontWeight:
                      FontWeight.w700,
                  height: 1.35,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // DIVIDER
  // ==========================================================

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.only(
        left: 40,
        top: 3,
        bottom: 3,
      ),
      child: Divider(
        height: 1,
        thickness: 0.6,
        color: Color(0xFFF1F5F9),
      ),
    );
  }
}