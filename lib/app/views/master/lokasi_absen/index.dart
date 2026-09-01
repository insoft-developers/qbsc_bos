import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/views/master/lokasi_absen/lokasi_absen_controller.dart';

class AturLokasiPage extends StatefulWidget {
  const AturLokasiPage({super.key});

  @override
  State<AturLokasiPage> createState() => _AturLokasiPageState();
}

class _AturLokasiPageState extends State<AturLokasiPage> {
  final controller = Get.find<LokasiAbsenController>();

  @override
  void initState() {
    
    super.initState();
    controller.getLokasi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        centerTitle: false,
        title: const Text(
          'Lokasi Absen',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F2937),
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1F2937)),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.latitude.value.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final latitude = controller.latitude.value;
        final longitude = controller.longitude.value;

        final hasLocation = latitude.isNotEmpty && longitude.isNotEmpty;

        return RefreshIndicator(
          color: const Color(0xFF2563EB),
          onRefresh: controller.getLokasi,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            children: [
              // ==================================================
              // HEADER
              // ==================================================
              const Text(
                'Pengaturan Lokasi',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Tentukan lokasi yang akan digunakan sebagai '
                'acuan absensi.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Color(0xFF6B7280),
                ),
              ),

              const SizedBox(height: 24),

              // ==================================================
              // LOCATION CARD
              // ==================================================
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.035),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // LOCATION ICON
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.location_on_rounded,
                        size: 40,
                        color: Color(0xFF2563EB),
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'Lokasi Absen Saat Ini',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      hasLocation
                          ? 'Lokasi telah ditentukan'
                          : 'Lokasi belum ditentukan',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: hasLocation
                            ? const Color(0xFF16A34A)
                            : const Color(0xFFF59E0B),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ==================================================
                    // COORDINATE
                    // ==================================================
                    _CoordinateItem(
                      icon: Icons.north_rounded,
                      title: 'Latitude',
                      value: hasLocation ? latitude : '-',
                    ),

                    const SizedBox(height: 10),

                    _CoordinateItem(
                      icon: Icons.east_rounded,
                      title: 'Longitude',
                      value: hasLocation ? longitude : '-',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ==================================================
              // INFO
              // ==================================================
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFDBEAFE)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      size: 21,
                      color: Color(0xFF2563EB),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Lokasi ini akan digunakan sebagai acuan '
                        'untuk menentukan posisi absensi.',
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ==================================================
              // UPDATE BUTTON
              // ==================================================
              SizedBox(
                height: 54,
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.aturLokasiSaatIni,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFF93C5FD),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: controller.isLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.my_location_rounded, size: 21),
                  label: Text(
                    controller.isLoading.value
                        ? 'Mengambil Lokasi...'
                        : 'Gunakan Lokasi Saat Ini',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ==================================================
              // GOOGLE MAPS BUTTON
              // ==================================================
              SizedBox(
                height: 54,
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: hasLocation ? controller.bukaGoogleMaps : null,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF374151),
                    disabledForegroundColor: const Color(0xFF9CA3AF),
                    side: BorderSide(
                      color: hasLocation
                          ? const Color(0xFFD1D5DB)
                          : const Color(0xFFE5E7EB),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.map_outlined, size: 21),
                  label: const Text(
                    'Buka dengan Google Maps',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              if (hasLocation)
                Center(
                  child: Text(
                    'Tarik ke bawah untuk memperbarui data',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

// ======================================================
// COORDINATE ITEM
// ======================================================

class _CoordinateItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _CoordinateItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Icon(icon, size: 19, color: const Color(0xFF2563EB)),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF111827),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          if (value != '-')
            const Icon(
              Icons.check_circle_rounded,
              size: 19,
              color: Color(0xFF22C55E),
            ),
        ],
      ),
    );
  }
}
