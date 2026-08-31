
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/app_prefs.dart';
import 'package:qbsc_saas/app/utils/fungsi.dart';
import 'package:qbsc_saas/app/views/broadcast/broadcast_controller.dart';
import 'package:qbsc_saas/app/views/broadcast/broadcast_model.dart';
import 'package:qbsc_saas/app/views/patroli/patroli_foto_preview.dart';

class BroadcastDetail extends StatelessWidget {
  final BroadcastModel data;

  const BroadcastDetail({
    super.key,
    required this.data,
  });

  static const Color primary = Color(0xFF0F172A);
  static const Color blue = Color(0xFF2563EB);
  static const Color background = Color(0xFFF6F8FC);

  // ==========================================================
  // DELETE CONFIRMATION
  // ==========================================================

  void _confirmDelete(
    BuildContext context,
    BroadcastController controller,
    int id,
  ) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titlePadding: const EdgeInsets.fromLTRB(
          24,
          24,
          24,
          8,
        ),
        contentPadding: const EdgeInsets.fromLTRB(
          24,
          8,
          24,
          10,
        ),
        actionsPadding: const EdgeInsets.fromLTRB(
          16,
          0,
          16,
          16,
        ),
        title: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.red,
                size: 21,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Hapus Broadcast?',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: primary,
                ),
              ),
            ),
          ],
        ),
        content: const Text(
          'Broadcast yang dihapus tidak dapat dikembalikan. '
          'Apakah Anda yakin ingin melanjutkan?',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF64748B),
            height: 1.5,
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Get.back(),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                color: Color(0xFFE2E8F0),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
            ),
            child: const Text(
              'Batal',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              controller.deleteBroadcast(id);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
            ),
            child: const Text(
              'Hapus',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final broadcastController =
        Get.find<BroadcastController>();

    final userId =
        int.tryParse(
              AppPrefs.getUserId() ?? '0',
            ) ??
            0;

    final bool canDelete =
        data.pengirim == userId;

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
              'Detail Broadcast',
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
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildHeader(context),

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
                  // INFORMASI BROADCAST
                  // =================================================

                  _sectionCard(
                    icon: Icons.info_outline_rounded,
                    iconColor: blue,
                    title: 'Informasi Broadcast',
                    children: [
                      _infoRow(
                        icon: Icons.tag_rounded,
                        label: 'ID',
                        value: data.id.toString(),
                      ),
                      _infoDivider(),
                      _infoRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'Tanggal',
                        value: Fungsi.tanggalIndo(
                          data.createdAt,
                        ),
                      ),
                      _infoDivider(),
                      _infoRow(
                        icon: Icons.person_outline_rounded,
                        label: 'Pengirim',
                        value: data.senderName,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // =================================================
                  // PESAN
                  // =================================================

                  _messageCard(),

                  const SizedBox(height: 12),

                  // =================================================
                  // METADATA
                  // =================================================

                  _sectionCard(
                    icon: Icons.storage_outlined,
                    iconColor: const Color(0xFF7C3AED),
                    title: 'Metadata',
                    children: [
                      _infoRow(
                        icon: Icons.access_time_rounded,
                        label: 'Dibuat',
                        value: Fungsi.formatDateTime(
                          data.createdAt,
                        ),
                      ),
                      _infoDivider(),
                      _infoRow(
                        icon: Icons.business_outlined,
                        label: 'Perusahaan',
                        value: data.comName,
                      ),
                    ],
                  ),

                  // =================================================
                  // DELETE
                  // =================================================

                  if (canDelete) ...[
                    const SizedBox(height: 18),
                    _buildDeleteButton(
                      context,
                      broadcastController,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // HEADER
  // ==========================================================

  Widget _buildHeader(
    BuildContext context,
  ) {
    final hasImage =
        data.image?.trim().isNotEmpty;

    final imageUrl =
        '${ApiProvider.imageUrl}/${data.image}';

    return Container(
      width: double.infinity,
      color: primary,
      padding: const EdgeInsets.fromLTRB(
        16,
        10,
        16,
        24,
      ),
      child: Column(
        children: [
          // FOTO
          _fotoDoc(
            context,
            hasImage == null ? null : imageUrl,
          ),

          const SizedBox(height: 16),

          // ICON BROADCAST
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withOpacity(0.12),
              ),
            ),
            child: const Icon(
              Icons.campaign_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            data.judul,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 6),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.person_outline_rounded,
                color: Colors.white60,
                size: 13,
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  data.senderName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 3,
                height: 3,
                decoration: const BoxDecoration(
                  color: Colors.white38,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.access_time_rounded,
                color: Colors.white60,
                size: 12,
              ),
              const SizedBox(width: 4),
              Text(
                Fungsi.formatDateTime(
                  data.createdAt,
                ),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // MESSAGE CARD
  // ==========================================================

  Widget _messageCard() {
    return Container(
      width: double.infinity,
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            _sectionHeader(
              icon: Icons.chat_bubble_outline_rounded,
              iconColor: blue,
              title: 'Pesan Broadcast',
            ),

            const SizedBox(height: 16),

            // JUDUL
            const Text(
              'Judul',
              style: TextStyle(
                fontSize: 9.5,
                color: Color(0xFF94A3B8),
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              data.judul,
              style: const TextStyle(
                fontSize: 15,
                color: primary,
                fontWeight: FontWeight.w800,
                height: 1.35,
              ),
            ),

            const SizedBox(height: 16),

            // PESAN
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: const Color(0xFFF1F5F9),
                ),
              ),
              child: Text(
                data.pesan,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF475569),
                  fontWeight: FontWeight.w500,
                  height: 1.6,
                ),
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
    required Color iconColor,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            _sectionHeader(
              icon: icon,
              iconColor: iconColor,
              title: title,
            ),

            const SizedBox(height: 14),

            ...children,
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // SECTION HEADER
  // ==========================================================

  Widget _sectionHeader({
    required IconData icon,
    required Color iconColor,
    required String title,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(11),
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
            fontSize: 13.5,
            color: primary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
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
      padding: const EdgeInsets.symmetric(
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
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              icon,
              size: 14,
              color: const Color(0xFF64748B),
            ),
          ),

          const SizedBox(width: 10),

          SizedBox(
            width: 75,
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 7),
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

          const SizedBox(width: 8),

          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 7),
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 11,
                  color: primary,
                  fontWeight: FontWeight.w700,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoDivider() {
    return const Padding(
      padding: EdgeInsets.only(
        left: 40,
        top: 3,
        bottom: 3,
      ),
      child: Divider(
        height: 1,
        thickness: 0.6,
        color: Color(0xFFEFF2F6),
      ),
    );
  }

  // ==========================================================
  // DELETE BUTTON
  // ==========================================================

  Widget _buildDeleteButton(
    BuildContext context,
    BroadcastController controller,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: () {
          _confirmDelete(
            context,
            controller,
            data.id,
          );
        },
        icon: const Icon(
          Icons.delete_outline_rounded,
          size: 18,
        ),
        label: const Text(
          'Hapus Broadcast',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red.shade600,
          side: BorderSide(
            color: Colors.red.shade200,
          ),
          backgroundColor: Colors.red.withOpacity(0.025),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // FOTO
  // ==========================================================

  Widget _fotoDoc(
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
        tag: imageUrl ?? 'broadcast-no-image',
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius:
                  BorderRadius.circular(18),
              border: Border.all(
                color: Colors.white.withOpacity(0.10),
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
                          (context, child, progress) {
                        if (progress == null) {
                          return child;
                        }

                        return const Center(
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
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

  // ==========================================================
  // IMAGE PLACEHOLDER
  // ==========================================================

  Widget _iconPlaceholder() {
    return Column(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.image_not_supported_outlined,
          size: 42,
          color: Colors.white38,
        ),
        SizedBox(height: 8),
        Text(
          'Tidak ada gambar',
          style: TextStyle(
            fontSize: 10,
            color: Colors.white54,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}