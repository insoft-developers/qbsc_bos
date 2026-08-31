import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/fungsi.dart';
import 'package:qbsc_saas/app/views/patroli/patroli_controller.dart';
import 'package:qbsc_saas/app/views/patroli/patroli_foto_preview.dart';
import 'package:qbsc_saas/app/views/patroli/patroli_model.dart';

class PatroliDetail extends StatelessWidget {
  final PatroliModel data;

  const PatroliDetail({
    super.key,
    required this.data,
  });

  static const Color primary = Color(0xFF2563EB);
  static const Color dark = Color(0xFF0F172A);
  static const Color background = Color(0xFFF6F8FC);
  static const Color textDark = Color(0xFF111827);
  static const Color textGrey = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    final patroliController = Get.find<PatroliController>();

    final bool hasImage =
        data.foto != null && data.foto!.trim().isNotEmpty;

    final String imageUrl =
        "${ApiProvider.imageUrl}/${data.foto}";

    return Scaffold(
      backgroundColor: background,

      // =====================================================
      // APP BAR
      // =====================================================

      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: dark,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        titleSpacing: 18,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detail Patroli',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Informasi aktivitas patroli',
              style: TextStyle(
                color: Color(0xFFCBD5E1),
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),

      // =====================================================
      // BODY
      // =====================================================

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // =================================================
            // FOTO / HEADER
            // =================================================

            _buildPhotoHeader(
              context,
              imageUrl,
              hasImage,
            ),

            // =================================================
            // CONTENT
            // =================================================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                18,
                16,
                35,
              ),
              child: Column(
                children: [
                  // =================================================
                  // SUMMARY
                  // =================================================

                  _buildSummaryCard(),

                  const SizedBox(height: 14),

                  // =================================================
                  // JADWAL
                  // =================================================

                  _buildSectionCard(
                    icon: Icons.schedule_rounded,
                    iconColor: const Color(0xFF7C3AED),
                    iconBackground: const Color(0xFFF3E8FF),
                    title: 'Jadwal Patroli',
                    children: [
                      _buildInfoRow(
                        'Jam Mulai',
                        data.jamAwal ?? '',
                        Icons.play_circle_outline_rounded,
                      ),
                      _buildInfoRow(
                        'Jam Selesai',
                        data.jamAkhir ?? '',
                        Icons.stop_circle_outlined,
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // =================================================
                  // LOKASI
                  // =================================================

                  _buildLocationCard(
                    context,
                    patroliController,
                  ),

                  const SizedBox(height: 14),

                  // =================================================
                  // CATATAN
                  // =================================================

                  _buildSectionCard(
                    icon: Icons.notes_rounded,
                    iconColor: const Color(0xFFD97706),
                    iconBackground: const Color(0xFFFFF7ED),
                    title: 'Catatan',
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius:
                              BorderRadius.circular(13),
                        ),
                        child: Text(
                          data.note?.trim().isNotEmpty == true
                              ? data.note!
                              : 'Tidak ada catatan.',
                          style: const TextStyle(
                            fontSize: 12,
                            height: 1.5,
                            color: Color(0xFF475569),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // =================================================
                  // METADATA
                  // =================================================

                  _buildSectionCard(
                    icon: Icons.info_outline_rounded,
                    iconColor: const Color(0xFF0891B2),
                    iconBackground: const Color(0xFFECFEFF),
                    title: 'Informasi Data',
                    children: [
                      _buildInfoRow(
                        'ID Patroli',
                        data.id.toString(),
                        Icons.tag_rounded,
                      ),
                      _buildInfoRow(
                        'Dibuat',
                        Fungsi.formatDateTime(
                          data.createdAt,
                        ),
                        Icons.access_time_rounded,
                      ),
                      _buildInfoRow(
                        'Perusahaan',
                        data.companyName,
                        Icons.business_outlined,
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

  // ===========================================================
  // PHOTO HEADER
  // ===========================================================

  Widget _buildPhotoHeader(
    BuildContext context,
    String imageUrl,
    bool hasImage,
  ) {
    return GestureDetector(
      onTap: hasImage
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      PatroliFotoPreview(
                    imageUrl: imageUrl,
                  ),
                ),
              );
            }
          : null,
      child: Hero(
        tag: imageUrl.isNotEmpty
            ? imageUrl
            : 'no-image',
        child: SizedBox(
          height: 265,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // IMAGE
              hasImage
                  ? Image.network(
                      imageUrl,
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
                                  const Color(0xFFE2E8F0),
                              child: const Center(
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                ),
                              ),
                            );
                          },
                      errorBuilder:
                          (_, __, ___) =>
                              _photoPlaceholder(),
                    )
                  : _photoPlaceholder(),

              // GRADIENT
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [
                      0.35,
                      1.0,
                    ],
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.78),
                    ],
                  ),
                ),
              ),

              // IMAGE LABEL
              if (hasImage)
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(
                        0.45,
                      ),
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize:
                          MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.zoom_in_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Lihat foto',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // BOTTOM CONTENT
              Positioned(
                left: 18,
                right: 18,
                bottom: 18,
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 9,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: primary
                                  .withOpacity(0.95),
                              borderRadius:
                                  BorderRadius.circular(
                                20,
                              ),
                            ),
                            child: const Text(
                              'PATROLI',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight:
                                    FontWeight.w800,
                                letterSpacing: 1,
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            data.locationName,
                            maxLines: 2,
                            overflow:
                                TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight:
                                  FontWeight.w800,
                              height: 1.15,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Row(
                            children: [
                              const Icon(
                                Icons.person_outline_rounded,
                                color: Colors.white70,
                                size: 14,
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  data.satpamName,
                                  maxLines: 1,
                                  overflow:
                                      TextOverflow
                                          .ellipsis,
                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.white70,
                                    fontSize: 11,
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 15),

                    Container(
                      width: 43,
                      height: 43,
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white
                              .withOpacity(0.25),
                        ),
                      ),
                      child: const Icon(
                        Icons
                            .verified_outlined,
                        color: Colors.white,
                        size: 22,
                      ),
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

  // ===========================================================
  // SUMMARY CARD
  // ===========================================================

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE8EDF3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan Patroli',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: textDark,
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _summaryItem(
                  icon: Icons.calendar_today_outlined,
                  title: 'Tanggal',
                  value:
                      Fungsi.tanggalIndo(
                    data.tanggal,
                  ),
                ),
              ),

              Container(
                width: 1,
                height: 45,
                color: const Color(0xFFE2E8F0),
              ),

              Expanded(
                child: _summaryItem(
                  icon: Icons.access_time_rounded,
                  title: 'Jam',
                  value: data.jam,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Container(
            height: 1,
            color: const Color(0xFFF1F5F9),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _summaryItem(
                  icon: Icons.location_on_outlined,
                  title: 'Lokasi',
                  value: data.locationName,
                ),
              ),

              Container(
                width: 1,
                height: 45,
                color: const Color(0xFFE2E8F0),
              ),

              Expanded(
                child: _summaryItem(
                  icon: Icons.person_outline_rounded,
                  title: 'Petugas',
                  value: data.satpamName,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // SUMMARY ITEM
  // ===========================================================

  Widget _summaryItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius:
                  BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 17,
              color: primary,
            ),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 9,
                    color: Color(0xFF94A3B8),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value,
                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: textDark,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // LOCATION CARD
  // ===========================================================

  Widget _buildLocationCard(
    BuildContext context,
    PatroliController patroliController,
  ) {
    return GestureDetector(
      onTap: () {
        patroliController.openGoogleMaps(
          double.parse(
            data.latitude.toString(),
          ),
          double.parse(
            data.longitude.toString(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(20),
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
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: Color(0xFF16A34A),
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
                        'Lokasi Patroli',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              FontWeight.w800,
                          color: textDark,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Koordinat GPS saat patroli',
                        style: TextStyle(
                          fontSize: 9.5,
                          color: textGrey,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color:
                        const Color(0xFFEFF6FF),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.open_in_new_rounded,
                    size: 14,
                    color: primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Container(
              padding:
                  const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color:
                    const Color(0xFFF8FAFC),
                borderRadius:
                    BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _coordinateRow(
                    'Latitude',
                    data.latitude.toString(),
                  ),
                  const SizedBox(height: 10),
                  _coordinateRow(
                    'Longitude',
                    data.longitude.toString(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(
                vertical: 11,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map_outlined,
                    size: 16,
                    color: primary,
                  ),
                  SizedBox(width: 7),
                  Text(
                    'Buka di Google Maps',
                    style: TextStyle(
                      fontSize: 10.5,
                      color: primary,
                      fontWeight:
                          FontWeight.w800,
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

  // ===========================================================
  // COORDINATE ROW
  // ===========================================================

  Widget _coordinateRow(
    String label,
    String value,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 75,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF94A3B8),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 11,
              color: textDark,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================
  // SECTION CARD
  // ===========================================================

  Widget _buildSectionCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBackground,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
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
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),

              const SizedBox(width: 11),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: textDark,
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

  // ===========================================================
  // INFO ROW
  // ===========================================================

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 11),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: const Color(0xFF94A3B8),
          ),

          const SizedBox(width: 10),

          SizedBox(
            width: 90,
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
              maxLines: 3,
              overflow:
                  TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11.5,
                color: textDark,
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // PHOTO PLACEHOLDER
  // ===========================================================

  Widget _photoPlaceholder() {
    return Container(
      color: const Color(0xFFE2E8F0),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.image_not_supported_outlined,
              size: 32,
              color: Color(0xFF94A3B8),
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Foto patroli tidak tersedia',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
