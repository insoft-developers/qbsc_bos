import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/fungsi.dart';
import 'package:qbsc_saas/app/utils/patroli_schedule.dart';
import 'package:qbsc_saas/app/views/doc/doc_controller.dart';
import 'package:qbsc_saas/app/views/doc/doc_model.dart';
import 'package:qbsc_saas/app/views/patroli/patroli_foto_preview.dart';

class DocDetail extends StatelessWidget {
  final DocModel data;

  const DocDetail({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final _doc = Get.find<DocController>();
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: const Text(
          'Detail Doc Keluar',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // =========================
            // HEADER FOTO SATPAM
            // =========================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: const BoxDecoration(color: Color(0xFF0F172A)),
              child: Column(
                children: [
                  _fotoDoc(context, "${ApiProvider.imageUrl}/${data.foto}"),
                  const SizedBox(height: 12),
                ],
              ),
            ),

            // =========================
            // CONTENT
            // =========================
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _card(
                    title: 'Informasi Catatan DOC',
                    children: [
                      _row('ID', data.id.toString()),
                      _row('Tanggal', Fungsi.tanggalIndo(data.tanggal)),
                      _row('Jam', data.jam),
                      _row('Satpam', data.satpamName),
                    ],
                  ),

                  const SizedBox(height: 12),

                  _card(
                    title: 'DOC',
                    children: [
                      _row('Ekspedisi', data.ekspedisiName),
                      _row('Jumlah', "${data.jumlah.toString()} Box"),
                      _row('Jenis Doc', data.jenis == 1 ? "Male" : "Female"),
                      _row('Tujuan', data.tujuan ?? ''),
                      _row('No Polisi', data.noPolisi ?? ''),
                    ],
                  ),

                  const SizedBox(height: 12),

                  _card(
                    title: 'Catatan',
                    children: [_row('Deskripsi', data.note ?? '-')],
                  ),

                  const SizedBox(height: 12),

                  _card(
                    title: 'Metadata',
                    children: [
                      _row(
                        'Tanggal Input',
                        Fungsi.formatDateTime(data.inputDate ?? ''),
                      ),
                      _row('Dibuat', Fungsi.formatDateTime(data.createdAt)),
                      _row('Perusahaan', data.comName),
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

  // =========================
  // WIDGET
  // =========================

  Widget _iconPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.image_not_supported, size: 64, color: Colors.grey),
        SizedBox(height: 8),
        Text(
          'Foto Patroli',
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _fotoDoc(BuildContext context, String? imageUrl) {
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
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            width: double.infinity,
            color: Colors.grey.shade200,
            child: hasImage
                ? Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (_, __, ___) => _iconPlaceholder(),
                  )
                : _iconPlaceholder(),
          ),
        ),
      ),
    );
  }

  Widget _card({required String title, required List<Widget> children}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
