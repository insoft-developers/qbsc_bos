import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/fungsi.dart';
import 'package:qbsc_saas/app/views/kandang/alarm/alarm_model.dart';
import 'package:qbsc_saas/app/views/kandang/suhu/suhu_controller.dart';
import 'package:qbsc_saas/app/views/patroli/patroli_foto_preview.dart';

class AlarmDetail extends StatelessWidget {
  final AlarmModel data;

  const AlarmDetail({super.key, required this.data});

  static const Color primary = Color(0xFF0F172A);
  static const Color danger = Color(0xFFDC2626);
  static const Color success = Color(0xFF16A34A);
  static const Color background = Color(0xFFF6F8FC);

  @override
  Widget build(BuildContext context) {
    final dataShow = Get.find<SuhuController>();

    final bool isAlarmOn = data.isAlarmOn == 1;

    return Scaffold(
      backgroundColor: background,

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        elevation: 0,
        backgroundColor: primary,
        centerTitle: false,

        title: const Text(
          'Detail Monitoring Alarm',
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

            Container(
              width: double.infinity,
              color: primary,
              child: Column(
                children: [
                  _fotoPatroli(
                    context,
                    data.foto != null && data.foto!.isNotEmpty
                        ? "${ApiProvider.imageUrl}/${data.foto}"
                        : null,
                  ),

                  const SizedBox(height: 18),

                  Text(
                    data.kandangName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    'Monitoring Alarm Kandang',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.60),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // =================================================
                  // STATUS ALARM
                  // =================================================

                  _statusAlarm(isAlarmOn),

                  const SizedBox(height: 24),
                ],
              ),
            ),

            // =====================================================
            // CONTENT
            // =====================================================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                14,
                16,
                14,
                30,
              ),
              child: Column(
                children: [
                  // =================================================
                  // INFORMASI PATROLI
                  // =================================================

                  _sectionCard(
                    icon: Icons.fact_check_outlined,
                    title: 'Informasi Patroli',
                    children: [
                      _infoRow(
                        icon: Icons.tag_rounded,
                        label: 'ID',
                        value: data.id.toString(),
                      ),

                      _infoRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'Tanggal',
                        value: Fungsi.tanggalIndo(
                          data.tanggal,
                        ),
                      ),

                      _infoRow(
                        icon: Icons.access_time_rounded,
                        label: 'Jam Patroli',
                        value: data.jam,
                      ),

                      _infoRow(
                        icon: Icons.person_outline_rounded,
                        label: 'Satpam',
                        value: data.satpamName,
                      ),

                      _infoRow(
                        icon: Icons.notifications_active_outlined,
                        label: 'Alarm Kandang',
                        value: isAlarmOn
                            ? 'ALARM ON'
                            : 'ALARM OFF',
                        valueColor:
                            isAlarmOn ? danger : success,
                        isLast: true,
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
                    child: _sectionCard(
                      icon: Icons.location_on_outlined,
                      title: 'Lokasi Patroli',
                      children: [
                        _infoRow(
                          icon: Icons.my_location_outlined,
                          label: 'Latitude',
                          value: data.latitude.toString(),
                        ),

                        _infoRow(
                          icon: Icons.explore_outlined,
                          label: 'Longitude',
                          value: data.longitude.toString(),
                        ),

                        const SizedBox(height: 8),

                        // =================================================
                        // GOOGLE MAPS BUTTON
                        // =================================================

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 11,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius:
                                BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  const Color(0xFFDBEAFE),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.map_outlined,
                                size: 17,
                                color:
                                    Color(0xFF2563EB),
                              ),

                              SizedBox(width: 8),

                              Expanded(
                                child: Text(
                                  'Buka lokasi di Google Maps',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color:
                                        Color(0xFF2563EB),
                                    fontWeight:
                                        FontWeight.w700,
                                  ),
                                ),
                              ),

                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 12,
                                color:
                                    Color(0xFF2563EB),
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

                  _sectionCard(
                    icon: Icons.notes_outlined,
                    title: 'Catatan',
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFFF8FAFC),
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                        child: Text(
                          data.note == null ||
                                  data.note!.isEmpty
                              ? 'Tidak ada catatan'
                              : data.note!,
                          style: TextStyle(
                            fontSize: 11,
                            height: 1.5,
                            color:
                                data.note == null ||
                                        data.note!.isEmpty
                                    ? const Color(
                                        0xFF94A3B8,
                                      )
                                    : const Color(
                                        0xFF334155,
                                      ),
                            fontWeight:
                                FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // =================================================
                  // METADATA
                  // =================================================

                  _sectionCard(
                    icon: Icons.info_outline_rounded,
                    title: 'Metadata',
                    children: [
                      _infoRow(
                        icon: Icons.schedule_outlined,
                        label: 'Dibuat',
                        value: Fungsi.formatDateTime(
                          data.createdAt,
                        ),
                      ),

                      _infoRow(
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
  // STATUS ALARM
  // =========================================================

  Widget _statusAlarm(bool isOn) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: isOn
            ? const Color(0xFFDC2626)
            : const Color(0xFF475569),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 27,
            height: 27,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isOn
                  ? Icons.notifications_active_rounded
                  : Icons.notifications_off_outlined,
              color: Colors.white,
              size: 15,
            ),
          ),

          const SizedBox(width: 9),

          Text(
            isOn ? 'ALARM AKTIF' : 'ALARM TIDAK AKTIF',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.4,
            ),
          ),
        ],
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
          margin: const EdgeInsets.symmetric(
            horizontal: 14,
          ),
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color:
                    Colors.black.withOpacity(0.20),
                blurRadius: 16,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(18),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: hasImage
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      loadingBuilder:
                          (context, child, progress) {
                        if (progress == null) {
                          return child;
                        }

                        return Container(
                          color:
                              const Color(0xFFE2E8F0),
                          child: const Center(
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                      errorBuilder:
                          (_, __, ___) =>
                              _iconPlaceholder(),
                    )
                  : _iconPlaceholder(),
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // PLACEHOLDER
  // =========================================================

  Widget _iconPlaceholder() {
    return Container(
      color: const Color(0xFFE2E8F0),
      child: const Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: 40,
            color: Color(0xFF94A3B8),
          ),
          SizedBox(height: 7),
          Text(
            'Foto patroli tidak tersedia',
            style: TextStyle(
              fontSize: 10,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // SECTION CARD
  // =========================================================

  Widget _sectionCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.025),
            blurRadius: 14,
            offset: const Offset(0, 5),
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
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color:
                      const Color(0xFFF1F5F9),
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: primary,
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

          const SizedBox(height: 13),

          ...children,
        ],
      ),
    );
  }

  // =========================================================
  // INFO ROW
  // =========================================================

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
    Color valueColor =
        const Color(0xFF334155),
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: isLast ? 0 : 10,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 29,
            height: 29,
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

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 8.5,
                    color:
                        Color(0xFF94A3B8),
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  value,
                  style: TextStyle(
                    fontSize: 11,
                    color: valueColor,
                    fontWeight:
                        FontWeight.w700,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}