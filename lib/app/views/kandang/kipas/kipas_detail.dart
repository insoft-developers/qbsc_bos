import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/fungsi.dart';
import 'package:qbsc_saas/app/views/kandang/kipas/kipas_model.dart';
import 'package:qbsc_saas/app/views/kandang/suhu/suhu_controller.dart';
import 'package:qbsc_saas/app/views/patroli/patroli_foto_preview.dart';

class KipasDetail extends StatelessWidget {
  final KipasModel data;

  const KipasDetail({super.key, required this.data});

  static const Color primary = Color(0xFF0F172A);
  static const Color green = Color(0xFF16A34A);
  static const Color blue = Color(0xFF2563EB);
  static const Color background = Color(0xFFF6F8FC);

  @override
  Widget build(BuildContext context) {
    final dataShow = Get.find<SuhuController>();

    final kipasList = parseKipas(data.kipas);
    final totalKipas = kipasList.length;
    final totalOn = kipasList.where((e) => e == 1).length;
    final totalOff = totalKipas - totalOn;

    return Scaffold(
      backgroundColor: background,

      // =========================================================
      // APP BAR
      // =========================================================
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        titleSpacing: 4,
        title: const Text(
          'Detail Monitoring Kipas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // =====================================================
            // HEADER FOTO
            // =====================================================
            Container(
              width: double.infinity,
              color: primary,
              padding: const EdgeInsets.fromLTRB(14, 4, 14, 22),
              child: Column(
                children: [
                  _fotoPatroli(context, "${ApiProvider.imageUrl}/${data.foto}"),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.kandangName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Row(
                              children: [
                                const Icon(
                                  Icons.person_outline_rounded,
                                  size: 14,
                                  color: Colors.white70,
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    data.satpamName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      // STATUS
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.15),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '$totalOn ON',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
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

            // =====================================================
            // CONTENT
            // =====================================================
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  // =================================================
                  // INFORMASI PATROLI
                  // =================================================
                  _sectionCard(
                    icon: Icons.info_outline_rounded,
                    iconColor: blue,
                    title: 'Informasi Monitoring',
                    children: [
                      _infoRow(Icons.tag_rounded, 'ID', data.id.toString()),
                      _infoRow(
                        Icons.calendar_today_outlined,
                        'Tanggal',
                        Fungsi.tanggalIndo(data.tanggal),
                      ),
                      _infoRow(
                        Icons.access_time_rounded,
                        'Jam Monitoring',
                        data.jam,
                      ),
                      _infoRow(
                        Icons.person_outline_rounded,
                        'Petugas',
                        data.satpamName,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // =================================================
                  // SUMMARY KIPAS
                  // =================================================
                  _buildKipasSummary(
                    total: totalKipas,
                    on: totalOn,
                    off: totalOff,
                  ),

                  const SizedBox(height: 12),

                  // =================================================
                  // DETAIL KIPAS
                  // =================================================
                  _sectionCard(
                    icon: Icons.air_rounded,
                    iconColor: green,
                    title: 'Status Kipas',
                    subtitle: 'Status masing-masing kipas',
                    children: [
                      const SizedBox(height: 6),
                      buildKipasGrid(data.kipas),
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
                        double.parse(data.latitude.toString()),
                        double.parse(data.longitude.toString()),
                      );
                    },
                    child: _sectionCard(
                      icon: Icons.location_on_outlined,
                      iconColor: const Color(0xFFDC2626),
                      title: 'Lokasi Monitoring',
                      subtitle: 'Tekan untuk membuka Google Maps',
                      children: [
                        const SizedBox(height: 4),

                        _locationRow('Latitude', data.latitude.toString()),

                        _locationRow('Longitude', data.longitude.toString()),

                        const SizedBox(height: 10),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.map_outlined, size: 17, color: blue),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Buka lokasi di Google Maps',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: blue,
                                    fontWeight: FontWeight.w800,
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
                  _sectionCard(
                    icon: Icons.notes_rounded,
                    iconColor: const Color(0xFF7C3AED),
                    title: 'Catatan',
                    children: [
                      const SizedBox(height: 2),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Text(
                          data.note == null || data.note!.trim().isEmpty
                              ? 'Tidak ada catatan'
                              : data.note!,
                          style: TextStyle(
                            fontSize: 11,
                            height: 1.5,
                            color:
                                data.note == null || data.note!.trim().isEmpty
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF334155),
                            fontWeight: FontWeight.w500,
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
                    icon: Icons.assignment_outlined,
                    iconColor: const Color(0xFF64748B),
                    title: 'Metadata',
                    children: [
                      _infoRow(
                        Icons.schedule_rounded,
                        'Dibuat',
                        Fungsi.formatDateTime(data.createdAt),
                      ),
                      _infoRow(
                        Icons.business_outlined,
                        'Perusahaan',
                        data.companyName,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // SUMMARY
  // =========================================================

  Widget _buildKipasSummary({
    required int total,
    required int on,
    required int off,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5EAF0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.dashboard_outlined,
                  color: green,
                  size: 18,
                ),
              ),

              const SizedBox(width: 10),

              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ringkasan Kipas',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: primary,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Status perangkat saat monitoring',
                    style: TextStyle(fontSize: 9, color: Color(0xFF94A3B8)),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _summaryItem(
                  label: 'TOTAL',
                  value: total,
                  icon: Icons.air_rounded,
                  color: blue,
                  background: const Color(0xFFEFF6FF),
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: _summaryItem(
                  label: 'MENYALA',
                  value: on,
                  icon: Icons.power_rounded,
                  color: green,
                  background: const Color(0xFFECFDF5),
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: _summaryItem(
                  label: 'MATI',
                  value: off,
                  icon: Icons.power_off_rounded,
                  color: const Color(0xFF64748B),
                  background: const Color(0xFFF1F5F9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryItem({
    required String label,
    required int value,
    required IconData icon,
    required Color color,
    required Color background,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        children: [
          Icon(icon, size: 17, color: color),

          const SizedBox(height: 5),

          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 20,
              height: 1,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            label,
            style: TextStyle(
              fontSize: 7.5,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // GRID KIPAS
  // =========================================================

  Widget buildKipasGrid(String data) {
    final List<int> kipasList = parseKipas(data);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: kipasList.length,

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,

        // 🔥 Dibuat lebih pendek
        childAspectRatio: 1.25,
      ),

      itemBuilder: (context, index) {
        final bool isOn = kipasList[index] == 1;

        return Container(
          decoration: BoxDecoration(
            color: isOn ? const Color(0xFFF0FDF4) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isOn ? const Color(0xFF86EFAC) : const Color(0xFFE2E8F0),
              width: 1,
            ),
          ),

          child: Stack(
            children: [
              // STATUS DOT
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isOn
                        ? const Color(0xFF16A34A)
                        : const Color(0xFFCBD5E1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // CONTENT
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ICON
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.air_rounded,
                        size: 16,
                        color: isOn
                            ? const Color(0xFF16A34A)
                            : const Color(0xFF94A3B8),
                      ),
                    ),

                    const SizedBox(width: 7),

                    // TEXT
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kipas ${index + 1}',
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),

                        const SizedBox(height: 2),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isOn
                                ? const Color(0xFF16A34A)
                                : const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            isOn ? 'ON' : 'OFF',
                            style: TextStyle(
                              fontSize: 7,
                              fontWeight: FontWeight.w900,
                              color: isOn
                                  ? Colors.white
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================================================
  // FOTO
  // =========================================================

  Widget _iconPlaceholder() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.image_not_supported_outlined,
          size: 48,
          color: Color(0xFF94A3B8),
        ),
        SizedBox(height: 8),
        Text(
          'Foto Patroli',
          style: TextStyle(
            fontSize: 11,
            color: Color(0xFF94A3B8),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _fotoPatroli(BuildContext context, String? imageUrl) {
    final bool hasImage = imageUrl != null && imageUrl.trim().isNotEmpty;

    return GestureDetector(
      onTap: hasImage
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PatroliFotoPreview(imageUrl: imageUrl!),
                ),
              );
            }
          : null,
      child: Hero(
        tag: imageUrl ?? 'no-image',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              width: double.infinity,
              color: const Color(0xFFE2E8F0),
              child: hasImage
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) {
                          return child;
                        }

                        return const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      },
                      errorBuilder: (_, __, ___) => _iconPlaceholder(),
                    )
                  : _iconPlaceholder(),
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // SECTION CARD
  // =========================================================

  Widget _sectionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5EAF0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.09),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: primary,
                      ),
                    ),

                    if (subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 9,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ),
                  ],
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

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 15, color: const Color(0xFF94A3B8)),

          const SizedBox(width: 9),

          SizedBox(
            width: 100,
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
  // LOCATION ROW
  // =========================================================

  Widget _locationRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              color: Color(0xFF94A3B8),
              fontWeight: FontWeight.w600,
            ),
          ),

          const Spacer(),

          Text(
            value,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF334155),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // PARSE KIPAS
  // =========================================================

  List<int> parseKipas(String data) {
    return data.split(',').map((e) => int.tryParse(e) ?? 0).toList();
  }
}
