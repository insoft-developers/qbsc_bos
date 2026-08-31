
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/fungsi.dart';
import 'package:qbsc_saas/app/views/kandang/lampu/lampu_model.dart';
import 'package:qbsc_saas/app/views/kandang/suhu/suhu_controller.dart';
import 'package:qbsc_saas/app/views/patroli/patroli_foto_preview.dart';

class LampuDetail extends StatelessWidget {
  final LampuModel data;

  const LampuDetail({super.key, required this.data});

  static const Color primary = Color(0xFF0F172A);
  static const Color green = Color(0xFF16A34A);
  static const Color blue = Color(0xFF2563EB);
  static const Color background = Color(0xFFF6F8FC);

  @override
  Widget build(BuildContext context) {
    final dataShow = Get.find<SuhuController>();

    final bool isLampOn = data.isLampOn == 1;

    return Scaffold(
      backgroundColor: background,

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        centerTitle: false,

        titleSpacing: 18,

        title: const Text(
          'Detail Lampu Kandang',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),

        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // =====================================================
            // HEADER
            // =====================================================

            _buildHeader(
              context,
              isLampOn,
            ),

            // =====================================================
            // CONTENT
            // =====================================================

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
                  // INFORMASI PATROLI
                  // =================================================

                  _buildSectionCard(
                    icon: Icons.info_outline_rounded,
                    title: 'Informasi Patroli',
                    iconColor: blue,
                    children: [
                      _buildInfoRow(
                        icon: Icons.tag_rounded,
                        label: 'ID',
                        value: data.id.toString(),
                      ),

                      _buildInfoRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'Tanggal',
                        value: Fungsi.tanggalIndo(
                          data.tanggal,
                        ),
                      ),

                      _buildInfoRow(
                        icon: Icons.access_time_rounded,
                        label: 'Jam Patroli',
                        value: data.jam,
                      ),

                      _buildInfoRow(
                        icon: Icons.person_outline_rounded,
                        label: 'Satpam',
                        value: data.satpamName,
                      ),

                      _buildStatusRow(
                        isLampOn,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // =================================================
                  // LOKASI
                  // =================================================

                  InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {
                      dataShow.openGoogleMaps(
                        double.parse(
                          data.latitude.toString(),
                        ),
                        double.parse(
                          data.longitude.toString(),
                        ),
                      );
                    },
                    child: _buildSectionCard(
                      icon: Icons.location_on_outlined,
                      title: 'Lokasi Patroli',
                      iconColor: const Color(0xFFEF4444),
                      children: [
                        _buildInfoRow(
                          icon: Icons.my_location_rounded,
                          label: 'Latitude',
                          value: data.latitude.toString(),
                        ),

                        _buildInfoRow(
                          icon: Icons.explore_outlined,
                          label: 'Longitude',
                          value: data.longitude.toString(),
                        ),

                        const SizedBox(height: 5),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 11,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.map_outlined,
                                size: 17,
                                color: blue,
                              ),

                              SizedBox(width: 8),

                              Expanded(
                                child: Text(
                                  'Buka lokasi di Google Maps',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: blue,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),

                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 12,
                                color: blue,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // =================================================
                  // CATATAN
                  // =================================================

                  _buildSectionCard(
                    icon: Icons.notes_outlined,
                    title: 'Catatan',
                    iconColor: const Color(0xFFF59E0B),
                    children: [
                      _buildNote(
                        data.note ?? '-',
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // =================================================
                  // METADATA
                  // =================================================

                  _buildSectionCard(
                    icon: Icons.dataset_outlined,
                    title: 'Metadata',
                    iconColor: const Color(0xFF8B5CF6),
                    children: [
                      _buildInfoRow(
                        icon: Icons.schedule_rounded,
                        label: 'Dibuat',
                        value: Fungsi.formatDateTime(
                          data.createdAt,
                        ),
                      ),

                      _buildInfoRow(
                        icon: Icons.business_outlined,
                        label: 'Perusahaan',
                        value: data.companyName,
                        isLast: true,
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

  // =========================================================
  // HEADER
  // =========================================================

  Widget _buildHeader(
    BuildContext context,
    bool isLampOn,
  ) {
    final String imageUrl =
        "${ApiProvider.imageUrl}/${data.foto}";

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(28),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          14,
          4,
          14,
          22,
        ),
        child: Column(
          children: [
            // =====================================================
            // FOTO
            // =====================================================

            _fotoPatroli(
              context,
              imageUrl,
            ),

            const SizedBox(height: 15),

            // =====================================================
            // KANDANG
            // =====================================================

            Text(
              data.kandangName,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              data.satpamName,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white60,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 13),

            // =====================================================
            // STATUS
            // =====================================================

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: isLampOn
                    ? const Color(0xFF16A34A)
                    : const Color(0xFF475569),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isLampOn
                        ? Icons.lightbulb_rounded
                        : Icons.lightbulb_outline_rounded,
                    color: Colors.white,
                    size: 17,
                  ),

                  const SizedBox(width: 7),

                  Text(
                    isLampOn
                        ? 'LAMPU MENYALA'
                        : 'LAMPU MATI',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
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
  // FOTO
  // =========================================================

  Widget _fotoPatroli(
    BuildContext context,
    String? imageUrl,
  ) {
    final bool hasImage =
        imageUrl != null &&
        imageUrl.trim().isNotEmpty &&
        !imageUrl.endsWith('/null');

    return GestureDetector(
      onTap: hasImage
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PatroliFotoPreview(
                    imageUrl: imageUrl!,
                  ),
                ),
              );
            }
          : null,
      child: Hero(
        tag: imageUrl ?? 'no-image',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Container(
            width: double.infinity,
            height: 210,
            color: const Color(0xFFF1F5F9),
            child: hasImage
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        imageUrl!,
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
                                ),
                              );
                            },

                        errorBuilder:
                            (
                              context,
                              error,
                              stackTrace,
                            ) {
                              return _imagePlaceholder();
                            },
                      ),

                      // OVERLAY FOTO
                      Positioned(
                        right: 10,
                        bottom: 10,
                        child: Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(
                              0.55,
                            ),
                            borderRadius:
                                BorderRadius.circular(10),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.zoom_in_rounded,
                                size: 14,
                                color: Colors.white,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Lihat Foto',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.white,
                                  fontWeight:
                                      FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : _imagePlaceholder(),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // IMAGE PLACEHOLDER
  // =========================================================

  Widget _imagePlaceholder() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.image_not_supported_outlined,
          size: 42,
          color: Color(0xFF94A3B8),
        ),

        SizedBox(height: 8),

        Text(
          'Foto patroli tidak tersedia',
          style: TextStyle(
            fontSize: 10,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // =========================================================
  // SECTION CARD
  // =========================================================

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required Color iconColor,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // =====================================================
          // TITLE
          // =====================================================

          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.10),
                  borderRadius:
                      BorderRadius.circular(11),
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
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          ...children,
        ],
      ),
    );
  }

  // =========================================================
  // INFO ROW
  // =========================================================

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: isLast ? 0 : 12,
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

          const SizedBox(width: 10),

          SizedBox(
            width: 90,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 5,
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF94A3B8),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(width: 6),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 4,
              ),
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF334155),
                  fontWeight: FontWeight.w700,
                  height: 1.35,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // STATUS ROW
  // =========================================================

  Widget _buildStatusRow(
    bool isLampOn,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.center,
      children: [
        Container(
          width: 29,
          height: 29,
          decoration: BoxDecoration(
            color: isLampOn
                ? const Color(0xFFDCFCE7)
                : const Color(0xFFF1F5F9),
            borderRadius:
                BorderRadius.circular(8),
          ),
          child: Icon(
            isLampOn
                ? Icons.lightbulb_rounded
                : Icons.lightbulb_outline_rounded,
            size: 15,
            color: isLampOn
                ? green
                : const Color(0xFF64748B),
          ),
        ),

        const SizedBox(width: 10),

        const SizedBox(
          width: 90,
          child: Text(
            'Status Lampu',
            style: TextStyle(
              fontSize: 10,
              color: Color(0xFF94A3B8),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: isLampOn
                    ? const Color(0xFFDCFCE7)
                    : const Color(0xFFF1F5F9),
                borderRadius:
                    BorderRadius.circular(20),
              ),
              child: Text(
                isLampOn ? 'ON' : 'OFF',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: isLampOn
                      ? green
                      : const Color(0xFF64748B),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // NOTE
  // =========================================================

  Widget _buildNote(
    String text,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: const Color(0xFFFDE68A),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.sticky_note_2_outlined,
            size: 17,
            color: Color(0xFFD97706),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 11,
                height: 1.5,
                color: Color(0xFF78350F),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
