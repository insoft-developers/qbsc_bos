
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/fungsi.dart';
import 'package:qbsc_saas/app/views/absensi/absensi_controller.dart';
import 'package:qbsc_saas/app/views/absensi/absensi_model.dart';

class AbsensiDetail extends StatelessWidget {
  final AbsensiModel data;

  const AbsensiDetail({
    super.key,
    required this.data,
  });

  static const Color primary = Color(0xFF2563EB);
  static const Color dark = Color(0xFF0F172A);
  static const Color textDark = Color(0xFF111827);
  static const Color textGrey = Color(0xFF64748B);
  static const Color background = Color(0xFFF6F8FC);

  @override
  Widget build(BuildContext context) {
    final absensi = Get.find<AbsensiController>();

    final bool isMasuk = data.status == 1;

    return Scaffold(
      backgroundColor: background,

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: dark,
        centerTitle: false,

        title: const Text(
          'Detail Absensi',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
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
            // PROFILE HEADER
            // =====================================================

            _buildProfileHeader(isMasuk),

            // =====================================================
            // CONTENT
            // =====================================================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                18,
                16,
                30,
              ),

              child: Column(
                children: [
                  // =================================================
                  // INFORMASI ABSENSI
                  // =================================================

                  _sectionCard(
                    icon: Icons.access_time_rounded,
                    title: 'Informasi Absensi',
                    children: [
                      _infoRow(
                        icon: Icons.tag_rounded,
                        label: 'ID Absensi',
                        value: data.id.toString(),
                      ),

                      _divider(),

                      _infoRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'Tanggal',
                        value: Fungsi.tanggalIndo(
                          data.tanggal,
                        ),
                      ),

                      _divider(),

                      _infoRow(
                        icon: Icons.login_rounded,
                        label: 'Jam Masuk',
                        value: Fungsi.formatToTime(
                          data.jamMasuk,
                        ),
                      ),

                      _divider(),

                      _infoRow(
                        icon: Icons.logout_rounded,
                        label: 'Jam Pulang',
                        value: data.jamKeluar != null
                            ? Fungsi.formatToTime(
                                data.jamKeluar!,
                              )
                            : '-',
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // =================================================
                  // SHIFT
                  // =================================================

                  _sectionCard(
                    icon: Icons.work_history_outlined,
                    title: 'Informasi Shift',
                    children: [
                      _infoRow(
                        icon: Icons.badge_outlined,
                        label: 'Nama Shift',
                        value: data.shiftName ?? '-',
                      ),

                      _divider(),

                      _infoRow(
                        icon: Icons.login_outlined,
                        label: 'Jam Masuk Shift',
                        value:
                            data.jamSettingMasuk ?? '-',
                      ),

                      _divider(),

                      _infoRow(
                        icon: Icons.logout_outlined,
                        label: 'Jam Pulang Shift',
                        value:
                            data.jamSettingPulang ?? '-',
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // =================================================
                  // LOKASI MASUK
                  // =================================================

                  _locationCard(
                    title: 'Lokasi Masuk',
                    icon: Icons.location_on_rounded,
                    latitude:
                        data.latitude.toString(),
                    longitude:
                        data.longitude.toString(),
                    onTap: () {
                      absensi.openGoogleMaps(
                        double.parse(
                          data.latitude.toString(),
                        ),
                        double.parse(
                          data.longitude.toString(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 14),

                  // =================================================
                  // LOKASI PULANG
                  // =================================================

                  _locationCard(
                    title: 'Lokasi Pulang',
                    icon: Icons.location_on_outlined,
                    latitude:
                        data.latitude2.toString(),
                    longitude:
                        data.longitude2.toString(),
                    onTap: () {
                      absensi.openGoogleMaps(
                        double.parse(
                          data.latitude2.toString(),
                        ),
                        double.parse(
                          data.longitude2.toString(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 14),

                  // =================================================
                  // CATATAN
                  // =================================================

                  _sectionCard(
                    icon: Icons.notes_rounded,
                    title: 'Catatan',
                    children: [
                      _noteItem(
                        icon: Icons.description_outlined,
                        label: 'Deskripsi',
                        value:
                            data.description ?? '-',
                      ),

                      _noteItem(
                        icon: Icons.login_rounded,
                        label: 'Catatan Masuk',
                        value:
                            data.catatanMasuk ?? '-',
                      ),

                      _noteItem(
                        icon: Icons.logout_rounded,
                        label: 'Catatan Pulang',
                        value:
                            data.catatanKeluar ?? '-',
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // =================================================
                  // FOTO
                  // =================================================

                  _buildPhotoSection(),

                  const SizedBox(height: 14),

                  // =================================================
                  // METADATA
                  // =================================================

                  _sectionCard(
                    icon: Icons.info_outline_rounded,
                    title: 'Metadata',
                    children: [
                      _infoRow(
                        icon: Icons.schedule_rounded,
                        label: 'Dibuat',
                        value:
                            Fungsi.formatDateTime(
                          data.createdAt,
                        ),
                      ),

                      _divider(),

                      _infoRow(
                        icon: Icons.business_outlined,
                        label: 'Perusahaan',
                        value:
                            data.namaPerusahaan,
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

  // =============================================================
  // PROFILE HEADER
  // =============================================================

  Widget _buildProfileHeader(bool isMasuk) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(
        20,
        22,
        20,
        26,
      ),

      decoration: const BoxDecoration(
        color: dark,

        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(28),
        ),
      ),

      child: Column(
        children: [
          // FOTO

          Container(
            padding: const EdgeInsets.all(4),

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: Colors.white.withOpacity(0.15),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.20),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),

            child: _fotoSatpam(
              "${ApiProvider.imageUrl}/${data.fotoSatpam}",
            ),
          ),

          const SizedBox(height: 13),

          // NAMA

          Text(
            data.namaSatpam,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),

          const SizedBox(height: 7),

          // STATUS

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),

            decoration: BoxDecoration(
              color: isMasuk
                  ? const Color(0xFFDCFCE7)
                  : const Color(0xFFFFEDD5),

              borderRadius:
                  BorderRadius.circular(30),
            ),

            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,

                  decoration: BoxDecoration(
                    color: isMasuk
                        ? const Color(0xFF16A34A)
                        : const Color(0xFFF97316),
                    shape: BoxShape.circle,
                  ),
                ),

                const SizedBox(width: 7),

                Text(
                  isMasuk
                      ? 'ABSENSI MASUK'
                      : 'ABSENSI PULANG',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    color: isMasuk
                        ? const Color(0xFF15803D)
                        : const Color(0xFFC2410C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // SECTION CARD
  // =============================================================

  Widget _sectionCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(
          color: const Color(0xFFE8EDF3),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          // HEADER

          Row(
            children: [
              Container(
                width: 38,
                height: 38,

                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius:
                      BorderRadius.circular(12),
                ),

                child: Icon(
                  icon,
                  size: 19,
                  color: primary,
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

          const SizedBox(height: 14),

          ...children,
        ],
      ),
    );
  }

  // =============================================================
  // INFO ROW
  // =============================================================

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 7,
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Icon(
            icon,
            size: 17,
            color: const Color(0xFF94A3B8),
          ),

          const SizedBox(width: 10),

          SizedBox(
            width: 105,

            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: textGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12,
                color: textDark,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // DIVIDER
  // =============================================================

  Widget _divider() {
    return const Divider(
      height: 1,
      thickness: 0.7,
      color: Color(0xFFF1F5F9),
    );
  }

  // =============================================================
  // LOCATION CARD
  // =============================================================

  Widget _locationCard({
    required String title,
    required IconData icon,
    required String latitude,
    required String longitude,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),

      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(20),

          border: Border.all(
            color: const Color(0xFFE8EDF3),
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.035),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),

        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,

                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius:
                        BorderRadius.circular(12),
                  ),

                  child: Icon(
                    icon,
                    size: 19,
                    color: const Color(0xFFEF4444),
                  ),
                ),

                const SizedBox(width: 11),

                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: textDark,
                    ),
                  ),
                ),

                Container(
                  width: 32,
                  height: 32,

                  decoration: BoxDecoration(
                    color:
                        const Color(0xFFEFF6FF),
                    borderRadius:
                        BorderRadius.circular(10),
                  ),

                  child: const Icon(
                    Icons
                        .arrow_forward_rounded,
                    size: 17,
                    color: primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.all(13),

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
                    latitude,
                  ),

                  const SizedBox(height: 9),

                  _coordinateRow(
                    'Longitude',
                    longitude,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.end,

              children: [
                const Icon(
                  Icons.map_outlined,
                  size: 16,
                  color: primary,
                ),

                const SizedBox(width: 6),

                const Text(
                  'Buka di Google Maps',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // COORDINATE ROW
  // =============================================================

  Widget _coordinateRow(
    String label,
    String value,
  ) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: textGrey,
          ),
        ),

        const Spacer(),

        Text(
          value,
          style: const TextStyle(
            fontSize: 11,
            color: textDark,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // =============================================================
  // NOTE
  // =============================================================

  Widget _noteItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(13),
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Icon(
            icon,
            size: 17,
            color: const Color(0xFF64748B),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 9.5,
                    color: textGrey,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value.isEmpty ? '-' : value,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: textDark,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // FOTO SECTION
  // =============================================================

  Widget _buildPhotoSection() {
    final bool adaMasuk =
        data.fotoMasuk != null &&
        data.fotoMasuk!.isNotEmpty;

    final bool adaPulang =
        data.fotoKeluar != null &&
        data.fotoKeluar!.isNotEmpty;

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),

        border: Border.all(
          color: const Color(0xFFE8EDF3),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 16,
            offset: const Offset(0, 6),
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
                width: 38,
                height: 38,

                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius:
                      BorderRadius.circular(12),
                ),

                child: const Icon(
                  Icons.photo_camera_outlined,
                  size: 19,
                  color: Color(0xFF16A34A),
                ),
              ),

              const SizedBox(width: 11),

              const Text(
                'Dokumentasi Absensi',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: textDark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: adaMasuk
                    ? _buildFotoFull(
                        "${ApiProvider.imageUrl}/${data.fotoMasuk}",
                        'Masuk',
                      )
                    : _fotoKosong('Masuk'),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: adaPulang
                    ? _buildFotoFull(
                        "${ApiProvider.imageUrl}/${data.fotoKeluar}",
                        'Pulang',
                      )
                    : _fotoKosong('Pulang'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =============================================================
  // FOTO SATPAM
  // =============================================================

  Widget _fotoSatpam(String? imageUrl) {
    final bool valid =
        imageUrl != null &&
        imageUrl.isNotEmpty &&
        !imageUrl.endsWith('/null');

    return CircleAvatar(
      radius: 48,

      backgroundColor: Colors.white,

      child: CircleAvatar(
        radius: 44,

        backgroundColor:
            const Color(0xFFE2E8F0),

        backgroundImage:
            valid
                ? NetworkImage(imageUrl)
                : null,

        child: !valid
            ? const Icon(
                Icons.person_rounded,
                size: 42,
                color: Color(0xFF94A3B8),
              )
            : null,
      ),
    );
  }
}

// =============================================================
// FOTO FULL
// =============================================================

Widget _buildFotoFull(
  String url,
  String label,
) {
  return Column(
    crossAxisAlignment:
        CrossAxisAlignment.start,

    children: [
      Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 5,
        ),

        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius:
              BorderRadius.circular(8),
        ),

        child: Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            color: Color(0xFF475569),
          ),
        ),
      ),

      const SizedBox(height: 7),

      ClipRRect(
        borderRadius:
            BorderRadius.circular(14),

        child: AspectRatio(
          aspectRatio: 0.88,

          child: Image.network(
            url,
            width: double.infinity,
            fit: BoxFit.cover,

            errorBuilder:
                (_, __, ___) {
              return Container(
                color:
                    const Color(0xFFF1F5F9),

                child: const Center(
                  child: Icon(
                    Icons
                        .broken_image_outlined,
                    size: 32,
                    color:
                        Color(0xFF94A3B8),
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
                color:
                    const Color(0xFFF8FAFC),

                child: const Center(
                  child:
                      CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    ],
  );
}

// =============================================================
// FOTO KOSONG
// =============================================================

Widget _fotoKosong(String label) {
  return Column(
    crossAxisAlignment:
        CrossAxisAlignment.start,

    children: [
      Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 5,
        ),

        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius:
              BorderRadius.circular(8),
        ),

        child: Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            color: Color(0xFF475569),
          ),
        ),
      ),

      const SizedBox(height: 7),

      AspectRatio(
        aspectRatio: 0.88,

        child: Container(
          decoration: BoxDecoration(
            color:
                const Color(0xFFF1F5F9),

            borderRadius:
                BorderRadius.circular(14),

            border: Border.all(
              color:
                  const Color(0xFFE2E8F0),
            ),
          ),

          child: const Center(
            child: Icon(
              Icons
                  .image_not_supported_outlined,
              size: 32,
              color:
                  Color(0xFF94A3B8),
            ),
          ),
        ),
      ),
    ],
  );
}
