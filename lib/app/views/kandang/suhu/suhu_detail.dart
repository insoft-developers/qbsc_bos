
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/fungsi.dart';
import 'package:qbsc_saas/app/views/kandang/suhu/suhu_controller.dart';
import 'package:qbsc_saas/app/views/kandang/suhu/suhu_model.dart';
import 'package:qbsc_saas/app/views/patroli/patroli_foto_preview.dart';

class SuhuDetail extends StatelessWidget {
  final SuhuModel data;

  const SuhuDetail({
    super.key,
    required this.data,
  });

  static const Color primary = Color(0xFF0F172A);
  static const Color blue = Color(0xFF2563EB);
  static const Color orange = Color(0xFFEA580C);
  static const Color background = Color(0xFFF6F8FC);

  @override
  Widget build(BuildContext context) {
    final dataShow = Get.find<SuhuController>();

    return Scaffold(
      backgroundColor: background,

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: primary,

        iconTheme: const IconThemeData(
          color: Colors.white,
        ),

        title: const Text(
          'Detail Monitoring Suhu',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
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

            Container(
              width: double.infinity,
              color: primary,
              padding: const EdgeInsets.fromLTRB(
                16,
                4,
                16,
                28,
              ),
              child: Column(
                children: [
                  // FOTO
                  _fotoPatroli(
                    context,
                    data.foto != null &&
                            data.foto!.trim().isNotEmpty
                        ? "${ApiProvider.imageUrl}/${data.foto}"
                        : null,
                  ),

                  const SizedBox(height: 16),

                  // NAMA KANDANG
                  Text(
                    data.kandangName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 5),

                  // SATPAM
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.person_outline_rounded,
                        size: 15,
                        color: Color(0xFFCBD5E1),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        data.satpamName,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFFCBD5E1),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // =================================================
                  // TEMPERATURE BADGE
                  // =================================================

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.09),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.12),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: orange.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.thermostat_rounded,
                            color: Color(0xFFF97316),
                            size: 20,
                          ),
                        ),

                        const SizedBox(width: 10),

                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'SUHU TERCATAT',
                              style: TextStyle(
                                fontSize: 8,
                                color: Color(0xFF94A3B8),
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.end,
                              children: [
                                Text(
                                  data.temperature.toString(),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    height: 1,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 3),
                                const Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 2,
                                  ),
                                  child: Text(
                                    '°C',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFFCBD5E1),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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

                  _card(
                    icon: Icons.analytics_outlined,
                    iconColor: blue,
                    title: 'Informasi Monitoring',
                    children: [
                      _row(
                        'ID Monitoring',
                        data.id.toString(),
                      ),
                      _row(
                        'Tanggal',
                        Fungsi.tanggalIndo(data.tanggal),
                      ),
                      _row(
                        'Jam Monitoring',
                        data.jam,
                      ),
                      _row(
                        'Petugas',
                        data.satpamName,
                      ),

                      const SizedBox(height: 8),

                      // SUHU HIGHLIGHT
                      Container(
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7ED),
                          borderRadius:
                              BorderRadius.circular(13),
                          border: Border.all(
                            color: const Color(0xFFFED7AA),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(11),
                              ),
                              child: const Icon(
                                Icons.thermostat_rounded,
                                color: orange,
                                size: 21,
                              ),
                            ),

                            const SizedBox(width: 11),

                            const Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Suhu Kandang',
                                    style: TextStyle(
                                      fontSize: 9,
                                      color:
                                          Color(0xFF9A3412),
                                      fontWeight:
                                          FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                ],
                              ),
                            ),

                            Text(
                              '${data.temperature} °C',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Color(0xFF9A3412),
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
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
                    child: _card(
                      icon: Icons.location_on_outlined,
                      iconColor: const Color(0xFFDC2626),
                      title: 'Lokasi Monitoring',
                      children: [
                        _row(
                          'Latitude',
                          data.latitude.toString(),
                        ),
                        _row(
                          'Longitude',
                          data.longitude.toString(),
                        ),

                        const SizedBox(height: 9),

                        Container(
                          width: double.infinity,
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius:
                                BorderRadius.circular(11),
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
                                    fontSize: 10,
                                    color: blue,
                                    fontWeight:
                                        FontWeight.w800,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons
                                    .arrow_forward_rounded,
                                size: 16,
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

                  _card(
                    icon: Icons.notes_rounded,
                    iconColor: const Color(0xFF7C3AED),
                    title: 'Catatan',
                    children: [
                      _noteBox(
                        data.note != null &&
                                data.note!
                                    .trim()
                                    .isNotEmpty
                            ? data.note!
                            : 'Tidak ada catatan.',
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // =================================================
                  // METADATA
                  // =================================================

                  _card(
                    icon: Icons.info_outline_rounded,
                    iconColor: const Color(0xFF64748B),
                    title: 'Metadata',
                    children: [
                      _row(
                        'Dibuat',
                        Fungsi.formatDateTime(
                          data.createdAt,
                        ),
                      ),
                      _row(
                        'Perusahaan',
                        data.companyName,
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
  // FOTO
  // =========================================================

  Widget _fotoPatroli(
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
        tag: imageUrl ?? 'no-image',
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(18),
            border: Border.all(
              color:
                  Colors.white.withOpacity(0.12),
            ),
            boxShadow: [
              BoxShadow(
                color:
                    Colors.black.withOpacity(0.25),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: AspectRatio(
            aspectRatio: 16 / 9,
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

                              return Container(
                                color:
                                    const Color(
                                  0xFF1E293B,
                                ),
                                child:
                                    const Center(
                                  child:
                                      CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color:
                                        Colors.white,
                                  ),
                                ),
                              );
                            },
                        errorBuilder:
                            (_, __, ___) =>
                                _iconPlaceholder(),
                      ),

                      Positioned(
                        right: 12,
                        bottom: 12,
                        child: Container(
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 9,
                            vertical: 6,
                          ),
                          decoration:
                              BoxDecoration(
                            color: Colors.black
                                .withOpacity(0.45),
                            borderRadius:
                                BorderRadius.circular(
                              20,
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons
                                    .zoom_in_rounded,
                                color:
                                    Colors.white,
                                size: 14,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Lihat foto',
                                style:
                                    TextStyle(
                                  color:
                                      Colors.white,
                                  fontSize: 9,
                                  fontWeight:
                                      FontWeight
                                          .w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : _iconPlaceholder(),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // CARD
  // =========================================================

  Widget _card({
    required IconData icon,
    required Color iconColor,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE8EDF3),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.035),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
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
                  color:
                      iconColor.withOpacity(0.09),
                  borderRadius:
                      BorderRadius.circular(11),
                ),
                child: Icon(
                  icon,
                  size: 19,
                  color: iconColor,
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

          const SizedBox(height: 13),

          Container(
            height: 1,
            color: const Color(0xFFF1F5F9),
          ),

          const SizedBox(height: 7),

          ...children,
        ],
      ),
    );
  }

  // =========================================================
  // ROW
  // =========================================================

  Widget _row(
    String label,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 7,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 108,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF94A3B8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF334155),
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // NOTE BOX
  // =========================================================

  Widget _noteBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius:
            BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.format_quote_rounded,
            size: 19,
            color: Color(0xFF94A3B8),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF475569),
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // PLACEHOLDER
  // =========================================================

  Widget _iconPlaceholder() {
    return Container(
      color: const Color(0xFF1E293B),
      child: const Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported_outlined,
              size: 42,
              color: Color(0xFF94A3B8),
            ),
            SizedBox(height: 7),
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
}
